#encoding: utf-8
require 'mysql2'
class Ims::GetData < ApplicationRecord
	class << self
		# 执行存储过程
		def find_data args={}
			begin
				# client = Mysql2::Client.new(:host => "192.168.2.207",:username => "root",:password => "Tenmind@207",:port => "3306",:database => "mmp")
				client = Mysql2::Client.new(:host => "192.168.2.207",
		                            :username => "root",
		                            :password => "Tenmind@207",
		                            :port => "3306",
		                            :database => "mmp_lgl"
		                            )
				# sql = "select code,name,py from dictarea limit 5";
				sql = "CALL p_getYPDataList('#{args[:search]}',#{args[:i_days]},'#{args[:org_id]}');"
				p sql
				result = client.query(sql).to_a 
			rescue Exception => e
				print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 执行存储过程 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
			end
		end
	end

end