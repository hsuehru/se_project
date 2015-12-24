class CreateTestCaseTestCaseships < ActiveRecord::Migration
  def change
    create_table :test_case_test_caseships do |t|
      t.integer :test_case1_id
      t.integer :test_case2_id
      t.timestamps null: false
    end
  end
end
