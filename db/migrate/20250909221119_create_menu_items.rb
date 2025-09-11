class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.references :menu, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :price, precision: 5, scale: 2, null: false
      t.text :description

      t.timestamps
    end
  end
end
