package yssoft.impls.twitterImpls;

import yssoft.daos.BaseDao;
import yssoft.services.twitterServices.ITwitterTypeService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.twitter.TwitterTypeAdminVo;
import yssoft.vos.twitter.TwitterTypeVo;

import java.util.HashMap;
import java.util.List;

public class TwitterTypeServiceImpl extends BaseDao  implements ITwitterTypeService {
	

	@Override
	public String addTwitterType(TwitterTypeVo twitterTypeVo) {
		
			String person = twitterTypeVo.getPerson();
			
			Integer iid = (Integer) this.insert("add_twitterType", twitterTypeVo) ;
			
			if(null!=person&&!"null".equals(person))
			{
				String[] array= new String[50]; 
				array=person.split(",");
				for(String personID :array)
				{ 
					TwitterTypeAdminVo twitterTypeAdminVo = new TwitterTypeAdminVo();
					twitterTypeAdminVo.setItwitterclass( iid.intValue() );
					twitterTypeAdminVo.setIperson( Integer.parseInt(personID) );
					
					this.insert("add_twitterTypeAdmin", twitterTypeAdminVo);
				}
			}
			return iid.toString();
	}

	@Override
	public void deleteTwitterType(int iid) {
		
			this.delete("delete_twitterType", iid);
			this.delete("delete_twitterTypeAdmin", iid);

	}

	@Override
	public HashMap<String,Object> getAllTwitterTypeList() {
		
		HashMap<String,Object> resultmap = new HashMap<String,Object>();
		String xmlstr = "";
		
		//获取论坛类型的数据集
		List<HashMap> treelist = this.queryForList("getAllTwitterType");
		
		if(treelist.size()==0){
			resultmap.put("treexml", null);
		}
		else{
			xmlstr =ToXMLUtil.createTree(treelist, "iid", "ipid", "-1");
			resultmap.put("treexml", xmlstr);
		}
		
		return resultmap;
		
	}

	@Override
	public void updateTwitterType(TwitterTypeVo twitterTypeVo) {
		String person = twitterTypeVo.getPerson();
		
		this.update("update_twitterType", twitterTypeVo);
		this.delete("delete_twitterTypeAdmin", twitterTypeVo.getIid());
		
		if(null!=person&&!"null".equals(person))
		{
			String[] array= new String[50]; 
			array=person.split(",");
			for(String personID :array)
			{ 
				TwitterTypeAdminVo twitterTypeAdminVo = new TwitterTypeAdminVo();
				twitterTypeAdminVo.setItwitterclass( twitterTypeVo.getIid() );
				twitterTypeAdminVo.setIperson( Integer.parseInt(personID) );
				this.insert("add_twitterTypeAdmin", twitterTypeAdminVo);
			}
		}
	}

}
