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

	#root 'welcome#index'

  #get "physicians" => redirect "physicians/physicians"

  #public domain

  root :to => "home#index"
  get "pages/eua"

  #get 'home/download_pdf'

  get '/emailconfirmation', :controller => 'emailconfirmations', :action => 'index'

  resources :mailings



  # namespace :physicians do
  #
  #   devise_for :physicians, :controllers => { :registrations => 'physicians/registrations', :sessions =>  'physicians/sessions'}
  #
  #   #resources :prescriptions
  #   #resources :activities
  #   #resources :patients
  #   resources :physicians
  #   #resources :mailings
  #   #resources :inventories
  #   resources :invoices
  #   #resources :monthend
  #   resources :orders
  #   resources :orderhistories
  #
  #   #get '/physicians/inventories/month_end', :controller => 'inventories', :action => 'month_end'
  #
  # end

  namespace :patients, path: 'shop' do

    devise_for :patients, :controllers => { :registrations => 'patients/registrations', :sessions =>  'patients/sessions'}

    resources :patients

    get '/products', :controller => 'products', :action => 'index'
    post '/products', :controller => 'products', :action => 'add_to_cart'


    get '/cart', :controller => 'cart', :action => 'index'
    post '/cart', :controller => 'cart', :action => 'save'

    get '/checkout', :controller => 'checkout', :action => 'index'
    post '/checkout', :controller => 'checkout', :action => 'save'

    get '/faq', :controller => 'faq', :action => 'index'

    get '/terms', :controller => 'terms', :action => 'index'




  end

  # devise_scope :physicians do
  #   get '/physicians/physicians/sign_out' => 'physicians/sessions#destroy'
  # end

  devise_scope :patients do
    get '/patients/patients/sign_out' => 'patients/sessions#destroy'
  end

  wash_out :rumbas




end
