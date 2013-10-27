class ActsAsFollowerMigration < ActiveRecord::Migration
  def change
    create_table(:follows) do |t|
      t.references :followable, polymorphic: true, null: false
      t.references :follower, polymorphic: true, null: false
      t.boolean :blocked, default: false, null: false
      t.timestamps
    end

    add_index :follows, [ :follower_id, :follower_type ], name: 'follows_idx_01'
    add_index :follows, [ :followable_id, :followable_type ], name: 'follows_idx_02'
  end
end
