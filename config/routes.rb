Rails.application.routes.draw do

  resources :welcome, only: :index
  root 'welcome#index'
  get "welcome/splash" => "welcome#splash"

  get "users/unknown_user" => "users#unknown_user"

  devise_scope :user do
    get "users/sign_up", to: "registrations#register", as: "new_user_registration_path"
    post "users/sign_up", to: "registrations#create", as: "user_registration"
  end
  devise_scope :user do
    get "users/sign_in", to: "sessions#new", as: "new_user_session_path"
    post "users/sign_in", to: "sessions#create", as: "user_session"
  end


  get '/users/finish_signup' => 'users#show_finish_signup'
  post "/users/finish_signup" => "users#finish_signup"

  post "/followings" => "followings#create"
  delete "/followings" => "followings#destroy"

  delete "/restaurants/:restaurant_id/bookmarks" => "bookmarks#destroy"

  # search
  get "search" => 'restaurants#search'
  get "search/filter" => 'restaurants#filter'

  resources :articles, except: :destroy
  resources :restaurants, except: [:index, :destroy] do
    resources :quick_takes, only: [:new, :create]
    resources :reviews
    resources :bookmarks, only: [:create]
    resources :visits, only: [:create]
    resources :specialties, only: [:create]
  end


  devise_for :users, :controllers => {:registrations => "registrations", omniauth_callbacks: "omniauth_callbacks", sessions: "sessions"}

  get "/users/top-reviewers" => 'users#top_reviewers', as: :top_reviewers

  get "/users/invite" => 'users#invite'
  post "/admins/invite" => 'users#reviewer_invite'
  post "/users/invite" => "users#user_invite"
  resources :users, only: [:show] do
    resources :profiles, only: [:new, :create, :edit, :update]
  end

  post 'reviews/:id/upvote'       => 'reviews#upvote', as: :upvote_review
  post 'reviews/:id/downvote'     => 'reviews#downvote', as: :downvote_review
  post 'comments/:id/upvote'      => 'comments#upvote', as: :upvote_comment
  post 'comments/:id/downvote'    => 'comments#downvote', as: :downvote_comment
  post 'specialties/:id/upvote'   => 'specialties#upvote', as: :upvote_specialty
  post 'specialties/:id/downvote' => 'specialties#downvote', as: :downvote_specialty
  post 'restaurants/:restaurant_id/reviews/:id/comments' => 'comments#create'

end
