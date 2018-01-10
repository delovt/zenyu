/**
 * 模块名称：AsSmssetVO
 * 模块说明：
 * 
 * 创建人：lzx
 * 创建日期：2012-10-09
 * 修改人： 
 * 修改日期：
 *	
 */

package yssoft.vos
{

	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsSmssetVO")]//对应的java类，不需要数据转换了
	public class AsSmssetVO
	{
		public function AsSmssetVO(){}
		
		public var iid:int;			//内码
		
		public var ipid:int;       //上级预算内码
				
		public var cname:String;		//模板名称
		
		public var ccode:String;		//模板编码
		
		public var oldCcode:String;     //老菜单编码
		
		public var cport:String;	//端口号
				
		public var cuser:String;			//用户名
		
		public var cpassword:String;		//密码
		
		public var cphoneprefix:String;		//电话前缀
				
		public var cmemo:String;		//备注
		
		public var caddress:String;  //IP地址
		
	}
}