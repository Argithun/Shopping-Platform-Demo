Rails.application.routes.draw do
  get 'products/index'
  get 'welcome/home'
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :products do
    resources :comments, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :favorites
  resources :cart_items
  resources :order_items do
    member do
      put 'pay'
      put 'cancel'
      put 'receive'
      put 'sent'
      put 'reject'
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # Defines the root path route ("/")
  # root "posts#index"
  get 'welcome/home' => 'welcome#home'
  root 'welcome#home'
end
