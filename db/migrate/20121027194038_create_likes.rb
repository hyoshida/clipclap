class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :clip_id
      t.integer :image_master_id

      t.timestamps
    end

    add_index :likes, [ :user_id, :clip_id ], :unique => true, :name => 'likes_idx_01'
  end
end
