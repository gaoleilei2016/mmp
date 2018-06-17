Rails.application.routes.draw do
  devise_for :users, controllers: {
    :sessions => 'users/sessions',
    :registrations =>"users/registrations",
    :passwords => "users/passwords",
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to:"customer/portal#index"
  mount ActionCable.server => "/cable"
  
  get "/application/menus",to:"application#menus"
  get "/application/templates",to:"application#templates"
  resources :interfaces do
    collection do
      get :get_orders
      post :pay_order
      post :save_order
      get :get_prescriptions_cart
      get :set_prescriptions_cart
      get :set_current_pharmacy
      get :get_current_pharmacy
      get :get_pharmacy
      get :get_yanzhengma
      get :get_duanxinma
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
    resources :home do
      collection do
        get :prescriptions
        get :orders
      end
    end
    resources :portal do
      collection do
        get :settlement
        get :pay
      end
    end
    resources :report
  end
  ########### customer ##########
  ############################

  ############################
  ########### hospital ##########
  namespace :hospital do
    namespace :sets do
      resources :inis do
        collection do
          get :cur_org_ini
        end
      end
      resources :mtemplates # 医嘱模板管理
    end
    resources :home
    # 就诊管理、统计
    resources :encounters do 
      collection do 
        post :quote_orders
      end
      member do
        get :all_prescriptions
      end
    end
    resources :orders      # 药品
    # 处方
    resources :prescriptions do
      collection do
        get :get_all_prescriptions_by_phone
        get :get_prescriptions_by_phone
      end
      member do
        post :set_drug_store
      end
    end
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
        get :get_order          # 获取订单
        get :charging_pre       # 收费
        get :dispensing_order   # 发药
        get :return_order       # 退药
        get :oprate_order       # 订单操作(发药/退药、、)
        get :order_settings
        get :get_detail
        get :get_search_data    # 未发订单或处方检索
        get :get_order_by_code  # 已发药或已退订单检索  
        post :create_order  #生成订单
      end
    end

    resources :settings do
      collection do
        get :get_cur_set
        post :save_settings
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
  # mount Pay::Api => '/'
  match '/users/positions/baidu', to: 'positions#baidu', via: [:get]
  match '/pay/wechat', to: 'pay#wechat', via: [:post]
  match '/pay/alipay', to: 'pay#alipay', via: [:post]

  match '/pay/index',  to: 'pay#index',  via: [:get]
  match '/pay/wx/pay', to: 'pay#wx', via: [:post]
  match '/pay/ali/pay', to: 'pay#ali', via: [:post]
  ########### hujun_end   ##########
end
