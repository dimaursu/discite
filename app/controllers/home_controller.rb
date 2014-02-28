# @author Dumitru Ursu
# Controller for the landing page
class HomeController < ApplicationController
  def index
    @courses = Course.all
  end
end
