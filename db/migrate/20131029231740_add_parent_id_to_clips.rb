class AddParentIdToClips < ActiveRecord::Migration
  def change
    add_column :clips, :parent_id, :integer
  end
end
