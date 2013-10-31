class Attachment < ActiveRecord::Base
  belongs_to :course
  has_attached_file :file
end
