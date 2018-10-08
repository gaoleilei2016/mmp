class Ims::Inv::RefreshLog < ApplicationRecord

	def self.get_log org_id,startDate=nil, endDate=nil
		logs = nil
		# startDate.present? && condition.merge!({:created_at.gt => Time.parse(startDate).beginning_of_day})
		# endDate.present? && condition.merge!({:created_at.lt => Time.parse(endDate).end_of_day})
		if(startDate.blank? && endDate.blank?)
			logs = Ims::Inv::RefreshLog.where('org_id = ?',org_id)
		elsif startDate.present? && endDate.present?
			logs = Ims::Inv::RefreshLog.where("created_at > ? AND created_at < ? and org_id = ?",Time.parse(startDate).beginning_of_day,Time.parse(endDate).end_of_day,org_id)
		elsif startDate.present?
			logs = Ims::Inv::RefreshLog.where("created_at > ? and org_id = ? ",Time.parse(startDate).beginning_of_day,org_id)
		else
			logs = Ims::Inv::RefreshLog.where("created_at < ? and org_id = ？",Time.parse(endDate).end_of_day,org_id)
		end
		return logs
  	end

end
