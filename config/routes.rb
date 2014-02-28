Discite::Application.routes.draw do
  scope '/:locale' do
    resources :courses
    devise_for :users, controllers: { registrations: 'registrations' }
  end

  match '/:locale' => 'home#index', via: [:get]
  root to: 'home#index'
end
