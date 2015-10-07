class TestCase < ActiveRecord::Base
	belongs_to :user,:foreign_key => "asigned_as"
end
