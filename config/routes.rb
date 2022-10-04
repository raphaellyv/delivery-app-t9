Rails.application.routes.draw do
  devise_for :users

  root to: "home#track"

  authenticate :user do
    resources :orders, only: [:index, :show, :new, :create]
  end
end
