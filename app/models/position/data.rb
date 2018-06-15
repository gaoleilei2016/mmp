#encoding: utf-8

class Position::Data < ApplicationRecord
  self.table_name = 'position_datas'

  # lat: 纬度 lng:经度

  class << self
    include Math

    # def 
    def lat_and_lng(args)
      "SELECT name,title,lng,lat, ROUND(6378.138*2*ASIN(SQRT(POW(SIN((#{args[:lat]}*PI()/180-lat*PI()/180)/2),2)+COS(#{args[:lat]}*PI()/180)*COS(lat*PI()/180)*POW(SIN((#{args[:lng]}*PI()/180-lng*PI()/180)/2),2)))*1000) AS distance
       FROM position_datas
       HAVING distance < 1000
       ORDER BY distance LIMIT #{args[:num]}" ;
    end

    def longitude(args)
      "SELECT *, ROUND(6378.138*2*ASIN(SQRT(POW(SIN((#{args[:lat]}*PI()/180-lat*PI()/180)/2),2)+COS(#{args[:lat]}*PI()/180)*COS(lat*PI()/180)*POW(SIN((#{args[:lng]}*PI()/180-lng*PI()/180)/2),2)))*1000) AS distance FROM position_datas ORDER BY distance LIMIT #{args[:num]}"
    end

    def latutile(args)
      "select name,title,lng,lat, acos(cos(#{args[:lat]}*pi()/180 )*cos(lat*pi()/180)*cos(#{args[:lng]}*pi()/180 -lng*pi()/180)+sin(#{args[:lat]}*pi()/180 )*sin(lat*pi()/180))*6370996.81 as distance
    from position_datas order by distance asc limit #{args[:num]}"
    end

    def find_name_by_latlng(args)
      find_by_sql(longitude(args))
    end

    def distance_by_metre(point, target_lat, target_lng)
      lat_diff = (point[:lat] - target_lat)*PI/180.0
      lng_diff = (point[:lng] - target_lng)*PI/180.0

      lat_sin = Math.sin(lat_diff/2.0) ** 2  
      lng_sin = Math.sin(lng_diff/2.0) ** 2  
      first = Math.sqrt(lat_sin + Math.cos(point[:lat]*PI/180.0) * Math.cos(target_lat*PI/180.0) * lng_sin)  
      result = Math.asin(first) * 2 * 6378137.0  
      p result
    end

    def getAround(lat, lon, raidus)
      latitude = lat
      longitude = lon

      #The circumference of the earth is 24,901 miles
      degree = (24901 * 1609) / 360.0
      raidusMile = raidus

      dpmLat = 1 / degree
      radiusLat = dpmLat * raidusMile
      minLat = latitude - radiusLat
      maxLat = latitude + radiusLat

      mpdLng = degree * Math.cos(latitude * (Math::PI/180))
      dpmLng = 1 / mpdLng
      radiusLng = dpmLng * raidusMile
      minLng = longitude - radiusLng
      maxLng = longitude + radiusLng

      hash = Hash.new
      hash['minLat'] = minLat
      hash['minLng'] = minLng
      hash['maxlat'] = maxLat
      hash['maxLng'] = maxLng
      hash
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
      s = (s * 10000).round / 10000
      s
    end

    # len = getAround(lat1, lng1, 100)
    # p len['minLng']
    # p len['minLat']
    # p len['maxLng']
    # p len['maxlat']
    # p getDistance(len['minLng'], len['minLat'], len['maxLng'], len['maxlat'])
  end
  # {lat: , lng: , name: '', title: ''}
end