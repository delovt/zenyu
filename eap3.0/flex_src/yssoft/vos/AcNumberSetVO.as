/**
 * 模块名称：AsDataClassVO
 * 模块说明：Flex中对应的档案分类实体类
 * 创建人：	YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AcNumberSetVO")]//对应的java类，不需要数据转换了
	
	public class AcNumberSetVO
	{
		
		public function AcNumberSetVO(){}
		
		public var iid:int;				//内码
		
		public var ifuncregedit:int;		//注册功能单据内码
		
		public var itype:int;				//编码类型
			
		public var bedit:int;				//自动编码是否允许修改
		
		public var cprefix1:String;		//前缀1
		
		public var cprefix1value:String;	//前缀1值
		
		public var bprefix1rule:int;		//前缀1是否流水依据	
		
		public var cprefix2:String;		//前缀2
		
		public var cprefix2value:String;	//前缀2值	
		
		public var bprefix2rule:int;		//前缀2是否流水依据
		
		public var cprefix3:String;		//前缀3
		
		public var cprefix3value:String;	//前缀3值
		
		public var bprefix3rule:int;		//前缀3是否流水依据	
		
		public var ilength:int;			//流水号长度
		
		public var istep:int;				//流水号步长

		public var ibegin:int;				//流水号起始值
	}
}