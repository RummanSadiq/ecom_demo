class ChargesController < ApplicationController
  def create
    # Amount in cents

    items = current_user.cart_items.includes(:product)

    if items.empty?
      redirect_to cart_url, alert: "Cart is empty!"
      return
    end

    if check_cart?(items)
      @amount = 500

      customer = Stripe::Customer.create({
        email: params[:stripeEmail],
        source: params[:stripeToken],
      })

      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: @amount,
        description: "Rails Stripe customer",
        currency: "usd",
      })

      place_orders(items)

      redirect_to orders_url, notice: "Thank you. Your Orders has been shipped!"
      return
    else
      redirect_to cart_url,
                  alert: "Some product are not avaible in required quantity. Try changing the quantity!"
      return
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to cart_url, alert: "Unable to process payment!"
  end

  def check_cart?(items)
    all_good = true

    items.each do |item|
      if item.quantity <= 0 || item.quantity > item.product.quantity
        all_good = false
      end
    end

    return all_good
  end

  def place_orders(items)
    items = current_user.cart_items.includes(:product)

    items.each do |item|
      item.update(item_state: "order")
      item.product.update(quantity: item.product.quantity - item.quantity)
    end
  end
end
