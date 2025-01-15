Rails.application.routes.draw do
  resources :urls
  get "/:url_shortener", to: "urls#redirect"
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
   root "urls#index"
end
