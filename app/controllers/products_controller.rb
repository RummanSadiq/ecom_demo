class ProductsController < ApplicationController
  before_action :find_product, only: [:edit, :update, :show, :destroy]
  around_action :check_ownership, only: [:edit, :update, :destroy]

  def index
    # @products = Product.all.order(created_at: :desc)
    @products = Product.search(params[:search])
  end

  def show
    @comment = Comment.new
    @line_item = LineItem.new
    @comments = @product.comments.order("created_at DESC")
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = current_user.products.new(product_params)

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: "Product was successfully destroyed."
  end

  def delete_image
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge_later

    redirect_to edit_product_url(image.record_id), notice: "Image Removed!"
  end

  private

  def find_product
    @product = Product.find_by_id(params[:id])
    if @product.blank?
      redirect_to products_url, alert: "Page not found!"
    end
  end

  def check_ownership
    if user_signed_in? && current_user.id == @product.user_id
      yield
    else
      redirect_to products_url, alert: "Page not found!"
    end
  end

  def product_params
    params.require(:product).permit(:title, :description, :price, :quantity, uploads: [])
  end
end
