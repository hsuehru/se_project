class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.string :name
      t.text :description
      t.integer :project_id
      t.integer :owner
			t.integer :asigned_as
			t.text :input_data
			t.text :expected_result
			t.boolean :finished

      t.timestamps null: false
    end
  end
end
