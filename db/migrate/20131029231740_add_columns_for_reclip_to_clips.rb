class AddColumnsForReclipToClips < ActiveRecord::Migration
  def change
    add_column :clips, :parent_id, :integer
    add_column :clips, :origin_id, :integer
  end
end
