Rails.application.routes.draw do
  devise_for :users, controllers: {
    :sessions => 'users/sessions',
    :registrations =>"users/registrations",
    :passwords => "users/passwords",
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to:"customer/portal#index"
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
    resources :portal do
      collection do
        get :settlement
      end
    end
    resources :report
  end
  ########### customer ##########
  ############################

  ############################
  ########### hospital ##########
  namespace :hospital do
    resources :home
    # 就诊管理、统计
    resources :encounters do 
      member do
        get :all_prescriptions
      end
    end
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
    resources :orders do
      collection do
        get :get_orders         # 获取订单
        get :dispensing_order   # 发药
        get :return_order       # 退药
        get :oprate_order       # 订单操作(发药/退药、、)
      end
    end
    resources :interfaces do
      collection do
        
      end
    end
  end
  ########### ims ##########
  ############################

  ########### hujun_start ##########
  match '/users/positions/baidu', to: 'positions#baidu', via: [:get]
  ########### hujun_end   ##########
end
