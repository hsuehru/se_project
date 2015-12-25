class Requirement < ActiveRecord::Base
  belongs_to :project,->{select(:id,:name,:description,:created_at)}
  belongs_to :requirement_type,->{select(:id,:name)}
  belongs_to :priority_type,->{select(:id,:name)}
  belongs_to :status_type,->{select(:id,:name)}
	belongs_to :owner, -> {select(:id,:name)}, :class_name => "User", :foreign_key => "owner"
  belongs_to :handler, -> {select(:id,:name)}, :class_name => "User", :foreign_key => "handler"
  has_many :requirement_test_caseships
  has_many :comments

  has_many :test_cases, :through => :requirement_test_caseships
end
