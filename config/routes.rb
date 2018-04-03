Rails.application.routes.draw do
  
  get '/users', to: "users#index"
  
  post 'users', to: 'users#create'
  get '/redirect', to: 'users#redirect', as: 'redirect'
  get '/callback', to: 'users#callback', as: 'callback'
  get '/calendars', to: 'users#calendars', as: 'calendars'
  get '/events/:calendar_id', to: 'users#events', as: 'events', calendar_id: /[^\/]+/
  post '/events/:calendar_id', to: 'users#new_event', as: 'new_event', calendar_id: /[^\/]+/
  
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'

	root to: "gatherings#index"
  resources :blogs
  resources :users
  resources :sessions
  resources :comments
  resources :gatherings
end
