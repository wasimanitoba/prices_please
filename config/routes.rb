# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  resources :shopping_lists
  resources :shopping_selections
  resources :errands
  resources :budgets
  resources :brands
  resources :sales
  resources :packages
  resources :users
  resources :stores
  resources :products
  resources :items
  resources :departments
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'
end
