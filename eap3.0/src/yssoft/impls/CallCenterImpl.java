package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.ICallCenterService;

import java.util.HashMap;
import java.util.List;

public class CallCenterImpl extends BaseDao implements ICallCenterService {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public List<?> getcallinfos(HashMap<?, ?> param) {
		return this.queryForList("cc.getcallinfos",param);
	}

	@Override
	public HashMap<?, ?> getsinglecallinfo(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return (HashMap<?, ?>) this.queryForObject("cc.getsinglecallinfo",param);
	}

	@Override
	public List<?> getnowworkorder(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return this.queryForList("cc.getnowworkorder",param);
	}

	@Override
	public List<?> getassets(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return this.queryForList("cc.getassets", param);
	}

	@Override
	public List<?> getactivity(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return this.queryForList("cc.getactivity", param);
	}

	@Override
	public List<?> gethisotryworkorder(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return this.queryForList("cc.gethisotryworkorder", param);
	}

	@Override
	public List<?> gethistoryhotline(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return this.queryForList("cc.gethistoryhotline", param);
	}
	
	@Override
	public List<?> getReceivable(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return this.queryForList("cc.getReceivable", param);
	}

    @Override
    public List<?> getHistoryPaidRecord(HashMap<?, ?> param) {
        // TODO Auto-generated method stub
        return this.queryForList("gethistoryPaidRecord", param);
    }

    //获得当前呼叫中心记录 生成的服务工单
	public List<?> getSrbilloniinvoice(HashMap<?,?> param){
		return this.queryForList("cc.getSrbilloniinvoice", param);
	}

	//获得工单状态
	public List<?> getistatus(HashMap<?,?> param){
		return this.queryForList("cc.getistatus", param);
	}
	
	//获得工单状态
	public List<?> getccode(HashMap<?,?> param){
		return this.queryForList("cc.getccode", param);
	}
	
	//获得客商人员
	public List<?> getcusperson(HashMap<?,?> param){
		return this.queryForList("cc.getcusperson", param);
	}
	
	/*
	 * YJ Modify 2012-04-17
	 * @see yssoft.services.ICallCenterService#updatecustperson(java.util.HashMap)
	 */
	@SuppressWarnings({ "rawtypes", "unused", "unchecked" })
	@Override
	public HashMap<?,?> updatecustperson(HashMap param) {
		// TODO Auto-generated method stub
		HashMap<String,Object> rhm = new HashMap<String,Object>();
		HashMap<String,Object> nhm = new HashMap<String,Object>();
		HashMap<String,Object> phm = new HashMap<String,Object>();
		List plist = null;//客商联系人档案列表
		String str = "";
		String strsql = "";

		try{
			String pname 		= param.get("cname")+"";//客商联系人姓名
			String ctel		 	= param.get("ctel")+"".trim();//客商联系人联系电话
			int imaker			= Integer.parseInt(param.get("imaker")+"");//制单人
			int idepartment		= Integer.parseInt(param.get("idepartment")+"");//制单人所属的部门

			int icustomer 		= Integer.parseInt(param.get("icustomer")+"");//客商

			//分析该人员是否存在
			plist = this.onGetPersonNumber(icustomer, pname);

			int number = plist.size();

			if(number >1) return (HashMap<?, ?>) rhm.put("rvalue", "人员信息重复，无法更新人员档案！");

			if(number == 0){//新增一条客商联系人档案

				//客商联系人编码
				String ccode = "";
				param.put("ccode", ccode);			

				Object obj = this.insert("cc.insertCusPerson", param);
				int iid = Integer.parseInt(obj.toString());//客商联系人内码

				//插入客商联系人权限
				strsql = "insert into ab_invoiceuser(ifuncregedit,iinvoice,idepartment,iperson,irole) values(45,"+iid+","+idepartment+","+imaker+",1)";
				phm.put("sqlValue", strsql);
				this.queryForList("cc.onSearch", phm);

				str = "增加一条人员档案！";
				rhm.put("newcustpersoniid",iid);
			}
			else{//更新客商联系人档案

				nhm = (HashMap)plist.get(0);
				String ptel = nhm.get("ctel")+"".trim();
				int iid		= Integer.parseInt(nhm.get("iid")+"");//客商联系人内码
				String newtel = "";//承载新的联系方式

				//分析联系方式是否一致
				String[] mtel=ptel.split(",");
				if (((String)mtel[0]).equals("null"))
				{
						newtel = ctel;
						param.put("ctel", newtel);
				}
				else
				{
					boolean find=false;
					for (int i = 0; i < mtel.length; i++) {
						if (ctel.equals(mtel[i]))
						{
							find=true;
							break;
						}
					}
					if (!find)
					{
						newtel = ptel+","+ctel;
						param.put("ctel", newtel);
					}
				}

				param.put("iid", iid);
				this.update("cc.updatecustperson", param);
				str = "更新当前人员档案！";

			}
			rhm.put("rvalue", "操作完成，已经成功"+str);
		}catch(Exception ex){
			ex.printStackTrace();
			rhm.put("rvalue", "");
		}
		return rhm;
	}

	public void updateSrProjectsArr(HashMap param) {
		this.update("updateSrProjectsArr", param);
	}
	
	public void updateSrProjectsLea(HashMap param) {
		this.update("updateSrProjectsLea", param);
	}
	
	public void updatesolution(HashMap param) {
		this.update("cc.updatesolution", param);
	}

	public String saveMoment(HashMap param) {
		try{
			this.update("cc.savemoment", param);
			return "sucess";
		}catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		
	}
	@Override
	public void updatearrivaldate(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		this.update("cc.updatearrivaldate", param);
	}

	@Override
	public void updatedeparturedate(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		this.update("cc.updatedeparturedate", param);
	}

	@Override
	public void updateiengineer(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		this.update("cc.updateiengineer", param);
	}

	@Override
	public int countCcode(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return (Integer)this.queryForObject("cc.countCcode", param);
	}

	@Override
	public void updateCcode(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		this.update("dd.updateCcode", param);
	}
	
	//变更呼叫中心记录的状态
	public void updateCallcenterIsolution(HashMap <?,?> param){
		this.update("cc.updateCallcenterIsolution", param);
	}

	@Override
	public int countSrRequest(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return (Integer)this.queryForObject("cc.countSrRequest", param);
	}

	@Override
	public int insertSrRequest(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return (Integer) this.insert("cc.insertSrRequest",param);
	}

	@Override
	public void insertSrBill(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		this.insert("cc.insertSrBill", param);
	}

	@Override
	public void deleteService(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		this.delete("cc.deleteService", param);
	}

	@Override
	public void insertSaClue(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		this.insert("cc.insertSaCule", param);
	}

	@Override
	public int countSaCule(HashMap<?, ?> param) {
		// TODO Auto-generated method stub
		return (Integer) this.insert("cc.countSaCule", param);
	}
	
	
	/**
	 * 获取客商对应的联系人有几个
	 * @param icustomer
	 * @param pname
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	protected List onGetPersonNumber(int icustomer,String pname)
	{
		String strsql = "";
		List list = null;
		HashMap<String,Object> phm = new HashMap<String,Object>();
		
		try{
			
			strsql = "select * from cs_custperson where icustomer="+icustomer+" and cname='"+pname+"'";
			phm.put("sqlValue", strsql);
			list = this.queryForList("cc.onSearch", phm);
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		return list;
	}

	public List<?> getCallcenterForProjects(HashMap<?,?> param){
		return this.queryForList("getCallcenterForProjects", param);
	}
    public List getPersonCtel(HashMap param){
        return  this.queryForList("getoersontel",param);
    }
}
