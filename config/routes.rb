Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#index'
  resources :users do
    member do
      get :view_file_changes_for, :as => :view_file_changes_for
      post :verify_file_changes_for, :as => :verify_file_changes_for
      get "untagged" => "users#show_untagged", :as => :show_untagged
      get :import, :as => :import
      get :export, :as => :export
    end
  end
  resources :textfiles
  resources :tags do
    member do
      post :change_tagged, :as => :change_tagged
      post :change_properties, :as => :change_properties
    end
  end
end
