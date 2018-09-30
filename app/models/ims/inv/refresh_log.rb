class Ims::Inv::RefreshLog < ApplicationRecord

	def self.get_log startDate=nil, endDate=nil
		condition = {}
		startDate.present? && condition.merge!({:created_at.gt => Time.parse(startDate).beginning_of_day})
		endDate.present? && condition.merge!({:created_at.lt => Time.parse(endDate).end_of_day})

		return Ims::Inv::RefreshLog.where(condition)
  	end

end
