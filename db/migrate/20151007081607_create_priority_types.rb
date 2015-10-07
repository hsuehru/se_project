class CreatePriorityTypes < ActiveRecord::Migration
  def change
    create_table :priority_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
