package yssoft.comps
{
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import yssoft.tools.CRMtool;

	public class CRMListMsg extends CRMListMsgUI
	{
		public function CRMListMsg(inarr:ArrayCollection,inaddcolumns:Array,inwarning:String):void
		{
			super();
			//var mainApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
		    this.arr=inarr;
			this.addcolumns=inaddcolumns;
			this.warning=inwarning;
			/*PopUpManager.addPopUp(this, mainApp);
			PopUpManager.centerPopUp(this);*/
			CRMtool.openView(this);
		}
	}
}