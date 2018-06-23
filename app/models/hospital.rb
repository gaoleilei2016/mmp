module ::Hospital
	METEDATA = {
		"Hospital::Sets::Department" => "hospital.sets.department.",
		"Hospital::Sets::Ini" => "hospital.sets.ini.",
		"Hospital::Sets::Mtemplate" => "hospital.sets.mtemplate.",
		"Hospital::Diagnose" => "hospital.diagnose."
	}
  def self.table_name_prefix
    'hospital_'
  end

  # 处理验证失败返回的信息  把返回信息进行格式化
  def self.format_errors_message(klass_name,err_message = {})
		ret_message = []
		cur_prefix = ::Hospital::METEDATA[klass_name]
		err_message.each do |key, _messages|
			err_string = I18n.t(cur_prefix+key.to_s) +": " + _messages.flatten.join(" ")+"."
			ret_message << err_string
		end
		return ret_message
  end
end
