package yssoft.views;

import yssoft.services.IExplorerService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class ExplorerView {
	private IExplorerService iExplorer;

	public void setiExplorer(IExplorerService iExplorer) {
		this.iExplorer = iExplorer;
	}
	
	public List<?> getDesktopList(HashMap<?, ?> params){
		return this.iExplorer.getDesktopList(params);
	}
	public List<?> getDetailDesktopList(HashMap<?, ?> params){
		return this.iExplorer.getDetailDesktopList(params);
	}
	public int insertDesktopItem(HashMap<?, ?> params){
		return this.iExplorer.insertDesktopItem(params);
	}
	public void deleteDesktopItem(HashMap<?, ?> params){
		this.iExplorer.deleteDesktopItem(params);
	}
	public void updateDesktopItem(HashMap<?, ?> params){
		this.iExplorer.updateDesktopItem(params);
	}
	
	
	public int insertDesktopsItem(HashMap<?, ?> params){
		return this.iExplorer.insertDesktopsItem(params);
	}
	public void deleteDesktopsItem(HashMap<?, ?> params){
		this.iExplorer.deleteDesktopsItem(params);
	}
	public void updateDesktopsItem(HashMap<?, ?> params){
		this.iExplorer.updateDesktopsItem(params);
	}
	
	
	// 获取桌面屏幕，屏幕对应详细配置
	public HashMap<?, ?> getExplorerInfo(HashMap<?,?> params){
		HashMap<Object, Object> ret = new HashMap<Object, Object>();
		List<?> explorer = this.getDesktopList(params);
		if(explorer == null || explorer.size()==0){
			ret.put("error","没有创建桌面屏幕");
			return ret;
		}
		List<?> detail= this.getDetailDesktopList(params);
		ret.put("pm",explorer);
		ret.put("detail",detail);
		return ret;
	}
	
	// 保存 屏幕 对应的设置
	public boolean saveDesktopPro(List<HashMap<?, ?>> list){
		if(list==null || list.size()<1){
			return false;
		}

		try{
			this.deleteDesktopItem(list.get(0));
			for (HashMap<?, ?> h : list){
				int retid=this.insertDesktopItem(h);
				List<HashMap<?, ?>> desktopsList = (List<HashMap<?, ?>>) h.get("desktopsList");
				for (HashMap desktops : desktopsList){
					desktops.put("idesktop", retid);
					this.insertDesktopsItem(desktops);
				}
			}
			return true;

		}catch (Exception e) {
			return false;
		}
	}

	// 保存 屏幕 对应的设置
	public Object saveData(List<?> list){
		
		if(list==null || list.size()<=1){
			return "数据格式错误";
		}
		// 最后一项是屏幕设置参数
		HashMap<?, ?> pm = (HashMap<?, ?>) list.get(list.size()-1);
		ArrayList retlist = new ArrayList();
		int pmiid=0;
		try{
			
		if("1".equals(pm.get("opttype")) || pm.get("iid") == null || "0".equals(pm.get("iid"))){ // 新增
			pmiid=this.insertDesktopItem(pm);
			if(pmiid <=0){
				return "新增屏幕错误";
			}
			returnData(retlist,"pm","",pmiid);
			for(int i=0;i<list.size()-1;i++){
				HashMap param = (HashMap) list.get(i);
				param.put("idesktop",pmiid);
				int retid=this.insertDesktopsItem(param);
				returnData(retlist,"sc",(String)param.get("flagid"),retid);
			}
		}else{
			//更新屏幕 参数
			this.updateDesktopItem(pm);
			
			for(int i=0;i<list.size()-1;i++){
				HashMap param = (HashMap) list.get(i);
				int retid=this.insertDesktopsItem(param);
				returnData(retlist,"sc",(String)param.get("flagid"),retid);
			}
		}
			return retlist;
		}catch(Exception e){
			return "数据插入失败";
		}
	}
	
	// 拼接返回数据
	private List<?> returnData(ArrayList list,String type,String flagid,int iid){
		HashMap hm = new HashMap();
		hm.put("type",type);
		hm.put("flagid",flagid);
		hm.put("iid",iid);
		list.add(hm);
		return list;
	}
	
	
	// 删除 shortcut
	public String onDeleteShortcut(HashMap<?, ?> params){
		try{
			this.deleteDesktopsItem(params);
			return "suc";
		}catch(Exception e){
			e.printStackTrace();
			return "error";
		}
		
	}
	
	
	
	
	
	
	
	
	
	
}
