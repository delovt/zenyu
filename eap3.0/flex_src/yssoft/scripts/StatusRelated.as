/**
 * Created with IntelliJ IDEA.
 *  状态注入
 */
package yssoft.scripts {
import flash.events.Event;
import mx.collections.ArrayCollection;
import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.tools.AccessUtil;

public class StatusRelated {
    public function StatusRelated() {
    }
    public function doStatusAfter(crmeap:CrmEapRadianVbox,winParam:Object,formIstatus:int, formIfunIid:int) {
        if (crmeap != null && this.hasOwnProperty("after_"+winParam.ctable+"_"+crmeap.formIfunIid )) {
            this["after_"+winParam.ctable+"_"+crmeap.formIfunIid ](crmeap,winParam,formIstatus,formIfunIid );
        }
    }
// wxh 事例
//    public function after_sc_arrival_599(crmeap:CrmEapRadianVbox,winParam:Object,formIstatus:int, formIfunIid:int):void{
//        var obj:Object = crmeap.getValue();
//        if(formIstatus == 20 || formIstatus == 19 ){
//            var updateSql:String  ="begin update sc_arrival set binrdrecord = 0 where iid =  " + obj.iid+
//                    " update  sc_arrivals set fquantity = 0,carrive = '' where iarrival =  "+obj.iid +" end ";
//            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:Event):void{
//                var sc_arrivals:ArrayCollection =  obj.sc_arrivals as ArrayCollection;
//                var sql:String = "";
//                for each(var arrival:Object in sc_arrivals ){
//                    arrival.fquantity = 0;
//                    arrival.carrive = "";
//                    sql += "update sc_poorders set farquantity = b.quan from ( "+
//                            "select a.iid,isnull(sum(b.quan),0)quan from sc_poorders a left join ( "+
//                            "select arrs.iinvoices,case when arr.istatus in (1,19) then arrs.farquantity else arrs.fquantity end quan from sc_arrival arr "+
//                            "left join sc_arrivals arrs on arr.iid = arrs.iarrival "+
//                            ")b " +
//                            "on a.iid = b.iinvoices where 1=1 group by a.iid " +
//                            ") b where sc_poorders.iid = b.iid and sc_poorders.ipoorder = " + arrival.iinvoice + ";";
//
//                    sql += "update sc_poorder set farquantity = (select SUM(farquantity) from sc_poorders where ipoorder = " + arrival.iinvoice + " ) where iid = " + arrival.iinvoice + ";";
//                }
//                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,sql);
//                obj.sc_arrivals = sc_arrivals;
//                obj.mainValue = obj;
//                crmeap.setValue(obj, 1, 1);
//            }, updateSql, null, false)
//        }
//        if(formIstatus == 21 ){
//            var updateSql2:String  =" update sc_arrivals set fqaquantity = 0,fdestructquantity = 0,iqaresult = 0 " +
//                    ",fvalidquantity = 0,fdegradequantity =0,fpickquantity = 0,frepairquantity = 0,freturnquantity = 0,iqatype=0" +
//                    ",funquantity=0,fletgo = 0,iqaperson1=0,dqa1='',cqa1='',iqaperson2=0,dqa2='',cqa2='' where iarrival =" + obj.iid;
//            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:Event):void{
//                var sc_arrivals:ArrayCollection =  obj.sc_arrivals as ArrayCollection;
//                var sql:String = "";
//                for each(var arrival:Object in sc_arrivals ){
//                    arrival.iqaresult = 0;
//                    arrival.iqaresult_Name = "";
//                    arrival.fqaquantity = 0;
//                    arrival.fdestructquantity = 0;
//                    arrival.fvalidquantity = 0;
//                    arrival.fdegradequantity = 0;
//                    arrival.fpickquantity = 0;
//                    arrival.frepairquantity = 0;
//                    arrival.freturnquantity = 0;
//                    arrival.funquantity = 0;
//                    arrival.fletgo = 0;
//                    arrival.iqaperson1 = 0;
//                    arrival.iqaperson1_Name = "";
//                    arrival.dqa1 = "";
//                    arrival.cqa1 = "";
//                    arrival.iqaperson2 = 0;
//                    arrival.iqaperson2_Name = "";
//                    arrival.dqa2 = "";
//                    arrival.cqa2 = "";
//
//                    sql += "update sc_poorders set farquantity = b.quan from ( "+
//                            "select a.iid,isnull(sum(b.quan),0)quan from sc_poorders a left join ( "+
//                            "select arrs.iinvoices,case when arr.istatus in (1,19) then arrs.farquantity else arrs.fquantity end quan from sc_arrival arr "+
//                            "left join sc_arrivals arrs on arr.iid = arrs.iarrival "+
//                            ")b " +
//                            "on a.iid = b.iinvoices where 1=1 group by a.iid " +
//                            ") b where sc_poorders.iid = b.iid and sc_poorders.ipoorder = " + arrival.iinvoice + ";";
//
//                    sql += "update sc_poorder set farquantity = (select SUM(farquantity) from sc_poorders where ipoorder = " + arrival.iinvoice + " ) where iid = " + arrival.iinvoice + ";";
//                }
//                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:Event):void{
//                    obj.sc_arrivals = sc_arrivals;
//                    obj.mainValue = obj;
//                    crmeap.setValue(obj, 1, 1);
//
//                },sql);
//
//            }, updateSql2, null, false)
//        }
//    }

}
}
