/**
 * 单据操作，自定义执行命令
 * 方法定义规则：public function onExcute_IFun功能内码(cmdparam:CommandParam):void
 * cmdparam参数属性：
 *  param:*;						  //传递的参数
	nextCommand:ICommand;			  //要执行的下一个命令
	excuteNextCommand:Boolean=false;  //是否立即执行下一条命令
	context:Container=null;           //环境容器变量
	optType:String="";                //操作类型
	cmdselfName:String="";            //自定义命令名称
 */
package yssoft.scripts.selfoptimp
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.ConsultList;
	import yssoft.comps.ConsultTreeList;
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.comps.product_controls.BomsWindow;
	import yssoft.frameui.FrameCore;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;

	public class AddDataGridRowBeforeCommandSelfImp
	{
		public function AddDataGridRowBeforeCommandSelfImp()
		{
		}
		/**
		 * 方法功能：
		 * 编写作者：
		 * 创建日期：
		 * 更新日期：
		 */
		/*public function onExcute_IFun162(cmdparam:CommandParam):void
		{
		}*/

		//新购
		public function onExcute_IFun162(cmdparam:CommandParam):void
		{
			bomsFunction(cmdparam);
		}


		//升级
		public function onExcute_IFun161(cmdparam:CommandParam):void
		{
			bomsFunction(cmdparam);
		}

        //资产
        public function onExcute_IFun216(cmdparam:CommandParam):void
        {
            var dg:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
            if (dg.ctableName == "cs_custproducts")
            {
                cmdparam.excuteNextCommand=false;

                var crmeap:CrmEapRadianVbox = (cmdparam.context as FrameCore).crmeap;
                var iproduct:int = crmeap.getValue().iproduct;
                var cs_custproducts:ArrayCollection = crmeap.getValue().cs_custproducts;

               /* if(crmeap.getValue().ifuncregedit == 228){
                    CRMtool.showAlert("该资产由出库生成，不允许手动新增模块。");
                    return;
                }*/

                if(iproduct>0){
                    onOpenProductWindow(iproduct,cs_custproducts,dg,"order");
                }else{
                    CRMtool.showAlert("产品未填写，或不存在，请确认。");
                }
            }
        }

        //产品配置213
        public function onExcute_IFun213(cmdparam:CommandParam):void
        {
            var dg:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
            if (dg.ctableName == "sc_boms")
            {
                cmdparam.excuteNextCommand=false;

                var crmeap:CrmEapRadianVbox = (cmdparam.context as FrameCore).crmeap;
                var iproduct:int = crmeap.getValue().iproduct;
                var sc_boms:ArrayCollection = crmeap.getValue().sc_boms;

                onOpenBomWindow(iproduct,sc_boms,dg,"order");
            }
        }


		public function bomsFunction(cmdparam:CommandParam,type:String="order"):void{
			var ordersbomDG:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			if (ordersbomDG.ctableName == "sc_ordersbom")
			{
				cmdparam.excuteNextCommand=false;

				var crmeap:CrmEapRadianVbox = (cmdparam.context as FrameCore).crmeap;
				var sc_orders:ArrayCollection = crmeap.getValue().sc_orders;
				var sc_productBom:ArrayCollection = crmeap.getValue().sc_ordersbom;
				var ordersDG:CrmEapDataGrid = null;
				for each(var dg:CrmEapDataGrid in crmeap.gridList){
					if(dg.ctableName=="sc_orders")
						ordersDG = dg;
				}

				if(sc_orders&&sc_productBom){
					var removeList:ArrayCollection = new ArrayCollection();
					for each(var bom:Object in sc_productBom){
						var flag:Boolean = true;
						for each(var prodouct:Object in sc_orders){
							if(bom.iproductp==prodouct.iproduct)
								flag = false;
						}
						if(flag)
							removeList.addItem(bom);
					}
					for each(var ritem:Object in removeList){
						sc_productBom.removeItemAt(sc_productBom.getItemIndex(ritem));
					}
				}

				if(sc_orders&&sc_orders.length>0){
					if(ordersDG&&ordersDG.selectedItem){
						var iproduct:int = ordersDG.selectedItem.iproduct;
						//XZQWJ 2013-01-15增加：子表关联
						var str:String="";
						if(ordersDG.selectedItem.hasOwnProperty("iid")){
							var iid:int=ordersDG.selectedItem.iid;
							str="iorders="+iid.toString();
						}
						if(iproduct>0){
							onOpenProductWindow(iproduct,sc_productBom,ordersbomDG,"order",str);
						}else{
							CRMtool.showAlert("产品未填写，或不存在，请确认。");
						}
					}else{
						CRMtool.showAlert("未在产品表中发现焦点行，请确认。\n     （被黄色标注的即为焦点行）");
					}
				}else{
					CRMtool.showAlert("请先增加产品，再增加模块。");
				}

			}
		}

		//其他入库
		public function onExcute_IFun174(cmdparam:CommandParam):void
		{
			bomsRdrecordsFunction174(cmdparam);
		}
		
		//产品购入
		public function onExcute_IFun231(cmdparam:CommandParam):void
		{
			bomsRdrecordsFunction(cmdparam);
		}
		
		//调拨单
		public function onExcute_IFun477(cmdparam:CommandParam):void
		{
			bomsTransferFunction(cmdparam);
		}
		public function bomsTransferFunction(cmdparam:CommandParam):void{
			var ordersbomDG:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			if (ordersbomDG.ctableName == "sc_transfersbom")
			{
				cmdparam.excuteNextCommand=false;
				
				var crmeap:CrmEapRadianVbox = (cmdparam.context as FrameCore).crmeap;
				var sc_transfers:ArrayCollection = crmeap.getValue().sc_transfers;
				var sc_transfersbom:ArrayCollection = crmeap.getValue().sc_transfersbom;
				var tableList:ArrayCollection = ordersbomDG.tableList;
				var ordersDG:CrmEapDataGrid = null;
				for each(var dg:CrmEapDataGrid in crmeap.gridList){
					if(dg.ctableName=="sc_transfers")
						ordersDG = dg;
				}
				
				if(sc_transfers&&sc_transfersbom){
					var removeList:ArrayCollection = new ArrayCollection();
					for each(var bom:Object in sc_transfersbom){
						var flag:Boolean = true;
						for each(var prodouct:Object in sc_transfers){
							if(bom.iproductp==prodouct.iproduct)
								flag = false;
						}
						if(flag)
							removeList.addItem(bom);
					}
					for each(var ritem:Object in removeList){
						sc_transfersbom.removeItemAt(sc_transfersbom.getItemIndex(ritem));
					}
				}
				
				if(sc_transfers&&sc_transfers.length>0){
					if(ordersDG&&ordersDG.selectedItem){
						var iproduct:int = ordersDG.selectedItem.iproduct;
						var child_iid:int = ordersDG.selectedItem.iid;
						if(iproduct>0){
							onOpenProductWindow_477(iproduct,sc_transfersbom,ordersbomDG,"sc_rdrecordsbom",child_iid);
						}else{
							CRMtool.showAlert("产品未填写，或不存在，请确认。");
						}
					}else{
						CRMtool.showAlert("未在产品表中发现焦点行，请确认。\n     （被黄色标注的即为焦点行）");
					}
				}else{
					CRMtool.showAlert("请先增加产品，再增加模块。");
				}
				
			}
		}
       
		public function bomsRdrecordsFunction174(cmdparam:CommandParam):void{
			var ordersbomDG:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			if (ordersbomDG.ctableName == "sc_rdrecordsbom")
			{
				cmdparam.excuteNextCommand=false;
				
				var crmeap:CrmEapRadianVbox = (cmdparam.context as FrameCore).crmeap;
				var sc_rdrecords:ArrayCollection = crmeap.getValue().sc_rdrecords;
				var sc_rdrecordsbom:ArrayCollection = crmeap.getValue().sc_rdrecordsbom;
				var tableList:ArrayCollection = ordersbomDG.tableList;
				var ordersDG:CrmEapDataGrid = null;
				for each(var dg:CrmEapDataGrid in crmeap.gridList){
					if(dg.ctableName=="sc_rdrecords")
						ordersDG = dg;
				}
				
				if(sc_rdrecords&&sc_rdrecordsbom){
					var removeList:ArrayCollection = new ArrayCollection();
					for each(var bom:Object in sc_rdrecordsbom){
						var flag:Boolean = true;
						for each(var prodouct:Object in sc_rdrecords){
							if(bom.iproductp==prodouct.iproduct)
								flag = false;
						}
						if(flag)
							removeList.addItem(bom);
					}
					for each(var ritem:Object in removeList){
						sc_rdrecordsbom.removeItemAt(sc_rdrecordsbom.getItemIndex(ritem));
					}
				}
				
				if(sc_rdrecords&&sc_rdrecords.length>0){
					if(ordersDG&&ordersDG.selectedItem){
						var iproduct:int = ordersDG.selectedItem.iproduct;
						var child_iid:int = ordersDG.selectedItem.iid;
						if(iproduct>0){
							onOpenProductWindow_174(iproduct,sc_rdrecordsbom,ordersbomDG,"sc_rdrecordsbom",child_iid);
							//onOpenProductWindow(iproduct,sc_rdrecordsbom,ordersbomDG,"sc_rdrecordsbom");
						}else{
							CRMtool.showAlert("产品未填写，或不存在，请确认。");
						}
					}else{
						CRMtool.showAlert("未在产品表中发现焦点行，请确认。\n     （被黄色标注的即为焦点行）");
					}
				}else{
					CRMtool.showAlert("请先增加产品，再增加模块。");
				}
				
			}
		}

		public function bomsRdrecordsFunction(cmdparam:CommandParam):void{
			var ordersbomDG:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			if (ordersbomDG.ctableName == "sc_rdrecordsbom")
			{
				cmdparam.excuteNextCommand=false;

				var crmeap:CrmEapRadianVbox = (cmdparam.context as FrameCore).crmeap;
				var sc_rdrecords:ArrayCollection = crmeap.getValue().sc_rdrecords;
				var sc_rdrecordsbom:ArrayCollection = crmeap.getValue().sc_rdrecordsbom;
				var tableList:ArrayCollection = ordersbomDG.tableList;
				var ordersDG:CrmEapDataGrid = null;
				for each(var dg:CrmEapDataGrid in crmeap.gridList){
					if(dg.ctableName=="sc_rdrecords")
						ordersDG = dg;
				}

				if(sc_rdrecords&&sc_rdrecordsbom){
					var removeList:ArrayCollection = new ArrayCollection();
					for each(var bom:Object in sc_rdrecordsbom){
						var flag:Boolean = true;
						for each(var prodouct:Object in sc_rdrecords){
							if(bom.iproductp==prodouct.iproduct)
								flag = false;
						}
						if(flag)
							removeList.addItem(bom);
					}
					for each(var ritem:Object in removeList){
						sc_rdrecordsbom.removeItemAt(sc_rdrecordsbom.getItemIndex(ritem));
					}
				}

				if(sc_rdrecords&&sc_rdrecords.length>0){
					if(ordersDG&&ordersDG.selectedItem){
						var iproduct:int = ordersDG.selectedItem.iproduct;

						if(iproduct>0){
							onOpenProductWindow(iproduct,sc_rdrecordsbom,ordersbomDG,"sc_rdrecordsbom");
						}else{
							CRMtool.showAlert("产品未填写，或不存在，请确认。");
						}
					}else{
						CRMtool.showAlert("未在产品表中发现焦点行，请确认。\n     （被黄色标注的即为焦点行）");
					}
				}else{
					CRMtool.showAlert("请先增加产品，再增加模块。");
				}

			}
		}
		
		private function onOpenProductWindow_174(iproduct:int,productbomarr:ArrayCollection,curDataGrid:CrmEapDataGrid,type:String="order",child_iid:int=0,o_filed:String=""):void{
			
			if(iproduct==0)
				return;
			
			new ConsultList(function (list:ArrayCollection):void {
				var dataporArr:ArrayCollection = curDataGrid.dataProvider as ArrayCollection;
				for each(var item:Object in list) {
					var obj:Object = new Object();
					
					if(o_filed!=""){
						var strArr:Array=o_filed.split("=");
						obj[strArr[0].toString()]=strArr[1].toString();
					}
					
					obj.fsum = '';
					obj.fprice = '';
					//obj.futprice = 0;
					//obj.fnetprice = 0;
					obj.iproductp = iproduct;
					obj.iproduct = item.iid;
					obj.iproduct_Name = item.linkpname;
					obj.fquantity = 1;
					obj.irdrecords = child_iid;
					dataporArr.addItem(obj);
					//objArr.addItem(obj);
				}
				curDataGrid.tableList = curDataGrid.dataProvider as ArrayCollection;
			}, 142, true, " and iproduct =" + iproduct);
			
		}

        private function onOpenProductWindow_477(iproduct:int,productbomarr:ArrayCollection,curDataGrid:CrmEapDataGrid,type:String="order",child_iid:int=0,o_filed:String=""):void{

            if(iproduct==0)
                return;

            new ConsultList(function (list:ArrayCollection):void {
                var dataporArr:ArrayCollection = curDataGrid.dataProvider as ArrayCollection;
                for each(var item:Object in list) {
                    var obj:Object = new Object();

                    if(o_filed!=""){
                        var strArr:Array=o_filed.split("=");
                        obj[strArr[0].toString()]=strArr[1].toString();
                    }

                    obj.fsum = '';
                    obj.fprice = '';
                    obj.futprice = 0;
                    obj.fnetprice = 0;
                    obj.iproductp = iproduct;
                    obj.iproduct = item.iid;
                    obj.iproduct_Name = item.linkpname;
                    obj.fquantity = 1;
                    obj.itransfers = child_iid;
                    dataporArr.addItem(obj);
                    //objArr.addItem(obj);
                }
                curDataGrid.tableList = curDataGrid.dataProvider as ArrayCollection;
            }, 142, true, " and iproduct =" + iproduct);

        }

		private function onOpenProductWindow(iproduct:int,productbomarr:ArrayCollection,curDataGrid:CrmEapDataGrid,type:String="order",o_filed:String=""):void{

			if(iproduct==0)
				return;

            new ConsultList(function (list:ArrayCollection):void {
                var dataporArr:ArrayCollection = curDataGrid.dataProvider as ArrayCollection;
                for each(var item:Object in list) {
                    var obj:Object = new Object();

                    if(o_filed!=""){
                        var strArr:Array=o_filed.split("=");
                        obj[strArr[0].toString()]=strArr[1].toString();
                    }

                    obj.fsum = '';
                    obj.fprice = '';
                    obj.iproductp = iproduct;
                    obj.iproduct = item.iid;
                    obj.iproduct_Name = item.linkpname;
                    obj.fquantity = 1;
                    obj.itransfers = 0;
                    dataporArr.addItem(obj);
                    //objArr.addItem(obj);
                }
                curDataGrid.tableList = curDataGrid.dataProvider as ArrayCollection;
            }, 142, true, " and iproduct =" + iproduct);

			//根据产品档案，查询该档案对应的BOM清单
			/*AccessUtil.remoteCallJava("ProductBomsDest","onGetBomsList",function(event:ResultEvent):void{

				var datasetArr:ArrayCollection = event.result as ArrayCollection;

				var bomswindow:BomsWindow = new BomsWindow();
				var columnsArr:ArrayCollection = new ArrayCollection(
					[{dataField:"iproduct",headerText:"产品档案内码"},
						{dataField:"iid",headerText:"产品BOMS内码"},
						{dataField:"linkpname",headerText:"产品模块名称"}]);
				bomswindow.type = type;
				bomswindow.iproductp = iproduct;
				bomswindow.caption 		= "产品BOM";
				bomswindow.datasetArr 	= datasetArr;
				bomswindow.columnsArr 	= columnsArr;
				bomswindow.odatasetArr 	= productbomarr;
				bomswindow.curDataGrid = curDataGrid;
				bomswindow.flied_value = o_filed;
				CRMtool.openView(bomswindow);

			},iproduct);*/
		}
        
		//新购
		public function onExcute_IFun194(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = (cmdparam.context as FrameCore).crmeap;
			var obj:Object=crmeap.getValue();
			if(obj.icustomer ==null || obj.icustomer ==""){
			    CRMtool.tipAlert("请先选择申请单位！");
				return;
			}
		}
		
        private function onOpenBomWindow(iproduct:int,productbomarr:ArrayCollection,curDataGrid:CrmEapDataGrid,type:String="order",o_filed:String=""):void{

            new ConsultTreeList(function (list:ArrayCollection):void {
                var dataporArr:ArrayCollection = curDataGrid.dataProvider as ArrayCollection;
                for each(var item:Object in list) {
                    var obj:Object = new Object();

                    if(o_filed!=""){
                        var strArr:Array=o_filed.split("=");
                        obj[strArr[0].toString()]=strArr[1].toString();
                    }

                    obj.iproduct = item.iid;
                    obj.iproduct_Name = item.cname;
                    dataporArr.addItem(obj);
                }
                curDataGrid.tableList = curDataGrid.dataProvider as ArrayCollection;
            }, 126, true,null, " and bconsume=1");

        }

	}//
}
