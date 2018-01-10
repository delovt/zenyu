package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IChecksalesService;

import java.util.HashMap;
import java.util.List;

public class CheckSalesServiceImpl extends BaseDao  implements IChecksalesService {

	@Override
	public List<HashMap> getOrderAndPlanInfoByIcustomer(int icustomer) throws Exception {
		return this.queryForList("getOrderAndPlanInfoByIcustomer",icustomer);
	}

	@Override
	public Object insert_Sc_ctrpclose(HashMap paramObj) throws Exception {
		return this.insert("insert_Sc_ctrpclose", paramObj);
	}

    @Override
    public Object insert_sc_orderapportions(HashMap paramObj) throws Exception {
        return this.insert("insert_sc_orderapportions", paramObj);
    }

	@Override
	public int update_Sc_orderrpplan(HashMap paramObj) throws Exception {
		return this.update("update_Sc_orderrpplan",paramObj);
	}

	@Override
	public int delete_Sc_ctrpcloseByiid(int iid) throws Exception {
		return this.delete("delete_Sc_ctrpcloseByiid",iid);
	}

    @Override
    public int delete_sc_orderapportionsByictrpclose(int iid) throws Exception {
        return this.delete("delete_sc_orderapportionsByictrpclose",iid);
    }

	@Override
	public int update_Sc_order(HashMap paramObj) throws Exception {
		return this.update("update_Sc_order",paramObj);
	}
	
	@Override
	public int update_Sc_order2(HashMap paramObj) throws Exception {
		return this.update("update_Sc_order2",paramObj);
	}

	@Override
	public int update_sc_rpinvoice(HashMap paramObj) throws Exception {
		return this.update("update_sc_rpinvoice",paramObj);
	}

}
