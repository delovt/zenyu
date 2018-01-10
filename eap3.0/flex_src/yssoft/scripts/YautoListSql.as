/*
	类名称:		YautoListSql
	类说明: 		列表配置中自动生成查询sql脚本
	创建人:		YJ
	创建时间:	2012-02-07

*/

package yssoft.scripts
{
	import mx.rpc.events.ResultEvent;
	
	import yssoft.tools.AccessUtil;
	
	public class YautoListSql
	{
		protected var _ifuncregedit:int;//功能注册码
		
		public function YautoListSql(){}
		
		//ifuncregedit属性定义
		public function set ifuncregedit(value:int):void{
			this._ifuncregedit = value;
		}
		public function get ifuncregeidt():int{
			return this._ifuncregedit;
		}
		
		public function onCreateListSql():void{
			
			if(this._ifuncregedit == 0) return;
			
//			var param:Object = {};
//			param.ifuncregedit = this._ifuncregedit;
			AccessUtil.remoteCallJava("AcDatadictionaryDest","createListSql",createListSqlBack,this._ifuncregedit);
			
		}
		
		private function createListSqlBack(evt:ResultEvent):void{
			
		}
	}
}