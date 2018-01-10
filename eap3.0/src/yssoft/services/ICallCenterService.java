package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface ICallCenterService {
	public List<?> getcallinfos(HashMap<?, ?> param);
	public HashMap<?,?> getsinglecallinfo(HashMap<?, ?> param);
	public List<?> getnowworkorder(HashMap<?,?> param);
	public List<?> getassets(HashMap<?,?> param);
	public List<?> getactivity(HashMap<?,?> param);
	public List<?> gethisotryworkorder(HashMap<?,?> param);
	public List<?> gethistoryhotline(HashMap<?,?> param);
	public List<?> getReceivable(HashMap<?,?> param);
    public List<?> getHistoryPaidRecord(HashMap<?,?> param);
	
	public List<?> getistatus(HashMap<?,?> param);
	public List<?> getccode(HashMap<?,?> param);
	
	public List<?> getCallcenterForProjects(HashMap<?,?> param);

    public List getPersonCtel(HashMap param);
	public List<?> getcusperson(HashMap<?,?> param);
	
	//获得当前呼叫中心记录 生成的服务工单
	public List<?> getSrbilloniinvoice(HashMap<?,?> param);
	
	//更新联系人
	@SuppressWarnings("rawtypes")
	public HashMap updatecustperson(HashMap<?,?> param);
	
	//呼叫中心暂存
	public String saveMoment(HashMap param);
	//更新到达时间
	public void updatearrivaldate(HashMap<?,?> param);
	//更新离开时间
	public void updatedeparturedate(HashMap<?,?> param);
	
	//变更工程师
	public void updateiengineer(HashMap <?,?> param);
	
	
	//更新实施日志相关
	public void updateSrProjectsArr(HashMap param);
	
	public void updateSrProjectsLea(HashMap param);
	
	//变更呼叫中心记录的状态
	public void updateCallcenterIsolution(HashMap <?,?> param);
	
	// 验证单号 是否唯一
	public int countCcode(HashMap <?,?> param);
	// 变更单号
	public void updateCcode(HashMap <?,?> param);
	//更新处理方式
	public void updatesolution(HashMap<?,?> param);
	
	//----------------------生成单据 处理------------------
	
	// 验证单据
	public int countSrRequest(HashMap<?,?> param);
	// 验证通过 就生成单据
	public int insertSrRequest(HashMap <?,?> param);
	//
	public void insertSrBill(HashMap <?,?> param);
	
	
	// 删除 单据 
	public void deleteService(HashMap<?,?> param);
	
	// 验证相关的 线索 是不是 已经生成了
	public int countSaCule(HashMap<?,?> param);
	
	// 生成线索
	
	public void insertSaClue(HashMap<?,?> param);
	
	// 生成协同
	//public void 
	
	
	
	
	
}
