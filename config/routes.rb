Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#index'
  resources :users do
    member do
      get :view_file_changes_for, :as => :view_file_changes_for
      post :verify_file_changes_for, :as => :verify_file_changes_for
    end
  end
  resources :textfiles
  resources :tags do
    member do
      get :edit, :as => :edit
      post :update, :as => :update
      get :rename, :as => :rename
      post :do_rename, :as => :do_rename
    end
  end
end
