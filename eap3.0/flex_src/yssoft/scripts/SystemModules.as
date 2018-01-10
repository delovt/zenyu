/**
 * @author：zmm
 * 日期：2011-8-9
 * 功能： 系统模块 加载
 * 修改记录：
 *
 */
import yssoft.comps.CRMRichTextEditor;
import yssoft.comps.frame.ActivityTracking;
import yssoft.comps.frame.ColorDGReportVBox;
import yssoft.comps.frame.CompositeReportVBox;
import yssoft.comps.frame.ConForecastReportVBox;
import yssoft.comps.frame.CrossStatementsVBox;
import yssoft.comps.frame.CustomerRelationship;
import yssoft.comps.frame.FrameworkVBoxView;
import yssoft.comps.frame.FunnelReportVBox;
import yssoft.comps.frame.MPTYReportVBox;
import yssoft.comps.frame.PrintVbox;
import yssoft.comps.frame.StatementsVBox;
import yssoft.comps.frame.WorkdiaryWarnVBox;
import yssoft.frameui.FditemHBox;
import yssoft.frameui.FrameCore;
import yssoft.frameui.RelationshipVBox;
import yssoft.frameui.TreeFormView;
import yssoft.frameui.VouchForm;
import yssoft.views.HomeViewPro;
import yssoft.views.QuestionList;
import yssoft.views.QuestionNaire;
import yssoft.views.advancedauth.AdvancedAuthView;
import yssoft.views.authcontent.AuthcontentView;
import yssoft.views.basisfile.RdTypeView;
import yssoft.views.basisfile.WarehouseView;
import yssoft.views.bmtarget.BmTargetView;
import yssoft.views.callcenter.CallCenterCore;
import yssoft.views.callcenter_new.CallCenterCores;
import yssoft.views.consultsets.ConsultsetView;
import yssoft.views.corpCmdPerson.CorpCmdPersonView;
import yssoft.views.corporation.CorporationView;
import yssoft.views.customer.CsCustomerRecord;
import yssoft.views.department.DepartmentView;
import yssoft.views.expensesBudget.BudgetItemView;
import yssoft.views.expensesBudget.BudgetMainListView;
import yssoft.views.expensesBudget.BudgetView;
import yssoft.views.forms.RelationDesign;
import yssoft.views.importData.ImportCsPersonDataView;
import yssoft.views.importData.ImportCustProductDataView;
import yssoft.views.importData.ImportDataView;
import yssoft.views.importData.ImportMrcustDataView;
import yssoft.views.importData.ImportOaWorkdiaryDataView;
import yssoft.views.importData.ImportSrBillDataView;
import yssoft.views.importData.ImportSrFeedBackDataView;
import yssoft.views.importData.ImportSrKnowledgeDataView;
import yssoft.views.listset.ListsetView;
import yssoft.views.materies.ComputationUnitView;
import yssoft.views.materies.MateriesProductView;
import yssoft.views.materies.MateriesRecord;
import yssoft.views.materies.ProductClassView;
import yssoft.views.materies.ProductgroupView;
import yssoft.views.menus.MenuMainView;
import yssoft.views.operauth.OperauthView;
import yssoft.views.operlog.SystemLogs;
import yssoft.views.person.PersonDataEditView;
import yssoft.views.person.PersonVBoxView;
import yssoft.views.plan.MyPlanView;
import yssoft.views.plan.PlanListView;
import yssoft.views.plan.PlanMainView;
import yssoft.views.postclass.PostclassView;
import yssoft.views.printreport.PrintDesign;
import yssoft.views.printreport.PrintPreview;
import yssoft.views.printreport.PrintView;
import yssoft.views.roles.RoleView;
import yssoft.views.smsset.AsSmssetView;
import yssoft.views.sysmanage.AC_tableView;
import yssoft.views.sysmanage.AcPrintView;
import yssoft.views.sysmanage.AcqueryclmView;
import yssoft.views.sysmanage.AsAuthcontent;
import yssoft.views.sysmanage.DataClassView;
import yssoft.views.sysmanage.DataRightView;
import yssoft.views.sysmanage.DatadictionaryView;
import yssoft.views.sysmanage.FuncregeditView;
import yssoft.views.sysmanage.MessageMiddle;
import yssoft.views.sysmanage.NumberSetView;
import yssoft.views.sysmanage.ObjectDefine;
import yssoft.views.sysmanage.RoleDataView;
import yssoft.views.sysmanage.SysDataView;
import yssoft.views.sysmanage.SysOptionView;
import yssoft.views.sysmanage.VouchVbox;
import yssoft.views.twitter.TwitterDetailView;
import yssoft.views.twitter.TwitterIssueView;
import yssoft.views.twitter.TwitterListView;
import yssoft.views.twitter.TwitterMainView;
import yssoft.views.twitter.TwitterOaplanCdetailView;
import yssoft.views.twitter.TwitterParentView;
import yssoft.views.twitter.TwitterTypeView;
import yssoft.views.workfform.FWFPaintView;
import yssoft.views.workfform.FWFlow;
import yssoft.views.workfform.TplManageView;
import yssoft.views.workflow.ActiveAnalyseBoard;
import yssoft.views.workflow.ActiveBoard;
import yssoft.views.workflow.CoManager;
import yssoft.views.workflow.FreeCoView;
import yssoft.views.workflow.ZFFreeCoView;

private var importsrfeedbackdataview:ImportSrFeedBackDataView = null;//回访导入
private var advancedauthview:AdvancedAuthView = null;
private var asSmssetView:AsSmssetView = null;//服务商配置
private var bmTargetView:BmTargetView = null;//计划指标
private var dataRightView:DataRightView=null;
private var roleDataView:RoleDataView=null;
private var menuMainView:MenuMainView=null;
private var consultsetView:ConsultsetView=null;
private var freeCoView:FreeCoView=null;
private var roleview:RoleView = null;
private var departmentView:DepartmentView=null;

//lr add
private var corporationView:CorporationView=null;
private var corpCmdPersonView:CorpCmdPersonView = null;
private var warehouseView:WarehouseView = null;
private var rdTypeView:RdTypeView = null;

private var importDataView:ImportDataView=null;
private var importCsPersonDataView:ImportCsPersonDataView = null;
private var importOaWorkdiaryDataView:ImportOaWorkdiaryDataView = null;
private var importSrBillDataView:ImportSrBillDataView = null;
private var importSrKnowledgeDataView:ImportSrKnowledgeDataView=null;
private var activeAnalyseBoard:ActiveAnalyseBoard=null;
private var twitterOaplanCdetailView:TwitterOaplanCdetailView=null;
private var importMrcustDataView:ImportMrcustDataView = null;
private var importCustProductDataView:ImportCustProductDataView = null;



private var funnelReportVBox:FunnelReportVBox = null;
private var wordiaryWarnVBox:WorkdiaryWarnVBox = null;
private var colorDGReportVBox:ColorDGReportVBox = null;
private var compositeReportVBox:CompositeReportVBox = null;
private var conForecastReportVBox:ConForecastReportVBox = null;
private var myPlanView:MyPlanView = null;
private var planMainView:PlanMainView = null;
private var planListView:PlanListView = null;
private var customerRelationship:CustomerRelationship = null;
private var treeFormView:TreeFormView = null;

private var listsetView:ListsetView =null;
private var datadictonaryView:DatadictionaryView = null;
private var messageMiddle:MessageMiddle = null; //消息中心列表


private var authcontentView:AuthcontentView=null;
private var funcregeditView:FuncregeditView = null;//功能注册
private var acqueryclmView:AcqueryclmView = null;//查询定制
private var dataclassView:DataClassView = null;//档案分类
private var sysdataView:SysDataView = null;//系统档案
private var numberSetView:NumberSetView = null;//单据编码
private var asauthcontent:AsAuthcontent = null;//权限设置
private var acprintsetView:AcPrintView = null;//YJ Add 打印设置
private var postclassView:PostclassView = null;
private var operauthView:OperauthView=null;
private var mPTYReportVBox:MPTYReportVBox=null;


private var personVBoxView:PersonVBoxView = null;
private var personDataEditView:PersonDataEditView=null;
private var coManager:CoManager = null;
private var tplManger:TplManageView=null;

private var twitterParentView:TwitterParentView=null;
private var twitterTypeView:TwitterTypeView=null;
private var twitterMainView:TwitterMainView=null;
private var twitterIssueView:TwitterIssueView=null;
private var twitterListView:TwitterListView=null;
private var twitterDetailView:TwitterDetailView=null;

private var productClassView:ProductClassView = null; //物料分类
private var productgroupView:ProductgroupView = null; //物料分组
private var computationUnitView:ComputationUnitView = null;//计量单位

private var materiesRecord:MateriesRecord = null; //物料档案
private var materiesProductView:MateriesProductView = null ; //物料管理
private var fwflow:FWFlow=null;
private var fwfpaintView:FWFPaintView=null;
private var activeboard:ActiveBoard=null;
private var activityTracking:ActivityTracking=null;


private var csCustomerRecord:CsCustomerRecord = null;
private var budgetItemView:BudgetItemView = null; //预算项目
private var budgetView:BudgetView = null;				//预算明细
private var budgetMainListView:BudgetMainListView = null; //预算列表
private var objectDefine:ObjectDefine = null;  //相关项目
private var systemLogs:SystemLogs=null;
private var printView:PrintView;//打印预览
private var printDesign:PrintDesign;//打印设计
private var printPreview:PrintPreview;//打印预览

//框架
private var frameworkVBoxView:FrameworkVBoxView = null;

private var crmrichtexteditor:CRMRichTextEditor=null;

//系统选项（安全策略）
private var sysOptionView:SysOptionView=null;
//纯数据字典设置
private var ac_tableView:AC_tableView=null;

private var vouchVbox:VouchVbox=null;

private var framCore:FrameCore =null;

private var homeViewPro:HomeViewPro = null;

private var relationDesign:RelationDesign=null;

private var callcentercore:CallCenterCore=null;

private var callcentercore_new:CallCenterCores = null;

private var vouchForm:VouchForm=null;

private var relationshipVBox:RelationshipVBox;

private var zfFreeCoView:ZFFreeCoView=null;

private var crossStatementsVBox:CrossStatementsVBox=null;

private var statementsVBox:StatementsVBox=null

private var fditemHBox:FditemHBox=null;

private var pringVbox:PrintVbox = null;

private var qn:QuestionNaire = null;

private var ql:QuestionList = null;