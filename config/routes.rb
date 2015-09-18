Rails.application.routes.draw do
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

  #get "physicians" => redirect "physicians/physicians"

  #public domain

  root :to => "home#index"


  get '/emailconfirmation', :controller => 'emailconfirmations', :action => 'index'

  resources :mailings



  namespace :physicians do

    devise_for :physicians, :controllers => { :registrations => 'physicians/registrations', :sessions =>  'physicians/sessions'}

    resources :prescriptions
    resources :activities
    resources :patients
    resources :physicians
    resources :mailings
    #resources :inventories
    resources :monthend
    resources :orders
    resources :orderhistories

    #get '/physicians/inventories/month_end', :controller => 'inventories', :action => 'month_end'

  end

  devise_scope :physicians do
    get '/physicians/physicians/sign_out' => 'physicians/sessions#destroy'
  end

  wash_out :rumbas


  # namespace :patients do
  #
  #   devise_for :patients, :controllers => { :registrations => 'patients/registrations', :sessions =>  'patients/sessions'}
  #
  #   resources :prescriptions
  #   resources :patients
  #   resources :activities
  #   resources :mailings
  #
  #
  #
  #   #healthvault post
  #   resources :activities do
  #     post :connect_to_health_vault, :on => :collection
  #   end
  #
  #   resources :activities do
  #     post :disconnect_from_health_vault, :on => :collection
  #   end
  #
  #
  # end

  # devise_scope :patients do
  #   get '/patients/patients/sign_out' => 'patients/sessions#destroy'
  # end


end
