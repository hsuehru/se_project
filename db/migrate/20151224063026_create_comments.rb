class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :requirement_id
      t.references :user
      t.string :comment
      t.string :decision

      t.timestamps null: false
    end
  end
end
