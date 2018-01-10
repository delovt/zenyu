package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface IChecksalesService {
	public List<HashMap> getOrderAndPlanInfoByIcustomer(int icustomer) throws Exception;
	public Object insert_Sc_ctrpclose(HashMap paramObj)throws Exception;
    public Object insert_sc_orderapportions(HashMap paramObj)throws Exception;

	public int update_Sc_orderrpplan(HashMap paramObj)throws Exception;
	public int update_Sc_order(HashMap paramObj)throws Exception;
	public int update_Sc_order2(HashMap paramObj)throws Exception;
	
	public int update_sc_rpinvoice(HashMap paramObj)throws Exception;
	public int delete_Sc_ctrpcloseByiid(int iid)throws Exception;

    public int delete_sc_orderapportionsByictrpclose(int ictrpclose)throws Exception;
}
