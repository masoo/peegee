Rails.application.routes.draw do
  root "top#index"
  resources :txt, only: [:index]
  resources :g, only: [:index]
  resources :japanese_secret_questions, only: [:index]
  get "kuronekoyamato.co.jp", to: "kuronekoyamato_co_jp#index", as: "kuronekoyamato_co_jp"
end
