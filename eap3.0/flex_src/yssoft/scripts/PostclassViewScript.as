	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.SortField;
	import mx.events.ItemClickEvent;
	import mx.rpc.events.ResultEvent;
	
	import spark.collections.Sort;
	
	import yssoft.models.ConstsModel;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.vos.DepartmentVo;
	import yssoft.vos.JobVo;
	import yssoft.vos.PostVo;
	import yssoft.vos.PostclassVo;
	
	
	[Bindable]
	private var itemType:String=ConstsModel.ONDELETE_LABLE;
	
	private var postclassVo:PostclassVo;
	
	[Bindable]
	private var postArr:ArrayCollection=new ArrayCollection();
	
	private var removeArr:ArrayCollection = new ArrayCollection();

	[Bindable]
	public  var postclassXml:XML = null;
	
	
//窗体初始化
public function onWindowInit():void
{
	
}
//窗体打开
public function onWindowOpen():void
{
	this.tnp_ccode.text ="";
	this.tnp_cname.text ="";
	this.tnp_cmemo.text = "";
	this.tre_postclass.enabled=true;
	postArr=new ArrayCollection();
	getPostclassTreeXml();
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}
	
	
	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-09 
	 * 功能 保存后执行操作
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	private function saveTreecallBackHandler(event:ResultEvent):void
	{
		if(event.result || event.result.toString()!=ConstsModel.FAIL_LABLE)
		{
			var result:String = event.result as String;
			if(itemType ==ConstsModel.ONNEW_LABLE)
			{
				postclassVo.iid =int(Number(event.result));
				this.tre_postclass.AddTreeNode(postclassVo);
				CRMtool.tipAlert(ConstsModel.POSTCLASS_ADD_SUCCESS);
			}
			else if(itemType==ConstsModel.ONDELETE_LABLE)
			{
				this.tre_postclass.DeleteTreeNode();
				CRMtool.tipAlert(ConstsModel.POSTCLASS_REMOVE_SUCCESS);
			}
			else if(itemType==ConstsModel.ONEDIT_LABLE)
			{
				this.tre_postclass.EditTreeNode(postclassVo);
				CRMtool.tipAlert(ConstsModel.POSTCLASS_UPDATE_SUCCESS);
			}
			onGiveUp(event);
			this.tre_postclass.enabled= true;
		}
		else
		{
			CRMtool.tipAlert(ConstsModel.FAIL);
		}
	}
	
	/**
	 *
	 * 函数名：
	 * 作者：钟晶
	 * 日期：2011-08-02
	 * 功能： 检查输入字段
	 * 参数：无
	 * 返回值：无
	 * 修改记录：
	 * 
	 */
	private function checkValue():Boolean
	{
		if(this.itemType==ConstsModel.ONNEW_LABLE||(this.itemType==ConstsModel.ONEDIT_LABLE&&this.tre_postclass.selectedItem.@ccode!=this.tnp_ccode.text))
		{
			if(this.tre_postclass.isExistsCcode(this.tnp_ccode.text,ConstsModel.ROLE_CCODE_WARNMSG))
			{
				return false;
			}
		}
		
		if(CRMtool.isStringNull(this.tnp_ccode.text))
		{
			CRMtool.tipAlert(ConstsModel.DEPARTMENT_CCODE_ISNULL,this.tnp_ccode);
			return false;
		}
		else if(CRMtool.isStringNull(this.tnp_cname.text))
		{
			CRMtool.tipAlert(ConstsModel.DEPARTMENT_CNAME_ISNULL,this.tnp_cname);
			return false;
		}
		else if(!this.tre_postclass.isExistsParent(this.tnp_ccode.text,ConstsModel.ROLE_PID_WARNMSG))
		{
			return false;
		}
		return true;
	}
	
	/**
	 *
	 * 函数名：
	 * 作者：钟晶
	 * 日期：2011-08-02
	 * 功能： 封装角色值
	 * 参数：无
	 * 返回值：角色
	 * 修改记录：
	 * 
	 */
	private function getRoleItem():PostclassVo
	{
		postclassVo = new PostclassVo();
		postclassVo.ccode = this.tnp_ccode.text;
		postclassVo.cname = this.tnp_cname.text;
		postclassVo.cmemo = this.tnp_cmemo.text;
		if(this.itemType==ConstsModel.ONEDIT_LABLE)
		{
			postclassVo.iid =  int(Number(this.tre_postclass.selectedItem.@iid));
			postclassVo.oldCcode = this.tre_postclass.selectedItem.@ccode;
		}
		postclassVo.ipid = this.tre_postclass.getIpid(this.tnp_ccode.text);
		return postclassVo;
	}
	
	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-08 
	 * 功能：确定删除树
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	public function onDelete(event:Event):void
	{
		this.itemType ="onDelete";
		var ccode:String = this.tre_postclass.selectedItem.@ccode as String;
		if(this.tre_postclass.isExistsChild(this.tre_postclass.selectedItem.@ccode,ConstsModel.DEPARTMENT_ROMEVE_PID))
		{
			return;
		}
		CRMtool.tipAlert(ConstsModel.DETERMINE_HEAD+this.tre_postclass.selectedItem.@ccname+ConstsModel.POSTCLASS_TAIL,null,"AFFIRM",this,"onDeleteTree");
	}
	
	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-08 
	 * 功能：删除树
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	public function onDeleteTree():void
	{
		//lzx 删除职务体系时，同时删除职务体系下的职务
		AccessUtil.remoteCallJava("HRPostDest","removeAllPost",saveTreecallBackHandler,int(Number(this.tre_postclass.selectedItem.@iid)),ConstsModel.POSTCLASS_REMOVE_INFO);
		AccessUtil.remoteCallJava("HRPostclassDest","removePostclass",saveTreecallBackHandler,int(Number(this.tre_postclass.selectedItem.@iid)),ConstsModel.POSTCLASS_REMOVE_INFO);	
		postArr.removeAll();
	}
	
	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-09 
	 * 功能 保存节点
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	public function onSave(event:Event):void
	{
		if(!this.checkValue())
		{
			return;	
		}
		itemType = itemType;
		postclassVo = new PostclassVo();
		postclassVo = getRoleItem();
		if(itemType==ConstsModel.ONNEW_LABLE)
		{
			AccessUtil.remoteCallJava("HRPostclassDest","addPostclass",saveTreecallBackHandler,postclassVo,ConstsModel.POSTCLASS_ADD_INFO); 
		}
		else
		{
			AccessUtil.remoteCallJava("HRPostclassDest","updatePostclass",saveTreecallBackHandler,postclassVo,ConstsModel.POSTCLASS_UPDATE_INFO);
		}
	}
	
	/**
	 *
	 * 函数名：
	 * 作者：钟晶
	 * 日期：2011-08-02
	 * 功能： 实现功能
	 * 参数： event（实现哪个功能）
	 * 返回值：无
	 * 修改记录：
	 * 
	 */
	public function clickbtr(event:ItemClickEvent):void
	{
		var type:String=event.item.name;
		CRMtool.toolButtonsEnabled(this.lbr_Department,type,this.tre_postclass.treeCompsXml.length());
		if(type !=ConstsModel.ONSAVE_LABLE ){
			itemType=type;
		}
		if(type==ConstsModel.ONNEW_LABLE||type==ConstsModel.ONEDIT_LABLE)
		{
			CRMtool.containerChildsEnabled(this.myBorder,true);
		}
		else if(type== ConstsModel.ONGIVEUP_LABLE)
		{
			CRMtool.containerChildsEnabled(this.myBorder,false);
		}
	}
	
	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-08 
	 * 功能：树初始化操作
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	public function init():void
	{
		
	}
	
	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-08 
	 * 功能：新增一行记录
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	public function addNewItem():void {
		if(!this.tre_postclass.selectedItem)
		{
			CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
			return;
		}
		var postVo:PostVo = new PostVo();
		postVo.postclassName = this.tre_postclass.selectedItem.@cname;
		postVo.ipostclass = int(Number(this.tre_postclass.selectedItem.@iid));
		postArr.addItem(postVo);
	}
	
	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-08 
	 * 功能：删除一行记录
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	public function deleteItem():void
	{
		if(!this.dgrd_postclass.selectedItem)
		{
			CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
			return;
		}
		removeArr.addItem(this.dgrd_postclass.selectedItem);
		for(var i:int=0;i<this.postArr.length;i++)
		{
			if(postArr.getItemAt(i)==this.dgrd_postclass.selectedItem)
			{
				postArr.removeItemAt(i);
			}
		}
	}
	
	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-08 
	 * 功能：校验
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	public function checkJob():Boolean
	{
		var forengCode:String=null;
		var arc:ArrayCollection = new ArrayCollection();
		sortAc();
		if(postArr.length==0 && this.removeArr.length == 0)
		{
			CRMtool.tipAlert("没有要保存的记录");
			return false;
		}
		for each(var postVo:PostVo in this.postArr)
		{
			if(postVo.ccode==null)
			{
				CRMtool.tipAlert(ConstsModel.DEPARTMENT_CCODE_ISNULL);
				return false;
			}
			else if(postVo.cname==null)
			{
				CRMtool.tipAlert(ConstsModel.DEPARTMENT_CNAME_ISNULL);
				return false;
			}
			else if(postVo.ilevel==0)
			{
				CRMtool.tipAlert(ConstsModel.POST_ILEVEL_ISNULL);
				return false;
			}
			
			if(forengCode==null)
			{
				forengCode = postVo.ccode;
			}
			else
			{
				if(forengCode==postVo.ccode)
				{
					arc.addItem(postVo);
				}
				else
				{
					forengCode = postVo.ccode;
				}
			}
		}
		if(arc.length>0)
		{
			CRMtool.tipAlert(ConstsModel.ROLE_CCODE_WARNMSG);
			return false;
		}
		return true;
	}
	
	private function sortAc():void
	{
		var sort:Sort=new Sort();  
		//按照ID升序排序  
		sort.fields=[new SortField("ccode")];  
		
		this.postArr.sort=sort;  
		this.postArr.refresh();//更新  
	}
	
	public function onSaveJob():void
	{
		if(!checkJob())
		{
			return;
		}
		var obj:Object = new Object();
		obj.jobArr = this.postArr;
		obj.removeArr = this.removeArr;
		AccessUtil.remoteCallJava("HRPostclassDest","addPost",saveJobcallBackHandler,obj,ConstsModel.DEPARTMENT_REMOVE_INFO);
	}
	
	public function saveJobcallBackHandler(event:ResultEvent):void
	{
		if(event.result==null)
		{
			CRMtool.tipAlert(ConstsModel.POST_FAIL_SUCCESS);
		}
		else
		{
			CRMtool.tipAlert(ConstsModel.POST_ADD_SUCCESS);
			var addArr:ArrayCollection = event.result as ArrayCollection;
			for each(var postVo:PostVo in addArr)
			{
				for each(var post:PostVo in this.postArr)
				{
					if(post.iid==0&&post.ccode==postVo.ccode)
					{
						post.iid = postVo.iid;
					}
				}
			}
		}
	}
	
	public function postclassNameFomart(item:Object,icol:int):String
	{
		return this.tre_postclass.selectedItem.@cname;		
	}
	
	public function selectedJob():void
	{
		if(!this.tre_postclass.selectedItem)
		{
			CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
			return;
		}
		this.tnp_ccode.text=this.tre_postclass.selectedItem.@ccode;
		this.tnp_cmemo.text=this.tre_postclass.selectedItem.@cname;
		this.tnp_cname.text=this.tre_postclass.selectedItem.@cname;
		AccessUtil.remoteCallJava("HRPostclassDest","getPostVoById",selectedJobcallBackHandler,int(Number(this.tre_postclass.selectedItem.@iid))
			,ConstsModel.DEPARTMENT_REMOVE_INFO);
		dgrd_postclass.addEventListener(KeyboardEvent.KEY_DOWN,CRMtool.doKeyDown);
	}
	
	private function selectedJobcallBackHandler(event:ResultEvent):void
	{
		this.postArr = event.result as ArrayCollection;
	}






/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 查询部门
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public  function getPostclassTreeXml():void
{
	AccessUtil.remoteCallJava("HRPostclassDest","getAllPostclass",getPostclasscallBackHandler);
}

private  function getPostclasscallBackHandler(event:ResultEvent):void
{
	if(event.result!=null)
	{
		var result:String = event.result as String;
		this.tre_postclass.treeCompsXml= new XML(result);
	}
	if(this.tre_postclass.treeCompsXml==null)
	{
		CRMtool.toolButtonsEnabled(this.lbr_Department,null);
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.lbr_Department,null,this.tre_postclass.treeCompsXml.length());
	}
	CRMtool.containerChildsEnabled(this.myBorder,false);
	//回车替代TAB键
	CRMtool.setTabIndex(this.myBorder);
}


private function onGiveUp(event:Event):void
{
		this.tnp_ccode.text ="";
		this.tnp_cname.text ="";
		this.tnp_cmemo.text = "";
	
	this.itemType ="onGiveUp";
	if(null==this.tre_postclass.treeCompsXml)
	{
		CRMtool.toolButtonsEnabled(this.lbr_Department,"onGiveUp");
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.lbr_Department,"onGiveUp",this.tre_postclass.treeCompsXml.length());
	}
	CRMtool.containerChildsEnabled(this.myBorder,false);
	this.tre_postclass.enabled= true;
}

public function onNew(event:Event):void
{
	this.tnp_ccode.text ="";
	this.tnp_cname.text ="";
	this.tnp_cmemo.text = "";
	postArr=new ArrayCollection();
	this.tre_postclass.enabled=false;
	this.itemType ="onNew";
	this.tre_postclass.selectedIndex=-1;
	if(null==this.tre_postclass.treeCompsXml)
	{
		CRMtool.toolButtonsEnabled(this.lbr_Department,"onNew");
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.lbr_Department,"onNew",this.tre_postclass.treeCompsXml.length());
	}
	CRMtool.containerChildsEnabled(this.myBorder,true);
}

public function onEdit(event:Event):void
{
	if(!this.tre_postclass.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}
	this.itemType ="onEdit";
	CRMtool.toolButtonsEnabled(this.lbr_Department,"onEdit",this.tre_postclass.treeCompsXml.length());
	CRMtool.containerChildsEnabled(this.myBorder,true);
	this.tre_postclass.enabled= false;
}

