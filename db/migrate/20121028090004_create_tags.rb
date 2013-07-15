class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :clip_id
      t.integer :user_id
      t.string :name, null: false

      t.timestamps
    end

    add_index :tags, [ :clip_id, :name ], :unique => true, :name => 'tags_idx_01'
  end
end
