Sistersigns::Application.routes.draw do
  root 'posts#index'
  resources :posts
  post '/posts/:id/approve' => "posts#approve", as: :approve_post

  post '/like' => "posts#create_like"

  get '/submit' => "posts#new", as: :submit
  get '/not-approved' => "posts#not_approved", as: :not_approved

  get '/most' => "posts#most", as: :most

  get "/auth/:provider/callback" => "sessions#create"
  get "/logout" => "sessions#destroy", :as => :logout

  get '/stat' => "posts#hello"
  
  get '/not-found' => "posts#not-found", :as => :not_found
  get '/about' => "posts#about", as: :about

  get '/:nickname' => "posts#by_nickname", :as => :by_nickname
end