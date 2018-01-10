/**

	模块名称：InvoicesMoreHandle
	模块功能：业务单据中更多操作的相关处理
	模块简介：在业务单据中有一个功能点：更多操作
	  		 在更多操作中有业务单据对应的特殊操作
			 譬如：审核、弃审、核销等。
			 
	创建者：	  YJ
	创建日期： 2011-10-24
	修改者：
	修改日期：

*/

package yssoft.tools
{
	import yssoft.models.CRMmodel;
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	import mx.controls.Alert;
	import yssoft.tools.AccessUtil;
	
	public class InvoicesMoreHandle
	{
		[Bindable]
		private var _arriid:ArrayCollection = new ArrayCollection();//记录需要操作的内码集合
		
		[Bindable]
		private var _ctable:String = "";//需要操作的表
		
		[Bindable]
		private var _cfield:String = "";//需要操作的字段
			
		public function InvoicesMoreHandle(){}
		
		public function set arriid(value:ArrayCollection):void{
			_arriid = value;
		}
		public function get arriid():ArrayCollection{
			return _arriid;
		}
		
		public function set ctable(value:String):void{
			_ctable = value;
		}
		public function get ctable():String{
			return _ctable;
		}
		
		public function set cfield(value:String):void{
			_cfield = cfield;
		}
		public function get cfield():String{
			return _cfield;
		}
		
		
		//审核操作
		public function onCheckBefore():Boolean{
			if(this._arriid == null) {CRMtool.tipAlert("无数据审核！");return false;}
			//判断当前单据是否已经审核过
			
			
			
			return true;
		}
		
		public function onCheck():void{
			var striid:String = "";
			var obj:Object = {};
			
			if(!onCheckBefore()) return;
			
			for(var i:int=0;i<_arriid.length;i++){
				striid +=_arriid[i]["iid"]+",";
			}
			striid = striid.substr(0,striid.lastIndexOf(','));
			
			obj.tablename = this._ctable;
			obj.condition = striid;
			obj.loginname = CRMmodel.userId;
			
			AccessUtil.remoteCallJava("MoreHandleDest","onCheck",onCheckBack,obj);
			
			onCheckEnd();
		}
		private function onCheckBack(evt:ResultEvent):void{
		
		}
		
		public function onCheckEnd():void{}
		
		
		
		//弃审操作
		public function onUnCheckBefore():void{}
		
		public function onUnCheck():void{}
		
		public function onUnCheckEnd():void{}
		
		
		
		//核销操作
		public function onVerificationBefore():void{}
		
		public function onVerification():void{}
		
		public function onVerificationEnd():void{}
	}
}