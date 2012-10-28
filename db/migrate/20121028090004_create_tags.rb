class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :name, null: false

      t.timestamps
    end

    add_index :tags, [ :post_id, :name ], :unique => true, :name => 'tags_idx_01'
  end
end
