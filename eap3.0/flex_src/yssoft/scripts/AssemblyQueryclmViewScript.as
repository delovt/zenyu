import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.Label;
import mx.controls.RadioButtonGroup;
import mx.controls.TextInput;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.skins.spark.BorderSkin;
import mx.utils.StringUtil;

import yssoft.comps.ConsultTextInput;
import yssoft.comps.DateControl;
import yssoft.comps.frame.FrameworkVBoxView;
import yssoft.models.CRMmodel;
import yssoft.models.DateHadle;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.consultsets.ConsultsetSet;

private var _ifuncregedit:int;

//注册程序内码查询条件数据集
[Bindable]public var arrDataList:ArrayCollection = new ArrayCollection();	

//重新封装高级查询数据集
[Bindable]public var advancedArr:ArrayCollection = new ArrayCollection();

//重新封装高级查询数据集
[Bindable]public var cfieldArr:ArrayCollection = new ArrayCollection();

public var componentsArr:ArrayCollection = new ArrayCollection();

[Bindable]
public 	var sql:String ="";

[Bindable]
public var sortArr:ArrayCollection = new ArrayCollection();

//找出所有的非空验证
[Bindable]
public var isNotNullArr:ArrayCollection = new ArrayCollection();

public var parentForm:Object;

public function set ifuncregedit(value:int):void
{
	this._ifuncregedit = value;
}

public function cfiedFormat(item:Object,icol:int):String
{
	return CRMtool.cfiedFo(item.cfiled,this.cfieldArr);
}

private var _isShow:Boolean = true;

public function set isShow(value:Boolean):void
{
	this._isShow = value;
}
 
//查询程序内码的查询条件
protected function inidata():void{
	AccessUtil.remoteCallJava("ACqueryclmDest","getAcQueryclmList",onGetAcQueryclmListBack,this._ifuncregedit);
}

private function onGetAcQueryclmListBack(evt:ResultEvent):void{
	arrDataList = evt.result as ArrayCollection;
	parentForm = this.owner;
	/******************* 先排序 ***********************/
	var sort:Sort=new Sort();  
	//按照优先序号升序排序  
	sort.fields=[new SortField("iqryno")];  
	this.arrDataList.sort=sort;
	
	var _commons:ArrayCollection = new ArrayCollection();
	
	var co:int=1;
	/******************* 找出所有常用条件 ***********************/
	for each(var obj:Object in arrDataList)
	{
		//找出常用条件
		if(String(obj.bcommon)== "true")
		{
			_commons.addItem(obj);
		}
		
		/******************* 重新封装数据集 ***********************/
		var advancedObj:Object = new Object();
		advancedObj.logic ="and";
		advancedObj.leftParenthesis ="";
		advancedObj.cfiled=obj.cfield;
		advancedObj.idatetype=obj.idatetype;
		advancedObj.ifieldtype=obj.ifieldtype;
		advancedObj.ccaption=obj.ccaption;
		advancedObj.condition ="=";
		advancedObj.value =" ";
		advancedObj.rightParenthesis =" ";
		advancedArr.addItem(advancedObj);
		
		/******************* 封装字段名下拉框 ***********************/
		var cfieldObj:Object = new Object();
		cfieldObj.ccaption = obj.ccaption;
		cfieldObj.cfield=obj.cfield;
		cfieldArr.addItem(cfieldObj);
		
		/******************* 封装排序 ***********************/
		var sortObj:Object = new Object();
		sortObj.isortno = co;
		sortObj.cfiled=obj.cfield;
		sortObj.isttype = obj.isttype;
		sortObj.iid=obj.iid;
		sortArr.addItem(sortObj);
		co++;
	}
	/******************* 封装组件 ***********************/
	//空值行数
	var count:int = 0;
	//动态对象集合（包括，动态主键，组件类型，和哪个字段绑定）

	for(var i:int=0;i<_commons.length;i++)
	{
		var hbx_coulmn:HBox;
		if(int(Number(_commons.getItemAt(i).icmtype))==1&&count%2!=0)
		{
			count++;
		}
		//一行显示两列
		if(count%2==0)
		{
			hbx_coulmn = new HBox();
			hbx_coulmn.styleName="contentSubHbox";
			hbx_coulmn.percentWidth=100;
			this.vbx_common.addChild(hbx_coulmn);
		}
		//两列各占50%
		var hbx_row:HBox = new HBox();
		hbx_row.percentWidth = 50;
		hbx_coulmn.addChild(hbx_row);
		
		var lbe_ccaption:Label = new Label;
		lbe_ccaption.text = _commons.getItemAt(i).ccaption;
		lbe_ccaption.styleName ="contentLabel";
		lbe_ccaption.percentWidth=30;
		//必输项
		if(Boolean(_commons.getItemAt(i).bunnull)||_commons.getItemAt(i).bunnull=="true")
		{
			lbe_ccaption.setStyle("color","red");
		}
		hbx_row.addChild(lbe_ccaption);
		
		var componentsObj:Object = new Object();
		switch(int(Number(_commons.getItemAt(i).ifieldtype)))
		{
			case 0:
			{
				var tnp_cfield;
				//判断是参照  add by lr
				if(_commons.getItemAt(i).iconsult!=null&&_commons.getItemAt(i).iconsult!=0){
					tnp_cfield = new ConsultTextInput();
					tnp_cfield.iid = _commons.getItemAt(i).iconsult;
					tnp_cfield.bindValueField=_commons.getItemAt(i).cconsultbkfld;
					tnp_cfield.bindLabelField=_commons.getItemAt(i).cconsultswfld;
					tnp_cfield.visibleIcon = true;
					tnp_cfield.editable = true;
					tnp_cfield.showBorder = true;
					tnp_cfield.borderStyle = "inset";
					if(null!=_commons.getItemAt(i).cdefault&&""!=StringUtil.trim(String(_commons.getItemAt(i).cdefault)))
					{
						switch(_commons.getItemAt(i).cdefault)
						{
							case "登录人":
							{
								tnp_cfield.tnp_text_str=CRMmodel.hrperson.cname;
								break;
							}
							case "登录人部门":
							{
								tnp_cfield.tnp_text_str=CRMmodel.hrperson.departcname;
								break;
							}	
						}
					}
					else if(null!=_commons.getItemAt(i).cfixdefault&&""!=_commons.getItemAt(i).cfixdefault)
					{
						tnp_cfield.tnp_text_str=_commons.getItemAt(i).cfixdefault;
					}
					tnp_cfield.onlyGetEndNode=Boolean(_commons.getItemAt(i).bconsultendbk);
					componentsObj.type ="ConsultTextInput";
					
				}
				else{
					tnp_cfield = new TextInput();
                    tnp_cfield.restrict = "^'";
					componentsObj.type ="TextInput";
					if(null!=_commons.getItemAt(i).cfixdefault&&""!=_commons.getItemAt(i).cfixdefault)
					{
						tnp_cfield.text=_commons.getItemAt(i).cfixdefault;
					}
				}

				tnp_cfield.percentWidth=60;
				hbx_row.addChild(tnp_cfield);
				componentsObj.components=tnp_cfield;
				componentsObj.cfield = _commons.getItemAt(i).cfield;

				break;
			}
			case 1:
			{
				var tnp_cfield_Number:TextInput = new TextInput();
				tnp_cfield_Number.restrict="[0-9]";
				tnp_cfield_Number.percentWidth=60;
				hbx_row.addChild(tnp_cfield_Number);
				componentsObj.components=tnp_cfield_Number;
				componentsObj.type ="TextInput";
				componentsObj.cfield = _commons.getItemAt(i).cfield;
				if(null!=_commons.getItemAt(i).cfixdefault&&""!=_commons.getItemAt(i).cfixdefault)
				{
					tnp_cfield_Number.text=_commons.getItemAt(i).cfixdefault;
				}
				break;
			}
			case 2:
			{
				var tnp_cfield_Float:TextInput = new TextInput();
				tnp_cfield_Float.restrict="[0-9]\.";
				tnp_cfield_Float.percentWidth=60;
				hbx_row.addChild(tnp_cfield_Float);
				componentsObj.components=tnp_cfield_Float;
				componentsObj.type ="TextInput";
				componentsObj.cfield = _commons.getItemAt(i).cfield;
				if(null!=_commons.getItemAt(i).cfixdefault&&""!=_commons.getItemAt(i).cfixdefault)
				{
					tnp_cfield_Float.text=_commons.getItemAt(i).cfixdefault;
				}
				if(Boolean(_commons.getItemAt(i).bunnull)||_commons.getItemAt(i).bunnull=="true")
				{
					this.isNotNullArr.addItem(componentsObj);
				}
				break;
			}
			case 3:
			{
				var dfl_cfield:DateControl = new DateControl();
				dfl_cfield.showShape = 0;
				dfl_cfield.percentWidth=60;
				if(null!=_commons.getItemAt(i).cdefault&&""!=_commons.getItemAt(i).cdefault)
				{
					switch(_commons.getItemAt(i).cdefault)
					{
						case "本年":
						{
							dfl_cfield.text=DateHadle.getFirstOfYear();
							break;
						}
						case "本月":
						{
							dfl_cfield.text=DateHadle.getFirstOfMonth();
							break;
						}	
						case "本周":
						{
							dfl_cfield.text=DateHadle.getFirstOfWeek();
							break;
						}
						case "今天":
						{
							dfl_cfield.text=CRMtool.getFormatDateString("YYYY-MM-DD");
							break;
						}
					}
				}
				hbx_row.addChild(dfl_cfield);
				dfl_cfield.isStyle = false;
				dfl_cfield.editable = true;
				componentsObj.components=dfl_cfield;
				componentsObj.type ="DateControl";
				componentsObj.cfield = _commons.getItemAt(i).cfield;
		
				break;
			}
			case 4:
			{
				var chbx_cfield:CheckBox = new CheckBox();
				hbx_row.addChild(chbx_cfield);
				componentsObj.components=chbx_cfield;
				componentsObj.type ="CheckBox";
				componentsObj.cfield = _commons.getItemAt(i).cfield;
				
				break;
			}
				
			default:
			{
				break;
			}
		}
		if(int(Number(_commons.getItemAt(i).icmtype))==1)
		{
			var hbx_row1:HBox = new HBox();
			hbx_row1.percentWidth = 50;
			hbx_coulmn.addChild(hbx_row1);
			
			var lbe_ccaption1:Label = new Label;
			lbe_ccaption1.text = "到";
			lbe_ccaption1.styleName ="contentLabel";
			lbe_ccaption1.percentWidth=30;
			//必输项
			if(Boolean(_commons.getItemAt(i).bunnull)||_commons.getItemAt(i).bunnull=="true")
			{
				lbe_ccaption1.setStyle("color","red");
			}
			hbx_row1.addChild(lbe_ccaption1);
			
			
			switch(int(Number(_commons.getItemAt(i).ifieldtype)))
			{
				case 0:
				{
					var tnp_cfield1:TextInput = new TextInput();
					tnp_cfield1.percentWidth=60;
					hbx_row1.addChild(tnp_cfield1);
					componentsObj.between=tnp_cfield1;
					break;
				}
				case 1:
				{
					var tnp_cfield_Number1:TextInput = new TextInput();
					tnp_cfield_Number1.percentWidth=60;
					tnp_cfield_Number1.restrict="[0-9]";
					hbx_row1.addChild(tnp_cfield_Number1);
					componentsObj.between=tnp_cfield_Number1;
					break;
				}
				case 2:
				{
					var tnp_cfield_Float1:TextInput = new TextInput();
					tnp_cfield_Float1.percentWidth=60;
					tnp_cfield_Float1.restrict="[0-9]\.";
					hbx_row1.addChild(tnp_cfield_Float1);
					componentsObj.between=tnp_cfield_Float1;
					break;
				}
				case 3:
				{
					var dfl_cfield1:DateControl = new DateControl();
					dfl_cfield1.showShape = 0;
					dfl_cfield1.percentWidth=60;
					dfl_cfield1.isStyle = false;
					dfl_cfield1.editable = true;
					hbx_row1.addChild(dfl_cfield1);
					componentsObj.between=dfl_cfield1;
					if(null!=_commons.getItemAt(i).cdefault&&""!=_commons.getItemAt(i).cdefault)
					{
						switch(_commons.getItemAt(i).cdefault)
						{
							case "本年":
							{
								dfl_cfield1.text=DateHadle.getEndOfYear();
								break;
							}
							case "本月":
							{
								dfl_cfield1.text=DateHadle.getEndOfMonth();
								break;
							}	
							case "本周":
							{
								dfl_cfield1.text=DateHadle.getEndOfWeek();
								break;
							}
							case "今天":
							{
								dfl_cfield1.text=CRMtool.getFormatDateString("YYYY-MM-DD");
								break;
							}
						}
					}
					
					break;
					
				}
				case 4:
				{
					var chbx_cfield1:CheckBox = new CheckBox();
					hbx_row1.addChild(chbx_cfield1);
					componentsObj.between=hbx_row1;
					break;
				}
					
				default:
				{
					break;
				}
					
			}
			count++;
		}
		
		
		componentsArr.addItem(componentsObj);
		
		if(Boolean(_commons.getItemAt(i).bunnull)||_commons.getItemAt(i).bunnull=="true")
		{
			this.isNotNullArr.addItem(componentsObj);
		}
		count++;
		
	}
	//回车替代TAB键
	CRMtool.setTabIndex(this.vbx_common);
	if(!_isShow)
	{
		this.myTab.removeChild(this.vbx_sort);
	}
}


public function sumbit():void
{
	var cfield:String ="";

	if(this.isNotNullArr.length>0)
	{
		for each(var notobj:Object in isNotNullArr)
		{
			switch(notobj.type)
			{
				//解析参照数据，此处取字符串值
				case "ConsultTextInput":
				{
					var tnp_confield:ConsultTextInput = notobj.components as ConsultTextInput;
					if(CRMtool.isStringNull(tnp_confield.tnp_text_str))
					{
						Alert.show("红色标签项必填！！");
						return;
					}
					break;
				}
				case "TextInput":
				{
					var tnp_cfield:TextInput = notobj.components as TextInput;
					if(CRMtool.isStringNull(tnp_cfield.text))
					{
						Alert.show("红色标签项必填！！");
						return;
					}
					if(notobj.hasOwnProperty("between"))
					{
						var tnp_between:TextInput = notobj.between as TextInput;
						if(CRMtool.isStringNull(tnp_between.text))
						{
							Alert.show("红色标签项必填！！");
							return;
						}
					}
					break;
				}
				case "DateControl":
				{
					var dfl_cfield:DateControl = notobj.components as DateControl;
					if(CRMtool.isStringNull(dfl_cfield.text))
					{
						Alert.show("红色标签项必填！！");
						return;
					}
					if(notobj.hasOwnProperty("between"))
					{
						var dfl_between:DateControl = notobj.between as DateControl;
						if(CRMtool.isStringNull(dfl_between.text))
						{
							Alert.show("红色标签项必填！！");
							return;
						}
					}
					break;
				}
			}
		}
	}
	
	for each(var obj:Object  in componentsArr)
	{
			switch(obj.type)
			{
				//解析参照数据，此处取字符串值
				case "ConsultTextInput":
				{
					var tnp_confield:ConsultTextInput = obj.components as ConsultTextInput;
					if(tnp_confield.tnp_text_str!=null&&StringUtil.trim(tnp_confield.tnp_text_str)!=""){
						sql+=" and " + obj.cfield;
						sql+="='"+ StringUtil.trim(tnp_confield.tnp_text_str)+"'";
					}
					break;
				}
				case "TextInput":
				{
					var tnp_cfield:TextInput = obj.components as TextInput;
					if(CRMtool.isStringNotNull(StringUtil.trim(tnp_cfield.text)))
					{
						sql+=" and " + obj.cfield;
						if(obj.hasOwnProperty("between"))
						{
							var tnp_between:TextInput = obj.between as TextInput;
							sql+=" between '";
							sql+= tnp_cfield.text;
							sql+="' and '";
							sql+= StringUtil.trim(tnp_between.text)+"'"; 
						}
						else
						{
							sql+="='"+ StringUtil.trim(tnp_cfield.text)+"'";
						}
					}
					break;
				}
				case "DateControl":
				{
					var dfl_cfield:DateControl = obj.components as DateControl;
					if(CRMtool.isStringNotNull(StringUtil.trim(dfl_cfield.text)))
					{
						sql+=" and convert(varchar(10)," + obj.cfield+",120) ";
						if(obj.hasOwnProperty("between"))
						{
							var dfl_between:DateControl = obj.between as DateControl;
							sql+=" between '";
							sql+= StringUtil.trim(dfl_cfield.text);
							sql+="' and '";
							sql+= StringUtil.trim(dfl_between.text)+"'";
						}
						else
						{
							sql+="='"+ dfl_cfield.text+"'";
						}
					}
					break;
				}
				case "CheckBox":
				{
					var chbx_cfield:CheckBox = obj.components as CheckBox;
					sql+=" and " + obj.cfield;
					if(chbx_cfield.selected)
					{
						sql+="='1'";
					}
					else
					{
						sql+="='0'";
					}
					break;
				}
				default:
				{
					break;
				}
		}
	}
	var sql2:Object=CRMtool.getSql(advancedArr,cfieldArr);
	if(sql2==null)
	{
		return;
	}
	sql+=sql2.sql;
	var count:int=0;
	for each(var sortobj:Object in this.sortArr)
	{
		if(sortobj.isttype!=""||sortobj.isttype!="0")
		{
			if(count==0)
			{
				sql+=" order by ";
			}
			else
			{
				sql+=",";
			}
			var cfiled1:String = sortobj.cfiled as String;
			var start:int = cfiled1.lastIndexOf(".")+1;
			var end:int = cfiled1.length;
			sql+="tmp."+cfiled1.substring(start,end);
			if(sortobj.isttype=="2")
			{
				sql+=" desc ";
			}
			count++;
		}
	}
	parentForm.pageInitBack(sql);
	AccessUtil.remoteCallJava("ACqueryclmDest","updateAcqueryclm",onSubmitBack,this.sortArr);
	
}

public function onSubmitBack(event:ResultEvent):void
{
	var result:String = event.result as String;
	/*if(result=="fail")
	{
		CRMtool.tipAlert("保存失败！！");
	}
	else
	{
		CRMtool.tipAlert("保存成功！！");
	}*/
	PopUpManager.removePopUp(this);
}







public function onChange(data:Object,a:RadioButtonGroup):void
{
	data.isttype = a.selectedValue;
}


public function openConsultSet():void
{
	var ass:ConsultsetSet = new ConsultsetSet();
	ass.iid = this._ifuncregedit;
	ass.isShowList =2;
	ass.width=700;
	ass.height = 500;
	ass.owner = this;
	/*var mainApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
	PopUpManager.addPopUp(ass, mainApp);
	PopUpManager.centerPopUp(ass);*/
	CRMtool.openView(ass);
}