class Ims::Inv::RefreshLog < ApplicationRecord

	def self.get_log startDate=nil, endDate=nil
		logs = nil
		# startDate.present? && condition.merge!({:created_at.gt => Time.parse(startDate).beginning_of_day})
		# endDate.present? && condition.merge!({:created_at.lt => Time.parse(endDate).end_of_day})
		if(startDate.blank? && endDate.blank?)
			logs = Ims::Inv::RefreshLog.all
		elsif startDate.present? && endDate.present?
			logs = Ims::Inv::RefreshLog.where("created_at > ? AND created_at < ?",Time.parse(startDate).beginning_of_day,Time.parse(endDate).end_of_day)
		elsif startDate.present?
			logs = Ims::Inv::RefreshLog.where("created_at > ?",Time.parse(startDate).beginning_of_day)
		else
			logs = Ims::Inv::RefreshLog.where("created_at < ?",Time.parse(endDate).end_of_day)
		end
		return logs
  	end

end
