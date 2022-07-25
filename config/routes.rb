require "sidekiq/web"

Rails.application.routes.draw do

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
    namespace :admin do
      resources :users
      resources :submissions
      root to: "users#index"
    end
  end

  resources :communities do
    resources :subscriptions
  end

  resources :submissions do
    member do
      put "upvote", to: "submissions#upvote"
      put "downvote", to: "submissions#downvote"
    end

    resources :comments do
      member do
        put "upvote", to: "comments#upvote"
        put "downvote", to: "comments#downvote"
      end
    end
  end

  get "submissions/unsubscribe/:unsubscribe_hash" => "submissions#unsubscribe", as: :comment_unsubscribe

  get :search, controller: :application

  devise_for :users
  root "submissions#index"

  resources :profiles, only: :show

  resource :pricing
  resources :checkouts
  resources :premium_subscriptions
  get "success", to: "checkouts#success"
  resources :webhooks, only: :create
  resources :billings, only: :create

end
