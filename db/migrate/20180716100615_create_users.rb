class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :gender
      t.string :email
      t.integer :contact
      t.string :role

      t.timestamps
    end
  end
end
