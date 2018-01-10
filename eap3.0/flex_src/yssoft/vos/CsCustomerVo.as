package yssoft.vos
{
	import flashx.textLayout.formats.Float;

	[Bindable]
	[RemoteClass(alias="yssoft.vos.CsCustomerVo")]//对应的java类，不需要数据转换了
	public class CsCustomerVo
	{
		public function CsCustomerVo()
		{
		}
		
		//内码
		public var iid:int;
		
		//客商编码
		public var ccode:String;
		
		//客商名称
		public var cname:String;
		
		//助记码
		public var cmnemonic:String;
		
		//状态
		public var istatus:int;
		
		//客商属性
		public var iproperty:int;
		
		//客商分类
		public var icustclass:int;
		
		//客商分组
		public var icustgroup:int;
		
		//商务关系
		public var ipartnership:int;
		
		//客商性质
		public var iownership:int;
		
		//客商行业
		public var iindustry:int;
		
		//主营业务
		public var ibusiness:int;
		
		//客商来源
		public var isource:int;
		
		//客商来源
		public var cwebsite:String;
		
		//股票代码
		public var cstockcode:String;
		
		//组织形式
		public var iorganization:int;
		
		//上级单位
		public var iheadcust:int;
		
		//下级单位数
		public var  isubsidiary:int;
		
		//单位规模
		public var ifirmsize:int;
		
		//人员规模
		public var istaffsize:int;
		
		//注册资金
		public var cregistcapital:String;
		
		//年营业额
		public var cannualturnover:String;
		
		//客户关系
		public var irelationship:int;
		
		//价值级别
		public var ivaluelevel:int;
		
		//销售状态
		public var isalesstatus:int;
		
		//商机进程
		public var isalesprocess:int;
		
		//客户热度
		public var ifiery:int;
		
		//国家
		public var icountry:int;
		
		//省份
		public var iprovince:int;
		
		//城市
		public var icity:int;
		
		//县区
		public var icounty:int;
		
		//乡镇/街道
		public var itown:int;
		
		//办公地址
		public var cofficeaddress:String;
		
		//办公邮编
		public var cofficezipcode:String;
		
		//发货地址
		public var cshipaddress:String;
		
		//发货邮编
		public var cshipzipcode:String;
		
		//交通路线
		public var croute:String;
		
		//单位电话
		public var ctel:String;
		
		//单位传真
		public var cfax:String;
		
		//单位邮箱
		public var cemail:String;
		
		//主联系人
		public var ikeycontacts:int;
		
		//业务结构
		public var ibusnstructure:int;
		
		//销售区域
		public var isalesarea:int;
		
		//销售部门
		public var isalesdepart:int;
		
		//销售人员
		public var isalesperson:int;
		
		//信用级别
		public var icreditrating:int;
		
		//信用额
		public  var fcredit:Float;
		
		//销售折扣
		public var fdiscount:Float;
		
		//销售厂商
		public var csalescompanies:String;
		
		//已购产品概要
		public var cpurchased:String;
		
		//已购产品序列号
		public var cpurchasedserial:String;
		
		//产品使用效果
		public var cproducteffect:String;
		
		//购买意向
		public var cpurchaseintention:String;
		
		//服务部门
		public var iservicesdepart:int;
		
		//服务人员
		public var iservicesperson:int;
		
		//服务级别
		public var iservicelevel:int;
		
		//服务收费难易
		public var ceaseofcharges:String;
		
		//是否服务回访
		public var  bsvmonitor:Boolean;
		
		//开票单位名称
		public var ctaxname:String;
		
		//纳税人识别号
		public var ctaxno:String;
		
		//开票地址
		public var ctaxaddress:String;
		
		//开票电话
		public var  ctaxtel:String;
		
		//开票银行
		public var ctaxbank:String;
		
		//开票银行账号
		public var ctaxbankcode:String;
		
		//开户银行
		public var cbank:String;
		
		//银行账号
		public var cbankcode:String;
		
		//客户开发时间
		public  var ddevelopment:Date;
		
		//客户开发人员
		public var  idevelopperson:int;
		
		//备注
		public var cmemo:String;
	}
}