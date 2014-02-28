# @author Dumitru Ursu
# The main Controller of the app
# Here we set the locale of the application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    I18n.locale = read_user_profile || params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def read_user_profile
    current_user.language if current_user
  end
end
