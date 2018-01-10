/**
 * 作者:zmm
 * 日期：2011-8-20
 * 功能：HrPersonVo
 */
package yssoft.vos
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="yssoft.vos.HrPersonVo")]
	public class HrPersonVo
	{
		
		public var iid:int;
		public var ccode:String;
		public var cname:String;
		public var cnickname:String;
		public var bjobstatus:Boolean;
		public var busestatus:Boolean;
		public var cusecode:String;
		public var cusepassword:String;
		public var idepartment:int;
		public var ipost:int;
		public var ijob1:int;
		public var ijob2:int;
		public var isex:int;
		public var dbirthday:Date;
		public var ieducation:int;
		public var cdiscipline:String;
		public var ctel:String;
		public var cmobile1:String;
		public var cmobile2:String;
		public var cemail:String;
		public var cqq:String;
		
		public var chaddress:String;
		public var chtel:String;
		public var cmemo:String;
		public var csignature:String;
		public var ihistoryoper:String;
		
		public var cip:String;
		public var cworkstation:String;
		public var cquestion:String;
		public var canswer:String;
		public var ihfuncregedit:String;
		public var idscreenlock:int;
		public var iconfirmtype:int;
		public var clast:String;  //最后一次登录地点
		public var dlast:String; //最后一次登录时间

		//密码最后修改时间
		public var dpasswordchange:String;
		//是否允许多点登录
		public var bmorelogin:Boolean;
		
		public var block:Boolean;
		
		//是否清退时例外放行
		public var bnotremove:Boolean;
		
		// 部门名称
		public var departcname:String;
		// ijob1 名称
		public var ijob1cname:String;
		// ijob2 名称
		public var ijob2cname:String;
		// 职务名称
		public var postcname:String;
		// 角色名称
		public var rolecname:String;
		// 角色 iid
		public var roleiid:String;
		// 角色 是否 可用
		public var rolebuse:String;
		//sessionid
		public var sesssionid:String;
		//角色列表
		public var rolelist:ArrayCollection;
		//用户在线时间戳
		public var onlinetimestamp:String;
		//keyid
		public var keyid:String;
		//busbkey
		public var busbkey:Boolean;
		//cusbkey //2013-03-25 XZQWJ 增加;存放加密锁ID
		public var cusbkey:String;
		public var keyRPwd:String;
		public var keyWPwd:String;
		
		public var cnote:String;

        //呼叫中心
        public var icallline:int;
        public var bcallout:Boolean;
        public var bisCloseOut:Boolean;
        public var ilayout:int;
		
	}
}