/**
 * Created with IntelliJ IDEA.
 * User: aruis
 * Date: 13-4-24
 * Time: 上午11:57
 * To change this template use File | Settings | File Templates.
 */
package yssoft.frameui.moreMenu {
import mx.rpc.events.ResultEvent;

import yssoft.frameui.TreeFormView;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

public class TreeFormMoreMenu {
    private var t:TreeFormView;

    public function TreeFormMoreMenu(t:TreeFormView) {
        this.t = t;
    }

    public function syncData():void {
        var sql:String = "update cs_customer set iareaperson=cs_customerarea.ihead from cs_customer,cs_customerarea  " +
                "where cs_customer.icustarea=cs_customerarea.iid "
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
            CRMtool.showAlert("同步成功。");
        }, sql);
    }

    public function resetdata():void {
        var iid:int = t.crmeap.getValue().iid;
        if(iid>0)
            AccessUtil.remoteCallJava("as_dataauthViewDest", "update_initdata", function(e:ResultEvent):void{
                if (e.result.toString() == "sucess") {
                    CRMtool.showAlert("重置数据权限分配成功。");
                }else{
                    CRMtool.showAlert("重置数据权限分配失败。");
                }
            }, iid, null, false);
    }
}
}
