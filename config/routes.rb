Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#index'
  resources :users
  resources :textfiles
  resources :tags do
    member do
      get :mass_edit, :as => :mass_edit
      post :do_mass_edit, :as => :do_mass_edit
    end
  end
end
