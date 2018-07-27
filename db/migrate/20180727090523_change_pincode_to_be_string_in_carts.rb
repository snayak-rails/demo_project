class ChangePincodeToBeStringInCarts < ActiveRecord::Migration[5.2]
  def change
    change_column :carts, :pincode, :string
  end
end
