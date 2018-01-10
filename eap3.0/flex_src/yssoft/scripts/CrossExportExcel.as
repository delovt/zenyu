package yssoft.scripts
{
import flash.errors.*;
import flash.events.*;
import flash.external.*;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.navigateToURL;
import flash.utils.ByteArray;

import mx.collections.ArrayCollection;
import mx.controls.AdvancedDataGrid;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
import mx.controls.dataGridClasses.DataGridColumn;

//import org.hamcrest.mxml.object.Null;

public class CrossExportExcel
{
	public function CrossExportExcel()
	{
	}
	/** 在导出数据的时候有可能出现单元格数据长度过长而导致Excel在显示时   
	 *  出现科学计数法或者#特殊符号，在此设置单元格宽度比例WIDTHSCALE，在   
	 *  代码中每个单元格的宽度扩展适当的比例值WIDTHSCALE。   
	 */   
	private static var WIDTHSCALE:Number=2.0;   
	
	
	private static var bool:Boolean=false;
	
	/**   
	 * 将DataGrid转换为htmltable   
	 * @author rentao   
	 * @param: dg 需要转换成htmltable的DataGrid   
	 * @return: String   
	 */   
	private static function convertDGToHTMLTable(dg:DataGrid):String {   
		//设置默认的DataGrid样式   
		var font:String = dg.getStyle('fontFamily');   
		var size:String = dg.getStyle('fontSize');   
		var str:String = '';   
		var colors:String = '';   
		var style:String = 'style="font-family:'+font+';font-size:'+size+'pt;"';                   
		var hcolor:Array;   
		
		//检索DataGrid的 headercolor   
		if(dg.getStyle("headerColor") != undefined) {   
			hcolor = [dg.getStyle("headerColor")];   
		} else {   
			hcolor = dg.getStyle("headerColors");   
		}                  
		
		//   Alert.show(hcolor+"");
		var x :String = "" ;
		if(hcolor == null){
			x = "0x323232" ;
		}else{
			x = Number((hcolor[0])).toString(16);
		}
		str+="<style　type='text/css'>.format{mso-number-format:'\@';}</style>";
		//   str+= '<table width="'+dg.width+'" border="1"><thead><tr width="'+dg.width+'" style="background-color:#' +Number((hcolor[0])).toString(16)+'">';   
		str+= '<table align="center" width="'+dg.width+'" border="1"><thead><tr width="'+dg.width+'" style="background-color:#' +x+'">';  
		
		//设置tableheader数据(从datagrid的header检索headerText信息)                  
		for(var i:int = 0;i<dg.columns.length;i++) {   
			colors = dg.getStyle("themeColor");   
			
			if(dg.columns[i].dataField == null || dg.columns[i].dataField == ""){}else{ //表示不是操作列
				if(dg.columns[i].headerText != undefined) {   
					str+="<th "+style+">"+dg.columns[i].headerText+"</th>";   
				} else {   
					str+= "<th "+style+">"+dg.columns[i].dataField+"</th>";   
				} 
			}
			
		}   
		str += "</tr></thead>";   
		colors = dg.getStyle("alternatingRowColors");   
		
		for(var j:int =0;j<dg.dataProvider.length;j++) {                    
			str+="<tr width=\""+Math.ceil(dg.width)+"\">";   
			
			for(var k:int=0; k < dg.columns.length; k++) {   
				
				if(dg.dataProvider.getItemAt(j) != undefined && dg.dataProvider.getItemAt(j) != null) {   
					if((dg.columns[k] as DataGridColumn).dataField == null || (dg.columns[k] as DataGridColumn).dataField == ""){}else{   //表示的是字段列
						if((dg.columns[k] as DataGridColumn).labelFunction != undefined) { 
							var dataGridColumn:DataGridColumn = dg.columns[k] as DataGridColumn ;
							//       str += "<td width=\""+Math.ceil((dg.columns[k] as DataGridColumn).width*WIDTHSCALE)+"\" "+style+">"+(dg.columns[k] as DataGridColumn).labelFunction(dg.dataProvider.getItemAt(j),dg.columns[k].dataField)+"</td>"; 
							str += "<td align='center' width=\""+Math.ceil(dataGridColumn.width*WIDTHSCALE)+"\" "+style+ " Class='format'>"+dataGridColumn.labelFunction(dg.dataProvider.getItemAt(j),dataGridColumn)+"</td>";
							//       //"+dg.columns[k].labelFunction(dg.dataProvider.getItemAt(j),dg.columns[k].dataField)+"
						} else {   
							str += "<td align='center' width=\""+Math.ceil(dg.columns[k].width*WIDTHSCALE)+"\" "+style+ " Class='format'>"+(dg.dataProvider.getItemAt(j)[(dg.columns[k] as DataGridColumn).dataField] == null ?"":dg.dataProvider.getItemAt(j)[(dg.columns[k] as DataGridColumn).dataField])+"</td>";   
						}   
					}
				}   
			}   
			str += "</tr>";   
		}   
		str+="</table>";   
		
		return str;   
	}   
	
	
	/**
	 * AdvancedDataGrid木有合并单元格
	 * **/
	private static function getAdvancedDGColMergeCellsNot(dg:AdvancedDataGrid,style:String,str:String):String{
		var colors:String = '';
		for(var i:int = 0;i<dg.columns.length;i++) {
			colors = dg.getStyle("themeColor");
			if(dg.columns[i].headerText != undefined) {
				str+="<th "+style+">"+dg.columns[i].headerText+"</th>";
			} else {
				str+= "<th "+style+">"+dg.columns[i].dataField+"</th>";
			}
		}
		return str ;
	}
	
	private static function createExcelFormAdvancedDG(children:Object,style:String,str:String,hcolor:Array,width:Number, count:int=1):String{
			for(var i:int=0;i<children.length;i++){
				if(children[i].hasOwnProperty("children")){
					var l:String=getColspan(children[i].children).toString();
					//1.合并单元格
					if( (children[i].headerText!=undefined) && (children[i].children.length>0) ){
						str+="<th "+style+" colspan="+l+">"+children[i].headerText+"</th>";
					}else {
						str+="<th "+style+" >"+children[i].dataField+"</th>";
					}
				}else{
					if(i==0&&count==0){
						str+= '<tr width="'+width+'" style="background-color:#' +Number((hcolor[0])).toString(16)+'">';
					}
					if(children[i].headerText != undefined) {  
						str+="<th "+style+">"+children[i].headerText+"</th>";
					}else{
						str+= "<th "+style+">"+children[i].dataField+"</th>";
					}
//					if(i==children.length-1){
//						
//					}
					
				}
			}
			if(children[0].hasOwnProperty("children")){
				str=createExcelFormAdvancedDG(children[0].children,style,str,hcolor,width,0);
				str+="</tr>";
			}
			
		return str;
	}
	
	private static function createExcelFormAdvancedDG_2(children:Object,style:String,str:String,str_f:String,hcolor:Array,width:Number, count:int=1):String{
		var str_temp_f:String=str_f;
		var arr_list:ArrayCollection = new ArrayCollection();
		for(var i:int=0;i<children.length;i++){
			
			if(count==0){
				if(children[i].hasOwnProperty("children")){
					if(i==0){
						str_temp_f+='<tr width="'+width+'" style="background-color:#' +Number((hcolor[0])).toString(16)+'">';
					}
					arr_list.addItem(children[i].children);
					var l:String=getColspan(children[i].children).toString();
					//1.合并单元格
					if( (children[i].headerText!=undefined) && (children[i].children.length>0) ){
						str_temp_f+="<th "+style+" colspan="+l+">"+children[i].headerText+"</th>";
					}else {
						str_temp_f+="<th "+style+" >"+children[i].dataField+"</th>";
					}
					if(i==children.length-1){
						if(arr_list.length>0){
							str_temp_f+="</tr>";
							str_temp_f=createExcelFormAdvancedDG_2(arr_list,style,str,str_temp_f,hcolor,width,1);
						}
					}
				}
			}else{
//				for(var j:int=0;j<children.length;j++){
					for(var jj:int=0;jj<children[i].length;jj++){
						if(children[i][jj].hasOwnProperty("children")){
							if(i==0){
								str_temp_f+='<tr width="'+width+'" style="background-color:#' +Number((hcolor[0])).toString(16)+'">';
							}
							arr_list.addItem(children[i][jj].children);
							
							var l:String=getColspan(children[i][jj].children).toString();
							//1.合并单元格
							if( (children[i][jj].headerText!=undefined) && (children[i][jj].children.length>0) ){
								str_temp_f+="<th "+style+" colspan="+l+">"+children[i][jj].headerText+"</th>";
							}else {
								str_temp_f+="<th "+style+" >"+children[i][jj].dataField+"</th>";
							}
							
						}
					}
					if(i==children.length-1){
						if(arr_list.length>0){
							str_temp_f+="</tr>";
							str_temp_f=createExcelFormAdvancedDG_2(arr_list,style,str,str_temp_f,hcolor,width,1);
						}
					}
//				}
			}
		}
		return str_temp_f;
	}
	
	
	private static function createExcelFormAdvancedDG_1(children:Object,style:String,str:String,str_f:String,hcolor:Array,width:Number, count:int=1):String{
		var str_temp_f:String=str_f;
		var str_temp_c:String=str;
		for(var i:int=0;i<children.length;i++){
			if(children[i].hasOwnProperty("children")){
				var l:String=getColspan(children[i].children).toString();
				//1.合并单元格
				if( (children[i].headerText!=undefined) && (children[i].children.length>0) ){
					str_temp_f+="<th "+style+" colspan="+l+">"+children[i].headerText+"</th>";
				}else {
					str_temp_f+="<th "+style+" >"+children[i].dataField+"</th>";
				}
				
				str_temp_c=createExcelFormAdvancedDG_1(children[i].children,style,str_temp_c,str_temp_f,hcolor,width,i);
			}else{
				if(i==0&&count==0){
					if(!bool){
						str_temp_c+= '<tr width="'+width+'" style="background-color:#' +Number((hcolor[0])).toString(16)+'">';
						bool=true;
					}
				}
				if(children[i].headerText != undefined) {  
					str_temp_c+="<th "+style+">"+children[i].headerText+"</th>";
				}else{
					str_temp_c+= "<th "+style+">"+children[i].dataField+"</th>";
				}
				
			}
		}
		
		return str_temp_c;
	}
	
	private static function getColspan(children:Object):Number{
		var l:Number=children.length;
		if(children[0].hasOwnProperty("children")){
			l=l*getColspan(children[0].children);
			
		}else{
			l=children.length;
		}
		return l;
		
	}
	
	/**
	 * AdvancedDataGrid合并单元格
	 * 1.支持标题合并列的情况
	 * **/
	private static function getAdvancedDGColMergeCellsYes(dg:AdvancedDataGrid,style:String,str:String,hcolor:Array):String{
		var colors:String = '';
		for(var i:int = 0;i<dg.groupedColumns.length;i++) {
			colors = dg.getStyle("themeColor");
			if( dg.groupedColumns[i].hasOwnProperty("children") ) { //表示有子列
				var l:String=getColspan(dg.groupedColumns[i].children).toString();
				str+= '<th '+style+' colspan='+l+'><table width="'+dg.width+'" border="1"><thead><tr width="'+dg.width+'" style="background-color:#' +Number((hcolor[0])).toString(16)+'">';
				//1.合并单元格
				if( (dg.groupedColumns[i].headerText!=undefined) && (dg.groupedColumns[i].children.length>0) ){
					str+="<th "+style+" colspan="+l+">"+dg.groupedColumns[i].headerText+"</th>";
				}else {
					str+="<th "+style+" >"+dg.groupedColumns[i].dataField+"</th>";
				}
				str+="</tr>";
//				str+= '</tr><tr width="'+dg.width+'" style="background-color:#' +Number((hcolor[0])).toString(16)+'">';
				//2.合并单元格
//				for(var j:int = 0;j<dg.groupedColumns[i].children.length; j++ ) {
//					var ll:String=getColspan(dg.groupedColumns[i].children[j].children).toString();
//					if(dg.groupedColumns[i].children[j].headerText!=undefined){    
//						str+="<th "+style+"colspan="+ll+">"+dg.groupedColumns[i].children[j].headerText+"</th>";
//					} else {
//						str+= "<th "+style+"colspan="+ll+">"+dg.groupedColumns[i].children[j].dataField+"</th>";
//					}
//				}
//				str += "</tr>";//获取子列完成-------------------
//				for(var j:int = 0;j<dg.groupedColumns[i].children.length; j++ ) {
				var str_temp_c:String="";
				var str_temp_f:String="";
				str_temp_f=createExcelFormAdvancedDG_2(dg.groupedColumns[i].children,style,str_temp_c,str_temp_f,hcolor,dg.width,0);
				str_temp_c=createExcelFormAdvancedDG_1(dg.groupedColumns[i].children,style,str_temp_c,str_temp_c,hcolor,dg.width,0);
//				}	
				str +=str_temp_f;
				str +=str_temp_c;
				str +="</tr></tr></thead></table></th>";
			} else { //表示没有子列
				if(dg.groupedColumns[i].headerText != undefined) {  
					str+="<th "+style+">"+dg.groupedColumns[i].headerText+"</th>";
				} else {
					str+= "<th "+style+">"+dg.groupedColumns[i].dataField+"</th>";
				}
			}
		}
		return str ;
	}
	
	/**
	 * AdvancedDataGrid导出excel
	 * 1.支持不合并的情况
	 * 1.支持标题合并列的情况
	 * 
	 * **/
	public  static function convertAdvancedDGToHTMLTable(dg:AdvancedDataGrid,hStr:String):String {
		var font:String = dg.getStyle('fontFamily');
		var size:String = dg.getStyle('fontSize');
		var str:String = '';
		var colors:String = '';
		var style:String = 'style="font-family:'+font+';font-size:'+size+'pt;"';               
		var hcolor:Array;
		if(hStr!=""){
			hStr=hStr.replace(".xls","");
		}
		//Retrieve the headercolor
		if(dg.getStyle("headerColor") != undefined) {
			hcolor = [dg.getStyle("headerColor")];
		} else {
			hcolor = dg.getStyle("headerColors");
		}               
		//style="font-size:18pt;fontWeight=bold"
		//Set the htmltabel based upon knowlegde from the datagrid
		str+= '<table width="'+dg.width+'" border="1"><caption align=center ><span style="font-size:18pt;fontWeight=bold">'+hStr+'</span></caption><thead><tr width="'+dg.width+'" style="background-color:#' +Number((hcolor[0])).toString(16)+'">';
		//Set the tableheader data (retrieves information from the datagrid header        
		
		//获取AdvancedDataGrid的列
		if(dg.groupedColumns.length == dg.columns.length){ //表示没有合并单元格
			str = getAdvancedDGColMergeCellsNot(dg,style,str);
		} else { //表示合并了单元格
			str = getAdvancedDGColMergeCellsYes(dg,style,str,hcolor);
		}
		
		str += "</tr></thead><tbody>";
		colors = dg.getStyle("alternatingRowColors");
		//Loop through the records in the dataprovider and
		//insert the column information into the table
		for(var j:int =0;j<dg.dataProvider.length;j++) {                   
			str+="<tr width=\""+Math.ceil(dg.width)+"\">";
			for(var k:int=0; k < dg.columns.length; k++) {
				//Do we still have a valid item?                       
				if(dg.dataProvider.getItemAt(j) != undefined && dg.dataProvider.getItemAt(j) != null) {
					//Check to see if the user specified a labelfunction which we must
					//use instead of the dataField
					if(dg.columns[k].labelFunction != undefined) {
						str += "<td text-align='center' width=\""+Math.ceil(dg.columns[k].width)+"\" "+style+">"+dg.columns[k].labelFunction(dg.dataProvider.getItemAt(j),dg.columns[k])+"</td>";
					} else {
						//Our dataprovider contains the real data
						//We need the column information (dataField)
						//to specify which key to use.
						str += "<td text-align='center' width=\""+Math.ceil(dg.columns[k].width)+"\" "+style+">"+(dg.columns[k].dataField == null ? "" : dg.dataProvider.getItemAt(j)[dg.columns[k].dataField.toString()])+"</td>";
					}
				}
			}
			str += "</tr>";
		}
		str+="</tbody></table>";
		return str;
	} 
	
	public static function exportBySource(dg:*,title:String):void{
		var htmlStr:String = convertAdvancedDGToHTMLTable(dg,title);     
		var mbytes:ByteArray = new ByteArray();     
		mbytes.writeUTFBytes(htmlStr);     
		var exportFile:FileReference = new FileReference();     
		//exportFile.addEventListener(Event.COMPLETE,saveComplete);      
		exportFile.save(mbytes,title);     

	}
	
	/**   
	 * 将制定的DataGrid加载到Excel文件，此方法传入一个htmltable字符串参数到后台Script脚本，然后浏览器给用户提供一个Excel下载   
	 * @author Chenwenfeng   
	 * @params dg 需要导入的数据源DataGrid   
	 * @params url excel文件下载路径   
	 */   
	public static function loadDGInExcel(dg:*,url:String,title:String=''):void {   
		
		//设置URLVariables参数变量，动态增加属性htmltable   
		var variables:URLVariables = new URLVariables();
		
		if(dg is DataGrid){
			variables.htmltable = convertDGToHTMLTable(dg);   
		}else if (dg is AdvancedDataGrid) {
			variables.htmltable = convertAdvancedDGToHTMLTable(dg,title);  
		}
		if(title!=""){
			variables.title = encodeURIComponent(title);
		}
		
		var u:URLRequest = new URLRequest(url);   
		u.data = variables;   
		u.method = URLRequestMethod.POST;   
		
		navigateToURL(u,"_self");
		//"_self" 指定当前窗口中的当前帧。    
		//"_blank" 指定一个新窗口。    
		//"_parent" 指定当前帧的父级。    
		//"_top" 指定当前窗口中的顶级帧。
	}
}
}