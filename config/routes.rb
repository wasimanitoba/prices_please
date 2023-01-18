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

  scope 'admin' do
    scope 'pipeline' do
      post '/scrape', to: 'admin#scrape'
      post '/transform', to: 'admin#transform'
      post '/load', to: 'admin#load'

      get '/', to: 'admin#pipeline', as: :pipeline
    end

    get '/', to: 'admin#index'
  end

  root 'home#index'
end
