# frozen_string_literal: true

Rails.application.routes.draw do
  get "users/index"
  get "users/show"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "static_pages#home"
  get "home", to: "static_pages#home"
  resources :posts
  resources :users, only: [:index, :show]
end
