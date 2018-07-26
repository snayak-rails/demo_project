class AddTitleToCartItems < ActiveRecord::Migration[5.2]
  def change
    add_column :cart_items, :title, :string
  end
end
