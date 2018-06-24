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
      post :refund_order
      get :get_orders
      post :pay_order
      post :save_order
      post :cancel_order
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
        get :prescription
        get :orders
        get :order
        get :confirm_order
      end
    end
    resources :portal do
      collection do
        
        get :pullrefresh_main
        get :pullrefresh_sub
        get :full_screen

        get :map
        get :settlement
        get :pay
      end
    end
    resources :report
    resources :invoice_headers
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
          get :get_org_user_list
        end
      end
      resources :departments do 
        collection do 
          get :get_active_departments
          post :set_cur_department
        end
      end
      resources :mtemplates # 医嘱模板管理
      resources :codes # 编码表
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
        get :get_not_read_prescription
        put :read_prescription
      end
      member do
        post :set_drug_store
      end
    end
    resources :histories      # 历史列表

    # 诊断
    resources :diagnoses do
      collection do
        post :sort
      end
    end

    resources :patients
    resources :people
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
        get :get_prescriptions  # 获取处方信息
        get :get_prescription   # 获取处方信息 
        get :charging_pre       # 收费
        get :dispensing_order   # 发药
        get :return_order       # 退药
        get :oprate_order       # 订单操作(发药/退药、、)
        get :order_settings
        get :get_detail
        get :get_search_data    # 未发订单或处方检索
        get :get_order_by_code  # 已发药或已退订单检索  
        post :operat_order_by_prescription   # 平台处方收费或收费并发药操作
        get :return_drug           # 退药
        get :prescription_back     # 下载错误处方返回      
        post :create_order  #生成订单
        post :order_setting  #订单设置
      end
    end

    # 设置
    resources :settings do
      collection do
        get :get_cur_set
        post :save_settings
      end
    end

    # 统计
    resources :reports do
      collection do
        get :sale_report                          # 销售统计
        get :dispensed_hospital                   # 处方发药汇总-医院
        get :dispensed_name                       # 处方发药汇总-发药人
        get :dispensed_hospital_and_name          # 处方发药汇总-医院及发药人
        get :dispensed_name_and_hospital          # 处方发药汇总-发药人及医院
        get :returned_hospital                    # 处方退药汇总-医院
        get :returned_name                        # 处方退药汇总-发药人
        get :returned_hospital_and_name           # 处方退药汇总-医院及发药人
        get :returned_name_and_hospital           # 处方退药汇总-发药人及医院
        get :drug_report                          # 处方药品汇总表
        get :drug_dispensed_report                # 处方发药汇总表
        get :drug_returned_report                 # 处方退药汇总表
        get :drug_dispensed_fact                  # 处方发药汇总-厂家
        get :drug_returned_fact                   # 处方退药汇总-厂家
        get :order_static                         # 订单统计(针对未交费、待发药)

        post :report_detail                       # 报表查看明细
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
  # match '/users/positions/baidu', to: 'positions#baidu', via: [:get]
  match '/pay/wechat', to: 'pay#wechat', via: [:post]
  match '/pay/alipay', to: 'pay#alipay', via: [:post]

  match '/pay/confirm/:id', to: 'pay#confirm', via: [:get]
  match '/pay/index',       to: 'pay#index',   via: [:get]
  match '/pay/wx/pay',      to: 'pay#wx',      via: [:post]
  match '/pay/ali/pay',     to: 'pay#ali',     via: [:post]

  match '/refund/wechat', to: 'refund#wechat', via: [:post]
  match '/refund/alipay', to: 'refund#alipay', via: [:post]

  match '/wechat/login',  to: 'wechat#login', via: [:get]
  match '/wechat/public_pay', to: 'wechat#pay', via: [:post]
  match '/wechat/websocket', to: 'wechat#websocket', via: [:get]
  match '/wechat/info',  to: 'wechat#info', via: [:post]
  ########### hujun_end   ##########
end
