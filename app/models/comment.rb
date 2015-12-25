class Comment < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :user, -> {select(:id,:name)}

end
