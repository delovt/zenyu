import flash.events.Event;

import mx.collections.ArrayCollection;

import yssoft.tools.CRMtool;
import yssoft.vos.CsCustomerVo;

private var custormerArr:ArrayCollection = new ArrayCollection();

private var count:int =1;

[Bindable]
public var winParam:Object=new Object();


private function init():void
{
	
	/*if(winParam!=null)
	{
		if(winParam.hasOwnProperty("itemType"))
		{
			CRMtool.toolButtonsEnabled(this.lbr_authcontent,winParam.itemType,this.personArr.length);
			switch(winParam.itemType)
			{
				case "onNew":
				{
					personVbox.onNew();
					break;
				}
				case "onEdit":
				{
					personVbox.onEdit();
					break;
				}
			}
		}
		if(winParam.hasOwnProperty("personArr"))
		{
			AccessUtil.remoteCallJava("hrPersonDest","getPersonVos",getPersoanBack,winParam.personArr); 
		}
		else if(winParam.hasOwnProperty("idepartment"))
		{
			this.personVbox.tnp_idepartment.te=winParam.idepartment;
		}
	}
	else
	{*/
		CRMtool.toolButtonsEnabled(this.lbr_authcontent,null,this.custormerArr.length);
	/*}*/
}

//新增
private function onNew(event:Event):void
{
	this.customerVBox.onNew();
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,"onNew",this.custormerArr.length);
}

private function onSave(event:Event):void
{
	this.customerVBox.onSave();
}

private function onEdit(event:Event):void
{
	this.customerVBox.onEdit();
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,"onEdit",this.custormerArr.length);
}

private function onDelete(event:Event):void
{
	this.customerVBox.customerVo = this.custormerArr.getItemAt(count-1) as CsCustomerVo;
	this.customerVBox.removeCustomer();
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,"onDelete",this.custormerArr.length);
	if(this.custormerArr.length==0)
	{
		this.btn_next.enabled = false;
		this.btn_up.enabled = false;
	}
}

private function onGiveUp(event:Event):void
{
	customerVBox.onGiveUp();
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,null,this.custormerArr.length);
}

public function pageInitBack(personVo:CsCustomerVo,item:String):void
{
	switch(item)
	{
		case "onNew":
		{
			this.custormerArr.addItem(personVo);
			if(this.custormerArr.length>1)
			{
				count++;
			}
			break;
		}
		case "onEdit":
		{
			for each(var person:CsCustomerVo in this.custormerArr)
			{
				if(personVo.iid == person.iid)
				{
					person = personVo;
				}
			}
			break;
		}	
		default:
		{
			break;
		}
	}
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,null,this.custormerArr.length);
	
	if(this.custormerArr.length>1)
	{
		if(count==this.custormerArr.length)
		{
			this.btn_next.enabled = false;
			this.btn_up.enabled = true;
		}
		else if(count==1)
		{
			this.btn_up.enabled = false;
			this.btn_next.enabled = true;
		}
		else
		{
			this.btn_next.enabled = true;
			this.btn_up.enabled = true;
		}
	}
}

public function deleteInitBack(iid:int):void
{
	for(var i:int=0;i<this.custormerArr.length;i++)
	{
		if(this.custormerArr.getItemAt(i).iid == iid)
		{
			this.custormerArr.removeItemAt(i);
		}
	}
	count--;
	if(this.custormerArr.length>1)
	{
		if(count==this.custormerArr.length)
		{
			this.btn_next.enabled = false;
			this.btn_up.enabled = false;
		}
	}
	if(count!=0)
	{
		var obj:CsCustomerVo= this.custormerArr.getItemAt(count-1) as CsCustomerVo;
		initText(obj);
	}
	else
	{
		this.customerVBox.onGiveUp();
	}
}

public function initText(obj:CsCustomerVo):void
{
	this.customerVBox.customerVo = obj;
	/*this.personVbox.tnp_idepartment.text = obj.idepartment;*/
	
	/*this.custpersonVbox.rbtgn_bjobstatus.selectedValue = obj.bjobstatus;
	if(obj.bjobstatus)
	{
	this.personVbox.rbtn_working.selected = true;
	}
	else if(obj.bjobstatus)
	{
	this.personVbox.rbtn_Leaving.selected = true;
	}
	this.personVbox.rbtgn_busestatus.selectedValue=obj.busestatus;
	if(obj.busestatus)
	{
	this.personVbox.rbtn_enabled.selected = true;
	}
	else if(obj.busestatus)
	{
	this.personVbox.rbtn_disable.selected = true;
	}*/
}

private function up():void
{
	count--;
	if(count==1)
	{
		this.btn_up.enabled = false;
	}
	if(count==this.custormerArr.length)
	{
		this.btn_next.enabled = false;
	}
	else
	{
		this.btn_next.enabled = true;
	}
	var obj:CsCustomerVo = this.custormerArr.getItemAt(count-1) as CsCustomerVo;
	this.label =obj.cname;
	initText(obj);
	
}

private function next():void
{
	
	count++;
	if(count==this.custormerArr.length)
	{
		this.btn_next.enabled=false;
	}
	if(count==1)
	{
		this.btn_up.enabled = false;
	}
	else
	{
		this.btn_up.enabled = true;
	}
	
	var obj:CsCustomerVo = this.custormerArr.getItemAt(count-1) as CsCustomerVo;
	this.label =obj.cname;
	initText(obj);
}