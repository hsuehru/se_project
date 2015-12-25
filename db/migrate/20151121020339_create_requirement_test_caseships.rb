class CreateRequirementTestCaseships < ActiveRecord::Migration
  def change
    create_table :requirement_test_caseships do |t|
      t.references :project
      t.references :requirement
      t.references :test_case
      t.timestamps null: false
    end
  end
end
