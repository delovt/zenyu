package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.CsCustpersonVo")]
	public class CsCustpersonVo
	{
		public function CsCustpersonVo()
		{
		}
		
		//内码
		public var iid:int;
		//编码
		public var  ccode:String;
		//姓名
		public var cname:String;
		//称谓
		public var ctitle:String;
		//所属分类
		public var icustpnclass:int;
		//所属客商
		public var icustomer:int;
		//是否单位负责人
		public var bcharge:Boolean;
		//是否主联系人
		public var bkeycontect:Boolean;
		//部门
		public var cdepartment:String;
		//职务
		public var cpost:String;
		//上级领导
		public var isuperiors:int;
		//助理秘书
		public var iassistant:int;
		//性别
		public var isex:int;
		//生日
		public var dbirthday:Date;
		//民族
		public var cnation:String;
		//学历
		public var ceducation:String;
		//专业
		public var cprofessional:String;
		//身份证号
		public var cidnumber:String;
		//联系电话
		public var ctel:String;
		//手机1
		public var cmobile1:String;
		//手机2
		public var cmobile2:String;
		//电子邮件
		public var cemail:String;
		//QQ/MSN
		public var cqqmsn:String;
		//传真
		public var cfax:String;
		//通讯地址
		public var caddress:String;
		//邮编
		public var czipcode:String;
		//车辆车牌
		public var ccarnumber:String;
		//婚姻状况
		public var cmarital:String;
		//配偶姓名
		public var cspouse:String;
		//配偶工作单位
		public var cspouseworkunit:String;
		//配偶部门职务
		public var cspousepost:String;
		//配偶联系电话
		public var cspousetel:String;
		//其他家庭成员概述
		public var cfamilymembers:String;
		//籍贯
		public var cbirthplace:String;
		//毕业院校
		public var cgraduated:String;
		//性格
		public var ccharacter:String;
		//爱好
		public var chobby:String;
		//生活习惯
		public var chabit:String;
		//客户关系
		public var crelationship:String;
		//朋友关系
		public var cfriendships:String;
	}
}