/**
 * 单据操作，自定义执行命令
 * 方法定义规则：public function onExcute_IFun功能内码(cmdparam:CommandParam):void
 * cmdparam参数属性：
 *  param:*;                          //传递的参数
 nextCommand:ICommand;              //要执行的下一个命令
 excuteNextCommand:Boolean=false;  //是否立即执行下一条命令
 context:Container=null;           //环境容器变量
 optType:String="";                //操作类型
 cmdselfName:String="";            //自定义命令名称
 */
package yssoft.scripts.selfoptimp {
import flash.utils.ByteArray;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import yssoft.comps.frame.module.CrmEapDataGrid;
import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.frameui.FrameCore;
import yssoft.frameui.formopt.selfopt.SaveCommandSelf;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.CommandParam;

public class SaveBeforeCommandSelfImp {
    //为保存前注入命令   特殊 加入 保存命令引用 以保证保存前牵扯到回调的命令链控制
    //此类中，想要命令继续执行，必须执行 saveCommandSelf.onNext(); 否则命令链会失效 lr add
    public var saveCommandSelf:SaveCommandSelf;


    public function SaveBeforeCommandSelfImp() {
    }

    /**
     * 方法功能：检测是否选中关联，如果选中则不在检测相同产品是否相同
     * 编写作者：XZQWJ
     * 创建日期：2013-01-22
     * 更新日期：
     */
    public function checkIsRealtion(cmdparam:CommandParam):Boolean {

        var isrelation:Boolean = false;
        var ruleArrList:ArrayList = cmdparam.param.ruleObj;
        if (ruleArrList != null && ruleArrList.length > 0) {
            for (var i:int = 0; i < ruleArrList.length; i++) {
                if (!(ruleArrList.getItemAt(i).childMap is ArrayCollection)) {
                    var obj:Object = ruleArrList.getItemAt(i).childMap;
                    if (obj.ctable == "sc_ordersbom" && obj.brelation) {
                        isrelation = true;
                        break;
                    }
                }
            }
        }
        return isrelation;

    }


	//客商资产
	public function onExcute_IFun216(cmdparam:CommandParam):void {
		
		var iid:int = cmdparam.param.value.iid;
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var myValue:Object = crmeap.getValue();
		if (crmeap.curButtonStatus == "onEdit") {
		var sSql:String="select iproduct from CS_custproduct where iid="+myValue.iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		  var ac:ArrayCollection=event.result as ArrayCollection;
			  if(ac.length==0)
				  return;
				  if(ac[0].iproduct!=myValue.iproduct){
						  var sql:String="delete    cs_custproducts where  icustproduct ="+myValue.iid;
						  AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {},sql);
				  }
			},sSql);
		}
		saveCommandSelf.onNext();
	}
	
	
    /**
     * 方法功能：校验收款计划金额必须等于合同成交金额(产品新购)
     * 编写作者：刘磊
     * 创建日期：2012-3-28
     * 更新日期：2012-3-29
     */
    public function onExcute_IFun162(cmdparam:CommandParam):void {
        var sc_orders:ArrayCollection = cmdparam.param.value.sc_orders as ArrayCollection;
        var sc_ordersbom:ArrayCollection = cmdparam.param.value.sc_ordersbom as ArrayCollection;
		var flag:Boolean=modifyCSN(cmdparam);//一个加密狗号对应一个产品   ADD   SZC
				if(flag){
				 return;
				}
        var sql:String = "select sc_bom.iproduct   from sc_bom ";
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var resultArr:ArrayCollection = event.result as ArrayCollection;
                //if (sc_ordersbom.length <= 0) {
                    if (resultArr && resultArr.length > 0) {
                        for each(var item:Object in sc_orders) {
                            var i:int=0;
                            for each(var item2:Object in resultArr) {
                                if (item.iproduct == item2.iproduct) {
                                    for each(var item3:Object in sc_ordersbom) {
                                        if(item.iproduct==item3.iproductp){
                                            i=1;
                                            break;
                                        }
                                    }
                                    if(i==0){
                                        CRMtool.showAlert("产品:" + item.iproduct_Name + "必须选择对应模块！");
                                        cmdparam.excuteNextCommand = false;//报错不执行其后命令
                                        return;
                                    }
                                }
                                if(i>0){
                                    break;
                                }
                            }
                        }
                    }
                //}

                removeBomNotinProduct(cmdparam);
                var isrelation:Boolean = checkIsRealtion(cmdparam);
                if (!isrelation) {
                    checkProductRepeat(cmdparam);
                }
				
				
//*********XZQWJ 2013-01-22修改：***********
//			
//			checkProductRepeat(cmdparam);
//			
//*****************************************************************************			
                checkPlanMomeyIsEqualsOrderMomey(cmdparam);
                //this.checkBomMomeyIsEqualsOrderMomey(cmdparam);
				

                //this.checkIsNoBom(cmdparam);

                if (cmdparam.excuteNextCommand)
                    saveCommandSelf.onNext();
            }, sql);

    }

    /**
     * 方法功能：校验收款计划金额必须等于合同成交金额(产品升级)
     * 编写作者：YJ
     * 创建日期：2012-4-10
     * 更新日期：
     */
    public function onExcute_IFun161(cmdparam:CommandParam):void {
        /**
         * 对应单据： 产品升级
         * 功能：根据orders2表 更新对应客商资产
         * lr add
         **/

        var sc_orders:ArrayCollection = cmdparam.param.value.sc_orders as ArrayCollection;
        var sc_ordersbom:ArrayCollection = cmdparam.param.value.sc_ordersbom as ArrayCollection;
		var flag:Boolean=modifyCSN(cmdparam);//一个加密狗号对应一个产品   ADD   SZC
		if(flag){
			return;
		}
        var sql:String = "select sc_bom.iproduct   from sc_bom ";
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var resultArr:ArrayCollection = event.result as ArrayCollection;
            //if (sc_ordersbom.length <= 0) {
            if (resultArr && resultArr.length > 0) {
                for each(var item:Object in sc_orders) {
                    var i:int=0;
                    for each(var item2:Object in resultArr) {
                        if (item.iproduct == item2.iproduct) {
                            for each(var item3:Object in sc_ordersbom) {
                                if(item.iproduct==item3.iproductp){
                                    i=1;
                                    break;
                                }
                            }
                            if(i==0){
                                CRMtool.showAlert("产品:" + item.iproduct_Name + "必须选择对应模块！");
                                cmdparam.excuteNextCommand = false;//报错不执行其后命令
                                return;
                            }

                        }
                        if(i>0){
                            break;
                        }
                    }
                }

            }
            var sc_orders2:ArrayCollection = cmdparam.param.value.sc_orders2 as ArrayCollection;
            if (!sc_orders2 || (sc_orders2 && sc_orders2.length <= 0)) {
                CRMtool.showAlert("保存失败！原因：没有回收产品。");
                cmdparam.excuteNextCommand = false;//报错不执行其后命令
                return;
            }
            removeBomNotinProduct(cmdparam);
            var isrelation:Boolean = checkIsRealtion(cmdparam);
            if (!isrelation) {
                checkProductRepeat(cmdparam);
            }
            //*********XZQWJ 2013-01-22修改：***********
            //
            //			checkProductRepeat(cmdparam);
            //
            //*****************************************************************************
            checkPlanMomeyIsEqualsOrderMomey(cmdparam);
            //this.checkBomMomeyIsEqualsOrderMomey(cmdparam);

            if (cmdparam.excuteNextCommand)
                saveCommandSelf.onNext();
        },sql);
    }

    private function removeBomNotinProduct(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var sc_orders:ArrayCollection = crmeap.getValue().sc_orders;
        var sc_productBom:ArrayCollection = crmeap.getValue().sc_ordersbom;

        if (sc_orders && sc_productBom) {
            var removeList:ArrayCollection = new ArrayCollection();
            for each(var bom:Object in sc_productBom) {
                var flag:Boolean = true;
                for each(var prodouct:Object in sc_orders) {
                    if (bom.iproductp == prodouct.iproduct)
                        flag = false;
                }
                if (flag)
                    removeList.addItem(bom);
            }
            for each(var ritem:Object in removeList) {
                sc_productBom.removeItemAt(sc_productBom.getItemIndex(ritem));
            }
        }
    }

    private function checkProductRepeat(cmdparam:CommandParam):void {
        var sc_orders:ArrayCollection = cmdparam.param.value.sc_orders as ArrayCollection;
        var flag:Boolean = false;
        for each(var item:Object in sc_orders) {
            for each(var item2:Object in sc_orders) {
                if (item != item2 && item.iproduct == item2.iproduct)
                    flag = true
            }
        }
        if (flag) {
            CRMtool.showAlert("保存失败！原因：合同中不允许存在相同产品，请尝试拆分合同解决。");
            cmdparam.excuteNextCommand = false;//报错不执行其后命令
        }
    }

    /**
     * 方法功能：校验收款计划金额必须等于合同成交金额(配套耗材)
     * 编写作者：YJ
     * 创建日期：2012-4-10
     * 更新日期：
     */
    public function onExcute_IFun157(cmdparam:CommandParam):void {
        this.checkPlanMomeyIsEqualsOrderMomey(cmdparam);
        if (cmdparam.excuteNextCommand)
            saveCommandSelf.onNext();
    }

    /**
     * 方法功能：校验收款计划金额必须等于合同成交金额(服务收费)
     * 编写作者：YJ
     * 创建日期：2012-4-10
     * 更新日期：
     */
    public function onExcute_IFun159(cmdparam:CommandParam):void {
        this.checkPlanMomeyIsEqualsOrderMomey(cmdparam);

        var sc_orders2:ArrayCollection = cmdparam.param.value.sc_orders2 as ArrayCollection;
        var ffee:Number = 0;//计划金额合计
        var fsum:Number = 0;//成交金额
        fsum = Number(cmdparam.param.value.fsum);
		cmdparam.excuteNextCommand=true;
        for each (var item:Object in sc_orders2) {
            ffee = ffee + Number(item.ffee);
        }
        if (ffee != fsum) {
            CRMtool.showAlert("保存失败！原因：服务资产分摊费用合计必须等于合同成交金额。");
            cmdparam.excuteNextCommand = false;//报错不执行其后命令
        }

        if (cmdparam.excuteNextCommand){
            saveCommandSelf.onNext();
		}
    }
	//租赁
	public function onExcute_IFun462(cmdparam:CommandParam):void {
		this.checkPlanMomeyIsEqualsOrderMomey(cmdparam);
		if(cmdparam.excuteNextCommand ==false){
		 return;
		}
		var sc_orders2:ArrayCollection = cmdparam.param.value.sc_orders2 as ArrayCollection;
		var ffee:Number = 0;//计划金额合计
		var fsum:Number = 0;//成交金额
		fsum = Number(cmdparam.param.value.fsum);
		cmdparam.excuteNextCommand=true;
		for each (var item:Object in sc_orders2) {
			ffee = ffee + Number(item.ffee);
		}
		if (ffee != fsum) {
			CRMtool.showAlert("保存失败！原因：租赁资产分摊费用合计必须等于合同成交金额。");
			cmdparam.excuteNextCommand = false;//报错不执行其后命令
		}
		
		if (cmdparam.excuteNextCommand){
			saveCommandSelf.onNext();
		}
	}
    //培训
    public function onExcute_IFun160(cmdparam:CommandParam):void {
        this.checkPlanMomeyIsEqualsOrderMomey(cmdparam);

        if (cmdparam.excuteNextCommand)
            saveCommandSelf.onNext();
    }

    //开发
    public function onExcute_IFun210(cmdparam:CommandParam):void {
        this.checkPlanMomeyIsEqualsOrderMomey(cmdparam);

        if (cmdparam.excuteNextCommand)
            saveCommandSelf.onNext();
    }
   
	//实施合同
	public function onExcute_IFun459(cmdparam:CommandParam):void {
		this.checkPlanMomeyIsEqualsOrderMomey(cmdparam);
		
		if (cmdparam.excuteNextCommand)
			saveCommandSelf.onNext();
	}
    private function checkPlanMomeyIsEqualsOrderMomey(cmdparam:CommandParam):void {
        var sc_orderrpplan:ArrayCollection = cmdparam.param.value.sc_orderrpplan as ArrayCollection;
        var fsummoney:Number = 0;//计划金额合计
        var fsum:Number = 0;//成交金额
        fsum = Number(cmdparam.param.value.fsum);
        for each (var item:Object in sc_orderrpplan) {
            fsummoney = fsummoney + Number(item.fmoney);
        }
        if (fsummoney != fsum) {
            CRMtool.showAlert("保存失败！原因：收款计划金额合计必须等于合同成交金额。");
            cmdparam.excuteNextCommand = false;//报错不执行其后命令
        }

        //else cmdparam.excuteNextCommand=true;
    }

    private function checkIsNoBom(cmdparam:CommandParam):void {
        //var obj:Object=cmdparam.param.value.iproject;
        var sc_orders:ArrayCollection = cmdparam.param.value.sc_orders as ArrayCollection;
        var sc_ordersbom:ArrayCollection = cmdparam.param.value.sc_ordersbom as ArrayCollection;
        var sql:String="select sc_bom.iproduct   from sc_bomp left join sc_bom on sc_bomp.ibom=sc_bom.iid";
        if(sc_ordersbom.length<=0){
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var resultArr:ArrayCollection = event.result as ArrayCollection;
                if (resultArr && resultArr.length > 0) {
                    for each(var item:Object in sc_orders) {
                        for each(var item2:Object in resultArr) {
                            if (item.iproject  == item2.iproduct){
                                CRMtool.showAlert("产品:"+item.iproduct_Name+"必须选择对应模块！");
                                return;
                            }
                        }
                    }
                  cmdparam.excuteNextCommand = false;//报错不执行其后命令
                }
            },sql);
        }

    }

    private function checkBomMomeyIsEqualsOrderMomey(cmdparam:CommandParam):void {
        var sc_ordersbom:ArrayCollection = cmdparam.param.value.sc_ordersbom as ArrayCollection;
        var fsummoney:Number = 0;//bom金额合计
        var fsum:Number = 0;//成交金额
        fsum = Number(cmdparam.param.value.fsum);
        for each (var item:Object in sc_ordersbom) {
            fsummoney = fsummoney + Number(item.fsum);
        }
        if (fsummoney != fsum) {
            CRMtool.showAlert("保存失败！原因：产品模块金额合计必须等于合同成交金额。");
            cmdparam.excuteNextCommand = false;//报错不执行其后命令
        }

        //else cmdparam.excuteNextCommand=true;
    }


    //回款单保存 校验 回款金额不能小于核销金额合计
    public function onExcute_IFun163(cmdparam:CommandParam):void {
        var sc_ctrpclose:ArrayCollection = cmdparam.param.value.sc_ctrpclose as ArrayCollection;
        var fsummoney:Number = 0;//计划金额合计
        var fmoney:Number = 0;//成交金额
        fmoney = Number(cmdparam.param.value.fmoney);
        for each (var item:Object in sc_ctrpclose) {
            fsummoney = fsummoney + Number(item.fclosemoney);
        }
        if (fsummoney > fmoney) {
            CRMtool.showAlert("保存失败！原因：回款金额不能小于已核销金额合计");
            cmdparam.excuteNextCommand = false;//报错不执行其后命令
        }
        //else	cmdparam.excuteNextCommand=true;

        if (cmdparam.excuteNextCommand)
            saveCommandSelf.onNext();
    }


    //新增服务回访中的综合评分 自动生成  wtf add
    public function onExcute_IFun154(cmdparam:CommandParam):void {
        var crmeap1:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainobj1:Object = crmeap1.getValue();
        //新增验证工单是否已经生成回访
        if(cmdparam.optType == "onNew"){
            var isfeed:String = mainobj1.vi_isfeed;
            if(isfeed == '是'){
                CRMtool.showAlert("工单已回访，不能再次生成！");
                return;
            }
        }
		modityFscore(cmdparam);
      /*  var sr_feedbacks:ArrayCollection = cmdparam.param.value.sr_feedbacks as ArrayCollection;
        var fscore:Number = 0;
        for each (var item:Object in sr_feedbacks) {
            if (item.fscore == null) {
                item.fscore = 0;
            } else {
                item.fscore = Number(item.fscore);
            }
            fscore += (item.fscore as Number);
        }

        var obj:Object = new Object();

        if (mainobj) {
            var objInfo:Object = ObjectUtil.getClassInfo(mainobj);
            var fieldName:Array = objInfo["properties"] as Array;
            for each (var q:QName in fieldName) {
                if (mainobj[q.localName] is ArrayCollection) {
                    obj[q.localName] = mainobj[q.localName];
                }
            }

            mainobj.fscore = fscore;

            obj.mainValue = mainobj;
            crmeap.setValue(obj, 1, 1);

            cmdparam.param.value.fscore = fscore;
        }
        //cmdparam.excuteNextCommand=true;

        if (cmdparam.excuteNextCommand)
            saveCommandSelf.onNext();*/
    }

    private function clone(source:Object):* {
        var myBA:ByteArray = new ByteArray();
        myBA.writeObject(source);
        myBA.position = 0;
        return(myBA.readObject());
    }

    //销售开票 金额自动计算 wtf add
    public function onExcute_IFun165(cmdparam:CommandParam):void {
        var sc_spinvoices:ArrayCollection = cmdparam.param.value.sc_spinvoices as ArrayCollection;
        var fsum:Number = 0;
        for each (var item:Object in sc_spinvoices) {
            if (item.ftaxsum == null) {
                item.ftaxsum = 0;
            } else {
                item.ftaxsum = Number(item.ftaxsum);
            }
            fsum += (item.ftaxsum as Number);
        }

        var obj:Object = new Object();
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainobj:Object = crmeap.getValue();
        if (mainobj) {
            var objInfo:Object = ObjectUtil.getClassInfo(mainobj);
            var fieldName:Array = objInfo["properties"] as Array;
            for each (var q:QName in fieldName) {
                if (mainobj[q.localName] is ArrayCollection) {
                    obj[q.localName] = mainobj[q.localName];
                }
            }

            mainobj.fsum = fsum;

            obj.mainValue = mainobj;
            crmeap.setValue(obj, 1, 1);
            cmdparam.param.value.fsum = fsum;
            crmeap.oldvouchFormValue = clone(obj);
        }

        //开票金额不能大于合同金额
        var sqlstr:String = "";
        if (crmeap.curButtonStatus == "onEdit") {
            sqlstr = "select isnull(so.fsum,0)-isnull(so.fspsum,0)+isnull(ss.fsum,0)as resultSum from sc_order so,sc_spinvoice ss where so.iid=" + mainobj.iinvoice + " and ss.iid=" + mainobj.iid;
        } else {
            sqlstr = "select isnull(fsum,0)-isnull(fspsum,0) as resultSum from sc_order where iid=" + mainobj.iinvoice;
        }
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var resultArr:ArrayCollection = event.result as ArrayCollection;
            if (resultArr && resultArr.length > 0) {
                var resultSum:Number = resultArr[0].resultSum as Number;
                if (resultSum < fsum) {
                    CRMtool.showAlert("开票金额不能大于合同金额！");
                    return;
                } else {
                    if (cmdparam.excuteNextCommand)
                        saveCommandSelf.onNext();
                }
            } else {
                if (cmdparam.excuteNextCommand)
                    saveCommandSelf.onNext();
            }
        }, sqlstr);

    }

    private function calSum(cmdparam:CommandParam):void {
        var sc_rdrecords:ArrayCollection = cmdparam.param.value.sc_rdrecords as ArrayCollection;
        var fsum:Number = 0;
        for each (var item:Object in sc_rdrecords) {
            if (item.fsum == null) {
                item.fsum = 0;
            } else {
                item.fsum = Number(item.fsum);
            }
            fsum += (item.fsum as Number);
        }

        var obj:Object = new Object();
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainobj:Object = crmeap.getValue();
        if (mainobj) {
            var objInfo:Object = ObjectUtil.getClassInfo(mainobj);
            var fieldName:Array = objInfo["properties"] as Array;
            for each (var q:QName in fieldName) {
                if (mainobj[q.localName] is ArrayCollection) {
                    obj[q.localName] = mainobj[q.localName];
                }
            }

            mainobj.fsum = fsum;

            obj.mainValue = mainobj;
            crmeap.setValue(obj, 1, 1);
            crmeap.oldvouchFormValue = clone(obj);
        }

        cmdparam.param.value.fsum = fsum;
    }

    //产品出库，求和 lr
    public function onExcute_IFun228(cmdparam:CommandParam):void {
        calSum(cmdparam);

        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainobj:Object = crmeap.getValue();
        var sc_rdrecords:ArrayCollection = mainobj.sc_rdrecords;
        var sc_rdrecordsbom:ArrayCollection = mainobj.sc_rdrecordsbom;



        var sql:String = ",";


        //wxh add 比较是否存在完全重复的记录
        //lr modify 优化算法
        var qsum:int = 0;
        for each(var item:Object in sc_rdrecords) {
            if (sql.search("," + item.iproduct + ",") == -1)
                sql = sql + item.iproduct + ",";
        }

        for each(var item:Object in sc_rdrecordsbom) {
            qsum += CRMtool.getNumber(item.fquantity);
        }

        sql = sql.substring(1, sql.length - 1); //lr 去掉第一个和最后一个逗号
        sql = "select COUNT(iid) as num,SUM(fquantity) as qsum  from sc_ordersbom where iorders=" + mainobj.iinvoice + " and iproductp in (" + sql + ")";
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var one:Object = (event.result as ArrayCollection)[0];
            if (sc_rdrecordsbom.length == one.num && qsum == one.qsum)
                next();
            else
                CRMtool.showAlert("出库模块数量与原始订单模块数量不符，请检查。");
        }, sql);

        function next():void {
            if (cmdparam.excuteNextCommand) {
                var sc_rdrecords:ArrayCollection = cmdparam.param.value.sc_rdrecords as ArrayCollection;
                var sc_rdrecord_csn:ArrayCollection = new ArrayCollection();
                for each(var item:Object in sc_rdrecords) {
                    if (CRMtool.isStringNotNull(item.csn)) {
                        sc_rdrecord_csn.addItem(item);
                    }
                }

                AccessUtil.remoteCallJava("customerDest", "checkCsProductSN", function (event:ResultEvent):void {
                    var rdrecords:ArrayCollection = event.result as ArrayCollection;
                    var flag = true;
                    for each(var item:Object in rdrecords) {
                        if (item.isIn) {
                            if (item.isUse) {
                                CRMtool.tipAlert1("加密狗:" + item.csn + " 已出库，确认您的操作。出现此提示的可能分析：" +
                                        "\n\t1.加密狗号输入错误。" +
                                        "\n\t2.您是要对资产补充站点。", null, "AFFIRM",
                                        function ():void {
                                            stockCheck();
                                        },
                                        function ():void {
                                            flag = false;
                                        });

                            } else {
                                stockCheck();
                            }
                        } else {
                            if (CRMtool.getOptionValue(95) == "0") {
                                CRMtool.showAlert("加密狗:" + item.csn + " 不存在入库记录，不允许出库，请检查。");
                                flag = false;
                            } else {
                                stockCheck();
                            }
                        }
                    }
                    if (rdrecords.length == 0)
                        stockCheck();

                    function stockCheck():void {
                        //lzx  begin
                        //检查库存<=0时不允许出库
                        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
                        var myValue:Object = crmeap.getValue();
                        AccessUtil.remoteCallJava("customerDest", "checkStock", function (event:ResultEvent):void {
                            var err:String = event.result as String;

                            if (err != null) {
                                CRMtool.tipAlert(err);
                            }
                            else {
                                saveCommandSelf.onNext();
                            }
                        }, myValue);

                        //lzx   end
                    }
                }, sc_rdrecord_csn);
                //saveCommandSelf.onNext();
            }
        }
    }

    //非产品出库，求和 lr
    public function onExcute_IFun167(cmdparam:CommandParam):void {
        calSum(cmdparam);
        //cmdparam.excuteNextCommand=true;
        //检查库存<=0时不允许出库
        //检查库存<=0时不允许出库
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();
		var sum:int=0;
		var subsum:int;
		var scsum:int;
		AccessUtil.remoteCallJava("customerDest", "checkStock", function (event:ResultEvent):void {
			var err:String = event.result as String;			
			if (err != null) {
				CRMtool.tipAlert(err);
			}
			else {
				if(cmdparam.optType=="onEdit" ){
					var Sql:String="UPDATE SC_rdrecords SET fquantity=0 WHERE irdrecord="+myValue.iid;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null,Sql);
				    }
				var sublist:ArrayCollection=myValue.sc_rdrecords;
				var num:Object;
				var i:int;
				var k:int;
				var iproduct:Object;
				var iinvoice:Object;
				subsum=sublist.length;
				for(i=0;i<sublist.length;i++){
					num=sublist[i].fquantity;
					iproduct=sublist[i].iproduct;
					iinvoice=sublist[i].iinvoice;
					if(num==null){
						num=0;
					}						
					var sql:String="SELECT (SUM(a.fquantity)+"+num+")frdquantity,SUM(a.fquantity)frdquantity1,s.fquantity  FROM SC_rdrecords a"
					+" LEFT join"
					+" SC_orders s ON a.iinvoice =s.iorder AND s.iproduct=a.iproduct where s.iproduct="+iproduct+" and s.iorder="+myValue.iinvoice
					+" GROUP BY frdquantity,s.fquantity";	
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
						var ac:ArrayCollection = event.result as ArrayCollection;
						scsum=ac.length;
						sum=sum+1;
						for(k=0;k<ac.length;k++){	
							if(ac[k].frdquantity>ac[k].fquantity){
								var num:Number=0;
								num=Math.round((ac[k].fquantity-ac[k].frdquantity1)*100)/100;  //SZC
								sum=sum-1;
								CRMtool.showAlert("出库数量与原始订单数量不符，还能出库 "+num+" 个。");
								return;
							}	
						}							
						if(sum==subsum){
							saveCommandSelf.onNext();	
						}
					}, sql);						
				}		
				}
			
		}, myValue);
		
    }
	
	public function onExcute_IFun204(cmdparam:CommandParam):void {
		modityFscore(cmdparam);
	}
	
	/**
	 * 实施回访和服务回访分数累加
	 * 作者：施则成
	 * 日期：2014-12-16
	 */
	public function modityFscore(cmdparam:CommandParam):void {
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var mainValue:Object = crmeap.getValue();
		var sr_feedbacks:ArrayCollection = cmdparam.param.value.sr_feedbacks as ArrayCollection;
		var fscore:Number = 0;
		for each (var item:Object in sr_feedbacks) {
			if (item.fscore == null) {
				item.fscore = 0;
			} else {
				item.fscore = Number(item.fscore);
			}
			fscore += (item.fscore as Number);
		}
		
		var obj:Object = new Object();
		
		if (mainValue) {
			var objInfo:Object = ObjectUtil.getClassInfo(mainValue);
			var fieldName:Array = objInfo["properties"] as Array;
			for each (var q:QName in fieldName) {
				if (mainValue[q.localName] is ArrayCollection) {
					obj[q.localName] = mainValue[q.localName];
				}
			}
			
			mainValue.fscore = fscore;
			
			obj.mainValue = mainValue;
			crmeap.setValue(obj, 1, 1);
			
			cmdparam.param.value.fscore = fscore;
		}
		if (cmdparam.excuteNextCommand)
			saveCommandSelf.onNext();
		
	}
	

    //其他产品出库，检查库存<=0时不允许出库
    public function onExcute_IFun175(cmdparam:CommandParam):void {
        //检查库存<=0时不允许出库
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();
        //SZC20160722 add 判断修改其他出库时iid为负数
        if(cmdparam.optType == "onEdit"){
            for each(var item:Object in myValue.sc_rdrecords){
                if(item.hasOwnProperty("iid")){
                    if(item.iid<0){
                        delete item.iid;
                    }
                }

            }
        }

        AccessUtil.remoteCallJava("customerDest", "checkStock", function (event:ResultEvent):void {
            var err:String = event.result as String;

            if (err != null) {
                CRMtool.tipAlert(err);
            }
            else {
                saveCommandSelf.onNext();
            }
        }, myValue);


    }

    //服务申请
    public function onExcute_IFun149(cmdparam:CommandParam):void {

        checkCustproductServiceDate(cmdparam);
    }

    //服务工单
    public function onExcute_IFun150(cmdparam:CommandParam):void {
        checkCustproductServiceDate(cmdparam);

    }

    private function checkCustproductServiceDate(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();

        var icustproduct:int = myValue.icustproduct;
        if (icustproduct > 0) {
            var sql:String = "select datediff(d,getdate(),dsend) as diffdate from cs_custproduct where iid=" + icustproduct;
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var eventAC:ArrayCollection = event.result as ArrayCollection;
                geCustproductDsendBack(eventAC, crmeap);
            }, sql);
        } else {
            saveCommandSelf.onNext();
        }

    }

    private function geCustproductDsendBack(ac:ArrayCollection, crmeap:CrmEapRadianVbox):void {
        if (ac && ac.length > 0) {
            var diffdate:int = ac[0].diffdate;
            if (diffdate < 0) {
                var overday:int = 0 - diffdate;
                CRMtool.tipAlert("该客户资产服务已超期，超期时间：" + overday + "天,是否继续保存？", null, "AFFIRM", this, "saveContinue");
            }
            else {
                saveContinue();
                if (diffdate <= 31) {
                    (crmeap.paramForm as FrameCore).tip = "该客户资产服务期即将结束，剩余时间：" + diffdate + "天";
                }
            }
        }
    }

    public function saveContinue():void {
        saveCommandSelf.onNext();
    }


    //人员计划编制保存条件
    public function onExcute_IFun317(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        if (cmdparam.context.oldvouchFormValue) {
            var oldMyValue:Object = cmdparam.context.oldvouchFormValue.mainValue;
        }
        var myValue:Object = crmeap.getValue();
        //人员预算保存时，预算明细根据表头部门人员保存
        myValue.bm_bgrecordp.removeAll();
        var bm_bgrecordp:Object = new Object();
        bm_bgrecordp.ibgrecord = myValue.iid;
        bm_bgrecordp.iperson = myValue.iperson;
        bm_bgrecordp.idepartment = myValue.idepartment;
        bm_bgrecordp.fpercent = 1;
        bm_bgrecordp.cmemo = "";
        myValue.bm_bgrecordp.addItem(bm_bgrecordp);


        if (myValue.bm_bgrecords && myValue.bm_bgrecords.length > 0) {
            var bm_bgrecords:ArrayCollection = myValue.bm_bgrecords;
            var fvalue1s:int = 0;
            var fvalue2s:int = 0;
            var flag:Boolean = true;
            for (var i:int = 0; i < bm_bgrecords.length; i++) {
                fvalue1s = fvalue1s + int(Number(bm_bgrecords[i].fvalue1));
                fvalue2s = fvalue2s + int(Number(bm_bgrecords[i].fvalue2));
                if (((i + 1) < bm_bgrecords.length) && (bm_bgrecords[i].imonth == bm_bgrecords[i + 1].imonth)) {
                    flag = false;
                }
            }

            if (fvalue1s != int(Number(myValue.fvalue1))) {
                CRMtool.showAlert("月标准值之和不等于预算标准！");
            } else if (fvalue2s != int(Number(myValue.fvalue2))) {
                CRMtool.showAlert("月冲刺值之和不等于预算冲刺！");
            } else if (!flag) {
                CRMtool.showAlert("月份输入重复！");
            } else {
                if (cmdparam.optType == "onNew") {
                    var sql:String = "select * from  bm_bgrecord  where bm_bgrecord.iyear=" + myValue.iyear + "  and   bm_bgrecord.iperson = " + myValue.iperson + "  and   bm_bgrecord.idepartment =" + myValue.idepartment + "  and   bm_bgrecord.itarget = " + myValue.itarget + "  and   bm_bgrecord.iifuncregedit = " + myValue.iifuncregedit;
                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                        if (event.result.length > 0) {
                            CRMtool.showAlert("年度、人员、部门、指标创建重复，不允许保存！");
                        } else {
                            saveCommandSelf.onNext();
                        }
                    }, sql);
                } else if (oldMyValue.itarget != myValue.itarget || oldMyValue.iyear != myValue.iyear || oldMyValue.idepartment != oldMyValue.idepartment) {
                    var sql:String = "select * from  bm_bgrecord  where bm_bgrecord.iyear=" + myValue.iyear + "  and   bm_bgrecord.iperson = " + myValue.iperson + "  and   bm_bgrecord.idepartment =" + myValue.idepartment + "  and   bm_bgrecord.itarget = " + myValue.itarget + "  and   bm_bgrecord.iifuncregedit = " + myValue.iifuncregedit;
                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                        if (event.result.length > 0) {
                            CRMtool.showAlert("年度、人员、部门、指标创建重复，不允许保存！");
                        } else {
                            saveCommandSelf.onNext();
                        }
                    }, sql);
                } else {
                    saveCommandSelf.onNext();
                }
            }
        } else {
            CRMtool.showAlert("请先填写月标准值和冲刺值！");
        }
    }

    //部门计划编制保存条件
    public function onExcute_IFun315(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        if (cmdparam.context.oldvouchFormValue) {
            var oldMyValue:Object = cmdparam.context.oldvouchFormValue.mainValue;
        }
        var myValue:Object = crmeap.getValue();

        if (myValue.bm_bgrecords && myValue.bm_bgrecords.length > 0) {
            var bm_bgrecords:ArrayCollection = myValue.bm_bgrecords;
            var fvalue1s:int = 0;
            var fvalue2s:int = 0;
            var flag:Boolean = true;
            for (var i:int = 0; i < bm_bgrecords.length; i++) {
                fvalue1s = fvalue1s + int(Number(bm_bgrecords[i].fvalue1));
                fvalue2s = fvalue2s + int(Number(bm_bgrecords[i].fvalue2));
                if (((i + 1) < bm_bgrecords.length) && (bm_bgrecords[i].imonth == bm_bgrecords[i + 1].imonth)) {
                    flag = false;
                }
            }

            if (fvalue1s != int(Number(myValue.fvalue1))) {
                CRMtool.showAlert("月标准值之和不等于预算标准！");
            } else if (fvalue2s != int(Number(myValue.fvalue2))) {
                CRMtool.showAlert("月冲刺值之和不等于预算冲刺！");
            } else if (!flag) {
                CRMtool.showAlert("月份输入重复！");
            } else {
                if (cmdparam.optType == "onNew") {
                    var sql:String = "select * from  bm_bgrecord  where bm_bgrecord.iyear=" + myValue.iyear + "  and   bm_bgrecord.idepartment =" + myValue.idepartment + "  and   bm_bgrecord.itarget = " + myValue.itarget + "  and   bm_bgrecord.iifuncregedit = " + myValue.iifuncregedit;
                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                        if (event.result.length > 0) {
                            CRMtool.showAlert("年度、部门、指标创建重复，不允许保存！");
                        } else {
                            saveCommandSelf.onNext();
                        }
                    }, sql);
                } else if (oldMyValue.itarget != myValue.itarget || oldMyValue.iyear != myValue.iyear || oldMyValue.idepartment != oldMyValue.idepartment) {
                    var sql:String = "select * from  bm_bgrecord  where bm_bgrecord.iyear=" + myValue.iyear + "  and   bm_bgrecord.idepartment =" + myValue.idepartment + "  and   bm_bgrecord.itarget = " + myValue.itarget + "  and   bm_bgrecord.iifuncregedit = " + myValue.iifuncregedit;
                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                        if (event.result.length > 0) {
                            CRMtool.showAlert("年度、部门、指标创建重复，不允许保存！");
                        } else {
                            saveCommandSelf.onNext();
                        }
                    }, sql);
                } else {
                    saveCommandSelf.onNext();
                }
            }
        } else {
            CRMtool.showAlert("请先填写月标准值和冲刺值！");
        }
    }

    //职员用户保存时，判断
    public function onExcute_IFun13(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();
        var busestatus:int = myValue.busestatus;
        var cusecode:String = myValue.cusecode as String;

        var busbkey:int = myValue.busbkey;
        var cusbkey:String = myValue.cusbkey;
        if (busestatus == 1 && CRMtool.isStringNull(cusecode)) {
            CRMtool.tipAlert1("请填写操作员账号。");
        } else if (busbkey == 1 && CRMtool.isStringNull(cusbkey)) {
            CRMtool.tipAlert1("请填写USB加密狗号。");
        } else {
           // saveCommandSelf.onNext();
        }
		if(myValue.blogin==1){
		var sSql:String="select clogin from hr_person where blogin=1 and clogin is not null";
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
			var ac:ArrayCollection=event.result as ArrayCollection;
			for(var i:int;i<ac.length;i++){
			   if(ac[i].clogin==""){
			     ac.removeItemAt(i);
			   }
			}
			var objparam:Object=new Object();
			objparam.ac=ac
			AccessUtil.remoteCallJava("hrPersonDest", "selectClogin", function (event:ResultEvent):void {
				if(event.result>=CRMmodel.imobilecount){
					CRMtool.tipAlert1("您设定的手机登陆人数，已经大于许可数。");
					return;
				}else{
					saveCommandSelf.onNext();
				}
			}, objparam);
		}, sSql);
		}else{
			saveCommandSelf.onNext();
		}
    }

    //公司计划编制保存条件
    //LC    修改  计算月标准值之和不等于预算标准 var fvalue1s:int = 0;
    public function onExcute_IFun313(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        if (cmdparam.context.oldvouchFormValue) {
            var oldMyValue:Object = cmdparam.context.oldvouchFormValue.mainValue;
        }
        var myValue:Object = crmeap.getValue();

        if (myValue.bm_bgrecords && myValue.bm_bgrecords.length > 0) {
            var bm_bgrecords:ArrayCollection = myValue.bm_bgrecords;
            var fvalue1s:Number = 0;
            var fvalue2s:Number = 0;
            var flag:Boolean = true;
            for (var i:int = 0; i < bm_bgrecords.length; i++) {
                fvalue1s = fvalue1s + bm_bgrecords[i].fvalue1;//fvalue1s = fvalue1s + int(Number(bm_bgrecords[i].fvalue1));
                fvalue2s = fvalue2s + bm_bgrecords[i].fvalue2;//fvalue2s = fvalue2s + int(Number(bm_bgrecords[i].fvalue2));
                if (((i + 1) < bm_bgrecords.length) && (bm_bgrecords[i].imonth == bm_bgrecords[i + 1].imonth)) {
                    flag = false;
                }
            }

            if (fvalue1s != myValue.fvalue1) {//int(Number(myValue.fvalue1))
                CRMtool.showAlert("月标准值之和不等于预算标准！");
            } else if (fvalue2s != myValue.fvalue2) {//int(Number(myValue.fvalue2))
                CRMtool.showAlert("月冲刺值之和不等于预算冲刺！");
            } else if (!flag) {
                CRMtool.showAlert("月份输入重复！");
            } else {
                if (cmdparam.optType == "onNew") {
                    var sql:String = "select * from  bm_bgrecord  where bm_bgrecord.iyear=" + myValue.iyear + "  and   bm_bgrecord.itarget = " + myValue.itarget + "  and   bm_bgrecord.iifuncregedit = " + myValue.iifuncregedit;
                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                        if (event.result.length > 0) {
                            CRMtool.showAlert("年度、指标创建重复，不允许保存！");
                        } else {
                            saveCommandSelf.onNext();
                        }
                    }, sql);
                } else if (oldMyValue.itarget != myValue.itarget || oldMyValue.iyear != myValue.iyear || oldMyValue.idepartment != oldMyValue.idepartment) {
                    var sql:String = "select * from  bm_bgrecord  where bm_bgrecord.iyear=" + myValue.iyear + "  and   bm_bgrecord.itarget = " + myValue.itarget + "  and   bm_bgrecord.iifuncregedit = " + myValue.iifuncregedit;
                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                        if (event.result.length > 0) {
                            CRMtool.showAlert("年度、指标创建重复，不允许保存！");
                        } else {
                            saveCommandSelf.onNext();
                        }
                    }, sql);
                } else {
                    saveCommandSelf.onNext();
                }
            }
        } else {
            CRMtool.showAlert("请先填写月标准值和冲刺值！");
        }
    }


    //商机
    public function onExcute_IFun80(cmdparam:CommandParam):void {
        var icustomer:int = cmdparam.param.value.icustomer;
        if (icustomer > 0) {
            var sql:String = "select * from sa_opportunity where istatus=340 and icustomer=" + icustomer + " and iid!=" + cmdparam.param.value.iid;
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var ac:ArrayCollection = event.result as ArrayCollection;
                if (ac && ac.length > 0)
                    CRMtool.showAlert("该客户存在别的进行中的商机，请注意沟通！");
            }, sql);
        }

        saveCommandSelf.onNext();
    }
    
	
	public function modifyBom(cmdparam:CommandParam):void {
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var sc_rdrecords:ArrayCollection = crmeap.getValue().sc_rdrecords;
		var sc_rdrecordsbom:ArrayCollection = crmeap.getValue().sc_rdrecordsbom;
		
		//add by zhong_jing 判断是否存在相同的产品。
		
		var flag:Boolean = false;
		for each(var item:Object in sc_rdrecords) {
			for each(var item2:Object in sc_rdrecords) {
				if (item != item2 && item.iproduct == item2.iproduct)
					flag = true
			}
		}
		if (flag) {
			CRMtool.showAlert("保存失败！原因：产品入库中不允许存在相同产品，请尝试拆分产品入库解决。");
			cmdparam.excuteNextCommand = false;//报错不执行其后命令
		}
		else
		{
			if (sc_rdrecords && sc_rdrecordsbom) {
				var removeList:ArrayCollection = new ArrayCollection();
				for each(var bom:Object in sc_rdrecordsbom) {
					var flag:Boolean = true;
					for each(var prodouct:Object in sc_rdrecords) {
						if (bom.iproductp == prodouct.iproduct)
							flag = false;
					}
					if (flag)
						removeList.addItem(bom);
				}
				for each(var ritem:Object in removeList) {
					sc_rdrecordsbom.removeItemAt(sc_rdrecordsbom.getItemIndex(ritem));
				}
			}
			
			saveCommandSelf.onNext();
			//break;
		}
	}

    public function onExcute_IFun231(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var mainValue:Object=crmeap.getValue();
		var istest:int = CRMmodel.IsRebackToContCost;
		var flag:Boolean=modifyCSNRdrecord(cmdparam);//一个加密狗号对应一个产品   ADD   SZC
				if(flag){
					return;
				}
		if(cmdparam.optType == "onEdit"){
		  if(istest ==1 && mainValue.iinvoice!=null){
			//20150106 SZC 做入库先不关联合同，点击修改后在关联合同，会报出null异常，删除入库的产品后异常解决
			var iinvoice:Number=0;
			var sqlStr:String="select  isnull(iinvoice,0) iinvoice  from sc_rdrecord where iid="+mainValue.iid;
			
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var ac:ArrayCollection = event.result as ArrayCollection;
				if (ac && ac.length > 0){
					iinvoice=ac[0].iinvoice;
					if(ac[0].iinvoice=="" || ac[0].iinvoice==null || ac[0].iinvoice==0){
						var delSql:String="delete from sc_rdrecords where irdrecord="+mainValue.iid;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, delSql, null, false);
						modifyBom(cmdparam);
					}else{
						modifyBom(cmdparam);
					}
				}
			}, sqlStr);
			//20150317
			var strSql1:String="select iid,iproduct,fquantity from sc_orders where iorder="+mainValue.iinvoice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				var asc:ArrayCollection=e.result  as ArrayCollection;
				var ac:ArrayCollection=mainValue.sc_rdrecords as ArrayCollection;
				if(asc.length==0){
					return;
				}
				for(var j:int=0;j<asc.length;j++){
					for(var i:int=0;i<ac.length;i++){
						if(asc[j].iproduct==ac[i].iproduct){
							var fcost:Number=ac[i].fprice*asc[j].fquantity;
							var upSql1:String="update sc_orders set fcostprice="+ac[i].fprice+",fcost="+fcost+"  where iid="+asc[j].iid;
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,upSql1, null, false);
						}
					}
				}
				var sql2:String="select fsum,forderprofit,fbackprofit,fcost from sc_order where iid="+mainValue.iinvoice;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					var aclist:ArrayCollection=e.result as  ArrayCollection;
					var obj:Object=new Object();
					obj.asc=asc;
					obj.ac=ac;
					obj.aclist=aclist;
					obj.iinvoice=mainValue.iinvoice;
					obj.optType="onEdit";
					AccessUtil.remoteCallJava("UtilViewDest", "updateOrderFsum", null,obj);
				},sql2);
				
				var sql:String ="update sc_order set fcost = a.fsum from (select sum(fcost)fsum from sc_orders where iorder="+mainValue.iinvoice+") a "+
				" where  sc_order.iid = " + mainValue.iinvoice;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
			}, strSql1);
			//
		/*	//20141206 SZC 修改后减去原来合同的成本
			var fsum:Number=0;
			var sql:String="select fsum from sc_rdrecord where iid="+mainValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var ac:ArrayCollection = event.result as ArrayCollection;
				if (ac && ac.length > 0){
					fsum=parseFloat(ac[0].fsum);
				}
			}, sql, null, false);
			var strSql:String="select isnull(fcost,0) fcost,forderprofit,isnull(fbackprofit,0) fbackprofit from sc_order where iid="+mainValue.iinvoice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
				var arr:ArrayCollection= e.result as ArrayCollection;
				if(arr.length>0){
					if(arr[0].fcost!=0 && arr[0].fcost!="" && arr[0].forderprofit!="" && arr[0].forderprofit!=null){
					var upSql:String="update sc_order set fcost="+(parseFloat(arr[0].fcost)-fsum)+",forderprofit="+(parseFloat(arr[0].forderprofit)+fsum)+" where iid="+mainValue.iinvoice;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					}
					if(arr[0].fbackprofit!=0 && arr[0].fbackprofit!="" && iinvoice!=0){//如果回款利润不为null,利润加上成本
						var upSql:String="update sc_order set fbackprofit="+(parseFloat(arr[0].fbackprofit)+fsum)+" where iid="+mainValue.iinvoice;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					}
				}
			}, strSql, null, false);*/
			}else{
				modifyBom(cmdparam);
			}
		}
		
		if(cmdparam.optType == "onNew"){
			modifyBom(cmdparam);
		}

        /*var sc_rdrecords:ArrayCollection = crmeap.getValue().sc_rdrecords;
        var sc_rdrecordsbom:ArrayCollection = crmeap.getValue().sc_rdrecordsbom;

        //add by zhong_jing 判断是否存在相同的产品。

        var flag:Boolean = false;
        for each(var item:Object in sc_rdrecords) {
            for each(var item2:Object in sc_rdrecords) {
                if (item != item2 && item.iproduct == item2.iproduct)
                    flag = true
            }
        }
        if (flag) {
            CRMtool.showAlert("保存失败！原因：产品入库中不允许存在相同产品，请尝试拆分产品入库解决。");
            cmdparam.excuteNextCommand = false;//报错不执行其后命令
        }
        else
        {
            if (sc_rdrecords && sc_rdrecordsbom) {
                var removeList:ArrayCollection = new ArrayCollection();
                for each(var bom:Object in sc_rdrecordsbom) {
                    var flag:Boolean = true;
                    for each(var prodouct:Object in sc_rdrecords) {
                        if (bom.iproductp == prodouct.iproduct)
                            flag = false;
                    }
                    if (flag)
                        removeList.addItem(bom);
                }
                for each(var ritem:Object in removeList) {
                    sc_rdrecordsbom.removeItemAt(sc_rdrecordsbom.getItemIndex(ritem));
                }
            }

            saveCommandSelf.onNext();
        }*/
    }

    //新增业务配置
    public function onExcute_IFun340(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;

        var mainObj = crmeap.getValue();
        var iordertp = mainObj.iordertp;
        var iid = mainObj.iid;
        var sql:String = "select iordertp from sc_apportioncf where iordertp=" + iordertp + " and iid!=" + iid;
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var ac:ArrayCollection = event.result as ArrayCollection;
            if (ac && ac.length > 0)
                CRMtool.showAlert("此业务功能已经配置过分摊方案，无法再次配置。");
            else
                saveCommandSelf.onNext();
        }, sql);
    }

    /**
     * 方法功能：表单设置保存前检验“是否关联”选择是否正确
     * 编写作者：XZQWJ
     * 创建日期：2012-12-28
     * 更新日期：
     *
     *
     */
    public function onExcute_IFun145(cmdparam:CommandParam):void {

        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var ac_vouchform:ArrayCollection = crmeap.getValue().ac_vouchform;
        var ifuncregedit:Object = crmeap.getValue().ifuncregedit;
        var boolean:Boolean = false;

        for each(var form:Object in ac_vouchform) {
            if (form.bshow == 1 && form.iobjecttype == 1 && (form.igrouprow == null || form.igrouprow == 0)) {
                var cobjectname:String = form.cobjectname as String;
                CRMtool.showAlert("<" + cobjectname + ">为显示的分组,其<分组控件内置列数>不能为空或者0");
                boolean = true;
                break;
            }
        }
        if (boolean) {
            return;
        }

        var sql:String = "select distinct ctable2 from dbo.ac_tablerelationship where  ctable2!='null' and isnull(ctable2,'')<>'' and  ifuncregedit=" + ifuncregedit;

        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var ac:ArrayCollection = event.result as ArrayCollection;
            if (ac == null || ac.length == 0) {//不存在主表
                saveCommandSelf.onNext();
            } else {

                for each(var form:Object in ac_vouchform) {
                    var ccaption:String = form.ccaption as String;
                    if (CRMtool.isStringNull(ccaption)) {
                        ccaption = form.cobjectname as String;
                    }
                    if (form.iobjecttype != 8 && form.brelation == 1) {
                        boolean = true;
                        CRMtool.showAlert("<" + ccaption + ">不是表格类型,不能设置关联关系")
                        break;
                    } else if (form.iobjecttype == 8 && form.brelation == 1) {
                        var l:int = ac.length;
                        var ctable:String = form.ctable as String;
                        for (var i:int = 0; i < l; i++) {
                            var ctable2:String = ac[i].ctable2 as String;
                            if (ctable == ctable2) {
                                boolean = true;
                                break;
                            }
                        }
                        if (boolean) {
                            CRMtool.showAlert("<" + ccaption + ">为主表,不能设置关联关系")
                            break;
                        }
                    }

                }
                if (!boolean) {
                    saveCommandSelf.onNext();
                }
            }
        }, sql);

//			cmdparam.excuteNextCommand=false
    }

    //add by zhong_jing 开发日志
    public function onExcute_IFun369(cmdparam:CommandParam):void {

        var iid:int = cmdparam.param.value.iid;
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();

        var ifuncregedit:int = myValue.ifuncregedit;
        if (ifuncregedit == 208 && myValue.iinvoice) {
            var sql:String = "select * from sr_project where iifuncregedit=" + ifuncregedit + " and iid=" + myValue.iinvoice;
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var resultArr:ArrayCollection = event.result as ArrayCollection;
                if (resultArr.length > 0) {
                    var resultObject:Object = resultArr.getItemAt(0);
                    if (resultObject.dfactbegin != null && resultObject.dfactbegin != "") {
                        var dfactbegin:Date = resultObject.dfactbegin as Date;
                        var ddate:Date = myValue.ddate as Date;
                        if (ObjectUtil.dateCompare(dfactbegin, ddate) == 1) {
                            CRMtool.tipAlert1("开发日期不能小于开发管理里面的实际开始时间");
                        }
                        else {
                            saveCommandSelf.onNext();
                        }
                    }
                    else {
                        saveCommandSelf.onNext();
                    }
                }
                else {
                    saveCommandSelf.onNext();
                }
            }, sql);
        }
        else {
            saveCommandSelf.onNext();
        }
    }

    //功能建模
    public function onExcute_IFun372(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var value:Object = crmeap.getValue();
        var iid:int = value.iid;
        var bdataauth1:int = value.bdataauth1;
        var bdataauth2:int = value.bdataauth2;
        var bdataauth:int = value.bdataauth;

        if (iid > 0 && value.bdataauth2 + "" == "1") {//说明启用了客户权限
            var sql:String = "select am.iid from ac_listclm am " +
                    "left join ac_listset alt on am.ilist = alt.iid " +
                    "left join as_funcregedit aft on aft.iid = alt.ifuncregedit " +
                    "where aft.ifuncregedit = " + iid + " and am.cfield='icustomer'"
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var ac:ArrayCollection = event.result as ArrayCollection;
                if (ac.length == 0)
                    CRMtool.showAlert("本功能关联列表，并未查询icustomer字段，会导致客户权限无法使用，请检查。");
            }, sql);

        }

        if (iid > 0) {
            var sql:String = "select bdataauth,bdataauth1,bdataauth2 from as_funcregedit where iid = " + iid;
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var ac:ArrayCollection = event.result as ArrayCollection;
                if (ac[0].bdataauth2 != bdataauth2 || ac[0].bdataauth1 != bdataauth1 || ac[0].bdataauth != bdataauth) {
                    crmeap.publicFlagObject.is372Change = true;
                }

                saveCommandSelf.onNext();
            }, sql);
        } else {
            saveCommandSelf.onNext();
        }
    }

    /**
     * 培训回访卡片保存前，计算评分
     */
    public function onExcute_IFun198(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainValue:Object = crmeap.getValue();
        var arr:ArrayCollection = mainValue.sr_feedbacks;
        var fscore:Number = 0;
        for each(var feedback:Object in arr) {
            fscore += CRMtool.getNumber(feedback.fscore);
        }
        crmeap.setSingValue("fscore", fscore.toString());
        saveCommandSelf.onNext();
    }


    /**
     * 方法功能：验证黄页客商里面的客户名称在客商里面是否存在
     * 编写作者：钟晶
     * 创建日期：2013—8-14
     *
     */
    public function onExcute_IFun176(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainValue:Object = crmeap.getValue();
        var cname:String = mainValue.cname;
        var sql:String = "select * from cs_customer where cname='" + cname + "'";
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var ac:ArrayCollection = event.result as ArrayCollection;
            if (ac.length > 0) {
                CRMtool.showAlert("该客商已经是正式客户，不能被添加");
            }
            else {
                saveCommandSelf.onNext();
            }
        }, sql);
    }

    //客商档案
    public function onExcute_IFun44(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainValue:Object = crmeap.getValue();
        var persons:ArrayCollection = mainValue.cs_custperson;
        var i:int = 0;
        for each(var item:Object in persons) {
            if (item.bkeycontect == 1 || item.bkeycontect == true)
                i++;
        }
        if (i > 1) {
            CRMtool.showAlert("一个客户只能有一个主联系人，请检查。");
            return;
        } else {
            saveCommandSelf.onNext();
        }
    }
    //批量保存发票前，判断是否执行了“预录入”
    public function onExcute_IFun394(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainValue:Object =crmeap.getValue() as Object;
        var arr:ArrayCollection = mainValue.tr_invoice as ArrayCollection;
        var iid:int = mainValue.iid;
        if(iid == 0 && (arr == null || arr.length == 0)){
            CRMtool.showAlert("请先执行(更多操作-预录入)！");
            return;
        }else if(iid>0){
            mainValue.tr_invoice = new ArrayCollection();//清空子表数据
            if(!(crmeap.paramForm as FrameCore).onPredictSave())//调用预录入操作
                return;
        }
        saveCommandSelf.onNext();
    }
	
    /**
     * 方法功能：客户联系人保存前校验 此单据主联系人 是否与数据库已存在数据冲突
     * 编写作者：lr
     * 创建日期：2012-5-11
     * 更新日期：
     *
     * 因为远程函数 返回后修改excuteNextCommand 解决不了问题,所以放弃此段代码
     */
    /*public function onExcute_IFun45(cmdparam:CommandParam):void
     {
     cmdparam.excuteNextCommand=false;

     var iid:int = cmdparam.param.value.iid; //iid>0是修改,iid==0新增
     var icustomer:int = cmdparam.param.value.icustomer;
     var bkeycontect:int = cmdparam.param.value.bkeycontect;

     if(icustomer==0){//没有选择客商
     cmdparam.excuteNextCommand=true;
     return;
     }

     if(bkeycontect==1){//此表单是主联系人
     AccessUtil.remoteCallJava("customerDest","getCustMainPerson",function(event:ResultEvent):void{
     var ac:ArrayCollection;
     if(event.result!=null)
     {
     ac = event.result as ArrayCollection;
     }
     if(ac.length>1){
     CRMtool.showAlert("异常:此客商已存在多个主联系人,请检查.");
     cmdparam.excuteNextCommand=true;
     return;
     }
     if(ac.length==1){
     var aciid:int = ac.getItemAt(0).iid;
     if(iid==aciid){//已存在的恰是本单据
     cmdparam.excuteNextCommand=true;
     }else{
     //CRMtool.tipAlert("",null,"AFFIRM",this,"");
     //CRMtool.showAlert("异常:此客商已存在一个主联系人,请检查.");
     //此处本来应该多做判断的,遇到其他问题,暂时都向下执行了.在保存时,会强刷当前单据主联系人
     cmdparam.excuteNextCommand=true;
     }
     }
     },icustomer);

     }else{
     cmdparam.excuteNextCommand=true;
     }
     }*/


    /**日期放不进去,暂时放弃.
     * 方法功能：客商档案保存时,检查联系人是否已存在,不存在插入制单时间,存在,插入修改时间
     * 编写作者：lr
     * 创建日期：2012-5-11
     * 更新日期：
     */
    /*		public function onExcute_IFun44(cmdparam:CommandParam):void
     {
     var cs_custperson:ArrayCollection=cmdparam.param.value.CS_custperson as ArrayCollection;

     if(cs_custperson&&cs_custperson.length>0){
     for each(var o:Object in cs_custperson){
     if(o.iid==0){
     o.imaker = CRMmodel.hrperson.iid.toString();
     o.dmaker = "服务器当前日期";
     }else{
     o.imodify = CRMmodel.hrperson.iid.toString();
     o.dmodify = "服务器当前日期";
     }
     }
     }
     var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
     var o:Object = crmeap.getValue();
     cmdparam.excuteNextCommand=true;
     }*/

	/**
	 * 收费单保存前，验证税控外包服务是否选择
	 * 作者：李宁
	 * 日期：2014-03-28
	 */
	public function onExcute_IFun390(cmdparam:CommandParam):void {
		
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var mainValue:Object = crmeap.getValue();
		
		var brevenue:Object = mainValue.brevenue;
		
		if(brevenue == null) {
			cmdparam.excuteNextCommand=false;
			CRMtool.showAlert("请选择是否税控外包服务！");	
			return;
		} else {
			saveCommandSelf.onNext();
		}
		
	}
	
	/**
	 * 解决通用费用修改后合同中的合同费用累加的问题
	 * 创建人：施则成
	 * 创建时间：20141215
	 * */
	public function  onExcute_IFun275(cmdparam:CommandParam):void{
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var value:Object = crmeap.getValue() as Object;
		if(cmdparam.optType=="onEdit"){
			var fsum:Number;
			var sql:String ="select fsum from oa_expense where  iid="+value.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(e:ResultEvent):void{
			   var ac:ArrayCollection= e.result as ArrayCollection;
			   if(ac.length>0){
				   fsum=parseFloat(ac[0].fsum);
			   }
			},sql);
			var strSql:String="select ffee,forderprofit,fbackprofit from sc_order where iid="+value.iinvoice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
				var arr:ArrayCollection= e.result as ArrayCollection;
				if(arr.length>0){
					var upSql:String="update sc_order set ffee="+(parseFloat(arr[0].ffee)-fsum)+",forderprofit="+(parseFloat(arr[0].forderprofit)+fsum)+" where iid="+value.iinvoice;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					if(arr[0].fbackprofit!=null && arr[0].fbackprofit!=""){//如果回款利润不为null,利润加上成本
						var upSql:String="update sc_order set fbackprofit="+(parseFloat(arr[0].fbackprofit)+fsum)+" where iid="+value.iinvoice;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					}
				}
			}, strSql, null, false);
		}
		saveCommandSelf.onNext();
	}
	
	/**
	 * 解决赠品出库修改后合同中的合同费用累加的问题
	 * 创建人：施则成
	 * 创建时间：20141215
	 * */
	public function  onExcute_IFun427(cmdparam:CommandParam):void{
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var value:Object = crmeap.getValue() as Object;
		if(cmdparam.optType=="onEdit"){
			var fsum:Number;
			var sql:String ="select fsum from sc_rdrecord where  iid="+value.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(e:ResultEvent):void{
				var ac:ArrayCollection= e.result as ArrayCollection;
				if(ac.length>0){
					fsum=parseFloat(ac[0].fsum);
				}
			},sql);
			var strSql:String="select fpremiums,forderprofit,fbackprofit from sc_order where iid=(select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ value.iinvoice+")";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
				var arr:ArrayCollection= e.result as ArrayCollection;
				if(arr.length>0){
					var upSql:String="update sc_order set fpremiums="+(parseFloat(arr[0].fpremiums)-fsum)+",forderprofit="+(parseFloat(arr[0].forderprofit)+fsum)+" where iid=(select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ value.iinvoice+")";
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					if(arr[0].fbackprofit!=null && arr[0].fbackprofit!=""){//如果回款利润不为null,利润加上成本
						var upSql:String="update sc_order set fbackprofit="+(parseFloat(arr[0].fbackprofit)+fsum)+" where iid=(select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ value.iinvoice+")";
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					}
				}
			}, strSql, null, false);
		}
		saveCommandSelf.onNext();
	}

	/**
	 * 方法功能：判断目标方案的比率是否为100
	 * 编写作者：SZC
	 * 创建日期：2015-2-3
	 * 更新日期：
	 */
	public function onExcute_IFun431(cmdparam:CommandParam):void {
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var mainValue:Object = crmeap.getValue();
		var sum:Number=0;
		if(mainValue.sr_goalprograms!=null){
			for each(var item:Object in mainValue.sr_goalprograms ){
				sum=sum+parseInt(item.irate);
			} 
		}
		if(sum!=100){
			CRMtool.tipAlert("方案定义中所有比率和不等于100");
			return;
		}else{
			saveCommandSelf.onNext();
		}

	}
	
	/**
	 * 方法功能：判断目标方案的比率是否为100
	 * 编写作者：SZC
	 * 创建日期：2015-2-3
	 * 更新日期：
	 */
	public function onExcute_IFun442(cmdparam:CommandParam):void {
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var mainValue:Object = crmeap.getValue();
		var sql:String="select isnull(cname,0) cname from sr_projectmodule where iproject="+mainValue.iproject;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
		var ac:ArrayCollection=e.result as ArrayCollection;
		if(ac.length==0){
			saveCommandSelf.onNext();
			return;
		}
		for (var i:int=0;i<ac.length;i++){
			if(ac[i].cname==mainValue.cname){
				CRMtool.tipAlert("项目中已经存在该模块，不能增加！");
				return;
			}
		}
			saveCommandSelf.onNext();
		},sql);
		
	}
	
    public function onExcute_IFun350(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainValue:Object = crmeap.getValue();
        var sc_rdrecords:Object = mainValue.sc_rdrecords;//子表信息
            var sql:String = "";
            if (cmdparam.optType == "onNew") {
                for each(var obj:Object in sc_rdrecords) {
                    if (obj.iinvoices != "") {
                        sql += obj.iinvoices + ",";
                    }
                }
                sql = "select iid,round(fquantity - isnull(fwoquantity,0),4) noquantity from sc_rdrecords where iid in (" + sql + "0) ";
            } else if (cmdparam.optType == "onEdit") {
                //订单数量 - 累计送货报检量 + 本订单原送货数量 = 当前还可以送货的数量
                sql = "select c.iid,round(c.fquantity - (isnull(c.fwoquantity,0)-ISNULL(a.fquantity,0)),4) noquantity " +
                        "from " +
                        " (select *  from  sc_rdrecords where irdrecord in  (select iid  from    sc_rdrecord  where iifuncregedit=350) ) " +
                        " a left join (select *  from    sc_rdrecord  where iifuncregedit=350) b on a.irdrecord = b.iid " +
                        " left join (select *  from  sc_rdrecords where irdrecord in  (select iid  from    sc_rdrecord  where iifuncregedit=348)) c " +
                        " on a.iinvoices = c.iid where b.iid = " + mainValue.iid;
            }
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var array:ArrayCollection = event.result as ArrayCollection;
                if (array.length > 0) {
                    for each(var ac:Object in array) {
                        for each(var obj:Object in sc_rdrecords) {
                            if (obj.iinvoices == ac.iid) {
                                if (obj.fquantity > ac.noquantity) {
                                    CRMtool.showAlert("产品 “" + obj.iproduct_Name + "” 本次最大归还数量是：" + ac.noquantity + "，请核实后再操作！");
                                    return;
                                }
                            }
                        }
                    }
                    saveCommandSelf.onNext();
                }
                else {
                    saveCommandSelf.onNext();
                }
            }, sql);

    }
    //维护线索中客商名称时，如果存在同名客商档案、黄页信息要能预警提示
    public function onExcute_IFun62(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainValue:Object = crmeap.getValue();
        if(mainValue.ccustomer!=null && mainValue.ccustomer!=""){
            var sql:String="select iid,'cs_customer' as cname  from cs_customer where cname ="+"'"+mainValue.ccustomer+"'";
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void {
                var sql1:String="select iid,'mr_customer' as cname  from mr_customer where cname ="+"'"+mainValue.ccustomer+"'";
                var arr:ArrayCollection = e.result as ArrayCollection;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void {
                    var arr1:ArrayCollection = e.result as ArrayCollection;
                    if (arr.length > 0) {
                        CRMtool.tipAlert1("客商档案中已存在"+mainValue.ccustomer+"的档案信息，是否继续生成商机？",null,"AFFIRM",next);
                    }
                    else if (arr1.length > 0) {
                        CRMtool.tipAlert1("黄页客商档案中已存在"+mainValue.ccustomer+"的档案信息，是否继续生成商机？",null,"AFFIRM",next);
                    }
                    else{
                        saveCommandSelf.onNext();
                    }
                },sql1);

            },sql);

        }
    }
	
	
	public function onExcute_IFun384(cmdparam:CommandParam):void {
        //原代码：活动人员录入完后保存，再修改想把“参会状态”改一下，但总提示“该参会人员已邀请，请选择其他人员”以致于如果当时未选择参会状态则无法进行修改了
		/*var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var mainValue:Object = crmeap.getValue();
		if(cmdparam.optType == "onNew"){
			var sql:String="select  count(*) num from mr_markets where iinvoice="+mainValue.iinvoice+" and icustomer="+mainValue.icustomer+" and ccustperson='"+mainValue.ccustperson+"';";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void {
				var arr1:ArrayCollection = e.result as ArrayCollection;
				if(arr1[0].num>0){
					CRMtool.tipAlert1("该客商的客商人员已经邀请，请选择邀请其他人员");
					return;
				} else{
					saveCommandSelf.onNext();
				}
			},sql);
		}else{
			saveCommandSelf.onNext();
		}*/
        /**
         * LKH 20160226 修改
         */
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var mainValue:Object = crmeap.getValue();

        saveCommandSelf.onNext();
		
	}
	
	//SZC Add 20150320如果加密狗号不为空，数量为1； 合同
	public function modifyCSN(cmdparam:CommandParam):Boolean {
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var myValue:Object = crmeap.getValue();
		var sc_orders:ArrayCollection=myValue.sc_orders;
		var flag:Boolean=false;
		for(var i:int=0;i<sc_orders.length;i++){
			if(sc_orders[i].csn!=null &&  sc_orders[i].csn!=""){
				if(sc_orders[i].fquantity!=1){
					CRMtool.showAlert("数量大于1了，一个加密狗号只能对应一个产品！");
					flag=true;
					break;
				}else{
					flag=false;
				}
			}else{
				flag=false;
			}
		}
		return  flag;
	}
	
	//SZC Add 20150320如果加密狗号不为空，数量为1； 入库
	public function modifyCSNRdrecord(cmdparam:CommandParam):Boolean {
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var myValue:Object = crmeap.getValue();
		var sc_rdrecords:ArrayCollection=myValue.sc_rdrecords;
		var flag:Boolean=false;
		for(var i:int=0;i<sc_rdrecords.length;i++){
			if(sc_rdrecords[i].csn!=null &&  sc_rdrecords[i].csn!=""){
				if(sc_rdrecords[i].fquantity!=1){
					CRMtool.showAlert("数量大于1了，一个加密狗号只能对应一个产品！");
					flag=true;
					break;
				}else{
					flag=false;
				}
			}else{
				flag=false;
			}
		}
		return  flag;
	}
    private function next():void
    {
        saveCommandSelf.onNext();
    }

    /**
     * LC   ADD 20160307    产品配置保存前查询列表内是否有同一产品信息
     * @param cmdparam
     */
    public function onExcute_IFun213(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();
        var types:CommandParam = this.saveCommandSelf.cmdparam as CommandParam;
        var type:String = types.optType;
        if (type == "onEdit") {
            saveCommandSelf.onNext();
        } else {
            if (myValue && myValue.iproduct != null) {
                var sql:String = "select COUNT(*)ccount from sc_bom sb left join sc_product sp on sb.iproduct=sp.iid where sb.iproduct = " + myValue.iproduct;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                    var ac:ArrayCollection = event.result as ArrayCollection;
                    if (ac[0].ccount > 0) {
                        CRMtool.showAlert("此产品配置已存在,请重新选择产品编码!");
                        return;
                    }
                    saveCommandSelf.onNext();
                }, sql);
            }
        }
    }

    /**
     * LC   ADD 2017年7月29日    九江二开，合同保存前判断小写金额与大写金额是否一致
     * @param cmdparam
     */
    public function onExcute_IFun497(cmdparam:CommandParam):void {
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();
        var fsum1:String = myValue.fsum1;
        var fsum2:String = myValue.fsum2;
        var fsum:String = myValue.fsum;
        if(CRMtool.isStringNotNull(fsum1)){
            var sql:String = "SELECT DBO.TOUPPERCASERMB("+fsum1+") bigsum";
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var ac:ArrayCollection = event.result as ArrayCollection;
                if (ac.length > 0) {
                    myValue.cbigsum1= ac[0].bigsum;
                    myValue.mainValue = myValue;
                    crmeap.setValue(myValue, 1, 1);
                }
            }, sql);
        }
        if(CRMtool.isStringNotNull(fsum2)){
            var sql:String = "SELECT DBO.TOUPPERCASERMB("+fsum2+") bigsum";
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var ac:ArrayCollection = event.result as ArrayCollection;
                if (ac.length > 0) {
                    myValue.cbigsum2= ac[0].bigsum;
                    myValue.mainValue = myValue;
                    crmeap.setValue(myValue, 1, 1);
                }
            }, sql);
        }
        if(CRMtool.isStringNotNull(fsum)){
            var sql:String = "SELECT DBO.TOUPPERCASERMB("+fsum+") bigsum";
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var ac:ArrayCollection = event.result as ArrayCollection;
                if (ac.length > 0) {
                    myValue.cbigsum= ac[0].bigsum;
                    myValue.mainValue = myValue;
                    crmeap.setValue(myValue, 1, 1);
                }
            }, sql);
        }

        saveCommandSelf.onNext();
    }

    }//括号到此为止，上面自己添加的方法，括号应该闭合了。
}