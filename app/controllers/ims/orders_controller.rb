class Ims::OrdersController < ApplicationController
	def index
	end

	def get_orders
		data = [
			{id:"12435",code:"08020231",name:"rth",amount:"14.23"},
			{id:"67874",code:"08020232",name:"ktys",amount:"52.23"},
			{id:"46876",code:"08020233",name:"fghsr",amount:"16.23"},
		]
		render json:data.to_json
	end
	def get_order
		data = [{
			header:{id:"121sdf20sd1g2asd0f",status:"P",patient_name:"张三",},
			lines:[
				{item_code:"1090",text:"yaopin",total_quantity:"23",unit:"克"},
				{item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
				{item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
				{item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
				{item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
				{item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
				{item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
				{item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
				{item_code:"1090",text:"yaopin",total_quantity:"23",unit:"克"},
			]
			}]
		render json:data.to_json
	end

	def oprate_order
		p params[:id]
		p params[:method] #out_order  refuse_order   check_order   return_order
		# render json:{flag:false}
		render json:{flag:true}
	end
end
