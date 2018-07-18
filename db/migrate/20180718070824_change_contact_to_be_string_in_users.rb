class ChangeContactToBeStringInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :contact, :string
  end
end
