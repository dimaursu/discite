# @author Dumitru Ursu
# Model for courses
class Course < ActiveRecord::Base
  belongs_to :user
end
