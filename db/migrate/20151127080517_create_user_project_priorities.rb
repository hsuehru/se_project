class CreateUserProjectPriorities < ActiveRecord::Migration
  def change
    create_table :user_project_priorities do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
