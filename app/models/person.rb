class Person < ApplicationRecord

	belongs_to :user,                   :class_name => '::User',                        :foreign_key => 'user_id', optional: true
	has_many :encounters,				:class_name => '::Hospital::Encounter',			:foreign_key => 'person_id'
	has_many :irritabilities,           :class_name => '::Hospital::Irritability',      :foreign_key => 'person_id'


	validates :name, :phone, :age, :gender_code,:gender_display, presence: {message: "不能为空"}

	def to_web_front
		ret = {
			id: self.id,
			iden: self.iden,
			name: self.name,
			name_jp: self.name_jp,
			name_wb: self.name_wb,
			birth_date: self.birth_date,
			age: self.age,
			gender: {
			  code: self.gender_code, 
			  display: self.gender_display
			},
			occupation:{
			  code: self.occupation_code,
			  display: self.occupation_display
			},
			phone: self.phone,
			address: self.pa_address,
			unit_name: self.unit_name,
			ua_address: self.ua_address,
			unit_phone: self.unit_phone,
			contact_name: self.contact_name,
			contact_phone: self.contact_phone,
			created_at: self.created_at,
			updated_at: self.updated_at,
			nation: {
			  code: self.nation_code,
			  display: self.nation_display
			},
			blood:{
			  code: self.blood_code,
			  display: self.blood_display
			},
			marriage:{
			  code: self.marriage_code,
			  display: self.marriage_display
			},
			height: self.height,
			weight: self.weight,
			person_id: self.id
		}
		return ret
	end


end



# field :health_file_no,             type: String                   # => 0-1 居民健康档案号                                                                                           
# field :iden,                       type: String                   # => 0-1 患者身份证件号码                                                                                 
# field :health_card_no,             type: String                   # => 0-1 居民健康卡号                                                                                           
# field :name,                       type: String                   # => 0-1 患者姓名                                                                                 
# field :birth_date,                 type: DateTime                 # => 0-1 出生日期                                                                                       
# field :age,                        type: Integer                  # => 0-1 年龄                                                                                                                                                                        
# field :gender_code,                type: String                   # => 0-1 性别代码                                                                                        
# field :gender_display,                type: String                   # => 0-1 性别名称                                                                                        
# field :nationality_code,           type: String                   # => 0-1 国籍代码                                                                                             
# field :nationality_display,           type: String                   # => 0-1 国籍名称                                                                                             
# field :home_town_province,         type: String                   # => 0-1 籍贯-省（自治区、直辖市）                                                                                               
# field :home_town_city,             type: String                   # => 0-1 籍贯-市（地区、州）                                                                                           
# # field :birt_province,              type: String                   # => 0-1 出生地-省（自治区、直辖市）                                                                                          
# # field :birt_city,                  type: String                   # => 0-1 出生地-市（地区、州）                                                                                      
# # field :birt_country,               type: String                   # => 0-1 出生地-县（区）                                                                                         
# field :nation_code,                type: String                   # => 0-1 民族代码                                                                                          
# field :nation_display,                type: String                   # => 0-1 民族名称                                                                                        
# field :marriage_code,              type: String                   # => 0-1 婚姻状况代码                                                                                          
# field :marriage_display,              type: String                   # => 0-1 婚姻状况名称                                                                                          
# field :education_code,             type: String                   # => 0-1 文化程度代码                                                                                           
# field :education_display,             type: String                   # => 0-1 文化程度                                                                                           
# field :occupation_code,            type: String                   # => 0-1 职业类别代码                                                                                            
# field :occupation_display,            type: String                   # => 0-1 职业类别名称                                                                                            
# field :phone,                      type: String                   # => 0-1 电话号码                                                                                         
# field :email,                      type: String                   # => 0-1 电子邮件                                                                                  
# # field :pa_province,                type: String                   # => 0-1 现住址-省（自治区、直辖市）                                                                                        
# # field :pa_city,                    type: String                   # => 0-1 现住址-市（地区、州）                                                                                    
# # field :pa_country,                 type: String                   # => 0-1 现住址-县（区）                                                                                       
# # field :pa_town_ship,               type: String                   # => 0-1 现住址-乡（镇、街道办事处）                                                                                         
# # field :pa_street,                  type: String                   # => 0-1 现住址-村(街、路、弄等）                                                                                      
# # field :pa_house_number,            type: String                   # => 0-1 现住址-门牌号码                                                                                            
# field :pa_post_code,               type: String                   # => 0-1 现住址-邮政编码                                                                                         
# field :pa_address,                  type: String                   # => 0-1 现住址-详细地址                                                                                      
# # field :ha_province,                type: String                   # => 0-1 户口地址-省（自治区、直 辖市）                                                                                        
# # field :ha_city,                    type: String                   # => 0-1 户口地址-市(地区、州）                                                                                    
# # field :ha_country,                 type: String                   # => 0-1 户口地址-县（区）                                                                                       
# # field :ha_town_ship,               type: String                   # => 0-1 户口地址-乡（镇、街道办 事处）                                                                                         
# # field :ha_street,                  type: String                   # => 0-1 户口地址-村（街、路、弄 等）                                                                                      
# # field :ha_house_number,            type: String                   # => 0-1 户口地址-门牌号码                                                                                            
# field :ha_post_code,               type: String                   # => 0-1 户口地址-邮政编码                                                                                         
# field :ha_address,                  type: String                   # => 0-1 户口地址-详细地址                                                                                      
# field :unit_name,                  type: String                   # => 0-1 工作单位名称                                                                                      
# field :unit_phone,                 type: String                   # => 0-1 工作单位电话号码                                                                   
# # field :ua_province,                type: String                   # => 0-1 工作单位地址-省（自治区、直辖市）                                                                                   
# # field :ua_city,                    type: String                   # => 0-1 工作单位地址-市（地区、 州）                                                                             
# # field :ua_country,                 type: String                   # => 0-1 工作单位地址-县（区）                                                                                                    
# # field :ua_town_ship,               type: String                   # => 0-1 工作单位地址-乡（镇、街 道办事处）                                                                                       
# # field :ua_street,                  type: String                   # => 0-1 工作单位地址-村（街、路、 弄等）                                                                           
# # field :ua_house_number,            type: String                   # => 0-1 工作单位地址-门牌号码                                                                                            
# field :ua_post_code,               type: String                   # => 0-1 工作单位地址-邮政编码                                                                                         
# field :ua_address,                  type: String                   # => 0-1 工作单位地址-详细地址                                                                                                     
# field :contact_name,               type: String                   # => 0-1 联系人姓名                                                                                         
# field :contact_relation_code,      type: String                   # => 0-1 联系人与患者的关系代码                                                                                                  
# field :contact_relation_display,   type: String                   # => 0-1 联系人与患者的关系名称                                                                                                  
# field :contact_phone,              type: String                   # => 0-1 联系人电话号码                                                                                          
# # field :ca_province,                type: String                   # => 0-1 联系人地址-省（自治区、 直辖市）                                                                                        
# # field :ca_city,                    type: String                   # => 0-1 联系人地址-市（地区、州）                                                                                    
# # field :ca_country,                 type: String                   # => 0-1 联系人地址-县（区）                                                                                       
# # field :ca_town_ship,               type: String                   # => 0-1 联系人地址-乡（镇、街道 办事处）                                                                                         
# # field :ca_street,                  type: String                   # => 0-1 联系人地址-村(街、路、弄等）                                                                                      
# # field :ca_house_number,            type: String                   # => 0-1 联系人地址-门牌号码                                                                                            
# field :ca_post_code,               type: String                   # => 0-1 联系人地址-邮政编码                                                                                         
# field :ca_address,                  type: String                   # => 0-1 联系人地址-详细地址                                                                                      
# field :input_date,                 type: DateTime                 # => 0-1 建档日期时间                                                                                       
# field :input_organ_code,           type: String                   # => 0-1 建档医疗机构组织机构代码                                                                                             
# field :input_organ_name,           type: String                   # => 0-1 建档医疗机构组织名称                                                                                             
# field :input_name,                 type: String                   # => 0-1 建档者姓名                                                                                       