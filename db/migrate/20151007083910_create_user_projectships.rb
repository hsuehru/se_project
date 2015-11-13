class CreateUserProjectships < ActiveRecord::Migration
  def change
    create_table :user_projectships do |t|
      t.references :user, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true
      t.timestamps null: false
    end
  	add_index :user_projectships, [:user_id, :project_id], unique: true
  end
end
