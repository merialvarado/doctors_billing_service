Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]

  resources :users do
    collection do
      get :system_settings
    end
  end
  authenticated :user do
    root :to => 'hmos#active_transactions_index', :as => :authenticated_root
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
      get :all_details
      post :transactional_report
      post :collection_detailed_report
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
  resources :surgeons
  resources :procedure_types
end
