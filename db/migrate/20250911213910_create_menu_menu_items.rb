class CreateMenuMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_menu_items do |t|
      t.integer :menu_id, null: false
      t.integer :menu_item_id, null: false
      t.index %i[menu_id menu_item_id], unique: true

      t.timestamps
    end
  end
end
