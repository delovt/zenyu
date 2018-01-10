/**
 * 作者：刘磊
 *
 * 日期：2011-8-4
 *
 * 功能：bean
 *
 * 修改记录：
 *
 * 修改人：刘磊
 *
 * 修改时间：2011-8-4
 */
package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsMenuVo")]
	public class AsMenuVo
	{
		
		public function AsMenuVo()
		{
		}
		
		public var iid:int;             //自增值
		
		
		public var ipid:int;           //上级菜单内码
		
		
		public var ccode:String;          //菜单编码
		
		public var oldCcode:String;     //老菜单编码
		
		
		public var cname:String;       //菜单名称
		
		
		public var iimage:int;         //菜单图标
		
		
		public var itype:int;          //菜单类型

        public var imenup:int;//菜单方案主表内码
		
		public var cprogram:String;    //外部程序链接地址
		
		
		public var ifuncregedit:String;   //关联注册程序ID
		
		
		public var iopentype:int;      //打开方式
		
		public var bshow:int;          //窗口状态

		public var cparameter:String;  //参数
		
		public var irfuncregedit:String;
		
		public var crname:String;
	}
}
