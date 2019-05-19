Rails.application.routes.draw do
  root "top#index"
  resources :txt, only: [:index]
  resources :g, only: [:index]
  resources :japanese_secret_questions, only: [:index]
end
