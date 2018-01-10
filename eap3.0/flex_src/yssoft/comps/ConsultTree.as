package yssoft.comps
{
	import flash.display.DisplayObject;
	
	import mx.containers.TitleWindow;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import yssoft.tools.CRMtool;

	/**
	 *
	 * 类名：ConsultTree
	 * 作者：刘磊
	 * 日期：2011-08-27
	 * 功能：树参照
	 * 参数：@requestback：回调函数，iid：参照主键，onlygetendnode：只允许参照末节点，search:模糊查询值, winwidth：窗体宽，winheight：窗体高
	 * 返回值：void
	 * 修改记录：无
	 * 
	 * 		protected function button1_clickHandler(event:MouseEvent):void
			{
			        //弹出参照窗体
				    new ConsultShow(getSelectTreeRows,4,true);
			}
			
			public function getSelectTreeRows(tree:XML):void{
			        //获得参照选中数据集
    				this.dgrd_test.dataProvider=tree;
			}
	 */
	public class ConsultTree extends ConsultTreeUI
	{
		public function ConsultTree(requestback:Function,iid:int,onlygetendnode:Boolean,search:String="",cconsultedit:String = "",winwidth:int=650,winheight:int=500):void
		{
			super();
			this.getSelectTreeRows=requestback;
			this.iid=iid;
			this.onlyGetEndNode=onlygetendnode;
			this.winwidth=winwidth;
			this.winheight=winheight;
            this.cconsultedit=cconsultedit==null?"":cconsultedit;
			this.search=search;
			CRMtool.openView(this);
		}
	}
}