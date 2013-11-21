class CreateMatomes < ActiveRecord::Migration
  def change
    create_table :matomes do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :description
      t.integer :view_count, default: 0
      t.string :last_access_ip
      t.timestamps
    end
  end
end
