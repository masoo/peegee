Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "top#index"
  resources :txt, only: [:index]
  resources :g, only: [:index]
  resources :japanese_secret_questions, only: [:index]
  get "kuronekoyamato.co.jp", to: "kuronekoyamato_co_jp#index", as: "kuronekoyamato_co_jp"
  get "nenkin.go.jp", to: "nenkin_go_jp#index", as: "nenkin_go_jp"
  get "sbisec.co.jp", to: "sbisec_co_jp#index", as: "sbisec_co_jp"
end
