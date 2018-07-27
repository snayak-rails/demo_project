class ChangeContactToBeStringInCarts < ActiveRecord::Migration[5.2]
  def change
    change_column :carts, :contact, :string
  end
end
