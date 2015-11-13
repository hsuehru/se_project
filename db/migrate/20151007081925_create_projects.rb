class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :owner
			t.text :descript

      t.timestamps null: false
    end
  end
end
