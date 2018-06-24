class CreateImsSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_settings do |t|
      t.string :org_ii,default:'',comment:'组织机构' 
      t.string :org_name,default:'',comment:'组织机构名称' 
      t.string :returned_at,default:'',comment:'可退药时间天数' 
      t.string :payment_Expired,default:'',comment:'付费未取药过期天数' 
      t.string :unpaid_expired,default:'',comment:'未支付订单过期天数' 
      t.boolean :voice_prompts,default:false,comment:'是否语音提示' 

      t.timestamps
    end
  end
end