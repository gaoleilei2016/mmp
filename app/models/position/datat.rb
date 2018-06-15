#encoding: utf-8

class Position::Data < ApplicationRecord
  self.table_name = 'position_datas'
  # lat: 纬度 lng:经度
  # SELECT shop_id,shop_name,lng,lat, ROUND(6378.138*2*ASIN(SQRT(POW(SIN((40.05748*PI()/180-lat*PI()/180)/2),2)+COS(40.05748*PI()/180)*COS(lat*PI()/180)*POW(SIN((116.30759*PI()/180-lng*PI()/180)/2),2)))*1000) AS distance
  # FROM shop_list
  # HAVING distance < 1000
  # ORDER BY distance LIMIT 100;

  # SELECT
  #   shop_id ,
  #   shop_name ,
  #   lng ,
  #   lat ,
  #   POWER(lat - 40.05748 , 2) + POWER(lng - 116.30759 , 2) * POWER(COS((lat + 40.05748) / 2) , 2) AS distance
  # FROM
  #     shop_list
  # HAVING
  #     distance < 1000
  # ORDER BY
  #     distance
  # LIMIT 100;
  class << self
    def lat_and_lng(args)
      "SELECT * POWER(lat - #{args[:lat]}, 2) + POWER(lng - #{args[:lng]}, 2) * POWER(COS((lat + #{args[:lat]}) / 2) , 2) AS distance FROM position_datas HAVING distance < 1000 ORDER BY distance LIMIT 1"
    end

    def find_name_by_latlng(args)
      find_by_sql(lat_and_lng(args))
    end
  end
end