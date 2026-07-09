Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  namespace :admin do
    resources :categories
  end

  resources :transactions
  resources :clients
  resources :invoices

  resource :weekly_budget, only: [:show, :update], path: "presupuesto"
  resources :subscriptions, only: [:index, :create, :update, :destroy] do
    collection do
      post :create_pending
    end
  end
end
