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
RequirementType.create!(:name => "functional")
RequirementType.create!(:name => "non-functional")
# ----------------------------------------------------
StatusType.create!(:name => "open")
StatusType.create!(:name => "under review")
StatusType.create!(:name => "approved")
# ----------------------------------------------------
UserProjectType.create!(:name => "Owner")
UserProjectType.create!(:name => "Manager")
UserProjectType.create!(:name => "Member")
UserProjectType.create!(:name => "Customer")
# ----------------------------------------------------
User.create!(:name=>"ZZ" , :email => "j00064qaz123@gmail.com", :password => "a123456")
