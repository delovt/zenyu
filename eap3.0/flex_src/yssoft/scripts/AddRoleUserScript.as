import flash.events.Event;
import flash.geom.Utils3D;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.messaging.AbstractConsumer;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

[Bindable]
public var epartmentUserArr:ArrayCollection = new ArrayCollection();

//角色用户
[Bindable]
private var roleUserArr:ArrayCollection = new ArrayCollection();

//添加用户 
[Bindable]
public var addUserArr:ArrayCollection = new ArrayCollection();

//删除用户
[Bindable]
public var romveUserArr:ArrayCollection = new ArrayCollection();

[Bindable]
public var roleId:int = 0;

[Bindable]
public var roleName:String="";

public var parentForm:Object;

[Bindable]
public var departmentXMl:XML = null;

public var treeCompsXmlBase;

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
public function init():void
{
	parentForm = this.owner;
	var param:Object = new Object();
	param.roleid = this.roleId;
	AccessUtil.remoteCallJava("RoleDest","getEpartment",getEpartmencallBackHandler,this.roleId,ConstsModel.ROLE_USER_GET_INFO);
}

private function getEpartmencallBackHandler(event:ResultEvent):void
{
	roleUserArr = event.result as ArrayCollection;
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 查询部门下的人员
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function tre_epartment_changeHandler(event:ListEvent):void
{
	var obj:Object = {};
	var iid:int=int(Number(this.tre_epartment.selectedItem.@iid));
	obj.idepartment = iid;
	obj.irole = this.roleId;//角色内码
	AccessUtil.remoteCallJava("RoleDest","getEpartmentUser",callBackHandler,obj,ConstsModel.ROLE_USER_GET_INFO);
}

private function callBackHandler(event:ResultEvent):void
{
	epartmentUserArr = new ArrayCollection();
	epartmentUserArr = event.result as ArrayCollection;

    var needRemove:ArrayCollection = new ArrayCollection();
    for each(var item:Object in epartmentUserArr){
        for each(var item2:Object in roleUserArr){
			if(item.iid == item2.iperson)
				needRemove.addItem(item);
        }
    }

    for each(var ritem:Object in needRemove){
        epartmentUserArr.removeItemAt(epartmentUserArr.getItemIndex(ritem));
    }
}


/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 查询部门下的人员
 * 参数：userAll 查询出来的结果（要往该数据集插入的）
 * 参数：addAll 临时变量用来记录用户选择了哪些记录要添加
 * 参数：deleteAll 查询出来的结果（要从该数据集删除）
 * 参数：deleteemo 临时变量，用来记录删除哪些记录
 * 参数：chooseObj 当前选择了哪些记录，如果选择方式为1，单独选择的时候，生效，全选的时候不生效
 * 参数：mode  方式1，全部新增/删除 2选择时删除
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function add(mode:String="1"):void
{
	// 全选
	if(mode=="2")
	{
		//查询出来的结果
		this.roleUserArr.addAll(this.epartmentUserArr);
		//临时变量
		this.addUserArr.addAll(this.epartmentUserArr);
		//从临时变量中删除插入记录
		deleteArr(this.romveUserArr,this.epartmentUserArr);
		//从结果集中删除记录
		this.epartmentUserArr.removeAll();
	}
	else
	{
		if(this.allUser.selectedItem)
		{
			//往j结果集中插入记录
			this.roleUserArr.addAll(new ArrayCollection(this.allUser.selectedItems));
			//往临时变量中插入记录
			this.addUserArr.addAll(new ArrayCollection(this.allUser.selectedItems));
			//从结果集钟删除数据
			deleteArr(this.epartmentUserArr,new ArrayCollection(this.allUser.selectedItems));
			//从临时变量删除数据.
			deleteArr(this.romveUserArr,new ArrayCollection(this.allUser.selectedItems));
		}
		else
		{
			CRMtool.tipAlert("请选择要添加的记录");
		}
	}
}


/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 查询部门下的人员
 * 参数：userAll 查询出来的结果（要往该数据集插入的）
 * 参数：addAll 临时变量用来记录用户选择了哪些记录要添加
 * 参数：deleteAll 查询出来的结果（要从该数据集删除）
 * 参数：deleteemo 临时变量，用来记录删除哪些记录
 * 参数：chooseObj 当前选择了哪些记录，如果选择方式为1，单独选择的时候，生效，全选的时候不生效
 * 参数：mode  方式1，全部新增/删除 2选择时删除
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function remove(mode:String="1"):void
{
	// 全选
	if(mode=="2")
	{
		//查询出来的结果
		this.epartmentUserArr.addAll(this.roleUserArr);
		//临时变量
		this.romveUserArr.addAll(this.roleUserArr);
		//从临时变量中删除插入记录
		deleteArr(this.addUserArr,this.roleUserArr);
		//从结果集中删除记录
		this.roleUserArr.removeAll();
	}
	else
	{
		if(this.roleUser.selectedItem)
		{
			//往j结果集中插入记录
			this.epartmentUserArr.addAll(new ArrayCollection(this.roleUser.selectedItems));
			//往临时变量中插入记录
			this.romveUserArr.addAll(new ArrayCollection(this.roleUser.selectedItems));
			//从结果集钟删除数据
			deleteArr(this.roleUserArr,new ArrayCollection(this.roleUser.selectedItems));
			//从临时变量删除数据.
			deleteArr(this.addUserArr,new ArrayCollection(this.roleUser.selectedItems));
		}
		else
		{
			CRMtool.tipAlert("请选择要删除的记录");
		}
	}
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 查询部门下的人员
 * 参数：deleteAll 查询出来的结果（要从该数据集删除）
 * 参数：deleteemo 临时变量，用来记录删除哪些记录
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */  
private function deleteArr(deleteAll:ArrayCollection,deleteemo:ArrayCollection):void
{
	
	for(var i:int=0;i<deleteemo.length;i++)
	{
		for(var j:int=0;j<deleteAll.length;j++)
		{
			if(deleteAll.getItemAt(j).iid==deleteemo.getItemAt(i).iid)
			{
				deleteAll.removeItemAt(j);
				break;
			}
		}
	}
}

public function addRoleUsr():void
{
	if(this.addUserArr.length==0&&this.romveUserArr.length==0)
	{
		CRMtool.tipAlert("请选择选后，在操作");
		return;
	}
	var param:Object = new Object();
	param.addRole = this.addUserArr;
	param.iids = this.romveUserArr;
	param.irole = this.roleId;
	AccessUtil.remoteCallJava("RoleDest","addRoleUser",addRoleUsercallBackHandler,param,"新增角色对应关系处理中...");
}

public function addRoleUsercallBackHandler(event:ResultEvent):void
{
	if(event.result)
	{
		CRMtool.tipAlert("添加成功");
		var d:ArrayCollection =event.result as ArrayCollection;
		parentForm.addRoleUserF(d,this.romveUserArr);
		PopUpManager.removePopUp(this);
		parentForm.getRoleUser();
	}
	else
	{
		CRMtool.tipAlert("添加失败");
	}
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
public function getDepartmentTreeXml(name:String):void
{
	AccessUtil.remoteCallJava("RoleDest","getDepartment",getllBackHandler,name,ConstsModel.EPARTMENT_GET_INFO);
}

private function getllBackHandler(event:ResultEvent):void
{
	if(event.result!=null)
	{
		var result:String = event.result as String;		
		this.tre_epartment.treeCompsXml = new XML(result);
		treeCompsXmlBase = new XML(result);
	}
	
}

/**
 * 搜索部门
 * 
*/
/*private	 function filtFun(item:Object):Boolean{
	
}*/
public function searchDepartant(fname:String):void
{
	var vname:String = StringUtil.trim(fname);
	if(vname==""){
		tre_epartment.treeCompsXml = treeCompsXmlBase;
	}else{			
		tre_epartment.treeCompsXml = CRMtool.searchTreeNode(treeCompsXmlBase.descendants("*"),vname);				
	}

}

