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
    namespace :sets do
      resources :inis do
        collection do
          get :cur_org_ini
        end
      end
    end
    resources :home
    # 就诊管理、统计
    resources :encounters do 
      member do
        get :all_prescriptions
      end
    end
    resources :orders      # 药品
    # 处方
    resources :prescriptions do
      collection do
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
    resources :orders do #药品订单
      collection do
        get :get_orders
        get :get_order
        post :create_order  #生成订单
        get :dispensing_order  #订单发药
        get :return_order  #订单退药
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
