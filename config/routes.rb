Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    :registrations =>"users/registrations",
    :passwords => "users/passwords",
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to:"application#index"
  get "/application/menus",to:"application#menus"
  get "/application/templates",to:"application#templates"
  resources :interfaces do
  end
  ############################
  ########### admin ##########
  namespace :admin do
    resources :home
  end
  ########### admin ##########
  ############################

  ############################
  ########### hospital ##########
  namespace :hospital do
    resources :home
  end
  ########### hospital ##########
  ############################

  ############################
  ########### ims ##########
  namespace :ims do
    resources :home
    resources :orders do #药品订单
      collection do
        get :get_orders
        get :get_order
        get :oprate_order
      end
    end
  end
  ########### ims ##########
  ############################
end
