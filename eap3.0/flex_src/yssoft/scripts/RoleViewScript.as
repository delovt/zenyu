/**
 *
 * @author：zhong_jing
 * 日期：2011-8-8
 * 功能：
 * 修改记录：
 *
 */
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.models.ConstsModel;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.views.roles.AddRoleUser;
	import yssoft.vos.RoleVo;

	[Bindable]
	public var isChecked:Boolean=false;

	//选中记录
	public var seleteItems:ArrayCollection = new ArrayCollection();

	//初始化按钮值
	[Bindable]
	private var itemType:String=ConstsModel.ONDELETE_LABLE;

	//初始化按钮值
	[Bindable]
	private var roleUserArr:ArrayCollection=new ArrayCollection();

	public var roleVo:RoleVo;

	[Bindable]
	public  var treeXml:XML = null;
	

	//窗体初始化
	public function onWindowInit():void
	{
		
	}
	//窗体打开
	public function onWindowOpen():void
	{
		roleUserArr=new ArrayCollection();
		this.tnp_ccode.text ="";
		this.tnp_cname.text ="";
		this.rbtgn_buse.selectedValue="";
		this.rbtn_enabled.selected = false;
		this.rbtn_disable.selected = false;
		this.tnp_cmemo.text = "";
		this.tre_role.enabled=true;
		getRoleTree();
	}
	//窗体关闭,完成窗体的清理工作
	public function onWindowClose():void
	{
		
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
		CRMtool.toolButtonsEnabled(this.lbr_role,null,this.tre_role.treeCompsXml.length());
		CRMtool.containerChildsEnabled(this.myBorder,false);
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
			
			if(this.itemType=="onNew"||(this.itemType==ConstsModel.ONEDIT_LABLE&&this.tre_role.selectedItem.@ccode!=this.tnp_ccode.text))
			{
				if(this.tre_role.isExistsCcode(this.tnp_ccode.text,ConstsModel.ROLE_CCODE_WARNMSG))
				{
					return false;
				}
			}
			
			if(CRMtool.isStringNull(this.tnp_ccode.text))
			{
				CRMtool.tipAlert(ConstsModel.ROLE_CCODE_ISNULL,this.tnp_ccode);
				return false;
			}
			else if(CRMtool.isStringNull(this.tnp_cname.text))
			{
				CRMtool.tipAlert(ConstsModel.ROLE_CNAME_ISNULL,this.tnp_cname);
				return false;
			}
			else if(this.rbtgn_buse.selectedValue ==null)
			{
				CRMtool.tipAlert(ConstsModel.ROLE_BUSE_ISNULL,this.rbtgn_buse);
				return false;
			}
			else if(!this.tre_role.isExistsParent(this.tnp_ccode.text,ConstsModel.ROLE_PID_WARNMSG))
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
		private function getRoleItem():RoleVo
		{
			var roleVo:RoleVo = new RoleVo();
			roleVo.ccode = this.tnp_ccode.text;
			roleVo.cname = this.tnp_cname.text;
			roleVo.cmemo = this.tnp_cmemo.text;
			if(this.itemType=="onEdit")
			{
				roleVo.iid =  int(Number(this.tre_role.selectedItem.@iid));
				roleVo.oldCcode = this.tre_role.selectedItem.@ccode;
			}
			
			roleVo.buse = this.rbtgn_buse.selectedValue;
			roleVo.ipid = this.tre_role.getIpid(this.tnp_ccode.text);
			return roleVo;
		}
		
		/**
		 *
		 * 函数名：
 　　	 * 作者：钟晶
	 　　* 日期：2011-08-02
 　　	 * 功能： 树的change事件
 　　	 * 参数：无
		 * 返回值：角色
		 * 修改记录：
		 * 
		 */
		public function tre_role_changeHandler():void
		{
			this.seleteItems.removeAll();
			this.isChecked = false;
			
			if(this.tre_role.selectedItem&&this.tre_role.selectedItem!=null)
			{
				getRoleUser();
				if(String(this.tre_role.selectedItem.@buse)=="true")
				{
					this.rbtn_enabled.selected = true;
				}
				else
				{
					this.rbtn_disable.selected = true;
				}
			}
			
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
			if(!this.tre_role.selectedItem)
			{
				CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
				return;
			}
			var ccode:String = this.tre_role.selectedItem.@ccode as String;
			//as String   ccode会为null
			var iid:String = (this.tre_role.selectedItem.@iid).toString();
			/*
			 * 角色已经关联人员不允许删除  szc20150921
			 * 角色下没有人员删除时提示该角色已关联职员     LKH 20160301    修改
			*/
			var delSql:String="select count(*) num from AS_roleuser where irole="+iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var list:ArrayCollection = event.result as ArrayCollection;
                var num:String  = list.getItemAt(0)["num"];
				if (num!="0") {
					CRMtool.showAlert("该角色已经关联职员，请移除职员后在删除！");
					return;
				}
				//end
				if(iid=="1")
				{
					CRMtool.tipAlert("系统管理人员不允许删除");
					return;
				}
				//admin所在角色不允许删除
				var sql:String = "select 1 flag from as_role r,as_roleuser ru,hr_person u "+
				"where r.iid = ru.irole and ru.iperson = u.iid "+
				"and u.cname='admin' and r.iid= " + iid;
				
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					var list:ArrayCollection = event.result as ArrayCollection;
					if (list && list.length > 0) {
						CRMtool.showAlert("admin账户属于此角色，不允许删除！");
						return;
					}
					
					if(tre_role.isExistsChild(tre_role.selectedItem.@ccode,ConstsModel.ROLE_ROMEVE_PID))
					{
						return;
					}
					
					CRMtool.tipAlert1(ConstsModel.DETERMINE_HEAD+tre_role.selectedItem.@ccname+ConstsModel.DETERMINE_TAIL,null,"AFFIRM",onDeleteTree);
					
					
				} ,sql);
				
			},delSql);//szc 20150921
			//系统管理人员不允许删除
			
			
//			if(this.tre_role.isExistsChild(this.tre_role.selectedItem.@ccode,ConstsModel.ROLE_ROMEVE_PID))
//			{
//				return;
//			}
//			
//			CRMtool.tipAlert(ConstsModel.DETERMINE_HEAD+this.tre_role.selectedItem.@ccname+ConstsModel.DETERMINE_TAIL,null,"AFFIRM",this,"onDeleteTree");
		
			
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
			AccessUtil.remoteCallJava("RoleDest","removeRole",saveTreecallBackHandler,int(Number(this.tre_role.selectedItem.@iid)),ConstsModel.ROLE_REMOVE_INFO);
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
			if(event.result.toString()!="fail")
			{
				var result:String = event.result as String;
				if(itemType =="onNew")
				{
					roleVo.iid =int(Number(event.result));
					this.tre_role.AddTreeNode(roleVo);
					CRMtool.tipAlert(ConstsModel.ROLE_ADD_SUCCESS);
				}
				else if(itemType=="onDelete")
				{
					this.tre_role.DeleteTreeNode();
					roleUserArr = new ArrayCollection();
					CRMtool.tipAlert(ConstsModel.ROLE_REMOVE_SUCCESS);
				}
				else if(itemType=="onEdit")
				{
					this.tre_role.EditTreeNode(roleVo);
					CRMtool.tipAlert(ConstsModel.ROLE_UPDATE_SUCCESS);
				}
				onGiveUp(event);
			}
			else
			{
				CRMtool.tipAlert(ConstsModel.FAIL);
			}
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
			roleVo = new RoleVo();
			roleVo = getRoleItem();
			if(itemType=="onNew")
			{
				AccessUtil.remoteCallJava("RoleDest","addRole",saveTreecallBackHandler,roleVo,ConstsModel.ROLE_ADD_INFO); 
			}
			else
			{
				AccessUtil.remoteCallJava("RoleDest","updateRole",saveTreecallBackHandler,roleVo,ConstsModel.ROLE_UPDATE_INFO);
			}
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
		public function getRoleUser():void
		{
			AccessUtil.remoteCallJava("RoleDest","getRoleuserVo",getRoleUsercallBackHandler,int(Number(this.tre_role.selectedItem.@iid)),ConstsModel.ROLE_USER_GET_INFO);
		}

		private function getRoleUsercallBackHandler(event:ResultEvent):void
		{
			roleUserArr =new ArrayCollection();
			roleUserArr = event.result as ArrayCollection;
		}
		

		/**
		 * 
		 * 作者：zhong_jing
		 * 日期：2011-08-09 
		 * 功能 打开窗口
		 * 参数：无
		 * 返回值：无
		 * 修改人：
		 * 修改时间：
		 * 修改记录：
		 * 
		 */ 
		public function openRoleUserWin(event:Event):void
		{
			if(this.tre_role.selectedItem)
			{
				var addRoleUser:AddRoleUser = new AddRoleUser();
				addRoleUser.roleId = this.tre_role.selectedItem.@iid;
				addRoleUser.roleName ="所属"+ this.tre_role.selectedItem.@cname+"的人员";
				addRoleUser.width=700;
				addRoleUser.height=500;
				addRoleUser.owner = this;
				/*var mainApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
				PopUpManager.addPopUp(addRoleUser, mainApp);
				PopUpManager.centerPopUp(addRoleUser);*/
				CRMtool.openView(addRoleUser);
			}
			else
			{
				CRMtool.tipAlert("请选择要添加用户的角色");
			}
			
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
		public function addRoleUserF(addUserArr:ArrayCollection,romveUserArr:ArrayCollection):void
		{
			if(addUserArr.length>0)
			{
				this.roleUserArr.addAll(addUserArr);
			}
			
			if(romveUserArr.length>0)
			{
				for(var i:int=0;i<romveUserArr.length;i++)
				{
					for(var j:int=0;j<this.roleUserArr.length;j++)
					{
						if(romveUserArr.getItemAt(i).ccode==this.roleUserArr.getItemAt(j).ccode)
						{
							this.roleUserArr.removeItemAt(j);
							break;
						}
					}
				}
			}
		}
	
	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-09 
	 * 功能 全选
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	 public function selectAll(checkMain:Boolean):void
	 {
		 this.isChecked = checkMain;
		 
		 if(checkMain)
		 {
			 seleteItems.addAll(this.roleUserArr);
		 }
		 else
		 {
			 seleteItems.removeAll();
		 }
	 }

	/**
	 * 
	 * 作者：zhong_jing
	 * 日期：2011-08-09 
	 * 功能 单选
	 * 参数：无
	 * 返回值：无
	 * 修改人：
	 * 修改时间：
	 * 修改记录：
	 * 
	 */ 
	public function selectSingle(checkMain:Boolean,obj:Object):void
	{
		if(checkMain)
		{
			this.seleteItems.addItem(obj);
		}
		else
		{
			for(var i:int=0;i<this.seleteItems.length;i++)
			{
				if(this.seleteItems.getItemAt(i).ccode==obj.ccode)
				{
					this.seleteItems.removeItemAt(i);
				}
			}
		}
	}

	public function deleteRole():void
	{
		if(this.seleteItems.length==0)
		{
			CRMtool.tipAlert("请选择待删除的职员后，再执行移除操作！");
			return;
		}
		AccessUtil.remoteCallJava("RoleDest","romeveRoleUser",addRoleUsercallBackHandler,this.seleteItems,"新增角色对应关系处理中...");
	}
		
	private function addRoleUsercallBackHandler(event:ResultEvent):void
	{
		if(event.result=="fail")
		{
			CRMtool.tipAlert("删除失败");
		}
		else
		{
			CRMtool.tipAlert("删除成功!!");
			for(var i:int=0;i<this.seleteItems.length;i++)
			{
				for(var j:int=0;j<this.roleUserArr.length;j++)
				{
					if(this.roleUserArr.getItemAt(j).iid==this.seleteItems.getItemAt(i).iid)
					{
						this.roleUserArr.removeItemAt(j);
						break;
					}
				}
			}
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
public  function getRoleTree():void
{
	AccessUtil.remoteCallJava("RoleDest","getRolesByIpid",callBackHandler); 
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：封装查询后的结果集
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
private  function callBackHandler(event:ResultEvent):void
{
	if(event.result!=null)
	{
		var treexml:XML = new XML(event.result as String);
		this.tre_role.treeCompsXml = treexml;
		CRMtool.toolButtonsEnabled(this.lbr_role,null,this.tre_role.treeCompsXml.length());
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.lbr_role,null,0);
	}
	
	this.myDataGrid.InitColumns();
	
	var dgc_ccode:DataGridColumn = new DataGridColumn();
	dgc_ccode.dataField="ccode";
	dgc_ccode.headerText="编码";
	myDataGrid.columns =myDataGrid.columns.concat(dgc_ccode);
	
	var dgc_cname:DataGridColumn = new DataGridColumn();
	dgc_cname.dataField="cname";
	dgc_cname.headerText="名称";
	myDataGrid.columns =myDataGrid.columns.concat(dgc_cname);
	
	var dgc_departmentName:DataGridColumn = new DataGridColumn();
	dgc_departmentName.dataField="departmentName";
	dgc_departmentName.headerText="部门";
	myDataGrid.columns =myDataGrid.columns.concat(dgc_departmentName);
	
	var dgc_jobName:DataGridColumn = new DataGridColumn();
	dgc_jobName.dataField="jobName";
	dgc_jobName.headerText="主岗";
	myDataGrid.columns =myDataGrid.columns.concat(dgc_jobName);
	
	var dgc_postName:DataGridColumn = new DataGridColumn();
	dgc_postName.dataField="postName";
	dgc_postName.headerText="职务";
	myDataGrid.columns =myDataGrid.columns.concat(dgc_postName);
	
	CRMtool.containerChildsEnabled(this.myBorder,false);
	//回车替代TAB键
	CRMtool.setTabIndex(this.myBorder);
	this.addEventListener("onGridClick",clickGrid,true);
	
}

public function clickGrid(evt:Event){
	this.seleteItems = myDataGrid.getSelectRows();
}
private function onGiveUp(event:Event):void
{
	this.tnp_ccode.text ="";
	this.tnp_cname.text ="";
	this.rbtgn_buse.selectedValue="";
	this.rbtn_enabled.selected = false;
	this.rbtn_disable.selected = false;
	this.tnp_cmemo.text = "";
	this.itemType ="onGiveUp";
	this.tre_role.enabled= true;
	CRMtool.toolButtonsEnabled(this.lbr_role,"onGiveUp",this.tre_role.treeCompsXml.length());
	CRMtool.containerChildsEnabled(this.myBorder,false);
}

//新增    LC 20160229 修改 点击增加按钮后，启用为选中状态
public function onNew(event:Event):void
{
	this.tre_role.selectedIndex=-1;
	this.tnp_ccode.text ="";
	this.tnp_cname.text ="";
	this.rbtgn_buse.selectedValue="";
	this.rbtn_enabled.selected = true;
	this.rbtn_disable.selected = false;
	this.tnp_cmemo.text = "";
	this.itemType ="onNew";
	this.tre_role.enabled= false;
	roleUserArr=new ArrayCollection();
	CRMtool.toolButtonsEnabled(this.lbr_role,"onNew",this.tre_role.treeCompsXml.length());
	CRMtool.containerChildsEnabled(this.myBorder,true);
}

public function onEdit(event:Event):void
{
	if(!this.tre_role.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}
	this.tre_role.enabled= false;
	this.itemType ="onEdit";
	CRMtool.toolButtonsEnabled(this.lbr_role,"onEdit",this.tre_role.treeCompsXml.length());
	CRMtool.containerChildsEnabled(this.myBorder,true);
}