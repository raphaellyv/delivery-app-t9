Rails.application.routes.draw do
  devise_for :users
  root to: "home#track"

  resources :orders, only: [:index]
end
