class Project < ActiveRecord::Base
	#belongs_to :owner, -> {select(:id, :name) }, :class_name => "User", :foreign_key => "owner"
	has_many :user_projectships
	has_many :requirement_requirementships
	has_many :requirement_test_caseships, ->{select(:id,:project_id,:requirement_id,:test_case_id, :created_at)}
	has_many :users, -> {select(:id, :name, :email)}, :through => :user_projectships
	has_many :user_project_types, -> {select(:id, :name)}, :through => :user_projectships
	has_many :requirements
	has_many :test_cases
end
