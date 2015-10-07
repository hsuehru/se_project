class Requirement < ActiveRecord::Base
  belongs_to :project
  belongs_to :requirement_type
  belongs_to :priority_type
  belongs_to :status_type
	belongs_to :owner, :class_name => "User", :foreign_key => "owner"
	
end
