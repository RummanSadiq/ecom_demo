class LineItemsController < ApplicationController
  before_action :check_logged_in
  around_action :check_ownership, only: [:update, :destroy]

  def create
    product = Product.find_by_id(line_item_params[:product_id])
    if product.blank?
      redirect_to products_url, alert: "Unable to add the product to cart!"
      return
    end

    if product.user_id == current_user.id
      redirect_to product_url(product.id), alert: "You can't add your own product to the cart!"
      return
    end

    if product.quantity < 1
      redirect_to product_url(product.id), alert: "Product is not available at this time. Try again later!"
      return
    end

    if current_user.cart_items.where(product_id: product.id).exists?
      redirect_to product_url(product.id), alert: "Product is already in the cart!"
      return
    end

    @line_item = current_user.line_items.new(line_item_params)

    if @line_item.save
      redirect_to cart_url, notice: "Product was successfully added to cart."
      return
    else
      redirect_to products_url, alert: "Unable to add product to the cart."
    end
  end

  def update
    if @line_item.update(quantity: params[:quantity])
      redirect_to cart_url, notice: "Cart updated.", type: "success"
    else
      redirect_to cart_url, alert: "Unable to update the cart."
    end
  end

  def destroy
    @line_item.destroy
    redirect_to cart_url, notice: "Product was successfully removed from cart."
  end

  def cart
    @cart_items = current_user.cart_items.includes(:product)
    render "line_items/cart/index"
  end

  def orders
    @order_items = current_user.order_items.includes(:product).order(updated_at: :desc)
    render "line_items/orders/index"
  end

  private

  def check_logged_in
    if !user_signed_in?
      redirect_to products_url, alert: "Please Login!"
    end
  end

  def check_ownership
    @line_item = LineItem.cart_items.find_by_id(params[:id])
    if !@line_item.blank? && current_user.id == @line_item.user_id
      yield
    else
      redirect_to cart_url, alert: "Page not found!"
    end
  end

  def line_item_params
    params.require(:line_item).permit(:product_id, :quantity)
  end
end
