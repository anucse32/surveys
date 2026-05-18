Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :surveys, only: [ :index, :new, :create, :show ] do
    resources :responses, only: [ :create ]
  end

  root "surveys#index"
end
