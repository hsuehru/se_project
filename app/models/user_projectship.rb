class UserProjectship < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, ->{select(:id,:name,:created_at)}
  belongs_to :user_project_priority
	validates_uniqueness_of :user_id, :scope => :project_id
end
