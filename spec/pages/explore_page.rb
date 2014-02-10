class ExplorePage
  include Capybara::DSL

  def visit_page
    visit '/en/courses/'
    self
  end
end

