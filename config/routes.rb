Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "home/index"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
  }

  devise_scope :user do
    %w(profile me whoami).each do |route|
      get "user/#{route}", to: 'users/sessions#show'
    end

    get "user/settings", to: 'users/settings#index'
  end

  resources :static_pages, only: [] do
    collection do
      get :about
      get :contact
      get :faqs
      get :features
    end
  end

  get "search" => "search#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
