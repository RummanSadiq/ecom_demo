Rails.application.routes.draw do
  devise_for :users
  resources :charges

  resources :products do
    resources :comments, shallow: true
  end

  resources :line_items, only: [:create, :update, :destroy]
  delete "uploads/:id", to: "products#delete_image", :as => "uploads"

  get "cart", to: "line_items#cart"
  get "orders", to: "line_items#orders"

  root "products#index"
end
