# == Route Map
#

Rails.application.routes.draw do
  resources :users
  resources :stores
  resources :packages
  resources :products
  resources :items
  resources :departments
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
