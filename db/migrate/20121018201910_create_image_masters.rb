class CreateImageMasters < ActiveRecord::Migration
  def change
    create_table :image_masters do |t|
      t.string :url, unique: true, null: false
      t.integer :width, null: false, default: 0
      t.integer :height, null: false, default: 0
      t.datetime :delete_ordered_at

      t.timestamps
    end
  end
end
