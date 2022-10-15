Rails.application.routes.draw do
  devise_for :users

  root to: "home#track"
  
  resources :orders, only: [:index, :show, :new, :create] do
    get 'search', on: :collection
    post 'deliver', on: :member
    resources :detailed_orders, only: [:new, :create]
    resources :delayed_orders, only: [:new, :create]
  end

  resources :shipping_options, only: [:index, :create, :edit, :update, :show] do
    post 'enable', on: :member
    post 'disable', on: :member
    resources :prices, only: [:new, :create, :edit, :update, :show]
    resources :deadlines, only: [:new, :create, :edit, :update, :show]
  end

  resources :vehicles, only: [:index, :create, :edit, :update, :show] do
    get 'search', on: :collection
    post 'sent_to_maintenance', on: :member
    post 'make_available', on: :member
  end

  resources :deadlines, only: [:index]

  resources :prices, only: [:index]
end
