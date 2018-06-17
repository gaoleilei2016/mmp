class ::Hospital::Sets::Mtemplate < ApplicationRecord

	belongs_to :organization,  class_name: "::Admin::Organization",       foreign_key: 'org_id', optional: true
	belongs_to :author,  class_name: "::User",       foreign_key: 'author_id', optional: true
	belongs_to :location,  class_name: "::Hospital::Sets::Department",       foreign_key: 'location_id', optional: true
	has_many :orders, class_name: "Hospital::Order", foreign_key: 'mtemplate_id'


	def to_web_front
		ret = {
			id: self.id,
			status: self.status,
			title: self.title,
			note: self.note,
			sharing_scope: {
				code: self.sharing_scope_code,
				display: self.sharing_scope_display
			},
			disease:{
				code: self.disease_code,
				display: self.disease_display
			},
			author:{
				id: self.author_id,
				display: self.author_display
			},
			location:{
				id: self.location_id,
			    display: self.location_display
			},
			organization: {
				id: self.org_id
			},
			created_at: self.created_at,
			updated_at: self.updated_at,
			orders: self.orders.map { |e| e.to_web_front  }
		}
	end

	class<<self
	end
end



# rails g model Hospital::Sets::Mtemplate enable_print_pres:boolean uoperator_id:integer print_pres_html:text org_id:integer

# field :org_id                         ,integer
# field :status                     , type: String        # 状态
# field :title                      , type: String        # 主题本文，模板名称
# field :note                       , type: String        # 备注
# field :sharing_scope_code              , type: String        # 共享范围  
# field :sharing_scope_display              , type: String        # 共享范围  
# field :disease_code                    , type: String        # 病种
# field :disease_display                    , type: String        # 病种
# field :author_id                     , type: String        # 作者
# field :author_display                     , type: String        # 作者
# field :location_id                   , type: String        # 科室
# field :location_display                   , type: String        # 科室
# field :search_str                 , type: String  # 搜索字段
# field :orders                     , type: Array    # 0-*  Cosds::Order    [{id:"",display:""}]




# rails g model Hospital::Sets::Mtemplate org_id:integer status:string title:string note:string sharing_scope_code:string sharing_scope_display:string disease_code:string disease_display:string author_id:integer author_display:string location_id:integer location_display:string search_str:string
