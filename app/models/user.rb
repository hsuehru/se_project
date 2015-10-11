class User < ActiveRecord::Base
	#validates :email, uniqueness: true
	#validates_uniqueness_of :email
	has_secure_password

	validates :email, :uniqueness => { :case_sensitive => false }

	belongs_to :user_priority_type
	has_many :test_cases, :foreign_key => "asigned_as"
	has_many :requirements, :foreign_key => "owner"
	has_many :own_projects, :class_name => "project", :foreign_key => "owner"
	has_many :user_projectships
	has_many :projects, :through => "user_projectships"
end
