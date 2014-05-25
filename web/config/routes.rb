Rails.application.routes.draw do


  get 'songs/new'

  get 'songs/update'

  get 'songs/edit'

  get 'songs/destroy'

  get 'songs/index'

  get 'songs/show'

  get 'users/new'

  get 'users/create'

  get 'users/update'

  get 'users/destroy'

  get 'users/index'

  get 'users/show'

  root :to => 'welcome_pages#home'
  match '/about',         to:   'welcome_pages#about',        via: 'get'

  match '/sign_in',       to:   'sessions#new',               via: 'get'
  match '/sign_in',       to:   'sessions#create',            via: 'post'
  match '/sign_out',      to:   'sessions#destroy',           via: 'get'

  match '/sign_up',       to:   'users#new',                  via: 'get'
  match '/sign_up',       to:   'users#create',               via: 'post'
  match 'dj_booth',         to:   'station#dj_booth',          via: 'get'
  match 'playlist_editor',  to: 'station#playlist_editor',      via: 'get'
  match 'station/update_order' => 'station#update_order',       via: 'post'
  match 'songs/create',   to:   'songs#create',                 via: 'post'
  match 'songs/check_for_song', to: 'songs#check_for_song',      via: 'get'
  match 'station/add_to_rotation', to: 'station#add_to_rotation',   via: 'post'
  match 'station/delete_from_rotation', to: 'station#delete_from_rotation', via: 'delete'

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
