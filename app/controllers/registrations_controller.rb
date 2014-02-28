# @author Dumitru Ursu
# Controller for user registration
class RegistrationsController < Devise::RegistrationsController
  def account_update_params
    devise_parameter_sanitizer.for(:account_update) << :language
    super
  end
end
