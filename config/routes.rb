Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root "dashboard#index"

  resources :clients
  resources :legal_cases do
    resources :case_notes, only: %i[create destroy]
    member do
      delete :purge_document
    end
  end

  resources :users, except: %i[show]

  resources :proformas do
    member do
      post :send_email
      patch :update_status
    end
  end

  resources :alimony_calculations, only: %i[index new create show destroy] do
    member { post :send_email }
  end

  resources :settlement_calculations, only: %i[index new create show destroy] do
    member { post :send_email }
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # PWA — installable app (manifest + service worker rendered from app/views/pwa)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest, defaults: { format: "json" }
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker, defaults: { format: "js" }
end
