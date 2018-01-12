Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :customers, only: [:new, :create, :show, :edit, :update]
  resources :sessions, only: [ :new, :create ]
  resources :images, only: [:new, :create]
  resources :notes, only: [:new, :create, :destroy]
  resources :businesses, only: [:new, :create, :show, :edit, :update]

  # visit
  get 'customers/visits/:id' => 'visits#new'
  post '/visits/' => 'visits#create'
  get '/visits/:id' => 'visits#show'

  # users
  get '/routes' => 'users#route'
  delete '/sessions' => 'sessions#destroy'
  get '/new_owner' => 'users#new_owner'
  post '/new_owner' => 'users#owner_create'
  get '/forgot_password' => 'users#forgot_password'
  post '/request_password' => 'users#request_password'
  get '/reset_password/:id' => 'users#reset_password'
  patch '/update_password/:id' => 'users#update_password'
  root "users#index"

  #customers
  get '/customers/:id/history' => 'customers#history'
  get '/customers/:id/directions' => 'customers#directions'

  #business
  post '/businesses/rest_weekely_complete' => 'businesses#reset_weekely_visit'

  #repairs
  resources :repairs, only: [ :create, :show, :edit, :update, :index ]
  post '/repairs/complete/:id' => 'repairs#complete'
  get 'customers/repairs/:id' => 'repairs#new'
  
end
