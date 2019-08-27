Rails.application.routes.draw do
  devise_for :users

  resources :products do
    resources :comments, only: [:create, :show, :edit, :update, :destroy]
  end
  delete "uploads/:id", to: "products#delete_image", :as => "uploads"

  resources :line_items, only: [:create, :update, :destroy]

  get "cart", to: "line_items#cart"
  get "orders", to: "line_items#orders"

  resources :charges

  root "products#index"
end
