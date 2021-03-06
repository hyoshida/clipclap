class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.integer :user_id, null: false
      t.integer :image_master_id, null: false
      t.string :title
      t.string :origin_url, null: false
      t.text :origin_html
      t.integer :view_count, default: 0
      t.string :last_access_ip

      t.timestamps
    end
  end
end
