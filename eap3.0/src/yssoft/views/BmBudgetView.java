package yssoft.views;

import yssoft.services.IBmBudgetService;
import yssoft.services.IBmBudgetsService;
import yssoft.services.IBmItemService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.BmBudgetVo;
import yssoft.vos.BmBudgetsVo;
import yssoft.vos.BmInterimVo;
import yssoft.vos.BmItemVo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * 资金预算
 * @author sdy
 *
 */
public class BmBudgetView {
	
	private IBmItemService ibmItem;
	private IBmBudgetService ibmBudget;
	private IBmBudgetsService ibmBudgets;
	
	public void setIbmItem(IBmItemService ibmItem) {
		this.ibmItem = ibmItem;
	}
	public void setIbmBudget(IBmBudgetService ibmBudget) {
		this.ibmBudget = ibmBudget;
	}
	public void setIbmBudgets(IBmBudgetsService ibmBudgets) {
		this.ibmBudgets = ibmBudgets; 
	}
	
	
	/**
	 * 项目列表 
	 * @return
	 */
	public String getBmItemList(){
		String result = ToXMLUtil.createTree(  ibmItem.getBmItemList(), "iid","ipid","-1");
		return result;
	}
	
	public HashMap addBmItem(BmItemVo item){
		String flag = "success";
		String iid = "";
		HashMap hm = new HashMap();
		try {
			 iid = ibmItem.addBmItem(item);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		 hm.put("flag",flag);
		 hm.put("iid",iid);
		return hm;
	}
	
	public String updateBmItem(BmItemVo item){
		String flag = "success";
		try {
			ibmItem.updateBmItem(item);
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return flag;
	} 
	
	public String DelBmItem(BmItemVo item){
		String flag = "success";
		try {
			String iid = item.getIid()+"";
			ibmItem.delBmItem(iid);
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return flag;
	} 
	
	@SuppressWarnings("unchecked")
	public HashMap getChildNodeItem(String ipid){
		HashMap hm = new HashMap();
		String flag = "success";
		List list = new ArrayList();
		try {
			list = ibmItem.getChildNodeItem(ipid);
		} catch (Exception e) {
			e.printStackTrace();
			 flag = "fail";
		}
		 hm.put("flag",flag);
		 hm.put("list",list);
		 return hm;
	}
	
	

	/**
	 * 获取Cname
	 * @param iid
	 * @return
	 */
	public String get_cname_bmitem(int iid){
		  try {
			  String cname =ibmItem.get_cname_bmitem(iid);
			  if( cname.equals("null") ){ return ""; }
			return cname;
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
	
	
	/**
	 * 项目主表
	 */
	public HashMap addBmBudget(BmBudgetVo budget){
		HashMap hm = new HashMap();
		String flag = "success";
		try {
		  String iid =	ibmBudget.addBudget(budget);
		  hm.put("iid",iid);
		} catch (Exception e) {
			e.printStackTrace();
			flag= "fail";
		}
		
		hm.put("flag",flag);
		return hm;
	}
	
	public String updateBmBudget(BmBudgetVo budget){
		String flag = "success";
		try {
			ibmBudget.updateBudget(budget);
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return flag;
	}
	
	public String delBmBudget(HashMap param){
		String flag = "success";
		try {
			ibmBudget.delBudget(param);
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return flag;
	}
	
	/**
	 * 项目子表
	 */
	@SuppressWarnings("unchecked")
	public String addBmBudgets(HashMap params){
		return 	excuteMethod(params,"add");
	}
	
	
	
	/**
	 * 更新预算子表
	 * @param Budgets
	 * @return
	 */
	public String updateBmBudgets(HashMap params){
		return excuteMethod(params,"update");
	}
	
	
	
	/**
	 * 获取预算数据细类
	 * @param param(Y轴 百分比、预算主表ID)
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public HashMap getBmBudgetsList(HashMap param){
		HashMap sqlParam = new HashMap();
		sqlParam.put("ibudget",param.get("iid"));
		List<HashMap>  list = ibmBudgets.getBudgetsList(sqlParam);
		
		List<String[]>  list_1 = new ArrayList<String[]>();
		BmInterimVo interimVo = new BmInterimVo();		
		String[] percentArr = (param.get("cproportions")+"").split(",");  //纵向百分比数组
		List resultList = new ArrayList(); 		//String department  ;  //部门 
		
		int counter = 0;
		String [] arr =new String[15];
		for(int i =0; i< list.size(); i++)
		{	
			arr[i] = list.get(i).get("fsum")+"";
			
			if(null != arr[11] ) //已加载满12月数值
			{	
				arr[12]  = list.get(i).get("iitems")+"";    //获取项目iid
				arr[13]  = percentArr[counter++];   //当前纵向百分比
				arr[14]  = list.get(i).get("idepartment")+""; //获取部门
				list_1.add(arr);
				arr =new String[15];
				i= -1;
				for(int j=0;j<12;j++){  //将本行的12月数值删除
					list.remove(0);
				}
			}
		}
		
		for (String[] str_arr : list_1) {
			interimVo.setDf_1_0(str_arr[0]);
			interimVo.setDf_1_1(str_arr[1]);
			interimVo.setDf_1_2(str_arr[2]);
			interimVo.setDf_1_sum(interimVo.getDf_1_sum());
			
			interimVo.setDf_2_0(str_arr[3]);
			interimVo.setDf_2_1(str_arr[4]);
			interimVo.setDf_2_2(str_arr[5]);
			interimVo.setDf_2_sum(interimVo.getDf_2_sum());
			
			interimVo.setDf_3_0(str_arr[6]);
			interimVo.setDf_3_1(str_arr[7]);
			interimVo.setDf_3_2(str_arr[8]);
			interimVo.setDf_3_sum(interimVo.getDf_3_sum());
			
			interimVo.setDf_4_0(str_arr[9]);
			interimVo.setDf_4_1(str_arr[10]);
			interimVo.setDf_4_2(str_arr[11]);
			interimVo.setDf_4_sum(interimVo.getDf_4_sum());
			
			interimVo.setDf_sum(interimVo.getDf_sum());

			interimVo.setProjectName(str_arr[12]);
			interimVo.setPercent(str_arr[13]);
			interimVo.setDepartment(str_arr[14]);
			resultList.add(interimVo);
			interimVo = new BmInterimVo();
		}
		param.put("list",resultList);
		return param;
	
	} 
	
	/**
	 * 删除子表
	 * @param params 主表IID
	 * @return
	 */
	public String delBmBudgets(HashMap params){
			
		String flag = "success";
		try {
			int ibudget =Integer.parseInt(params.get("ibudget")+"");
			ibmBudgets.deleteBudgets(ibudget);
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return flag;
	}
	
	
	
	/** 
	 *  新增(主表，子表)<br/>
	 *  更新(删除原子表纪录<重新新增>，更新主表) 
	 * 
	 * */
	@SuppressWarnings("unchecked")
	public String excuteMethod(HashMap params,String method){
		try {
			List<HashMap> paramList =  (List<HashMap>)params.get("budgetArr");
			List<List<BmBudgetsVo>> newList = new ArrayList<List<BmBudgetsVo>>();
			HashMap budget_map = (HashMap)params.get("budget");
			
			int ibudget = 0 ; //子表父类IID
			if(method.equals("add")){
				String iid =this.addBmBudget(getBudgetVo(budget_map)).get("iid")+"";   //执行新增主表，并获取最新IID
				 ibudget = Integer.parseInt(iid);
			}else if(method.equals("update")){
				this.updateBmBudget(getBudgetVo(budget_map));//更新主表
				ibudget = Integer.parseInt(budget_map.get("iid").toString()); 	
			}
			
			for(int i=0; i < paramList.size(); i++){
				HashMap map  = paramList.get(i);
				String [] dfName = new String[]{"df_1_0","df_1_1","df_1_2","df_2_0","df_2_1","df_2_2","df_3_0","df_3_1","df_3_2","df_4_0","df_4_1","df_4_2"};
				newList.add( getBudgetsList(map,dfName,ibudget) );
			}
			
			boolean delFlag = true;
			
			for (List<BmBudgetsVo> list : newList) {
				for (BmBudgetsVo bmBudgetsVo : list) {
					if(method.equals("add")){
						ibmBudgets.addBudgets(bmBudgetsVo); 	//新增
					}else{
						if(delFlag){ 
							ibmBudgets.deleteBudgets(ibudget);   //删除 
							delFlag = false;
						}
						ibmBudgets.addBudgets(bmBudgetsVo); 	//新增
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return "success";
	}
	
	
@SuppressWarnings("unchecked")
private List<BmBudgetsVo> getBudgetsList(HashMap map,String[] dfName,int ibudget){
		
		List<BmBudgetsVo> budgets_list = new ArrayList<BmBudgetsVo>();      	//子表对象集合
		BmBudgetsVo budgets = null;
		for(int i =1; i <= dfName.length;i++){
			budgets = new BmBudgetsVo();
			budgets.setFsum(Double.parseDouble(map.get(dfName[i-1]).toString()));
			budgets.setIbudget(ibudget);     
			
			budgets.setIdepartment(Integer.parseInt(map.get("department").toString()));
			
			if(null != map.get("projectName") ){
				budgets.setIitems(Integer.parseInt(map.get("projectName").toString()));
			}else{
				budgets.setIitems(Integer.parseInt("0")); //加入项目对应IID
			}
				
			budgets.setImonth(i);  
			budgets_list.add(budgets);
		}
		return budgets_list;
	}
	
	private BmBudgetVo getBudgetVo(HashMap map){
		BmBudgetVo classvo = new BmBudgetVo();
			if(map.get("bdetail").toString().equals("false")){
				classvo.setBdetail(Integer.parseInt("0"));
			}else classvo.setBdetail(Integer.parseInt("1"));
			classvo.setCcode(map.get("ccode")+"");
			classvo.setCmemo(map.get("cmemo")+"");
			classvo.setCname(map.get("cname")+"");
			classvo.setCproportion(map.get("cproportion")+"");
			classvo.setCproportions(map.get("cproportions")+"");
			classvo.setCversion(map.get("cversion")+"");
			classvo.setFsum(Float.parseFloat(map.get("fsum")+""));
			classvo.setIid(Integer.parseInt(map.get("iid")+""));
			classvo.setIitem(Integer.parseInt(map.get("iitem")+""));
			classvo.setIorganization(Integer.parseInt(map.get("iorganization")+""));
			classvo.setIstatus(Integer.parseInt(map.get("istatus")+""));
			classvo.setIyear(Integer.parseInt(map.get("iyear")+""));
		return classvo;
	}
	
//	@SuppressWarnings("unchecked")
//	public HashMap<String,String> parseVoConvertHashMap(Object obj){
//		Class c = obj.getClass() ;
//		HashMap<String,String> map = new HashMap<String,String>();
//		for(int i=0; i < c.getDeclaredFields().length; i++ ){
//			map.put(c.getDeclaredFields()[i].getName(),"");
//		}
//		return map;
//	}
	
}


