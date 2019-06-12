Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]

  resources :users
  authenticated :user do
    root :to => 'users#dashboard', :as => :authenticated_root
  end
  root :to => redirect('/users/sign_in')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :patients do
  	member do
  		put :check_available
  	end
    collection do
      get :make_payment
      post :pay
    end
  end
  resources :hospitals
end
