# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :all

  scope 'users' do
    post 'sign_in', to: 'users#login'
    post 'sign_up', to: 'users#sign_up'
    get 'show/(:id)', to: 'users#show'
    patch 'update', to: 'users#update'
    delete 'delete', to: 'users#delete'
    get 'students', to: 'users#student_index'
  end
end
