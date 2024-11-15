# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "static_pages#home"
  get "home", to: "static_pages#home"

  # for posts likes and comments
  resources :posts do
    resources :comments
    resources :likes, only: %i[create destroy]
  end
  # for comments likes
  resources :comments do
    resources :likes, only: %i[create destroy]
  end

  resources :users, only: %i[index show] do
    member do
      get :following, :followers
    end
  end

  resources :relationships, only: [:create, :destroy] do
    member do
      post :follow
      post :unfollow
    end
  end

  resources :messages, only: %i[create] do
    member do
      get :chat
    end
  end

  resources :notifications, only: [] do
    collection do
      post :mark_as_read
    end
  end
end
