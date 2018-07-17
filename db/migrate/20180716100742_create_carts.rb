class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.string :name
      t.integer :contact
      t.string :email
      t.text :address1
      t.string :city
      t.string :state
      t.string :country
      t.integer :pincode
      t.float :total_amount
      t.boolean :is_paid
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
