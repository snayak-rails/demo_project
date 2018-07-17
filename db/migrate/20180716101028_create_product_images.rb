class CreateProductImages < ActiveRecord::Migration[5.2]
  def change
    create_table :product_images do |t|
      t.string :image
      t.belongs_to :product, index: true

      t.timestamps
    end
  end
end
