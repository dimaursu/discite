# @author Dumitru Ursu
# A model that represents both the student and the teacher
# A teacher is actually just a course owner
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :courses

  def nearest_course
    self.courses.order(:starts_at).first
  end

  def handle
    self.name || self.email.split('@').first
  end
end
