# @author Dumitru Ursu
# Page Object for the list of all courses.
class ExplorePage
  include Capybara::DSL

  def visit_page
    visit '/en/courses/'
    self
  end
end
