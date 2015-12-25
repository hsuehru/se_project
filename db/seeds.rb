# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
PriorityType.create!(:name => "Low")
PriorityType.create!(:name => "Medium")
PriorityType.create!(:name => "High")
# ----------------------------------------------------
RequirementType.create!(:name => "Functional")
RequirementType.create!(:name => "Non-functional")
# ----------------------------------------------------
StatusType.create!(:name => "Open")
StatusType.create!(:name => "Under review")
StatusType.create!(:name => "Approved")
StatusType.create!(:name => "Not approved")

# ----------------------------------------------------
UserProjectPriority.create!(:name => "Owner")
UserProjectPriority.create!(:name => "Manager")
UserProjectPriority.create!(:name => "Member")
UserProjectPriority.create!(:name => "Customer")
# ----------------------------------------------------
User.create!(:name=>"ZZ" , :email => "j00064qaz123@gmail.com", :password => "a123456")
User.create!(:name=>"YH" , :email => "user@user", :password => "123456")
User.create!(:name=>"test_acc_1" , :email => "test1@test", :password => "123456")
User.create!(:name=>"test_acc_2" , :email => "test2@test", :password => "123456")
User.create!(:name=>"test_acc_3" , :email => "test3@test", :password => "123456")
User.create!(:name=>"test_acc_4" , :email => "test4@test", :password => "123456")
User.create!(:name=>"test_acc_5" , :email => "test5@test", :password => "123456")

