# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  resources :pipelines do
    member do
      post 'run', to: 'pipelines#run', as: :run
    end
  end

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

  root 'home#index'
end
