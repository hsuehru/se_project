class CreateRequirementRequirementships < ActiveRecord::Migration
  def change
    create_table :requirement_requirementships do |t|
      t.integer :project_id
      t.integer :requirement1_id
      t.integer :requirement2_id
      t.timestamps null: false
    end
  end
end
