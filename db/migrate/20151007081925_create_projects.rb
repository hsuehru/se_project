class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.text :owner
      t.text :manager
      t.text :member
      t.text :customer

      t.timestamps null: false
    end
  end
end
