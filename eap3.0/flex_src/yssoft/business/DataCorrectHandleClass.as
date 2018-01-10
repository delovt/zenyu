/**
 *		YJ Add 20120822
 * 		数据批改业务操作
 *  	依据业务字典中的配置，动态创建相关控件
 */


package yssoft.business
{
	import flash.display.DisplayObject;
	import flash.events.Event;
/*	import flash.media.H264Level;*/
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.CheckBox;
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.Container;
	
	import yssoft.comps.ConsultTextInput;
	import yssoft.comps.DateControl;
	import yssoft.tools.CRMtool;
	import mx.utils.StringUtil;
	
	public class DataCorrectHandleClass
	{
		public function DataCorrectHandleClass(){}
		
		//容器
		private var _container:Container;
		
		public function set container(value:Container):void{
			
			_container = value;
			
		} 
		
		//控件属性集合
		//包含字段信息及参照信息，业务字典及参照配置表关联查询的集合
		private var _controlpropertys:ArrayCollection;
		
		public function set controlpropertys(value:ArrayCollection):void{
		
			this._controlpropertys = value;
			
		}
		
		//是否显示多选控件
		private var _bcheckshow:Boolean;
		
		public function set bcheckshow(value:Boolean):void{
		
			this._bcheckshow = value;
			
		}
		
		//是否显示标签
		private var _blabelshow:Boolean;
		
		public function set blabelshow(value:Boolean):void{
		
			this._blabelshow = value;
			
		}
		
		//一行显示几列
		private var _cols:int;
		
		public function set cols(value:int):void{
			
			this._cols = value;
			
		}
		
		//初始化操作
		public function ini():void{
		
			onIniControls();
			
		}
		
		/**
		 *	初始化控件	 
		 * 
		 * 	YJ Add 20120829
		 * 
		 *  理念：
		 *  	调用此方法时，客户端必须自己建立一个存放控件的大的容器
		 *  	然后是创建每一行的容器，HBox
		 * 		根据列数，创建小的容器HBox，放入到大的HBox中
		 * 		每个小的容器中会依据属性创建控件
		 * 
		 * 	排列顺序：
		 * 		container(客户端容器) <--- 大HBox <--- 小的HBox <--- 控件
		 * 
		 */		
		protected function onIniControls():void{
		
			if(this._controlpropertys == null || this._controlpropertys.length == 0) return;
			
			this._container.removeAllChildren();
			
			var phb:HBox;
			var flag:int=0;//标志,用于计数使用
			
			for(var i:int=0;i<this._controlpropertys.length;i++){//控件属性集合
			
				var item:Object = this._controlpropertys[i];
				
				var control:DisplayObject = onProduceControls(item);
				
				if(control != null){
					
					if(i%_cols==0)	{
						phb= new HBox();//公共HBox
						phb.percentWidth =100;
						flag = 1;
					}
						
					var hb:HBox = new HBox();
					hb.name = i+"";
					hb.setStyle("paddingTop",5);
					hb.setStyle("paddingLeft",10);
					hb.setStyle("paddingRight",10);
					hb.percentWidth = 50;
					
					//添加标签和勾选项
					onAddOtherControls(hb,item);
					//添加控件
					hb.addChild(control);
					//大HB添加小HB
					phb.addChild(hb);
					
					//添加一行
					if(flag == 1){
						this._container.addChild(phb);
						flag = 0;
					}
					
				} 
				
			}
			
		}
		
		/**
		 * 动态创建控件
		 * @param dtname 数据类型名称(sqlsever的数据类型)
		 * @return 显示对象
		 * 
		 */		
		private function onProduceControls(item:Object):DisplayObject{
		
			//首先判定是否是参照
			if(item.iconsult>0){
				
				var tnp_cfield:ConsultTextInput = new ConsultTextInput();
				tnp_cfield.iid = item.iconsult;
				tnp_cfield.bindValueField=item.cconsultbkfld;
				tnp_cfield.bindLabelField=item.cconsultswfld;
				tnp_cfield.editable = false;
				tnp_cfield.showBorder = true;
				tnp_cfield.borderStyle = "inset";
				tnp_cfield.onlyGetEndNode=Boolean(item.bconsultendbk);
				tnp_cfield.name = "ConsultTextInput";
				
				return tnp_cfield;
			}
			
			return onCreateControls(item.ctype);
			
		}
		
		/**
		 *	根据数据类型创建控件 
		 * @param ctype 数据类型
		 * @return  控件
		 * 
		 */		
		private function onCreateControls(ctype:String):DisplayObject{
		
			var rvalue:DisplayObject;
			
			switch(ctype){				
				case "nvarchar":
					var ti_nvarchar:TextInput = new TextInput();
					ti_nvarchar.editable = false;
					ti_nvarchar.name = "TextInput";
					ti_nvarchar.percentWidth = 100;
					
					rvalue = ti_nvarchar;
					break;	
				
				case "int":
					var ti_int:TextInput = new TextInput();
					ti_int.restrict="0-9";
					ti_int.editable = false;
					ti_int.percentWidth = 100;
					ti_int.name = "TextInput";
					
					rvalue = ti_int;
					break;
				
				case "float":
					var ti_float:TextInput = new TextInput();
					ti_float.restrict="0-9\.";					
					ti_float.editable = false;
					ti_float.percentWidth = 100;
					ti_float.name = "TextInput";
					
					rvalue = ti_float;
					break;
				
				case "datetime":
					var dc:DateField = new DateField();
					dc.dayNames = ['日','一','二','三','四','五','六'];
					dc.monthNames = ['一','二','三','四','五','六','七','八','九','十','十一','十二'];
					dc.enabled = false;
					dc.formatString = CRMtool.getFormatDateString("YYYY-MM-DD");
					dc.percentWidth = 100;
					dc.name = "DateField";
					
					rvalue = dc;
					break;
				
				case "bit":
					var cb:CheckBox = new CheckBox();
					cb.enabled = false;
					cb.name = "CheckBox";
					
					rvalue = cb;
					break;
				
				case "text":
					var t_text:TextArea = new TextArea();
					t_text.height = 30;
					t_text.editable = false;
					t_text.name = "TextArea";
					
					rvalue = t_text;
					break;
				
				default:
					break;
				
			}
			
			return rvalue;
			
		}
		
		//添加其他的控件信息
		private function onAddOtherControls(hb:HBox,item:Object):void{
		
			//添加CheckBox
			if(this._bcheckshow == true){
			
				var cb:CheckBox = new CheckBox();
				cb.addEventListener("click",cb_clickHandler);//监听点击事件
				hb.addChild(cb);
				
			}
			//添加Label
			if(this._blabelshow == true){
				
				var lbl:Label = new Label();
				lbl.styleName="contentLabel";
				lbl.percentWidth=30;
				lbl.text = item.ccaption;
				hb.addChild(lbl);
				
			}
			
		}
		
		/**
		 * CHECKBOX的点击事件
		 * @param event
		 * 
		 */		
		private function cb_clickHandler(event:Event):void{
		
			var cb:CheckBox = event.currentTarget as CheckBox;
			var pcontainer:HBox = cb.parent as HBox;
			var cArr:Array = pcontainer.getChildren();
			
			onBControlEdit(cArr,cb.selected);
			
		}
		
		/**
		 * 设置控件是否可用
		 * @param cArr 控件集合
		 * @param bedit 是否可用
		 * 
		 */
		private function onBControlEdit(cArr:Array,bedit:Boolean):void{
		
			for(var i:int=0;i<cArr.length;i++){
			
				var item:Object = cArr[i];
				
				if(!item.hasOwnProperty("name") || item.name == null || item.name == "") continue;
				
				switch(item.name){
				
					case "ConsultTextInput":
						(item as ConsultTextInput).editable = bedit;
						(item as ConsultTextInput).visibleIcon = bedit;
						break;
					case "TextInput":
						(item as TextInput).editable = bedit;
						break;
					case "DateField":
						(item as DateField).enabled = bedit;
						break;
					case "CheckBox":
						(item as CheckBox).enabled = bedit;
						break;
					case "TextArea":
						(item as TextArea).editable = bedit;
						break;
					default:
						break;
					
				}
				
			}
			
		}
		
		/**
		 *	获取选中项的集合
		 * @return 
		 * 
		 */		
		public function onGetSelectDataMuster():ArrayCollection{
		
			if(this._container.getChildren().length == 0) return null;
			
			var rvalue:ArrayCollection = new ArrayCollection();
			
			var levelone:Array = this._container.getChildren();//第一级一般是行的记录，大的HBox
			
			for(var i:int=0;i<levelone.length;i++){
				
				var leveltwo:Array = (levelone[i] as HBox).getChildren();//第二级一般是列的记录，小的HBox
				
				for(var j:int=0;j<leveltwo.length;j++){
				
					var levelthree:Array = (leveltwo[j] as HBox).getChildren();//第三级一般是具体的控件
					
					if((levelthree[0] as CheckBox).selected == true){
					
						var item:Object = this._controlpropertys[leveltwo[j].name];
						
						var ovalue:Object = onGetControlValue(item.ctype,levelthree[2]);
						
						var obj:Object = {};
						obj.cfield = item.cfield;
						obj.cvalue = ovalue;
						rvalue.addItem(obj);
						
					}
					
				}
				
			}
			
			return rvalue;
			
		}
		
		
		
		/**
		 * 	获取控件的输入值 
		 *  @param dtype 数据类型
		 *  @param cname 控件名称
		 *  @return 
		 * 
		 */		
		private function onGetControlValue(dtype:String,obj:Object):Object{
		
			var rvalue:Object = {};
			
			//存入参照内码
			if(obj.name == "ConsultTextInput"){
				if(CRMtool.isStringNotNull(obj.value)){
					if(dtype == "int")
						rvalue = Number(obj.value+"");
					else
						rvalue = "'"+obj.value+"'";
				}
				else
					rvalue = null;
			}
			else if(obj.name == "CheckBox"){
			
				if(obj.selected == true)
					rvalue = 1;
				else
					rvalue = 0;
				
			}
			else{
			
				rvalue = StringUtil.trim("'"+obj.text+"'");
			}
			
			return rvalue;
		}
		
		
	}
}