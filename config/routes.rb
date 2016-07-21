Rails.application.routes.draw do
  resources :sessions, only: [:new, :create]

  match 'logout' => 'sessions#destroy', as: 'logout', via: [:get, :post]

  resources :users
  resources :friendships

  root "users#index"

  resources :messages do
  	collection do
  		get :sent
  		get :received
  	end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
