class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.integer :image_master_id, null: false
      t.string :title
      t.string :origin_url, null: false
      t.text :origin_html

      t.timestamps
    end
  end
end
