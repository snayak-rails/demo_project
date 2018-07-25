module ProductsHelper
  def fetch_product
    begin
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:notice] = e.message
      redirect_to products_path
      return
    end
    @product_images = @product.product_images.all
  end
end
