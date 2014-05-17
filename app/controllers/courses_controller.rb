# @author Dumitru Ursu
# Controller for the courses
class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :run, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :redirect_to_course, except: :run

  def index
    @courses = Course.all
  end

  def show
  end

  def run
    @slides_path = "#{Rails.root}" + '/public' + @course.slides.url.sub!(/\?(.*)\z/, '')
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    @course.user_id = current_user.id
    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: 'Course was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  def redirect_to_course
    course = current_user.nearest_course
    # we redirect to the course page even if it's 5 minutes earlier
    redirect_to course_start_path(course) if Time.now + 1.hour > course.starts_at
  end

  def course_params
    params.require(:course).permit(:title, :description, :language, :slides,
                                   :prerequisites, :duration, :rating)
  end
end
