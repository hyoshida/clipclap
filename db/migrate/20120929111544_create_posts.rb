class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :url
      t.string :origin_url
      t.text :origin_html
      t.integer :user_id

      t.timestamps
    end
  end
end
