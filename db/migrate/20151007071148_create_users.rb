class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
			t.string :email, :limit => "100", :unique => true, :null => false
      t.string :password_digest, :limit => "100", :null => false
      t.string :name, :limit => "100", :null => false
			t.references :user_priority_type
      t.timestamps null: false
    end
    add_index :users, [:email], :unique => true
  end
end
