class RenameImageMastersToImages < ActiveRecord::Migration
  def change
    rename_table :image_masters, :images
    rename_column :clips, :image_master_id, :image_id
    rename_column :likes, :image_master_id, :image_id
  end
end
