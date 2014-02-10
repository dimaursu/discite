class HomePage
  include Capybara::DSL

  def visit_page
    visit '/'
    self
  end

  def login(user)
    fill_in 'email', with: user.email
    fill_in 'password', with: 'password'
    click_on 'Log In'
  end
end

