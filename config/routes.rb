Clipclap::Application.routes.draw do
  get "ranking/views"
  get "ranking/likes"

  devise_for :admin_users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :user, :controllers => {
    :registrations => "users/registrations",
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

  resources :clips, except: [ :edit, :update ] do
    member do
      # TODO: RESTを考慮した上でURI再設計
      get "like"
      get "unlike"
      post "tagging"
      get "untagging"
      post "comment"
      get "uncomment"

      put :reclip
      put :unreclip
    end

    collection do
      post "clipping"
      get "get_image_tags"
    end
  end

  resources :users do
    member do
      get :follow
      get :unfollow
    end

    resources :clips, only: :index
    resources :tags, only: :index
    match 'tags/:name(/:type)' => 'tags#show', via: :get, as: :tag
    resources :likes, only: :index
    resources :matomes, only: :index
  end

  match 'tags/:name(/:type)' => 'tags#show', via: :get, as: :tag
  resources :tags, only: [ :index ]

  match 'images/:id/:type' => 'images#show', via: :get
  resources :images, only: [ :show ]

  resources :matomes, only: [ :index, :show, :new, :create, :edit, :update ] do
    member do
      post :like
      delete :like, action: :unlike, as: :unlike
    end

    collection do
      get :clips
    end
  end

  get 'bookmarklet' => 'home#bookmarklet', via: :get, as: :bookmarklet
  get 'tutorial' => 'home#tutorial', via: :get, as: :tutorial
  get "home/index"
  root :to => "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
