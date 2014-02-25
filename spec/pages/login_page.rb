# @author Dumitru Ursu
require 'spec_helper'

# This class creates a page object to the login page
class LoginPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
    visit new_user_session_path(:en)
  end

  def login
    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password
    click_on 'Sign In'
  end
end
