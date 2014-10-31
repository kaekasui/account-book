require 'sidekiq/web'

Rails.application.routes.draw do

  root 'home#index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    get 'users/mypage' => 'users/registrations#mypage'
    get 'users/edit_email' => 'users/registrations#edit_email'
    post 'users/update_email' => 'users/registrations#update_email'
    #get 'users/cancel' => 'users/registrations#cancel'
  end

  resource :dashboard do
    post "/set_graph" => "dashboards#set_graph"#, on: :collection
  end
  get 'csv/new' => 'csv#new'
  post 'csv/import' => 'csv#import'
  resources :categories, except: [:new] do
    post "/set_categories_list" => "categories#set_categories_list", on: :collection
    post "/set_categories_box" => "categories#set_categories_box", on: :collection
  end
  resources :breakdowns, except: [:new, :show]
  resources :feedbacks, only: [:create]
  resource :notice, only: [:show] do
    get 'terms' => 'notice#terms'
  end
  resources :places
  resources :records do
    post "/set_breakdowns_from_category" => "records#set_breakdowns_from_category", on: :collection
    get "/download" => "records#download", on: :collection
  end
  resources :tags, only: [:index, :create, :update, :destroy] do
    post "/set_color_code_text_field" => "tags#set_color_code_text_field", on: :collection
    post "/set_name_text_field" => "tags#set_name_text_field", on: :collection
  end

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :admin do
    root 'feedbacks#index'
    resources :feedbacks
    resources :users, only: [:index]
  end
end
