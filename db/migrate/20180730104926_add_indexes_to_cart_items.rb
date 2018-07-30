class AddIndexesToCartItems < ActiveRecord::Migration[5.2]
  def change
    add_index :cart_items, %i[cart_id product_id]
  end
end
