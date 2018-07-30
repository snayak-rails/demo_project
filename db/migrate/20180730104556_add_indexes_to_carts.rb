class AddIndexesToCarts < ActiveRecord::Migration[5.2]
  def change
    add_index :carts, %i[user_id is_paid]
  end
end
