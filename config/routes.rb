Rails.application.routes.draw do
  devise_for :users, controllers: {
    :sessions => 'users/sessions',
    :registrations =>"users/registrations",
    :passwords => "users/passwords",
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to:"customer/home#index"
  get "/application/menus",to:"application#menus"
  get "/application/templates",to:"application#templates"
  resources :interfaces do
    collection do
      get :get_pharmacy
      get :get_dicts
      get :get_addrs
      get :get_medicine_by_name
    end
  end
  ############################
  ########### admin ##########
  namespace :admin do
    resources :home
    resources :organizations
    resources :users
  end
  ########### admin ##########
  ############################

  ############################
  ########### customer 个人中心 客户 ##########
  namespace :customer do
    resources :home
    resources :portal
    resources :report
  end
  ########### customer ##########
  ############################

  ############################
  ########### hospital ##########
  namespace :hospital do
    resources :home
    resources :encounters  # 就诊管理、统计
    resources :orders      # 药品
    resources :prescriptions      # 处方
    resources :histories      # 历史列表
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
    resources :orders
    resources :interfaces do
      collection do
        
      end
    end
  end
  ########### ims ##########
  ############################
end
