class TestCase < ActiveRecord::Base
	belongs_to :asigned_as,->{select(:id,:name)}, :class_name  => "User", :foreign_key => "asigned_as"
	has_many :requirement_test_caseships
	has_many :requirements, :through => :requirement_test_caseships
end
