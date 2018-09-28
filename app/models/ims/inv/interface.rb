class Ims::Inv::Interface < Grape::API
	resource :useInfo  do
		post do
			puts "-------wqj--------"
			data=params["userinfo"]
			puts data
			# hh=eval(data)
			# puts data
			{ret_code:'1',info:'ok'}
		end
	end
end