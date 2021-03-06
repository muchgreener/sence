Sence::Application.routes.draw do
  
  resources :category_questions

  resources :categories

  resources :profiles

  resources :answers do
    collection do
      get 'history' => 'answers#history'
      get 'summary' => 'answers#summary'
    end
  end

  resources :questions do 
    collection do
      get 'mine' => 'questions#index'
      get 'nopicture' => 'questions#index'
      get 'random'
      get 'wapproval' => 'questions#index'
      get 'wimages'
    end
    member do
      post :approve
      get 'stats'
    end
  end
  
  devise_for :users,:controllers => {:sessions => "sessions",:registrations => "registrations"}
  
  resources :users do
    resources :questions
    resources :answers
    resources :profiles
  end

  match 'logout' => 'devise/session#destroy'
  match 'myrank' => 'profiles#myrank'
  match 'most' => 'statistics#most_answered'
  match 'gap' => 'statistics#gap'
  match 'aomq' => 'statistics#aomq'
  
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
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
