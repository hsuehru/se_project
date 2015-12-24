class RequirementRequirementship < ActiveRecord::Base
  belongs_to :project
  belongs_to :requirement1, -> {select(:id,:name)}, :class_name => "Requirement", :foreign_key => "requirement1_id"
  belongs_to :requirement2, -> {select(:id,:name)}, :class_name => "Requirement", :foreign_key => "requirement2_id"
end
