Rails.application.routes.draw do
  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks, only: [:index, :new, :show, :create, :edit, :update, :destroy]
    end
    resources :categories
  end
  devise_for :admins, only: [:sessions, :passwords], controllers: {
    sessions: 'devise/sessions',
    passwords: 'devise/passwords'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"

  authenticate :admin_user do
    root to: "admin#index", as: :admin_root
  end

  resources :categories, only: [:show]
  resources :products, only: [:show]
  get "admin" => "admin#index"
  get "cart" => "carts#show"
  post "checkout" => "checkouts#create"
  get "success" => "checkouts#success"
  get "cancel" => "checkouts#cancel"
  post '/webhooks/stripe', to: 'webhooks#stripe'
end
