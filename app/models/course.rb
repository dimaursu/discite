# @author Dumitru Ursu
# Model for courses
class Course < ActiveRecord::Base
  belongs_to :user
  has_attached_file :slides
  validates_attachment_content_type :slides, content_type: [
    'application/vnd.oasis.opendocument.presentation', 'application/pdf',
    'text/html']
end
