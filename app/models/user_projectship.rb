class UserProjectship < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :user_project_type
	validates_uniqueness_of :user_id, :scope => :project_id
end
