Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]

  resources :users
  authenticated :user do
    root :to => 'hmos#all_transactions_index', :as => :authenticated_root
  end
  root :to => redirect('/users/sign_in')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :patients do
  	member do
  		put :check_available
      get :download_image
  	end
    collection do
      get :make_payment
      post :pay
      get :uploaded_patients_index
      get :payment_method_patients_index
    end
  end
  resources :hospitals
  resources :hmos do
    collection do
      get :hmo_patients_index
      get :active_transactions_index
      get :collectibles_index
      get :all_transactions_index
    end
  end
  resources :patient_uploads do
    member do
      put :process_csv
    end
  end
end
