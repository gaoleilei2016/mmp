class Hospital::Sets::CodesController < ApplicationController
  before_action :set_cur_org
	before_action :set_ini, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/sets/codes
	def index
    p "Hospital::Sets::CodesController index"
    code =  {
      routes: [{code: "PO", display: "口服", jianpin: "KF"},{code: "IV.DRIP", display: "静脉滴注", jianpin: "JMDZ"},{code: "SC", display: "皮下注射", jianpin: "PXZS"},{code: "IM", display: "肌肉注射", jianpin: "JRZS"},{code: "IV.SHOVE", display: "静脉推注", jianpin: "JMTZ"},{code: "INH", display: "雾化吸入", jianpin: "WHXR"},{code: "JMBR", display: "静脉泵入", jianpin: "JMBR"},{code: "OP", display: "滴眼", jianpin: "DY"},{code: "NA", display: "滴鼻", jianpin: "DB"},{code: "ST", display: "喷喉", jianpin: "PH"},{code: "CHEW", display: "含化", jianpin: "HH"},{code: "ATW", display: "敷伤口", jianpin: "FSK"},{code: "CTS", display: "擦皮肤", jianpin: "CPF"},{code: "RE", display: "直肠用药", jianpin: "ZCYY"},{code: "SL", display: "舌下用药", jianpin: "SXYY"},{code: "INJP", display: "注射用药", jianpin: "ZSYY"},{code: "ID", display: "皮内注射", jianpin: "PNZS"},{code: "IV", display: "静脉注射", jianpin: "JMZS"},{code: "IN", display: "吸入用药", jianpin: "XRYY"},{code: "LA", display: "局部用药", jianpin: "JBYY"},{code: "SCM", display: "椎管内用药", jianpin: "ZGNYY"},{code: "ACD", display: "关节腔内用药", jianpin: "GJQNYY"},{code: "PCM", display: "胸膜腔用药", jianpin: "XMQYY"},{code: "IP", display: "腹腔用药", jianpin: "FQYY"},{code: "VA", display: "阴道用药", jianpin: "YDYY"},{code: "EM", display: "气管内用药", jianpin: "QGNYY"},{code: "ODW", display: "其他用药途径", jianpin: "QTYYTJ"}],
      rates: [{code: "QD", display: "每日一次", jianpin: "MRYC"}, {code: "BID", display: "每日两次", jianpin: "MRLC"}, {code: "TID", display: "每日三次", jianpin: "MRSC"}, {code: "QID", display: "每日四次", jianpin: "MRSC"}, {code: "QUINGID", display: "每日五次", jianpin: "MRWC"}, {code: "QN", display: "每晚一次", jianpin: "MWYC"}, {code: "Q4H", display: "四小时一次", jianpin: "SXSYC"}, {code: "Q6H", display: "六小时一次", jianpin: "LXSYC"}, {code: "Q8H", display: "八小时一次", jianpin: "BXSYC"}, {code: "Q12H12", display: "小时一次", jianpin: "XSYC"}, {code: "QH", display: "一小时一次", jianpin: "YXSYC"}, {code: "Q2H", display: "二小时一次", jianpin: "EXSYC"}, {code: "Q3H", display: "三小时一次", jianpin: "SXSYC"}, {code: "QOD", display: "隔日一次", jianpin: "GRYC"}, {code: "QW", display: "每周一次", jianpin: "MZYC"}],
      nations: [], # 民族
      marriages: [{code:"10",display:'未婚',jianpin: "WH"},{code:'20',display:'已婚',jianpin: "YH"}], # CodeSystem 2.16.156.1.19449.1.2261.2 婚姻
      occupations: [{code: "01", display: "幼托儿童",jianpin: "YTET"}, {code: "02", display: "散居儿童",jianpin: "SJET"}, {code: "03", display: "学生（大中小学）",jianpin: "XSDZXX"}, {code: "04", display: "教师",jianpin: "JS"}, {code: "05", display: "保育员及保姆",jianpin: "BYYJBM"}, {code: "06", display: "餐饮食品业",jianpin: "CYSPY"}, {code: "07", display: "商业服务",jianpin: "SYFW"}, {code: "08", display: "医务人员",jianpin: "YWRY"}, {code: "09", display: "工人",jianpin: "GR"}, {code: "10", display: "民工",jianpin: "MG"}, {code: "11", display: "农民",jianpin: "NM"}, {code: "12", display: "牧民",jianpin: "MM"}, {code: "13", display: "渔（船）民",jianpin: "YCM"}, {code: "14", display: "干部职员",jianpin: "GBZY"}, {code: "15", display: "离退人员",jianpin: "LTRY"}, {code: "16", display: "家务及待业",jianpin: "JWJDY"}, {code: "17", display: "不详",jianpin: "BX"}, {code: "99", display: "其他",jianpin: "QT"}], # CodeSystem 2.16.156.1.13610.1.364.2.1.202, # 职业
      prescription_types: [{code: "1", display: "普通处方", jianpin: "PTCF"}, {code: "2", display: "急诊处方", jianpin: "JZCF"}, {code: "3", display: "儿科处方", jianpin: "EKCF"}, {code: "4", display: "毒麻药品处方", jianpin: "DMYPCF"}, {code: "5", display: "第一类精神药品处方", jianpin: "DYLJSYPCF"}, {code: "6", display: "第二类精神药品处方", jianpin: "DELJSYPCF"}, {code: "7", display: "抗生素处方", jianpin: "KSSCF"}], # CodeSystem 2.16.156.1.675425699.1.50
      bloods:[{code:"1",display:'A型', jianpin: "AX"},{code:'2',display:'B型', jianpin: "BX"},{code:'3',display:'O型', jianpin: "OX"},{code:'4',display:'AB型', jianpin: "ABX"},{code:'5',display:'不详', jianpin: "BX"}], # CodeSystem 2.16.156.1.13610.1.364.4.50.5
      # routes: ::Hospital::DictCoding.where(org_id: @cur_org.id, system: "routes"),
      # rates: ::Hospital::DictCoding.where(org_id: @cur_org.id, system: "rates")
    }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"success", data: code} }
    end
	end

	private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end
end
