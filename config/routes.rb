# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :all

  scope 'users' do
    post 'sign_in', to: 'users#login'
    post 'sign_up', to: 'users#sign_up'
    get 'show/(:id)', to: 'users#show'
    patch 'update', to: 'users#update'
    delete 'delete', to: 'users#delete'
    # get 'students', to: 'users#student_index'
  end

  scope 'categories' do
    post 'create', to: 'categories#create'
    get 'index', to: 'categories#index'
    get 'show/(:id)', to: 'categories#show'
    patch 'update/:id', to: 'categories#update'
    delete 'delete/:id', to: 'categories#delete'
  end

  scope 'gym_classes' do
    post 'create', to: 'gym_classes#create'
    get 'index', to: 'gym_classes#index'
    get 'show/:id', to: 'gym_classes#show'
    patch 'update/:id', to: 'gym_classes#update'
    delete 'delete/:id', to: 'gym_classes#delete'
  end
end
