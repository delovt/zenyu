/**
 * 	模块名称：ProductConfigScript(BOM管理)
 *  模块功能：BOM管理中业务维护
 * 			 1、BOM的新增
 * 			 2、BOM的修改
 * 			 3、BOM的删除
 * 			 4、BOM的浏览
 *  创建人： YJ
 *  创建时间：2012-02-10
 * 
 * */

import mx.collections.ArrayCollection;
import yssoft.tools.CRMtool;
//产品模块列集合
[Bindable]
public var pcolumns:ArrayCollection = new ArrayCollection([
										{cfield:"ccode",ccaption:"产品编码"},
										{cfield:"cname",ccaption:"产品名称"},
										{cfield:"ctype",ccaption:"站点及价格控制方式"}]);
//固定基数列集合
[Bindable]
public var fixnumcolumns:ArrayCollection = new ArrayCollection([
										{cfield:"quas",ccaption:"数量(从)"},
										{cfield:"quae",	ccaption:"数量(到)"},
										{cfield:"quap",	ccaption:"价格"}]);
//阶梯增量列集合
[Bindable]
public var stepnumcolumns:ArrayCollection = new ArrayCollection([
										{cfield:"steps",ccaption:"数量(从)"},
										{cfield:"stepe",ccaption:"数量(到)"},
										{cfield:"stepp",ccaption:"价格"}]);

//产品模块数据集合
[Bindable]
public var pdata:ArrayCollection = new ArrayCollection();
//固定基数数据集合
[Bindable]
public var fdata:ArrayCollection = new ArrayCollection();
//阶梯增量数据集合
[Bindable]
public var sdata:ArrayCollection = new ArrayCollection();

[Bindable]
protected var arr_menubar:ArrayCollection = new ArrayCollection([
										{label:"增加",name:"onNew"},
										{label:"修改",name:"onEdit"},
										{label:"删除",name:"onDelete"},
										{label:"保存",name:"onSave"},
										{label:"放弃",name:"onGiveUp"}]);


/*****************      YJ　Add 2012-02-10 业务处理		*****************/

/*
	函数名称：ini
	函数功能：初始化BOM管理界面
	函数参数：
	创建者：  YJ
	创建日期：2012-02-09
*/
private function ini():void{
	
}