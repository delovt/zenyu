package yssoft.comps
{
	import flash.display.DisplayObject;
	
	import mx.containers.TitleWindow;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import yssoft.tools.CRMtool;

	/**
	 *
	 * 类名：ConsultList
	 * 作者：刘磊
	 * 日期：2011-08-29
	 * 功能：树表参照
	 * 参数：@requestback:回调函数，iid:参照主键，allowmulti:允许多选，childsql:子sql, condition:数据字典中条件sql, search:模糊查询值, winwidth：窗体宽，winheight：窗体高
	 * 返回值：void
	 * 修改记录：无
	 * 
	 * 		protected function button1_clickHandler(event:MouseEvent):void
			{
			        //弹出参照窗体
				    new ConsultShow(getSelectListRows,4,true);
			}
			
			public function getSelectListRows(list:ArrayCollection):void{
			        //获得参照选中数据集
				    this.dgrd_test.dataProvider=list;
			}
	 */
	public class ConsultTreeList extends ConsultTreeListUI
	{
		public function ConsultTreeList(requestback:Function,iid:int,allowmulti:Boolean,childsql:String="",condition:String="",search:String="",cconsultedit="",winwidth:int=650,winheight:int=500):void
		{
			super();
			this.getSelectListRows=requestback;
			this.iid=iid;
			this.allowmulti=allowmulti;
			this.winwidth=winwidth;
			this.winheight=winheight;
			this.childsql=childsql==null?"":childsql;
			this.condition=condition==null?"":condition;
            this.cconsultedit=cconsultedit==null?"":cconsultedit;
			this.search=search;
			CRMtool.openView(this);
		}
	}
}