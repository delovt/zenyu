/**    
 *
 * 文件名：LogPerateVo.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-10-15    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos
{
/**    
 *     
 * 项目名称：rkycrm    
 * 类名称：LogPerateVo    
 * 类描述：系统操作日志    
 * 创建人：孙东亚
 * 创建时间：2011-2011-10-15       
 *     
 */
	
	[Bindable]
	[RemoteClass(alias="yssoft.vos.LogPerateVo")]
	public class LogPerateVo {
		
		public function LogPerateVo(){}
		
		/**
		 * 自增值
		 */ 
		public var iid:int;   
		
		/**
		 * Ip地址
		 */ 
		public var cip:String;
		
		/**
		 * 站点机器名
		 */
		public var cworkstation:String;
		
		/**
		 * 用户ID
		 */
		public var iperson:int;
		
		/**
		 * 操作时间
		 */
		public var doperate:String;
		
		/**
		 * 业务单据注册码
		 */
		public var ifuncregedit:String;
		
		/**
		 * 业务节点
		 */
		public var cnode:String;
		
		/**
		 * 操作功能
		 */
		public var cfunction:String;
		
		/**
		 * 操作结果
		 */
		public var cresult:String;
		
		/**
		 * 操作单据ID
		 */ 
		public var iinvoice:int;
		

	}

}