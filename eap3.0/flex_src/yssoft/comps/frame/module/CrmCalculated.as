package yssoft.comps.frame.module
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.tools.AccessUtil;

	public class CrmCalculated
	{
		/**
		 * 1、查询参照信息，
		 * 2、表头触发表体参照信息
		 * 3、翻译信息
		 * 4、参照存入字段信息
		 * 5、验证字段信息
		 */ 
		public static function  getCountsetObj(paramMap:Object):void
		{
			AccessUtil.remoteCallJava("CommonalityDest","consultInit",function(evt:ResultEvent):void{
				var resultMap:Object = evt.result;
				
				/**
				 * 表头信息项包括
				 * 1、表头参照详细信息
				 * 2、表头参照验证字段类型
				 * 3、表头存入字段类型
				 * 4、翻译结果
				 * 5、参照根据字段拼装成sql 
				 */ 
				if(resultMap.hasOwnProperty("headConsultObj"))
				{
					
				}
				
				/**
				 * 表体信息包括
				 * 1、表体参照详细信息
				 * 2、表体翻译
				 * 3、表体根据字段拼装sql
				 */ 
				if(resultMap.hasOwnProperty("childConsultObj"))
				{
					
				}
				
				/**
				 * 计算公式包括
				 * 1、计算公式信息
				 * 2、计算公式结果
				 */ 
				if(resultMap.hasOwnProperty("cfunctionObj"))
				{
					
				}
				
				/**
				 * 约束公式包括
				 * 1、约束公式信息
				 * 2、约束公式验证消息
				 */ 
				if(resultMap.hasOwnProperty())
				{
					
				}
			},paramMap,null,false);
		}
	
	}
}