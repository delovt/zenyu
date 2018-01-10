package yssoft.frameui.formopt
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.core.FlexGlobals;
	import mx.utils.ObjectUtil;
	
	import spark.components.ComboBox;
	
	import yssoft.impls.ICommand;
	import yssoft.models.ConstsModel;
	import yssoft.tools.CRMtool;
	
	public class PrintingCommand extends BaseCommand
	{
		private var bbox:ComboBox;
		
		public function PrintingCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
			bbox=this._param.pttemp;
		}
		override public function onExcute():void{
			//Alert.show(""+ObjectUtil.toString(this._param.pttemp),"object提示");
			if(this._param==null || bbox.selectedItem == null){
				bbox.setFocus();
				CRMtool.showAlert("没有对应的打印模板，或打印模板未启用");
				return;			
			}
			var tplname:String=bbox.selectedItem.ctemplate as String;
			if(tplname==null || tplname==""){
				bbox.setFocus();
				CRMtool.showAlert("未找到对应的模板文件");
				return;			
			} 			
			onPrintHandler(tplname);
		}
		private function onPrintHandler(tplname:String):void{
			if(_param.formIfunIid<=0){
				bbox.setFocus();
				CRMtool.showAlert("获取不到单据功能注册码");
				return;
			}
            //lr modify 没有内码 就打印空的信息
			/*if(_param.currid<=0){
             bbox.setFocus();
             CRMtool.showAlert("获取不到单据内容");
             return;
             }*/
			var request:URLRequest;
			request=new URLRequest(ConstsModel.publishUrlRoot+"/printmodel/"+bbox.selectedItem["ctemplate"]);
			_param.printurl=request.url;
			_param.paramvalues=_param.currid;
			_param.reportiid=_param.pttemp.selectedItem.iid;
			CRMtool.openMenuItemFormOther("yssoft.views.printreport.PrintView",_param,bbox.selectedItem["cname"],"打印"+"_"+bbox.selectedItem["cname"]+"_"+bbox.selectedItem["ifuncregedit"]+"_"+bbox.selectedItem["iid"]);
		}
	}
}