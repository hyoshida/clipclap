class AddMatomeIdToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :matome_id, :integer
  end
end
