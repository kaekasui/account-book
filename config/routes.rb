require 'sidekiq/web'

Rails.application.routes.draw do

  root 'home#index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    get 'users/mypage' => 'users/registrations#mypage'
  end

  resource :dashboard do
    post "/set_graph" => "dashboards#set_graph"#, on: :collection
  end
  get 'csv/new' => 'csv#new'
  post 'csv/import' => 'csv#import'
  resources :categories, except: [:new] do
    post "/set_categories_list" => "categories#set_categories_list", on: :collection
  end
  resources :breakdowns, except: [:new, :show]
  resources :records do
    post "/set_breakdowns_from_category" => "records#set_breakdowns_from_category", on: :collection
  end

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
end
