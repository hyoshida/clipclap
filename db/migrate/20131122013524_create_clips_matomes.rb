class CreateClipsMatomes < ActiveRecord::Migration
  def change
    create_table :clips_matomes do |t|
      t.belongs_to :clip, null: false
      t.belongs_to :matome, null: false
    end
  end
end
