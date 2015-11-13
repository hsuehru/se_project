class Project < ActiveRecord::Base
	belongs_to :owner, -> {select(:id, :name) }, :class_name => "User", :foreign_key => "owner"
	has_many :user_projectships
	has_many :users, :through => :user_projectships
end
