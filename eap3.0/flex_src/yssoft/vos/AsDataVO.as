/**
 * 模块名称：AsDataVO
 * 模块说明：Flex中对应的档案数据实体类
 * 创建人：	YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsDataVO")]
	
	public class AsDataVO
	{
		public function AsDataVO(){}
		
		public var iid:int;			//主键
		
		public var iclass:int;			//所属分类
		
		public var ipid:int;			//上级内码
		
		public var ccode:String;		//编码
		
		public var cname:String;		//名称
		
		public var cmnemonic:String;	//助记码
		
		public var cmemo:String;		//备注
		
		public var cabbreviation:String //单据编码前缀
		
		public var coutkey:String //外部系统内码
		
		public var bbuse:int;			//是否启用
		
		public var oldCcode:String;	//旧编码
	}
}