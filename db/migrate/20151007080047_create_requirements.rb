class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :name
      t.text :description
      t.integer :owner
      #t.references :project, index: true, foreign_key: true
      t.references :project
      t.references :requirement_type
      t.references :priority_type
      t.references :status_type

      t.timestamps null: false
    end
  end
end
