Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :sessions, only: [:create] do
        collection do
          delete :destroy
          post :facebook
        end
      end
    end
  end

  root to: 'pages#index'

  resources :pages, only:[] do
    get :check_session
  end

  resources :pages, only: [:index]
end
