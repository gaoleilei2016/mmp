#encoding: utf-8
require 'mysql2'
class Ims::GetData < ApplicationRecord
	class << self
		def find_data
			client = Mysql2::Client.new(:host => "192.168.2.207",
	                            :username => "root",
	                            :password => "Tenmind@207",
	                            :port => "3306",
	                            :database => "mmp"
	                            )
			# sql = "select code,name,py from dictarea limit 5";
			sql = "CALL p_getYPDataList('45',7,'34');"
			result = client.query(sql)
			
		end
	end

end