Rails.application.routes.draw do
  devise_for :users

  root to: "home#track"
  
  resources :orders, only: [:index, :show, :new, :create] do
    get 'search', on: :collection
  end

  resources :shipping_options, only: [:index, :create, :edit, :update, :show] do
    post 'enable', on: :member
    post 'disable', on: :member
  end

  resources :vehicles, only: [:index]
end
