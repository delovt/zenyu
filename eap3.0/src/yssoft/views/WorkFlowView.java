/**
 *
 * 文件名：WorkFlowView.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-22    
 * 版权所有  徐州市增宇软件有限公司
 *
 */
package yssoft.views;

import org.apache.log4j.Logger;
import yssoft.consts.SysConstant;
import yssoft.exceptions.CRMRuntimeException;
import yssoft.services.*;
import yssoft.utils.FileUtil;
import yssoft.utils.LogOperateUtil;
import yssoft.utils.ToXMLUtil;
import yssoft.utils.ToolUtil;
import yssoft.vos.*;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * 项目名称：yscrm
 * 类名称：WorkFlowView
 * 类描述：
 * 创建人：zmm
 * 创建时间：2011-2011-8-22 下午04:35:18
 */
public class WorkFlowView {

    private Logger logger = Logger.getLogger(WorkFlowView.class);

    private IWorkFlowService iWorkFlowService;
    private IInvoicepropertyService iInvoicepropertyService;
    private IWFMessageService iWFMessageService;
    private FileUtil fileUtil;
    public ICommonalityService getiCommonalityService() {
        return iCommonalityService;
    }

    public void setiCommonalityService(ICommonalityService iCommonalityService) {
        this.iCommonalityService = iCommonalityService;
    }

    private ICommonalityService iCommonalityService;
    private IPrintService iPrintService;

    private IMsgService iMsgService;

    public void setiMsgService(IMsgService iMsgService) {
        this.iMsgService = iMsgService;
    }

    public void setiPrintService(IPrintService iPrintService) {
        this.iPrintService = iPrintService;
    }

    private IYwhandler iYwhandler;

    public void setiYwhandler(IYwhandler iYwhandler) {
        this.iYwhandler = iYwhandler;
    }

    public void setFileUtil(FileUtil fileUtil) {
        this.fileUtil = fileUtil;
    }

    private IAbInvoiceatmService iAbInvoiceatmService;
//	private IWorkFlowManageService iWorkFlowManageService;
//
//	public void setiWorkFlowManageService(
//			IWorkFlowManageService iWorkFlowManageService) {
//		this.iWorkFlowManageService = iWorkFlowManageService;
//	}

    public void setiAbInvoiceatmService(IAbInvoiceatmService iAbInvoiceatmService) {
        this.iAbInvoiceatmService = iAbInvoiceatmService;
    }

    public void setiWFMessageService(IWFMessageService iWFMessageService) {
        this.iWFMessageService = iWFMessageService;
    }

    public void setiInvoicepropertyService(IInvoicepropertyService iInvoicepropertyService) {
        this.iInvoicepropertyService = iInvoicepropertyService;
    }

    public void setiWorkFlowService(IWorkFlowService iWorkFlowService) {
        this.iWorkFlowService = iWorkFlowService;
    }

    /**
     * insertOAinvoice(这里用一句话描述这个方法的作用)
     * 创建者：zmm
     * 创建时间：2011-2011-8-23 上午11:27:02
     * 修改者：lovecd
     * 修改时间：2011-2011-8-23 上午11:27:02
     * 修改备注：
     *
     * @param name
     * @return int
     * @Exception 异常对象
     */

    //发送 与 第一次暂存都走这里
    public int insertOAinvoice(HashMap hashMap) {

        List nodes = (List) hashMap.get("nodes");
        int len = nodes.size();
        OAinvoiceVo oainvoiceVo = (OAinvoiceVo) nodes.get(len - 1);
        int iid = 0;
        String inodeid = null; //主要是针对 开始节点
        boolean issend = false;
        HashMap logParams = new HashMap();
        try {
            iid = this.iWorkFlowService.insertOAinvoice(oainvoiceVo);
            if (iid == 0) {
                throw new CRMRuntimeException("工作流，插入单据数据失败");
            }
            HashMap params = new HashMap();
            params.put("ifuncregedit", 10);
            params.put("iinvoice", iid);
            params.put("iworkflow", "");
            params.put("ccode", "");
            params.put("iform", "");
            params.put("isourceregedit", "");
            params.put("isource", "");
            params.put("imaker", oainvoiceVo.getImaker());
            logParams = params;
            this.iInvoicepropertyService.insertImaker(params);

            //插入 工作流节点 信息
            for (int i = 0; i < len - 1; i++) {
                WfNodeVo wfnodeVo = (WfNodeVo) nodes.get(i);
                wfnodeVo.setIoainvoice(iid);
                if ("startnode".equals(wfnodeVo.getIpnodeid())) {
                    inodeid = wfnodeVo.getInodeid();
                }
                if (wfnodeVo.getInodelevel() == 2 && wfnodeVo.getIstatus() == 3) { // 判断是发送还是暂存
                    issend = true;
                }
                insertWorkFlowNode(wfnodeVo);

                if (wfnodeVo.getInodetype() != 0) { //只对非人员节点做处理
                    HashMap param = new HashMap();
                    param.put("ioainvoice", "" + wfnodeVo.getIoainvoice());
                    param.put("inodeid", wfnodeVo.getInodeid());
                    param.put("istatus", "" + wfnodeVo.getIstatus());
                    param.put("nodeType", "" + wfnodeVo.getInodetype());
                    param.put("nodeValue", "" + wfnodeVo.getInodevalue());
                    param.put("iperson", hashMap.get("iperson") + "");
                    insertNodeDetail(param);
                }
            }

            // 写入工作流节点对应的消息提示
            if (issend && inodeid != null && !inodeid.equals("")) {
                this.insertNodeItemsMsg("发起", inodeid, 10, iid, hashMap);
                HrPersonVo person = (HrPersonVo) iUserService.getUser(hashMap);
                //int ifunid,int iinvoice,int ipersonid,int idepartmentid,int irole
                this.xgryInsertItemWF(10, iid, person.getIid(), person.getIdepartment(), 1);

                this.insertDJxgr(10, iid, iid, 2, inodeid, "zy");
            }

            System.out.println("----------------------------iinvoice[" + (Integer) params.get("iinvoice") + "]");
            //wtf add 日志
            String result = "";
            if (iid != 0) {
                result = "success";
            } else {
                result = "fail";
            }
            logParams.put("iifuncregedit", 10);
            HashMap<String, Serializable> map = new HashMap<String, Serializable>();
            map.put("operate", "add");
            map.put("result", result);
            map.put("iinvoice", iid);
            map.put("params", logParams);
            LogOperateUtil.insertLog(map);
            //wtf add over

            return iid;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("工作流，插入详细数据失败！");
        }
    }

    /**
     * getNodeTypeDetail(获取节点类型对应的组织信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-8-23 上午11:31:51
     * 修改者：lovecd
     * 修改时间：2011-2011-8-23 上午11:31:51
     * 修改备注：
     *
     * @param name
     * @return String
     * @Exception 异常对象
     */
    public String getNodeTypeDetail(String nodeType) {
        List list = this.iWorkFlowService.getNodeTypeDetail(nodeType);
        return ToXMLUtil.createTree(list, "iid", "ipid", "-1");
    }

    /**
     * getPersons(组织对应的人员信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-8-23 下午05:11:54
     * 修改者：lovecd
     * 修改时间：2011-2011-8-23 下午05:11:54
     * 修改备注：
     *
     * @param name
     * @return String
     * @Exception 异常对象
     */
    public String getPersons(HashMap params) {
        List list = this.iWorkFlowService.getPersons(params);
        if (list.size() == 0) {
            list = null;
        } else {
            HashMap hmap = (HashMap) list.get(0);
            if (hmap.get("iid") == null) {
                list = null;
            }
        }
        return ToXMLUtil.createTree(list, "iid", "ipid", "-1");
    }

    /**
     * insertWorkFlowNode(插入节点信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-8-24 上午09:42:59
     * 修改者：lovecd
     * 修改时间：2011-2011-8-24 上午09:42:59
     * 修改备注：
     *
     * @param name
     * @return int
     * @Exception 异常对象
     */
    public int insertWorkFlowNode(WfNodeVo params) throws Exception {
        return this.iWorkFlowService.insertWorkFlowNode(params);
    }

    /**
     * insertNodeDetail(插入组织节点 对应的详细人员信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-8-24 上午09:44:28
     * 修改者：lovecd
     * 修改时间：2011-2011-8-24 上午09:44:28
     * 修改备注：
     *
     * @param name
     * @return int
     * @Exception 异常对象
     */
    public void insertNodeDetail(HashMap params) throws Exception {
        this.iWorkFlowService.insertNodeDetail(params);
    }

    /**
     * getWorkFlow(获取当前登录用户的 协同信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-8-24 下午02:21:59
     * 修改者：lovecd
     * 修改时间：2011-2011-8-24 下午02:21:59
     * 修改备注：
     *
     * @param name
     * @return List
     * @Exception 异常对象
     */
    public List getWorkFlows() {
        return this.iWorkFlowService.getWorkFlows(null);
    }

    /**
     * getWorkFlow(获取指定协同 的单据信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-8-25 下午01:58:03
     * 修改者：lovecd
     * 修改时间：2011-2011-8-25 下午01:58:03
     * 修改备注：
     *
     * @param iid 协同的iid
     * @return HashMap
     * @Exception 异常对象
     */
    public OAinvoiceVo getWorkFlow(int iid) {
        return this.iWorkFlowService.getWorkFlow(iid);
    }

    public HashMap getWorkFlowAndHandleNode(HashMap params) {
        //int iid,String optType,int iperson
        int iid = (Integer) params.get("ioainvoice");
        String optType = (String) params.get("optType");

        HashMap map = new HashMap();
        map.put("oa", this.iWorkFlowService.getWorkFlow(iid));

        if (optType.equals(SysConstant.XTGL_OPT_DFSX) || optType.equals(SysConstant.XTGL_OPT_GZSX) || optType.equals(SysConstant.XTGL_OPT_YFSX)) {//获取发起人节点
            map.put("handleNode", getStartNodeInfo(iid));
        } else {
//			HashMap param=new HashMap();
//			param.put("iperson",iperson);
//			param.put("ioainvoice",iid);
            map.put("handleNode", getCurNodeInfo(params));
        }

        return map;
    }

    /**
     * getWorkFlowNodes(获取工作流的详细信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-8-25 下午01:56:50
     * 修改者：lovecd
     * 修改时间：2011-2011-8-25 下午01:56:50
     * 修改备注：
     *
     * @param ioainvoice 协同的iid
     * @return HashMap
     * @Exception 异常对象
     */
    public HashMap getWorkFlowNodes(int ioainvoice) {
        HashMap map = new HashMap();
        List nodeList = this.iWorkFlowService.getWorkFlowNodes(ioainvoice);
        String nodeStr = ToXMLUtil.createTree(nodeList, "inodeid", "ipnodeid", "startnode");
        List nodeDetailList = this.iWorkFlowService.getWorkFlowNodeDetails(ioainvoice);
        map.put("nodeStr", nodeStr);
        map.put("nodeDetailList", nodeDetailList);
        return map;
    }

    /**
     * getWorkFlewInfo(获取完整的工作流信息，单据信息，节点信息，节点的详细信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-8-25 下午02:00:52
     * 修改者：lovecd
     * 修改时间：2011-2011-8-25 下午02:00:52
     * 修改备注：
     *
     * @param iid 协同的iid
     * @return HashMap
     * @Exception 异常对象
     */
    public HashMap getWorkFlowInfo(int iid) {
        HashMap map = new HashMap();
        List nodeList = this.iWorkFlowService.getWorkFlowNodes(iid);
        String nodeStr = ToXMLUtil.createTree(nodeList, "inodeid", "ipnodeid", "startnode");
        List nodeDetailList = this.iWorkFlowService.getWorkFlowNodeDetails(iid);
        map.put("OAinvoiceVo", getWorkFlow(iid));
        map.put("nodeStr", nodeStr);
        map.put("nodeDetailList", nodeDetailList);
        return map;
    }

    /**
     * crmPage(分页)
     * 创建者：lovecd
     * 创建时间：2011-2011-8-25 下午02:00:52
     * 修改者：lovecd
     * 修改时间：2011-2011-8-25 下午02:00:52
     * 修改备注：
     *
     * @param iid 协同的iid
     * @return HashMap
     * @Exception 异常对象
     */
    public HashMap crmPage(HashMap params) {
        return this.iWorkFlowService.crmPage(params);
    }

    public String editWorkFlow(HashMap params) {
        try {
            String ioainvoice = this.iWorkFlowService.editWorkFlow(params);

            // 发起人 负责人权限
            HrPersonVo person = (HrPersonVo) iUserService.getUser(params);
            //int ifunid,int iinvoice,int ipersonid,int idepartmentid,int irole
            this.xgryInsertItemWF(10, Integer.parseInt(ioainvoice), person.getIid(), person.getIdepartment(), 1);

            this.insertDJxgr(10, Integer.parseInt(ioainvoice), Integer.parseInt(ioainvoice), 2, "startnode", "zj");


            return ioainvoice;
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return null;
    }

    /***************************************系统消息回复********************************************/
    /**
     * getMessages(获取发起人消息列表)
     * 创建者：lovecd
     * 创建时间：2011-2011-9-1 下午02:13:43
     * 修改者：lovecd
     * 修改时间：2011-2011-9-1 下午02:13:43
     * 修改备注：
     *
     * @param name
     * @return List
     * @throws Exception
     * @Exception 异常对象
     */
    public List getMessages(HashMap params) {
        try {
//			WfNodeVo handleNode=this.getCurNodeInfo(params);
//			params.put("isStartNode",handleNode.getIpnodeid());
            return this.iWFMessageService.getMessages(params);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("获取发起人协同回复信息出错");
        }
    }

    // 插入震荡消息
    public int insertzdmsg(HashMap params) {
        int retid = this.iWFMessageService.insertzdmsg(params); // 插入震荡信息后，返回的主键iid
        if (params.get("ists") != null) {
            try {
                if (retid > 0) {
                    params.put("imessages", retid);
                    this.iWFMessageService.insertdszdmsg(params);
                    System.out.println("---插入推送的震荡消息---");
                } else {
                    System.out.println("---震荡消息插入不成功---");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return retid;
    }

    // 获取 震荡消息
    public HashMap getzdmsgs(HashMap params) {
        HashMap ret = new HashMap();
        List zdlist = this.iWFMessageService.getzdmsgs(params);
        List ydlist = this.iWFMessageService.getdszdmsgs(params);
        ret.put("zdlist", zdlist);
        ret.put("ydlist", ydlist);
        return ret;
    }

    /**
     * getMessagesHide(获取非发起人消息列表)
     * 创建者：lovecd
     * 创建时间：2011-2011-9-3 上午08:40:47
     * 修改者：lovecd
     * 修改时间：2011-2011-9-3 上午08:40:47
     * 修改备注：
     *
     * @param name
     * @return List
     * @Exception 异常对象
     */
    public List getMessagesHide(HashMap params) {
        try {
            return this.iWFMessageService.getMessagesHide(params);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("获取非发起人协同回复信息出错");
        }
    }

    /**
     * insertMessage(新增协同回复信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-9-1 下午02:18:21
     * 修改者：lovecd
     * 修改时间：2011-2011-9-1 下午02:18:21
     * 修改备注：
     *
     * @param name
     * @return int
     * @Exception 异常对象
     */
    public int insertMessage(WfMessageVo wfMessageVo) {
        try {
            return this.iWFMessageService.insertMessage(wfMessageVo);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("新增协同回复信息出错");
        }
    }

    // 暂存待办
    public int zcdbHandler(HashMap param) throws Exception {
        WfMessageVo wfMessageVo = (WfMessageVo) param.get("msgvo");
        int ret = insertMessage(wfMessageVo);
        String inodeid = (String) param.get("inodeid");
        int ioainvoice = (Integer) param.get("ioainvoice");
        this.insert_pnode_items_msg("暂存待办", inodeid, 10, ioainvoice, param);
        return ret;
    }

    /**
     * getCurNodeInfo(获取用户当前处在的节点位置)
     * 创建者：lovecd
     * 创建时间：2011-2011-9-2 下午05:53:29
     * 参数： 协同iid ，ipersoniid
     * 修改者：lovecd
     * 修改时间：2011-2011-9-2 下午05:53:29
     * 修改备注：
     *
     * @param name
     * @return WfNodeVo
     * @Exception 异常对象
     */
    public WfNodeVo getCurNodeInfo(HashMap params) {
        return this.iWorkFlowService.getCurNodeInfo(params);
    }

    /**
     * getStartNodeInfo(获取发起人节点)
     * 创建者：lovecd
     * 创建时间：2011-2011-9-4 下午11:14:45
     * 修改者：lovecd
     * 修改时间：2011-2011-9-4 下午11:14:45
     * 修改备注：
     *
     * @param params 协同的 iid
     * @return WfNodeVo
     * @Exception 异常对象
     */
    public WfNodeVo getStartNodeInfo(int params) {
        return this.iWorkFlowService.getStartNodeInfo(params);
    }

    /**
     * wfHandleNode(相关节点 推进)
     * 创建者：lovecd
     * 创建时间：2011-2011-9-5 下午02:46:08
     * 修改者：lovecd
     * 修改时间：2011-2011-9-5 下午02:46:08
     * 修改备注：
     *
     * @param name
     * @return int
     * @Exception 异常对象
     */
    //自由协同处理
    @SuppressWarnings("unchecked")
    public int wfHandleNode(HashMap params) {
        String result = "suc";
        try {
            WfMessageVo wfMessageVo = (WfMessageVo) params.get("msgvo");
            params.remove("msgvo");
            String ret = this.iWorkFlowService.wfHandleNode(params);

            // 向父节点返回信息
            int ioainvoice = (Integer) params.get("ioainvoice");
            String inodeid = (String) params.get("inodeid");
            this.insert_pnode_items_msg("已被处理", inodeid, 10, ioainvoice, params);

            //插入工作流 相关人权限

            if ("wf_xgry".equals(ret)) {
                this.insertDJxgr(10, ioainvoice, ioainvoice, 2, inodeid, "zy");
            }

            return insertMessage(wfMessageVo);
        } catch (Exception e) {
            result = "fail";
            throw new CRMRuntimeException("修改暂存待发，发起人节点推进信息出错");
        } finally {
            /**
             * SDY  添加系统操作日志
             */
            if (null == params.get("flag")) {
//				HashMap<String, Serializable> map_ = new HashMap<String, Serializable>();
//				map_.put("operate", " 自由协同回复处理 ");
//				map_.put("result", result);
//				params.put("iinvoice",params.get("ioainvoice"));
//				params.put("ifuncregedit",10); //自由协同注册码为10 （固定）
//				map_.put("params",params);
//				LogOperateUtil.insertLog(map_);
            }
        }
    }


    /**
     * insertFile(协同 上传文件)
     * 创建者：lovecd
     * 创建时间：2011-2011-9-5 下午02:46:08
     * 修改者：lovecd
     * 修改时间：2011-2011-9-5 下午02:46:08
     * 修改备注：
     *
     * @param name
     * @return int
     * @Exception 异常对象
     */
    public int insertFile(AbInvoiceatmVo params) throws Exception {
        return this.iAbInvoiceatmService.insertFile(params);
    }

    public List selectFile(HashMap params) {
        return this.iAbInvoiceatmService.selectFile(params);
    }

    public int deleteFile(Object params) {
        try {
            return this.iAbInvoiceatmService.deleteFile(params);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("业务单据公共附件表，删除文件出错");
        }
    }

    //批量上传文件
    @SuppressWarnings({"unchecked", "finally"})
    public String batchUploadFile(List list) {
        String result = "suc";
        if (list == null || list.size() == 0) {
            return "fail";
        }
        int listlen = list.size();
        try {
            for (int i = 0; i < listlen; i++) {
                AbInvoiceatmVo abvo = (AbInvoiceatmVo) list.get(i);


                //判断文件是不是已经存在，转化的
                String oldfile = abvo.getCsysname();

                // 生成唯一的文件名
                String syscname = ToolUtil.generateUpLoadFileName(abvo.getIinvoice() + "_" + abvo.getIperson() + "_");
                //暂停下的
                Thread.sleep(300);
                abvo.setCsysname(syscname);
                // 文件信息 入库
                insertFile(abvo);
                // 上传文件
                HashMap params = new HashMap();
                params.put("fileName", syscname);
                params.put("fileType", abvo.getCextname());
                params.put("uploadType", "1");
                params.put("content", abvo.getFdata());
                params.put("oldfile", oldfile);
                this.fileUtil.uploadFile(params);
            }
        } catch (Exception e) {
            result = "fail";
            e.printStackTrace();
            throw new CRMRuntimeException("业务单据公共附件表，批量上传文件出错");
        } finally {

            /**
             * SDY  添加系统操作日志
             */
            HashMap map_ = new HashMap();
            map_.put("operate", "上传附件 数量:" + list.size());
            map_.put("result", result);

//			AbInvoiceatmVo abvo=(AbInvoiceatmVo) list.get(0);
//			HashMap map_0 = new HashMap();
//			map_0.put("iinvoice",abvo.getIinvoice());
//			map_0.put("ifuncregedit",abvo.getIfuncregedit());
//			map_.put("params",map_0);
//			LogOperateUtil.insertLog(map_);
            return result;

        }
    }

    //删除文件
    public void deleteRealFile(HashMap params) {
        this.fileUtil.deleteFile(params);
    }

    // 
    public byte[] downRealFile(HashMap params) {
        return this.fileUtil.downFile(params);
    }

    // 协同删除 文件
    public String wfDeleteFile(HashMap params) {
        try {
            deleteRealFile(params);
            deleteFile(params);
            return "suc";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "fail";
    }

    public String deleteWorkFlow(HashMap iid) {
        try {
            this.iWorkFlowService.deleteWorkFlow(iid);
            return "suc";
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("删除协同错误");
        }
    }

    /**
     * zjEditWorkFlow(这里用一句话描述这个方法的作用)
     * 创建者：lovecd
     * 创建时间：2011-2011-9-8 下午06:47:58
     * 修改者：lovecd
     * 修改时间：2011-2011-9-8 下午06:47:58
     * 修改备注：
     *
     * @param name
     * @return int
     * @Exception 异常对象
     */
    public int zjEditWorkFlow(HashMap params) {
        try {
            OAinvoiceVo oainvoiceVo = (OAinvoiceVo) params.get("oAinvoiceVo");
            updateOAinvoice(oainvoiceVo);
            params.remove("oAinvoiceVo");
            int ioainvoice = this.iWorkFlowService.zjEditWorkFlow(params);
            // 发起人 负责人权限
            HrPersonVo person = (HrPersonVo) iUserService.getUser(params);
            //int ifunid,int iinvoice,int ipersonid,int idepartmentid,int irole
            this.xgryInsertItemWF(10, ioainvoice, person.getIid(), person.getIdepartment(), 1);
            this.insertDJxgr(10, ioainvoice, ioainvoice, 2, "startnode", "zj");

            return ioainvoice;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("待发中，发送协同错误");
        }
    }

    /**
     * updateOAinvoice(修改协同信息)
     * 创建者：lovecd
     * 创建时间：2011-2011-9-9 上午08:35:41
     * 修改者：lovecd
     * 修改时间：2011-2011-9-9 上午08:35:41
     * 修改备注：
     *
     * @param name
     * @return void
     * @Exception 异常对象
     */
    public String updateOAinvoice(OAinvoiceVo oainvoiceVo) throws Exception {
        this.iWorkFlowService.updateOAinvoice(oainvoiceVo);

        return "suc";
    }

    public String revocationHandler(int iid) {
        try {
            return this.iWorkFlowService.cxHandler(iid);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("跟踪事项，撤销失败");
        }
    }


    // 表单协同
    private ICoopHandlerService iCoopHandlerService;

    public void setiCoopHandlerService(ICoopHandlerService iCoopHandlerService) {
        this.iCoopHandlerService = iCoopHandlerService;
    }


    //验证 单据是否绑定了 可用的协同模板

    public HashMap co_invoset_judge(HashMap params) {
        return (HashMap) this.iCoopHandlerService.co_invoset_judge(params);
    }


    //批量 处理
    public HashMap patchCoopHandler(HashMap params) {
        HashMap ret = new HashMap();

        String ifuniid = (String) params.get("ifuncregedit");
        String iinvoices = (String) params.get("iinvoices"); // 单据内码 iid 集合
        String ipersonid = (String) params.get("ipersonid");
        // 1  获取单据对应的 表名 ，主要是 避免 前台不显示 项目令号 信息
        if (ifuniid == null || ifuniid == "") {
            ret.put("error", "后台获取不到单据对应的 功能注册码");
            return ret;
        }

        if (iinvoices == null || iinvoices == "") {
            ret.put("error", "后台获取不到单据对应的 内码集合");
            return ret;
        }

        //分解 单据内码集合
        String[] iinvoiceArray = iinvoices.split(",");
        if (iinvoiceArray == null || iinvoiceArray.length == 0) {
            ret.put("error", "后台解析不到单据对应的 内码集合");
            return ret;
        }
        // 判断 表单是否有关联的协同
        HashMap wf_invoset = (HashMap) this.iCoopHandlerService.co_invoset_judge(params);
        if (wf_invoset == null) {
            ret.put("error", "表单没有关联的协同模板");
            return ret;
        }
        String table = this.iWorkFlowService.get_form_table_name(ifuniid);
        if (table == null || table == "") {
            ret.put("error", "单据功能注册码[" + ifuniid + "],没有对应的单据的表名");
            return ret;
        }

        //boolean boo=false;
        String retStr = "";
        int sucnum = 0;
        int errornum = 0;
        try {
            for (String iinvoice : iinvoiceArray) {
                //验证 单据的状态是不是 待提交 状态
                String iwfstatus = "";
                //String sql = "select citemcode from "+table+" where iid ="+iinvoice;
                String sql = "select iwfstatus from " + table + " where iid=" + iinvoice;
                try {
                    iwfstatus = this.iWorkFlowService.getitemcode(sql);
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("无法验证表名为[" + table + "],内码为[" + iinvoice + "],关联的协同状态");
                }

                if (iwfstatus == null || iwfstatus == "" || "1".equals(iwfstatus)) {
                    retStr += "单据[" + iinvoice + "]，协同状态不可提交";
                } else { // 单据状态 为提交状态的
                    HashMap chparams = new HashMap();
                    chparams.put("ifuncregedit", Integer.parseInt(ifuniid));
                    chparams.put("iinvoice", Integer.parseInt(iinvoice));
                    String chstr = coopHandler(chparams);
                    retStr += "单据[" + iinvoice + "],流程协同[" + chstr + "]";
                    Thread.sleep(3000); //暂定3秒钟
                }
            }
            ret.put("suc", retStr);
            return ret;
        } catch (Exception e) {
            e.printStackTrace();
            ret.put("error", "单据批量提交失败");
            return ret;
        }

    }

    /**
     * 协同操作 入口
     * <p/>
     * 参数：ifuncregedit ,iinvoice--单据的iid
     */

    private IUserService iUserService;

    public IUserService getiUserService() {
        return iUserService;
    }

    public void setiUserService(IUserService iUserService) {
        this.iUserService = iUserService;
    }

    public String coopHandler(HashMap params) throws Exception {

        HrPersonVo person = (HrPersonVo) iUserService.getUser(params);

        if (person == null) {
            return "会话过期，不予操作";
        }
        int ifuncregedit = (Integer) params.get("ifuncregedit"); // 单据的 注册功能 iid
        int iinvoice = (Integer) params.get("iinvoice");         // 单据 iid

        //因为撤销时，不删除 单据对应的回复和单据与流程图的关联(只删除流程中节点的信息)，所以在提交以前要判断单据是否已经关联过流程的
        List tplist = this.iWorkFlowService.djtjcheck(params);
        int iid = 0; // 工作流 iid
        if (tplist != null) {
            if (tplist.size() == 0) {
                iid = 0;
            } else if (tplist.size() == 1) {
                iid = (Integer) ((HashMap) tplist.get(0)).get("iid");
            } else {
                return "功能注册码[" + ifuncregedit + "],单据内码[" + iinvoice + "],绑定了[" + tplist.size() + "]个流程，提交失败";
            }
        }

        // 判断 表单是否有关联的协同
        HashMap wf_invoset = (HashMap) this.iCoopHandlerService.co_invoset_judge(params);
        if (wf_invoset == null) {
            return "表单没有关联的协同模板！";
        }


        HashMap map = new HashMap();
        String startnodeid = ""; // 发起人节点iid

        //获取 模板wf_invoset表中 内码
        int iinvoset = (Integer) wf_invoset.get("iid");
        //模板名称
        String icname = (String) wf_invoset.get("cname");

        map.put("iinvoset", iinvoset);
        List nodeList = this.iCoopHandlerService.co_invosets_items(map);

        if (nodeList == null || nodeList.size() <= 1) {
            return "表单关联的协同模板，信息不完整,请联系管理员！\n模板编号:[" + iinvoset + "]";
        }


        // 添加 工作流 有效性 验证
        HashMap xxparam = new HashMap();
        xxparam.put("iwfset", iinvoset);
        xxparam.put("iwfperson", person.getIid());
        List yxxlist;
        try {
            yxxlist = this.iCoopHandlerService.checkformwf(xxparam);
            if (yxxlist != null && yxxlist.size() != 0) {
                logger.info("工作流提交失败原因:" + yxxlist.toString());
                return "当前发起人，对应的工作流模板，有空节点，\n工作流不予提交\n[" + getCmemo(yxxlist) + "]";
            }
        } catch (Exception e1) {
            e1.printStackTrace();
        }


        //表单对应的协同模板 转移至 工作流中
        OAinvoiceVo oainvoiceVo = new OAinvoiceVo(); // 构建 单据对象信息
        //#ifuncregedit#,#iinvoice#,#csubject#,#icustomer#,#dfinished#,#bplan#,#cdetail#,#baddnew#,#bsendnew#,#istatus#
        oainvoiceVo.setIfuncregedit(ifuncregedit);
        oainvoiceVo.setIinvoice(iinvoice);
        oainvoiceVo.setIinvoset(iinvoset);
        //oainvoiceVo.setCsubject(icname+"_"+ifuncregedit+"_"+iinvoset+"_"+iinvoice);
        oainvoiceVo.setCsubject(icname);
        try {
            // 如果 单据与流程 没有绑定关系的
            if (iid == 0) {
                iid = this.iWorkFlowService.insertOAinvoice(oainvoiceVo);
                // 写入 单据的描述信息
                map = new HashMap();
                map.put("ifuncregedit", 11);
                map.put("iinvoice", iid);
                map.put("iworkflow", "");
                map.put("ccode", "");
                map.put("iform", "");
                map.put("isourceregedit", "");
                map.put("isource", "");
                map.put("imaker", person.getIid());
                this.iInvoicepropertyService.insertImaker(map);
            }
            // iid = this.iWorkFlowService.insertOAinvoice(oainvoiceVo); 主要防止这个异常的
            if (iid == 0) {
                throw new CRMRuntimeException("协同处理，插入单据数据失败");
            }

            int len = nodeList.size();
            //插入 工作流节点 信息
            map = new HashMap();
            for (int i = 0; i < len; i++) {
                map = (HashMap) nodeList.get(i);

                String inodeid = (String) map.get("inodeid");
                String ipnodeid = (String) map.get("ipnodeid");

                int inodetype = (Integer) map.get("inodetype");

                int inodevalue = Math.abs((Integer) map.get("inodevalue"));

                int inodeattribute = (Integer) map.get("inodeattribute");

                int inodemode = (Integer) map.get("inodemode");
               // int iistatus = (Integer) map.get("iistatus");//20150521被注销,iistatus 未null时报空指针
                Integer iistatus = (Integer) map.get("iistatus");//20150521添加
//				int bfinalverify=((Boolean)map.get("bfinalverify")?1:0);
//				int baddnew=((Boolean) map.get("baddnew")?1:0);
//				int bsendnew=((Boolean) map.get("bsendnew")?1:0);

                int bfinalverify = (Integer) map.get("bfinalverify");
                int baddnew = (Integer) map.get("baddnew");
                int bsendnew = (Integer) map.get("bsendnew");
                int istatus = (Integer) map.get("istatus");
                String cnotice = (String) map.get("cnotice");
                int inodelevel = (Integer) map.get("inodelevel");
                String ccomefield = (String) map.get("ccomefield");
                String cexecsql = (String) map.get("cexecsql");

//(#ipid#,#inodeid#,#ipnodeid#,#ioainvoice#,#inodetype#,#inodevalue#,#inodeattribute#,#inodemode#,
//#bfinalverify#,#baddnew#,#bsendnew#,#istatus#,#cnotice#,#inodelevel#)

                WfNodeVo wfnodeVo = new WfNodeVo();
                wfnodeVo.setIoainvoice(iid);
                wfnodeVo.setInodeid(inodeid);
                wfnodeVo.setIpnodeid(ipnodeid);
                wfnodeVo.setInodetype(inodetype);
                wfnodeVo.setInodevalue(inodevalue);
                wfnodeVo.setInodeattribute(inodeattribute);
                wfnodeVo.setInodemode(inodemode);
                wfnodeVo.setBfinalverify(bfinalverify);
                wfnodeVo.setBaddnew(baddnew);
                wfnodeVo.setBsendnew(bsendnew);
                wfnodeVo.setCnotice(cnotice);
                wfnodeVo.setInodelevel(inodelevel);
                wfnodeVo.setCcomefield(ccomefield);
                wfnodeVo.setCexecsql(cexecsql);
                wfnodeVo.setIistatus(iistatus);

                if ("startnode".equals(wfnodeVo.getIpnodeid())) { // 如果是发起人节点，在写入协同后的，状态为1 已发送
                    wfnodeVo.setIstatus(1);
                    wfnodeVo.setInodevalue(person.getIid());
                    startnodeid = wfnodeVo.getInodeid();
                    wfnodeVo.setBavailable(1);
                }

                //判断 角色 -9 ，-10 特殊处理 ---------------------------------------------------------------------------

                if (wfnodeVo.getInodetype() == 2 && (wfnodeVo.getInodevalue() == 9 || wfnodeVo.getInodevalue() == 10)) {

                    HashMap jsmap;
                    int nodevalue = -1;

                    if (wfnodeVo.getCcomefield() != null && !wfnodeVo.getCcomefield().equals("") && !wfnodeVo.getCcomefield().equals("null")) {
                        jsmap = getDJInof(ifuncregedit, iinvoice);
                        if (jsmap == null) {
                            logger.info("单据相关节点信息不合法，生成协同失败2");
                        }
                        nodevalue = (jsmap == null || jsmap.get(wfnodeVo.getCcomefield()) == null) ? 0 : (Integer) jsmap.get(wfnodeVo.getCcomefield());
                        if (nodevalue == 0) {
                            logger.info("单据相关节点信息不合法，生成协同失败3");
                        }
                    } else {
                        logger.info("单据相关节点信息不合法,comefield字段值不存在");
                        //return "单据相关节点信息不合法，生成协同失败1";
                    }

                    //更新特殊角色的相关的节点
                    if (wfnodeVo.getInodevalue() == 9) {
                        wfnodeVo.setInodetype(0);
                    } else {
                        wfnodeVo.setInodetype(1);
                    }
                    wfnodeVo.setInodevalue(nodevalue);
                }

                // 写入节点信息
                insertWorkFlowNode(wfnodeVo);
                // 写入节点 的条件，录入
                HashMap tpmap = new HashMap();
                tpmap.put("cnodeid", inodeid);
                tpmap.put("ioainvoice", iid);
                this.iCoopHandlerService.co_insert_nodecd(tpmap);
                this.iCoopHandlerService.co_insert_nodeentry(tpmap);

                if (wfnodeVo.getInodetype() != 0) { //只对非人员节点做处理
                    HashMap param = new HashMap();
                    param.put("ioainvoice", "" + wfnodeVo.getIoainvoice());
                    param.put("inodeid", wfnodeVo.getInodeid());
                    param.put("istatus", "" + wfnodeVo.getIstatus());
                    param.put("nodeType", "" + wfnodeVo.getInodetype());
                    param.put("nodeValue", "" + wfnodeVo.getInodevalue());
                    param.put("iperson", person.getIid());
                    param.put("ijob1", person.getIjob1());
                    param.put("ijob2", person.getIjob1());
                    param.put("iperson", params.get("iperson") + "");
                    param.put("istatus", "" + wfnodeVo.getIstatus());
                    //param.put("ipost",person.getIpost());
                    //param.put("idepartment",person.getIdepartment());
                    insertNodeDetail(param);
                }
            }
            if (startnodeid != null && !startnodeid.equals("")) {
                params.put("ipnodeid", startnodeid);
                params.put("istartnode", "1"); // 1 是发起节点
                formWorkFlowGoForward(params);
            }

            //添加更新 对应单据 状态的数据
            editorFormStatus(ifuncregedit, iinvoice, 1);

            execsql((String) params.get("cexecsql"));

            return "" + iid;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("协同处理失败");
        }
    }

    //遍历list
    private String getCmemo(List list) {
        String ret = "";
        if (list == null || list.size() == 0) {
            return ret;
        }
        for (int i = 0; i < list.size(); i++) {
            HashMap hm = (HashMap) list.get(i);
            ret += (String) hm.get("cmemo") + "\n,";
        }

        return ret.substring(0, ret.length() - 1);
    }

    /**
     * 获取单据的相关信息
     */
    public HashMap getDJInof(int ifuncregedit, int iinvoice) {
        if (ifuncregedit == 0 || iinvoice == 0) {
            return null;
        }
        HashMap map = new HashMap();
        String ctable;
        //String sql;
        try {
            map = this.iWorkFlowService.co_node_ts_js(ifuncregedit);
            if (map == null) {
                return null;
            }
            ctable = (String) map.get("ctable");
            if (ctable == null || ctable == "") {
                return null;
            }
            String sql = "select * from " + ctable + " where iid=" + iinvoice;
            map = new HashMap();
            map = this.iWorkFlowService.co_node_ts_js_sql(sql);
            if (map == null) {
                return null;
            }
            return map;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    /**
     * 获取单据对应的工作流
     * <p/>
     * 参数：ifuncregedit ,iinvoice--单据的iid
     */

    public HashMap getFormWorkFlowNodes(HashMap params) {
        HashMap map = new HashMap();

        HashMap oainvoice = co_select_oainvoice(params);
        if (oainvoice == null) {
            System.out.println("该单据没有匹配的协同流程");
            return null;
        }
        int ioainvoice = (Integer) oainvoice.get("iid");
        map = this.getWorkFlowNodes(ioainvoice);
        List nodeDetailList = this.iWorkFlowService.getWorkFlowNodeDetails(ioainvoice); // 获取组织节点的详细内容
        map.put("nodecd", co_select_wfnodecd(ioainvoice));
        map.put("nodeentry", co_select_wfnodeentry(ioainvoice));
        //getCurNodeInfo
        //添加 协同的iid
        params.put("ioainvoice", ioainvoice);
        params.put("nodeDetailList", nodeDetailList);
        map.put("handlerNode", this.getCurNodeInfo(params));
        return map;
    }

    public List co_select_wfnodecd(int ioainvoice) {
        return this.iCoopHandlerService.co_select_wfnodecd(ioainvoice);
    }

    public List co_select_wfnodeentry(int ioainvoice) {
        return this.iCoopHandlerService.co_select_wfnodeentry(ioainvoice);
    }

    public HashMap co_select_oainvoice(HashMap params) {
        return (HashMap) this.iCoopHandlerService.co_select_oainvoice(params);
    }

    public HashMap co_select_abinvoiceproperty(int iinvoice) {
        return (HashMap) this.iCoopHandlerService.co_select_abinvoiceproperty(iinvoice);
    }


    /**
     * 表单协同中，发送回复
     */

//	public int wfHandleNode(HashMap params){
//		try {
//			WfMessageVo wfMessageVo=(WfMessageVo) params.get("msgvo");
//			params.remove("msgvo");
//			this.iWorkFlowService.wfHandleNode(params);
//			
//			return insertMessage(wfMessageVo);
//		} catch (Exception e) {
//			throw new CRMRuntimeException("修改暂存待发，发起人节点推进信息出错");
//		}
//	}
    public int sendFormReply(HashMap params) {
        WfMessageVo wfMessageVo = (WfMessageVo) params.get("msgvo");

        //后期添加处理---->> 下一级推进

        return insertMessage(wfMessageVo);
    }

    public List getFromReplyList(HashMap params) {
        int iinvoice = (Integer) params.get("iinvoice");
        int iperson = (Integer) params.get("iperson");
        String flag = "0"; // 不是发起人
        //首先验证是不是 发起人
        HashMap ab = co_select_abinvoiceproperty(iinvoice);
        if (ab != null && ((Integer) ab.get("imaker")) == iperson) {
            flag = "1";
        }
        HashMap map = new HashMap();
        map.put("flag", flag);
        map.put("ioainvoice", iinvoice);
        return getFormMessages(map);
    }

    public List getFormMessages(HashMap params) {
        return this.iWFMessageService.getFormMessages(params);
    }

    //---------条件判断
    public List co_zd_select_wfnodecd(HashMap params) {
        return this.iCoopHandlerService.co_zd_select_wfnodecd(params);
    }

    public List co_zd_select_wfnodeentry(HashMap params) {
        return this.iCoopHandlerService.co_zd_select_wfnodeentry(params);
    }

    //获取指定节点的 所有子节点
    public List co_select_subnodes(HashMap params) {
        return this.iCoopHandlerService.co_select_subnodes(params);
    }

    public List co_select_allnodes(HashMap params) {
        return this.iCoopHandlerService.co_select_allnodes(params);
    }

    //验证节点条件是否成立
    public int co_judge_nodecd(String sql) {
        if (sql == null || sql == "") {
            return 0;
        }
        return this.iCoopHandlerService.co_judge_nodecd(sql);
    }

    //录入 
    public void co_update_nodeentry(String sql) {
        if (sql == null || sql == "") {
            return;
        }
        this.iCoopHandlerService.co_update_nodeentry(sql);
    }

    //获取单据对应数据表名
    public String co_form_tablename(HashMap params) {
        return this.iCoopHandlerService.co_form_tablename(params);
    }

    //修改节点信息
    public void co_update_node(HashMap params) {
        this.iCoopHandlerService.co_update_node(params);
    }

    //修改节点状态信息
    public void co_update_nodes(HashMap params) {
        this.co_update_nodes(params);
    }

    //批量修改节点状态信息
    public void co_update_nodes_patch(HashMap params) {
        this.co_update_nodes_patch(params);
    }

    //同事修改 node 与 nodes 中状态信息
    public void co_updateNode(int ioainvoice, String inodeid, int status) {
        HashMap params = new HashMap();
        params.put("ioainvoice", ioainvoice);
        params.put("inodeid", inodeid);
        params.put("istatus", status);
//		co_update_node(params);
//		co_update_nodes_patch(params);
        this.iCoopHandlerService.co_updateNode(params);
    }

    /**
     * 获取单据流程推进
     * <p/>
     * 参数：ifuncregedit ,iinvoice--单据的iid,ipnodeid(节点父iid)
     * type 是否为发起节点，1 是， 其他 不是
     *
     * @throws Exception
     */
    // map 中含有 cnodeid(节点id),ipnodeid(节点父iid),ioainvoice(单据iid)
    public String formWorkFlowGoForward(HashMap map) throws Exception {
        String istartnode = (map.get("istartnode") == null ? "0" : "1");
        int ifuncregedit = (Integer) map.get("ifuncregedit");
        if (ifuncregedit <= 0) {
            return "单据对应的注册码错误";
        }
        //获取单据对应的 数据表
        String ctable = this.co_form_tablename(map);
        if (ctable == null || ctable == "") {
            return "单据没有关联的数据表";
        }
        //获取节点的 ioainvoice 
        HashMap oainvoice = co_select_oainvoice(map);
        if (oainvoice == null) {
            //System.out.println("该单据没有匹配的协同流程");
            return "该单据没有匹配的协同流程";
        }
        int iinvoice = (Integer) map.get("iinvoice"); // 单据iid
        int ioainvoice = (Integer) oainvoice.get("iid"); // 单据工作流的iid
        String ipnodeid = (String) map.get("ipnodeid");
        // 获取 父节点为 ipnodeid 的所有节点
        HashMap params = new HashMap();
        params.put("ipnodeid", ipnodeid);
        params.put("ioainvoice", ioainvoice);

        List subnodes = co_select_subnodes(params);
        if (subnodes == null || subnodes.size() == 0) {
            List nodeList = co_select_allnodes(params);
            if(nodeList.size()==0)
                editorFormStatus(ifuncregedit, iinvoice, 2);

            return "没有父节点[" + ipnodeid + "]的子节点";
        }


        // 获取每一个子节点 对应的 条件信息
        for (int i = 0; i < subnodes.size(); i++) {
            HashMap node = (HashMap) subnodes.get(i);
            String cnodeid = (String) node.get("inodeid"); // 获取节点对应的 iid
            HashMap nodeparam = new HashMap();
            //nodeparam.put("ipnodeid",ipnodeid);
            nodeparam.put("cnodeid", cnodeid);
            nodeparam.put("ioainvoice", ioainvoice);
            List co = this.co_zd_select_wfnodecd(nodeparam);
            if (co == null || co.size() == 0) {// 节点不存在 条件信息,则 直接修改 节点的状态为3 待处理
                this.co_updateNode(ioainvoice, cnodeid, 3);
                //插入 相关人 权限
                insertDJxgr(ifuncregedit, iinvoice, ioainvoice, 2, cnodeid, "yw");

                if ("1".equals(istartnode)) {
                    //this.insertNodeItemsMsg("发起",ipnodeid,ifuncregedit,ioainvoice,map);
                    this.insertNodeItemsMsgZd("发起", cnodeid, ifuncregedit, ioainvoice, map);
                } else {
                    this.insertNodeItemsMsgZd("处理", cnodeid, ifuncregedit, ioainvoice, map);
                }
            } else {
                String sql = ToolUtil.combiSql(co, ctable, "" + iinvoice, null);
                if (sql == null || sql.equals("")) {
                    System.out.println("表单协同[" + iinvoice + "]的节点[" + cnodeid + "],判断条件错误");
                    return "表单协同[" + iinvoice + "]的节点[" + cnodeid + "],判断条件错误";
                } else {
                    int cosum = this.co_judge_nodecd(sql);

                    if (cosum > 0) {//条件成立
                        this.co_updateNode(ioainvoice, cnodeid, 3);
                        //插入 相关人 权限
                        insertDJxgr(ifuncregedit, iinvoice, ioainvoice, 2, cnodeid, "yw");
                        System.out.println("表单协同[" + iinvoice + "]的节点[" + cnodeid + "]条件成立");
                        //添加消息机制 String cdetail,String inodeid,int ifuncregedit,int ioainvoice
                        if ("1".equals(istartnode)) {
                            //this.insertNodeItemsMsg("发起",ipnodeid,ifuncregedit,ioainvoice,map);
                            this.insertNodeItemsMsgZd("发起", cnodeid, ifuncregedit, ioainvoice, map);
                        } else {
                            this.insertNodeItemsMsgZd("处理", cnodeid, ifuncregedit, ioainvoice, map);
                        }
                    } else {
                        //lr add
                        //this.co_updateNode(ioainvoice,cnodeid,0);
                    }
                }
            }
        }

        //检查所有节点是不是已经处理完毕
        List nodeList = co_select_allnodes(params);
        if(nodeList.size()==0)
            editorFormStatus(ifuncregedit, iinvoice, 2);

        return "suc";
    }
    //select * from dbo.wf_nodeentry where ioainvoice=#ioainvoice# and cnodeid=#cnodeid#
    // 

    /**
     * 录入
     * 参数
     * ioainvoice 协同工作流 iid
     * iinvoice 单据iid
     * cnodeid 节点iid
     * table 单据对应的表名
     * other 要录入的值
     */
    //* 参数：ifuncregedit ,iinvoice--单据的iid,ipnodeid(节点父iid)
    public void co_enterHandler1(int ioainvoice, int iinvoice, String cnodeid, String table, String other) {
        //获取 指定节点的 录入 字段
        HashMap params = new HashMap();
        params.put("ioainvoice", ioainvoice);
        params.put("cnodeid", cnodeid);
        List entrys = this.co_zd_select_wfnodeentry(params);
        if (entrys == null || entrys.size() == 0) {
            System.out.println();
            return;
        }
    }

    //* 参数：ifuncregedit ,iinvoice--单据的iid,cnodeid(节点iid),other,节点操作类型 opt,perosn personid
    public String co_enterHandler(HashMap map) {
        String result = "suc";

        try {
            //获取单据对应的 数据表
            String ctable = this.co_form_tablename(map);
            if (ctable == null || ctable == "") {
                return "单据没有关联的数据表";
            }
            //获取节点的 ioainvoice 
            HashMap oainvoice = co_select_oainvoice(map);
            if (oainvoice == null) {
                //System.out.println("该单据没有匹配的协同流程");
                return "该单据没有匹配的协同流程";
            }
            int iinvoice = (Integer) map.get("iinvoice"); // 单据iid
            int ioainvoice = (Integer) oainvoice.get("iid"); // 单据工作流的iid
            int ifuncregedit = (Integer) map.get("ifuncregedit"); // 功能注册iid
            int iistatus = map.containsKey("iistatus") ? (Integer) map.get("iistatus") : 0;
            int iperson = map.containsKey("iperson") ? (Integer) map.get("iperson") : 0;
            String other = (String) map.get("other");
            String cnodeid = (String) map.get("inodeid");
            String opt = (String) map.get("opt");
            if (opt == null) {
                opt = "";
            }

            HashMap params = new HashMap();
            params.put("ioainvoice", ioainvoice);
            params.put("cnodeid", cnodeid);
            // 获取节点的 entry
            List entrys = this.co_zd_select_wfnodeentry(params);
            if (entrys == null || entrys.size() == 0) {
                System.out.println("---该节点没有关联的录入字段---");
                //return "该节点没有关联的录入字段";
            } else {
                //-------------反馈 录入
                // 拼接sql
                String sql = combiEntrySql(entrys, ctable, "" + iinvoice, other, null, map);
                this.co_update_nodeentry(sql);
            }
            //----------修改节点属性

            HrPersonVo person = (HrPersonVo) iUserService.getUser(map);
            HashMap tp = new HashMap();
            tp.put("ioainvoice", ioainvoice);
            tp.put("inodeid", cnodeid);
            tp.put("iperson", person.getIid());
            tp.put("opt", opt);
            tp.put("flag", "form");
            String cotype = this.iWorkFlowService.wfHandleNode(tp);
            if (cotype == "fwf") {
                //参数：ifuncregedit ,iinvoice--单据的iid,ipnodeid(节点父iid)
                map.put("ipnodeid", cnodeid);
                map.put("ifuncregedit", ifuncregedit);
                //向上级节点反馈信息
                insert_pnode_items_msg("已被处理", cnodeid, ifuncregedit, ioainvoice, map);
                //推进
                formWorkFlowGoForward(map);

                execsql((String) map.get("cexecsql"));

                if (iistatus > 0) {
                    updateStatus(iistatus, ifuncregedit, iinvoice, iperson);
                }
            }

            //发送消息
            if (map.get("msgvo") != null) {
                map.put("ioainvoice", ioainvoice);// 协同工作流的iid
                result = "" + this.onlySendReplay(map);
            }

            /**
             * SDY  添加系统操作日志
             */
//		HashMap map1 = new HashMap();
//		map1.put("operate", " 回复处理流程 ");
//		map1.put("result", result);
//		map1.put("params", map);
//		LogOperateUtil.insertLog(map1);

            return result;
        } catch (Exception e) {
            result = "fail";
            e.printStackTrace();
            throw new CRMRuntimeException("协同处理失败");
        }
    }

    //执行注入sql
    private void execsql(String cexecsql) throws Exception {
        if (cexecsql != null && !cexecsql.trim().equals("")) {
            this.iWorkFlowService.update_form_status(cexecsql);
        }
    }

    // 节点录入
    public String combiEntrySql(List list, String table, String value, String other, String key, HashMap userParam) throws Exception {
        if (key == null) {
            key = "iid";
        }
        if (list == null || list.size() == 0) {
            return "";
        }
        String sql = "";

        int len = list.size();
        for (int i = 0; i < len; i++) {
            HashMap map = (HashMap) list.get(i);
            String cfield = (String) map.get("cfield");
            String cvalue = (String) map.get("cvalue");

            sql += " " + cfield + "='" + setFieldValue(cvalue, other, userParam) + "',";
        }
        // 除去最后一个 逗号
        sql = sql.substring(0, sql.lastIndexOf(","));
        sql = "update " + table + " set " + sql + " where " + key + "='" + value + "'";
        return sql;
    }


    // 字段赋值
    public String setFieldValue(String valueType, String other, HashMap userParam) throws Exception {
        HrPersonVo person = (HrPersonVo) iUserService.getUser(userParam);
        String val = "";
        if ("kong".equals(valueType)) {
            val = "";
        } else if ("iperson".equals(valueType)) {
            val = "" + person.getIid();
        } else if ("idepartment".equals(valueType)) {
            val = "" + person.getIdepartment();
        } else if ("cperson".equals(valueType)) {
            val = person.getCname();
        } else if ("cdepartment".equals(valueType)) {
            val = person.getDepartcname();
        } else if ("cmessage".equals(valueType)) {
            //val=other;
            val = resolveOther("cmessage", other);
        } else if ("cresult".equals(valueType)) {
            //val=other;
            val = resolveOther("cresult", other);
        } else if ("hand".equals(valueType)) {
            //val=other;
            val = resolveOther("hand", other);
        } else if ("ddate".equals(valueType)) {
            val = ToolUtil.formatDay(new Date(), null);
        } else if ("booltrue".equals(valueType)) {
            val = "true";
        } else if ("boolfalse".equals(valueType)) {
            val = "false";
        } else if (valueType.indexOf("hand:") > -1) {
            val = valueType.substring("hand:".length());
        }
        return val;
    }

    //分解other中得数据
    public String resolveOther(String type, String other) {
        if (other == null || other == "") {
            return "";
        }
        if (other.indexOf(type) == -1) {
            return "";
        }
        String tp[] = other.split("@@");
        for (int i = 0; i < tp.length; i++) {
            String tpstr = tp[i];
            if (tpstr.indexOf(type) != -1) {
                return tpstr.split("=")[1];
            }
        }

        return "";
    }

    //至发送回复，不做流程处理
    public int onlySendReplay(HashMap params) {
        WfMessageVo wfMessageVo = (WfMessageVo) params.get("msgvo");
        return insertMessage(wfMessageVo);
    }

    //暂存待办
    public int ywZcdbHandler(HashMap params) throws Exception {
        int ret = onlySendReplay(params);
        String inodeid = (String) params.get("inodeid");
        int ifuncregedit = (Integer) params.get("ifuncregedit");
        int ioainvoice = (Integer) params.get("ioainvoice");
        this.insert_pnode_items_msg("暂存待办", inodeid, ifuncregedit, ioainvoice, params);

        execsql((String) params.get("cexecsql"));

        return ret;
    }

    public HashMap replayGetFormWorkFlow(HashMap params) {
        HashMap map = new HashMap();

        //获取节点的 ioainvoice 
        HashMap oainvoice = co_select_oainvoice(params);
        if (oainvoice == null) {
            //System.out.println("该单据没有匹配的协同流程");
            return null;
        }
        int oaid = (Integer) oainvoice.get("iid"); // 协同工作流 iid  
        params.put("ioainvoice", oaid);
        //获取当前节点
        WfNodeVo node = this.getCurNodeInfo(params);
        if (node == null) {
            return null;
        }
        List<HashMap> list = iWorkFlowService.getCurNodeiid(params);
        map.put("me", list.get(0));

        params.put("cnodeid", node.getInodeid());
        map.put("handlerNode", node);
        //获取节点的 录入
        map.put("nodeentry", this.co_zd_select_wfnodeentry(params));
        return map;
    }


    // 撤销
    public HashMap co_deleteWorkFlow(HashMap params) {
        try {
            //int num=this.iWorkFlowService.co_is_zx(params);
            HashMap pm = new HashMap();
            int ioainvoice = (Integer) params.get("ioainvoice");
            int iperson = (Integer) params.get("iperson");
            pm.put("ioainvoice", ioainvoice);
            pm.put("iperson", iperson);
            //pm.put("icanback", 0);
            pm.put("cexecsql", "");
            pm.put("iistatus", 0);
            int icanback = this.pr_canback(pm);


            //this.iCoopHandlerService.co_deleteWorkFlow(params);

            int funiid = (Integer) params.get("ifuniid");
            int djid = (Integer) params.get("djid");

            //添加更新 对应单据工作流 状态的数据

            List nodeList = co_select_allnodes(params);
            if (nodeList.size() > 0)
                editorFormStatus(funiid, djid, 1);
            else {
                editorFormStatus(funiid, djid, 0);
                pm.put("iistatus", -1);
            }


            pm.put("result", "suc");

            if (icanback == -1) {
                pm.put("result", "当前节点尚未处理，不予撤销");
            }
            if (icanback == 0) {
                pm.put("result", "当前节点已被处理，不予撤销");
            }

            return pm;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("协同撤销失败");
        }

    }

    // 加签处理
    public String co_jq_handler(HashMap params) {

        int ioainvoice = (Integer) params.get("ioainvoice");
        List newAC = (List) params.get("newAC");
        List editAC = (List) params.get("editAC");

        int len = 0;
        try {
            //新增
            if (newAC != null) {
                len = newAC.size();
                for (int i = 0; i < len; i++) {
                    WfNodeVo wfnodeVo = (WfNodeVo) newAC.get(i);
                    wfnodeVo.setIoainvoice(ioainvoice);
                    //this.iWorkFlowService.insertWorkFlowNode(wfnodeVo);
                    this.insertWorkFlowNode(wfnodeVo);
                    if (wfnodeVo.getInodetype() != 0) { //只对非人员节点做处理
                        HashMap param = new HashMap();
                        param.put("ioainvoice", "" + ioainvoice);
                        param.put("inodeid", wfnodeVo.getInodeid());
                        param.put("istatus", "" + wfnodeVo.getIstatus());
                        param.put("nodeType", "" + wfnodeVo.getInodetype());
                        param.put("nodeValue", "" + wfnodeVo.getInodevalue());
                        param.put("iperson", "" + params.get("iperson"));
                        //this.iWorkFlowService.insertNodeDetail(param)
                        this.insertNodeDetail(param);
                    }
                }
            }
            // 修改
            if (editAC != null) {
                len = editAC.size();
                for (int i = 0; i < len; i++) {
                    WfNodeVo wfnodeVo = (WfNodeVo) editAC.get(i);
                    //this.updateWFNode(wfnodeVo);
                    this.iWorkFlowService.updateWFNode(wfnodeVo);
                }
            }
            return "suc";
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            throw new CRMRuntimeException("加签，处理失败");
        }

    }

    // 回退
    // ----------层级为2
    public String return2level(HashMap params) {
        try {
            //this.iCoopHandlerService.co_node_return_update(params);
            //this.onlySendReplay(msgvo);
            //params.remove("msgvo");			
            String inodeid = (String) params.get("pinodeid");
            int ifuncregedit = (Integer) params.get("ifuncregedit");
            int ioainvoice = (Integer) params.get("ioainvoice");
            int iinvoice = (Integer) params.get("iinvoice"); // 单据iid
            int iistatus = params.containsKey("iistatus") ? (Integer) params.get("iistatus") : 0;
            int iperson = params.containsKey("iperson") ? (Integer) params.get("iperson") : 0;
            this.insertNodeItemsMsgZd("回退", inodeid, ifuncregedit, ioainvoice, params);

            this.iCoopHandlerService.co_node_return_2(params);
            //this.insert_pnode_items_msg("回退", inodeid, ifuncregedit, ioainvoice,params);			
            execsql((String) params.get("cexecsql"));
            if (iistatus < 0) {//回退要刷新的状态是小于0的
                updateStatus(iistatus, ifuncregedit, iinvoice, iperson);
            }

            return "suc";
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("层级2，回退处理失败");
        }
    }

    public String returnOtheLevel(HashMap params) {
        try {

            //this.onlySendReplay(params);
            //params.remove("msgvo");
            // 先更新父节点状态
            this.iCoopHandlerService.co_node_return_update_p(params);
            this.iCoopHandlerService.co_node_return_update(params);
            String inodeid = (String) params.get("pinodeid");
            int ifuncregedit = (Integer) params.get("ifuncregedit");
            int ioainvoice = (Integer) params.get("ioainvoice");
            int iinvoice = (Integer) params.get("iinvoice"); // 单据iid
            int iistatus = params.containsKey("iistatus") ? (Integer) params.get("iistatus") : 0;
            int iperson = params.containsKey("iperson") ? (Integer) params.get("iperson") : 0;
            this.insertNodeItemsMsgZd("回退", inodeid, ifuncregedit, ioainvoice, params);

            execsql((String) params.get("cexecsql"));
            if (iistatus < 0) {//回退要刷新的状态是小于0的
                updateStatus(iistatus, ifuncregedit, iinvoice, iperson);
            }
            //this.insert_pnode_items_msg("回退", inodeid, ifuncregedit, ioainvoice,params);
            return "suc";
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("层级其他，回退处理失败");
        }
    }

    // 根据 功能注册ifunid 和 单据iinoviceid 
//	public String co_invoset_judge(){
//		return "";
//	}


    //表单 业务相关处理
    //业务注释
    public List ywzs_selete_items(HashMap param) {
        return this.iYwhandler.ywzs_selete_items(param);
    }

    public int ywzs_insert_item(HashMap param) {
        try {
            return this.iYwhandler.ywzs_insert_item(param);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("插入业务注释失败");
        }
    }

    public void ywzs_delete_item(HashMap param) {
        try {
            this.iYwhandler.ywzs_delete_item(param);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("删除业务注释失败");
        }
    }

    //相关人员
    public List xgry_selete_items(HashMap param) {
        return this.iYwhandler.xgry_selete_items(param);
    }

    public int xgry_insert_item(HashMap param) {
        try {
            return this.iYwhandler.xgry_insert_item(param);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("插入相关人员失败");
        }
    }

    public int xgry_selete_items_count(HashMap param) {
        return this.iYwhandler.xgry_selete_items_count(param);
    }

    public void xgry_delete_item(HashMap param) {
        try {
            this.iYwhandler.xgry_delete_item(param);
        } catch (Exception e) {
            throw new CRMRuntimeException("删除相关人员失败");
        }
    }

    public int xgry_selete_fz_items_count(HashMap param) {
        return this.iYwhandler.xgry_selete_fz_items_count(param);
    }

    public String xgrySelectItems(HashMap param) {
        List list = xgry_selete_items(param);
        return ToXMLUtil.createTree(list, "iid", "pid", "-1");
    }

    //wtf MOD
    public List XGRYSelectItems(HashMap param) {
        List list = xgry_selete_items(param);
        return list;
    }

    public String xgryInsertItem(HashMap param) {
        int count = xgry_selete_items_count(param);
        if (count > 0) {
            return "已有相同人员存在，添加失败";
        }
        return "" + xgry_insert_item(param);
    }

    public String xgryInsertItems(HashMap param) {
        int count = xgry_selete_items_count(param);
        if (count > 0) {
            return "已有相同人员存在，添加失败";
        }
        return "" + xgry_insert_item(param);
    }

    public String xgryInsertItemWF(int ifunid, int iinvoice, int ipersonid, int idepartmentid, int irole) {
        HashMap param = new HashMap();
        param.put("ifuncregedit", ifunid);
        param.put("iinvoice", iinvoice);
        param.put("iperson", ipersonid);
        param.put("idepartment", idepartmentid);
        param.put("irole", irole);
        int count = xgry_selete_items_count(param);
        if (count > 0) {
            return "已有相同人员存在，添加失败";
        }
        return "" + xgry_insert_item(param);
    }

    public String xgryDeleteItem(HashMap param) {
        String irole = (String) param.get("irole");
        if ("1".equals(irole)) { //负责人
            int count = xgry_selete_fz_items_count(param);
            if (count <= 1) {
                return "至少要保留一个负责人，删除不成功";
            }
        }

        this.xgry_delete_item(param);
        return "suc";
    }

    //wtf add
    public String xgryDeleteItem1(List array) {
        int j = 0;
        HashMap hm = new HashMap();
        String ifuncregedit = "";
        String iinvoice = "";
        for (int i = 0; i < array.size(); i++) {
            HashMap obj = (HashMap) array.get(i);
            String irole = obj.get("irole") + "";
            if ("1".equals(irole)) {
                j++;
            }
            if (iinvoice.equals("")) {
                iinvoice = obj.get("iinvoice") + "";
            }
            if (ifuncregedit.equals("")) {
                ifuncregedit = obj.get("ifuncregedit") + "";
            }
        }
        hm.put("ifuncregedit", ifuncregedit);
        hm.put("iinvoice", iinvoice);
        int count = xgry_selete_fz_items_count(hm);
        if (j >= count) {
            return "至少要保留一个负责人，删除不成功";
        }
        for (int k = 0; k < array.size(); k++) {
            HashMap obj = (HashMap) array.get(k);
            HashMap param = new HashMap();
            param.put("iperson", obj.get("iperson") + "");
            param.put("iinvoice", obj.get("iinvoice") + "");
            param.put("ifuncregedit", obj.get("ifuncregedit") + "");
            this.xgry_delete_item(param);

        }
        return "suc";
    }

    public String deletItem(HashMap param) {
        List items = xgry_selete_items(param);
        if (null != items && items.size() > 0) {
            if (items.size() > 1) {
                this.xgry_delete_item(param);
            } else if (items.size() == 1) {
                HashMap itemMap = (HashMap) items.get(0);
                if (null != itemMap.get("irole") && itemMap.get("irole").toString().equals("2")) {
                    this.xgry_delete_item(param);
                } else {
                    return "至少要保留一个负责人，删除不成功";
                }
            }
        }
        return "suc";
    }

    // 业务对象

    public List ywdx_selete_items(HashMap param) {
        return this.iYwhandler.ywdx_selete_items(param);
    }

    //获取打印模板
    public HashMap print_selete_item(HashMap param) {
        return (HashMap) this.iPrintService.print_selete_item(param);
    }

    // 获取打印模板列表
    public List print_selete_items(HashMap param) {
        return this.iPrintService.print_selete_items(param);
    }

    //发送工作流节点消息提示
    public String insertNodeItemsMsg(String cdetail, String inodeid, int ifuncregedit, int ioainvoice, HashMap userParam) throws Exception {

        HrPersonVo person = (HrPersonVo) iUserService.getUser(userParam);

        HashMap params = new HashMap();
        params.put("isperson", person.getIid());
        params.put("cdetail", cdetail);
        params.put("inodeid", inodeid);
        params.put("ifuncregedit", ifuncregedit);
        params.put("ioainvoice", ioainvoice);
        try {
            this.iWorkFlowService.insert_node_items_msg(params);
            return "suc";
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("写入工作流节点提示消息失败");
        }
    }

    //发送工作流节点消息提示
    public String insertPNodeBackItemsMsg(String cdetail, String inodeid, int ifuncregedit, int ioainvoice, HashMap userParam) throws Exception {

        HrPersonVo person = (HrPersonVo) iUserService.getUser(userParam);

        HashMap params = new HashMap();
        params.put("isperson", person.getIid());
        params.put("cdetail", cdetail);
        params.put("inodeid", inodeid);
        params.put("ifuncregedit", ifuncregedit);
        params.put("ioainvoice", ioainvoice);
        try {
            this.iWorkFlowService.insert_pnodeback_item_msg(params);
            return "suc";
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("写入工作流节点提示消息失败");
        }
    }

    //发送工作流节点消息提示,所属的人员  穿入的节点 是需要接受信息的节点
    //lr 增加功能  同时 向wf_time表插入时间信息
    public String insertNodeItemsMsgZd(String cdetail, String inodeid, int ifuncregedit, int ioainvoice, HashMap userParam) throws Exception {
        HrPersonVo person = (HrPersonVo) iUserService.getUser(userParam);
        HashMap params = new HashMap();
        params.put("isperson", person.getIid());
        params.put("cdetail", cdetail);
        params.put("inodeid", inodeid);
        params.put("ifuncregedit", ifuncregedit);
        params.put("ioainvoice", ioainvoice);
        try {
            this.iWorkFlowService.insert_node_items_msg_zd(params);
        } catch (Exception e) {
            e.printStackTrace();
            throw new CRMRuntimeException("写入工作流节点提示消息失败");
        }


        //wf_time表插入时间信息
        int itype = 1;
        if ("回退".equals(cdetail))
            itype = 0;

        List<HashMap> list = this.iWorkFlowService.getNodeAndNodes(params);
        if (list != null && list.size() > 0) {
            for (HashMap hm : list) {
                if ((hm.get("isNode") + "").equals("true"))
                    this.iWorkFlowService.insertWfTime(true, (Integer) hm.get("iid"), itype);
                else
                    this.iWorkFlowService.insertWfTime(false, (Integer) hm.get("iid"), itype);
            }
        }
        return "suc";
    }

    public void insertWfTime(HashMap param){
        Boolean flag = Boolean.parseBoolean(param.get("isNode")+"");
        this.iWorkFlowService.insertWfTime(flag, (Integer) param.get("iid"), (Integer) param.get("itype"));
    }

    //向根节点反馈信息  而不是父节点
    public void insert_pnode_items_msg(String cdetail, String inodeid, int ifuncregedit, int ioainvoice, HashMap userParam) throws Exception {
        HrPersonVo person = (HrPersonVo) iUserService.getUser(userParam);
        HashMap params = new HashMap();
        params.put("isperson", person.getIid());
        params.put("cdetail", cdetail);
        params.put("inodeid", inodeid);
        params.put("ifuncregedit", ifuncregedit);
        params.put("ioainvoice", ioainvoice);
        try {
            this.iWorkFlowService.insert_pnode_items_msg(params);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            throw new CRMRuntimeException("向父节点，写入工作流节点提示消息失败");
        }
    }

    // 插入权限的 负责人
    public void insertDJfzr(int ifunid, int djid, int wfid, int irole, String inodeid) {

    }

    //插入权限的相关人员

    /**
     * ifunid 单据的功能注册码
     * djid 单据iid
     * wfid 单据关联的 工作流iid
     * irole 1 负责人 2 相关人
     * inodeid 当前节点的 iid
     */
    public void insertDJxgr(int ifunid, int djid, int wfid, int irole, String inodeid, String type) {
        // 获取 wfid，inodeid 节点对应的 人员信息
        // 检查 人员是不是已经 拥有了相关的权限
        // 没有相关的权限，就插入相关人权限
        if (ifunid == 0 || djid == 0 || wfid == 0 || inodeid == null) {
            System.out.println("[" + wfid + "]工作流中，插入相关人权限信息，参数不合法，不予写入权限信息");
            return;
        }

        HashMap params = new HashMap();
        params.put("wfid", wfid);
        params.put("inodeid", inodeid);
        List xgry_person_infos = null;
        if ("yw".equals(type)) {
            xgry_person_infos = this.iWorkFlowService.select_xgry_person_info(params);
        } else if ("zy".equals(type)) {
            xgry_person_infos = this.iWorkFlowService.select_xgry_person_info_xj(params);
        } else if ("zj".equals(type)) {
            xgry_person_infos = this.iWorkFlowService.select_xgry_person_info_nukown(params);
        }
        if (xgry_person_infos == null || xgry_person_infos.size() == 0) {
            System.out.println("[" + wfid + "]工作流中，插入相关人权限信息,节点[" + inodeid + "]没有关联的人员信息");
            return;
        }

        //验证 是否已经管理权限信息
        int len = xgry_person_infos.size();
        for (int i = 0; i < len; i++) {
            HashMap pinfo = (HashMap) xgry_person_infos.get(i);
            //int ifunid,int iinvoice,int ipersonid,int idepartmentid,int irole
            int iperson = (Integer) pinfo.get("iperson");
            if(iperson>0)
                xgryInsertItemWF(ifunid, djid, iperson, (Integer) pinfo.get("idepartment"), irole);
            else
                System.out.println("未找到指定的工作流人员");
        }
    }

    //添加，工作流 提交与撤销是，修改对应单据状态的 
    public void editorFormStatus(int ifuniid, int djid, int djzt) {
        //获取根据单据ifun 找到对应的表明
        // 拼接sql，动态执行sql

        if (ifuniid == 0 || djid == 0) {
            System.out.println("修改工作流对应的单据状态不成功，参数不合法");
            return;
        }

        String table = this.iWorkFlowService.get_form_table_name("" + ifuniid);
        if (table == null || table == "") {
            System.out.println("修改工作流对应的单据状态不成功，没有找到单据功能注册码[" + ifuniid + "],对应的单据的表名");
            return;
        }
        //iwfstatus字段为1表示“提交”; 2 "撤消";iwfstatus字段为0表示“待提交”
        String sql = "update " + table + " set iwfstatus = " + djzt + " where iid = " + djid;
        try {
            this.iWorkFlowService.update_form_status(sql);
        } catch (Exception e) {
            System.out.println("修改工作流对应的单据状态不成功,单据表名[" + table + "],更新sql[" + sql + "]");
            e.printStackTrace();
        }
    }

    // 批量修改 单据对应的 上传附件
    public HashMap patchEditFj(HashMap params) {
        HashMap ret = new HashMap();

        String ifuniid = (String) params.get("ifuniid");
        String iinvoice = (String) params.get("iinvoice");
        // 1  获取单据对应的 表名 ，主要是 避免 前台不显示 项目令号 信息
        if (ifuniid == null || ifuniid == "") {
            ret.put("error", "后台获取不到单据对应的 功能注册码");
            return ret;
        }

        if (iinvoice == null || iinvoice == "") {
            ret.put("error", "后台获取不到单据对应的 内码");
            return ret;
        }

        String table = this.iWorkFlowService.get_form_table_name(ifuniid);
        if (table == null || table == "") {
            ret.put("error", "单据功能注册码[" + ifuniid + "],没有对应的单据的表名");
            return ret;
        }
        //获取 项目令号
        String citemcode = null;
        String sql = "select citemcode from " + table + " where iid =" + iinvoice;
        try {
            citemcode = this.iWorkFlowService.getitemcode(sql);
        } catch (Exception e) {
            e.printStackTrace();
            ret.put("error", "无法获取表名为[" + table + "],内码为[" + iinvoice + "]项目令号");
            return ret;
        }

        if (citemcode == null || citemcode == "") {
            ret.put("error", "获取表名为[" + table + "],内码为[" + iinvoice + "]项目令号不存在，请确认！");
            return ret;
        }

        // 获取指定单据的对应的 附件
        int fjnum = this.iWorkFlowService.getdjfjnum(params);
        if (fjnum == 0) {
            ret.put("error", "该单据没有对应的附件");
            return ret;
        }

        //批量跟新附件名称
        try {
            // 添加 项目令号
            params.put("itemlh", citemcode);
            this.iWorkFlowService.patcheditfj(params);
            ret.put("suc", "批量更新单据对应的附件名称成功");
            return ret;
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            ret.put("error", "批量更新单据对应的附件名称失败");
            return ret;
        }
    }

    //WorkFlowDest消息浮动窗口，收到点击关闭时，把所有登录人 已被处理 的消息 置成已阅的 
    public String msgreaded(String ipersonid) {
        try {
            if (ipersonid == null || ipersonid == "") {
                return "获取登录人iid错误";
            }
            this.iWorkFlowService.msgreaded(ipersonid);
            return "suc";
        } catch (Exception e) {
            e.printStackTrace();
            return "操作失败";
        }
    }

    //相关单据一打开，就设置，登录人对应的单据的所属的消息 为已阅读 
    public void editdjmsgreaded(HashMap params) {
        if (params == null || params.get("ifunid") == null || params.get("iinvoice") == null || params.get("ipersonid") == null) {
            System.out.println("修改单据对应的当前人的消息状态，HashMap参数不合法");
            return;
        }
        this.iWFMessageService.editdjmsgreaded(params);
    }

    /**
     * editdjmsgreaded1(这里用一句话描述这个方法的作用)
     * 创建者：Administrator
     * 创建时间：2011-2011-12-17 下午02:11:58
     * 修改者：Administrator
     * 修改时间：2011-2011-12-17 下午02:11:58
     * 修改备注：
     *
     * @param ifunid    单据功能注册码
     * @param iinvoice  单据内码
     * @param ipersonid 当前登录人 iid
     * @return void
     * @Exception 异常对象
     */
    public void editdjmsgreaded1(int ifunid, int iinvoice, int ipersonid) {
        //#ifunid# and iinvoice=#iinvoice# and irperson=#ipersonid#
        if (ifunid == 0 || iinvoice == 0 || ipersonid == 0) {
            System.out.println("修改单据对应的当前人的消息状态，参数不合法");
            return;
        }
        HashMap params = new HashMap();
        params.put("ifunid", ifunid);
        params.put("iinvoice", iinvoice);
        params.put("ipersonid", ipersonid);
        editdjmsgreaded(params);
    }

    /**
     * 单据 工作流的，统一处理
     *
     * @param params ifuniid
     *               djiid
     *               wfiid
     *               isflag 是否重复 进行模板验证，打印模板获取
     * @return
     */

    public HashMap wfCoreHandler(HashMap params) {
        HashMap ret = new HashMap();

        int ifuniid = (Integer) params.get("ifuniid");
        int djiid = (Integer) params.get("djiid");
        //int wfiid = (Integer) params.get("wfiid");
        int isflag = (Integer) params.get("isflag");

        if (ifuniid <= 0) {
            ret.put("error1", "无法获取单据功能注册码");
            return ret;
        }
        HashMap queryParam = new HashMap();
        HashMap queryReturn = new HashMap();

        queryParam.put("ifuncregedit", ifuniid);
        queryParam.put("ifunid", ifuniid);

        //判断 单据功能注册码 是否 绑定 工作流模板 

        if (isflag == 0) {
            //queryParam.put("ifuncregedit",ifuniid);
            queryReturn = this.co_invoset_judge(queryParam);
            if (queryReturn == null) {
                ret.put("retcode1", "单据没有绑定工作流模板"); //没有绑定模板
            } else {
                ret.put("mp", queryReturn); //添加模板信息
            }

            // 获取打印机 模板
            //queryParam.put("ifunid",ifuniid);
            List queryList = this.print_selete_items(queryParam);
            if (queryList == null || queryList.size() == 0) {
                ret.put("retcode2", "没有打印模板");
            } else {
                ret.put("print", queryList);
            }
        }


        /***********************以单据iid为界**************************/
        if (djiid <= 0) {
            ret.put("error2", "无法获取单据内码");
            return ret;
        }
        //验证 制定功能注册码与单据内码的单据 是否 已经生成了 工作流
        queryParam.put("iinvoice", djiid);
        queryReturn = this.co_select_oainvoice(queryParam);
        if (queryReturn == null) {
            ret.put("retcode3", "单据没有生成工作流");//单据没有生成工作流
            return ret;  // 如果没有生成工作流，就不需要 再往下面进行了

        } else {
            ret.put("wfinfo", queryReturn); //添加工作流的描述信息
        }

        // 获取工作流 信息
        queryReturn = this.replayGetFormWorkFlow(queryParam);
        if (queryReturn == null) {
            ret.put("retcode4", "未查询到工作流信息");
        } else {
            ret.put("wfdetail", queryReturn);
        }
        return ret;
    }

    // 验证工作流 是否可以撤销 0：不可撤销 1：可撤销

    public int pr_canback(HashMap params) {
        try {
            int icanback = (Integer)(this.iCoopHandlerService.pr_canback(params).get("icanback"));
            return icanback;
        } catch (Exception e1) {
            e1.printStackTrace();
            return 0;
        }
    }

    private void updateStatus(int iistatus, int ifuncregedit, int iinvoice, int iperson) throws Exception {
        HashMap statusParam = new HashMap();
        statusParam.put("ifuncregedit", ifuncregedit);
        statusParam.put("iinvoice", iinvoice);
        statusParam.put("iperson", iperson);
        statusParam.put("istatus", iistatus);
        iCommonalityService.updateStatus(statusParam);
    }

}

