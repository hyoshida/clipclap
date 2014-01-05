class AddColumnsForMatomeToTags < ActiveRecord::Migration
  def up
    change_column :tags, :clip_id, :integer, null: false
    rename_column :tags, :clip_id, :tagged_id
    add_column :tags, :tagged_type, :string, null: false
    Tag.reset_column_information
    Tag.update_all(tagged_type: "Clip")
    remove_index :tags, name: 'tags_idx_01'
    add_index :tags, [ :tagged_id, :tagged_type, :name ], :unique => true, :name => 'tags_idx_01'
  end

  def down
    change_column :tags, :tagged_id, :integer
    rename_column :tags, :tagged_id, :clip_id
    remove_column :tags, :tagged_type
    remove_index :tags, name: 'tags_idx_01'
    add_index :tags, [ :clip_id, :name ], :unique => true, :name => 'tags_idx_01'
  end
end
