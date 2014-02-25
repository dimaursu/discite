# @author Dumitru Ursu
# Page Object for the user profile page
class ProfilePage
  include Capybara::DSL
  include Warden::Test::Helpers
  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
    login_as @user
  end

  def locale(lang)
    visit edit_user_registration_path(:en)
    select lang, from: 'user_language'
    fill_in 'user_current_password', with: @user.password
    click_button 'Update'
  end
end
