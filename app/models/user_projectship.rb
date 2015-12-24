class UserProjectship < ActiveRecord::Base
  belongs_to :user, ->{select(:id,:name)}
  belongs_to :project, ->{select(:id,:name,:description,:created_at)}
  belongs_to :user_project_priority, ->{select(:id,:name)}
	validates_uniqueness_of :user_id, :scope => :project_id
end
