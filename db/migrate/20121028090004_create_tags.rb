class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :name, unique: true, null: false

      t.timestamps
    end
  end
end
