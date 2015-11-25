class User < ActiveRecord::Base
	#validates :email, uniqueness: true
	#validates_uniqueness_of :email
	has_secure_password

	validates :email, :uniqueness => { :case_sensitive => false }

	has_many :test_cases, :foreign_key => "asigned_as"
	has_many :requirements, :foreign_key => "owner"
	has_many :own_projects, :class_name => "project", :foreign_key => "owner"
	has_many :user_projectships

	has_many :projects, -> {select(:id, :name, :descript)}, :through => :user_projectships
end
