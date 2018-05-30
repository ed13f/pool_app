Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :customers, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :sessions, only: [ :index, :new, :create ]
  resources :images, only: [:new, :create]
  resources :notes, only: [:new, :create, :destroy]
  resources :businesses, only: [:new, :create, :show, :edit, :update]

  # visit
  get 'customers/:id/visits' => 'visits#new'
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
  post '/update_password/:id' => 'users#update_password'
  root "sessions#index"

  # resets
  get '/resets' => 'resets#new'
  post '/resets' => 'resets#create'
  get '/resets/:id' => 'resets#edit'
  post '/resets/:id' => 'resets#update'

  #customers
  get '/customers/:id/history' => 'customers#history'
  get '/customers/:id/directions' => 'customers#directions'

  #business
  post '/businesses/rest_weekely_complete' => 'businesses#reset_weekely_visit'

  #repairs
  resources :repairs, only: [ :create, :show, :edit, :update, :index, :destroy ]
  post '/repairs/:id/complete' => 'repairs#complete'
  get 'customers/:id/repairs' => 'repairs#new'

  #days
  post '/days' => 'days#new'

end
