Rails.application.routes.draw do

  resources :welcome, only: :index
  root 'welcome#index'

  devise_scope :user do
    get "users/sign_up", to: "registrations#register"
  end

  resources :followings, only: [:create, :destroy]

  # search
  get "search" => 'restaurants#search'
  resources :articles, except: :index
  resources :restaurants, except: [:index, :destroy] do
    resources :reviews
  end
  get "users/hey" => "users#hey"
  devise_for :users, :controllers => {:registrations => "registrations"}
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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
