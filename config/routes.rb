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
    resources :organizations
  end
  ########### admin ##########
  ############################

  ############################
  ########### hospital ##########
  namespace :hospital do
    resources :home
    resources :encounters  # 就诊管理、统计
    resources :orders      # 药品
    resources :prescriptions      # 处方
  end
  ########### hospital ##########
  ############################


  ############################
  ########### dict ##########
  namespace :dict do
    resources :diseases  # 诊断字典
    resources :medications #药品字典
  end
  ########### dict ##########
  ############################


  ############################
  ########### ims ##########
  namespace :ims do
    resources :home
  end
  ########### ims ##########
  ############################
end
