class Admin::Organization < ApplicationRecord
	has_many :users,class_name:"User"
	has_many :pharmacy_link,class_name:"Admin::HospitalPharmacy",foreign_key:"hospital_id"
	has_many :hospital_link,class_name:"Admin::HospitalPharmacy",foreign_key:"pharmacy_id"
	validate do
		errors.add(:type_code,"type_code=>#{type_code}:#{type_code.class} 取值必须在 [ '1','2' ]") unless ['1','2'].index(self.type_code)
	end

  # lat: 纬度 lng:经度
  # 调用方法：class.recent_lists({lat: 0.323232, lng: 0.673267, num: 2}) #num默认是1
  class << self
    include Math

    def recent_lists(args)
      begin
        return "经度和纬度必须有值" unless args[:lat]&&args[:lng]
        lat, lng = args[:lat].to_f, args[:lng].to_f
        num = args[:num].to_i || 1
        res = find_by_sql(sql_syntax({lat: lat, lng: lng, num: num}))
        return {state: :empty, msg: '结果为空', desc: '没有找到最近的结果'} if res.empty?
        get_result(lat, lng, res)
      rescue Exception => e
        {state: :fail, msg: '系统错误', desc: e.message}
      end
    end

    def distance_list(point, target)
      dis = get_distance(point[:lng], point[:lat], target[:lng], target[:lat])
      handle_distance(dis)
    end

    def handle_distance(dis)
      return "约#{(dis/1000.0).round(1)}公里" if (dis >= 1000)
      "约#{dis.round(1)}米"
    end

    def sql_syntax(args)
      "SELECT *, ROUND(6378.138*2*ASIN(SQRT(POW(SIN((#{args[:lat]}*PI()/180-lat*PI()/180)/2),2)+COS(#{args[:lat]}*PI()/180)*COS(lat*PI()/180)*POW(SIN((#{args[:lng]}*PI()/180-lng*PI()/180)/2),2)))*1000) AS distance FROM admin_organizations ORDER BY distance LIMIT #{args[:num]}"
    end

    def get_result(lat, lng, recents)
      res = []
      recents&.each do |rec|
        dis = get_distance(lng, lat, rec.lng, rec.lat)
        dis_desc = handle_distance(dis)
        res << { org: rec, distance: dis_desc }
      end
      {state: :succ, msg: '成功', res: res}
    end

    def get_distance(lng1, lat1, lng2, lat2)
      rad = Math::PI / 180.0
      earth_radius = 6378.137 * 1000 #地球半径
      radLat1 = lat1 * rad
      radLat2 = lat2 * rad
      a = radLat1 - radLat2
      b = (lng1 - lng2) * rad
      s = 2 * Math.asin(Math.sqrt( (Math.sin(a/2)**2) + Math.cos(radLat1) * Math.cos(radLat2)* (Math.sin(b/2)**2) ))
      s = s * earth_radius
      s = (s * 10000).round / 10000.0
      s
    end
  end
end
