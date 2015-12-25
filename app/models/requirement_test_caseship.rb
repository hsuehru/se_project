class RequirementTestCaseship < ActiveRecord::Base

  belongs_to :requirement
  belongs_to :test_case
  belongs_to :project
  validates_uniqueness_of :test_case_id, :scope => :requirement_id
end
