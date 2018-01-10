package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：SendMessageView
 * 类描述：控制发送短信总流程
 * 创建人：lzx
 * 创建时间：2012-12-3 11:48:30
 * 修改人：
 * 修改时间：
 * 修改备注：无
 * @version 1.0
 * 
 */
import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.HashMap;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import yssoft.impls.SendMessageMobileImpl;
import yssoft.impls.SendMessageTelecomImpl;
import yssoft.services.IMessageService;
import yssoft.services.Ias_smssetService;
import yssoft.servlets.LicenseServlet;
import yssoft.utils.DesEncryptUtil;
import yssoft.vos.AbSmsVo;

public class SendMessageView {

	private IMessageService iMessageService;
	
	private Ias_smssetService ias_smssetService;
	
	private SendMessageTelecomImpl sendMessageTelecomImpl;
	
	private SendMessageMobileImpl sendMessageMobileImpl;

    private MsgView msgView;

    public void setMsgView(MsgView msgView) {
        this.msgView = msgView;
    }

	public void setiMessageService(IMessageService iMessageService) {
		this.iMessageService = iMessageService;
	}
	
	public void setIas_smssetService(Ias_smssetService ias_smssetService) {
		this.ias_smssetService = ias_smssetService;
	}
	
    public void setSendMessageTelecomImpl(
			SendMessageTelecomImpl sendMessageTelecomImpl) {
		this.sendMessageTelecomImpl = sendMessageTelecomImpl;
	}

	public void setSendMessageMobileImpl(SendMessageMobileImpl sendMessageMobileImpl) {
		this.sendMessageMobileImpl = sendMessageMobileImpl;
	}

    //获取加密狗信息
	public String getLicense() {
		String registerMessage = "0";
		if(LicenseServlet.getLicenseMap().containsKey("RegisterMessage")) {
			registerMessage = LicenseServlet.getLicenseMap().get("RegisterMessage").toString().trim();
		}else {
			registerMessage = "0";
		}	
		return registerMessage;
	}
	public List<AbSmsVo> getMessage(HashMap hm){	
    	List<AbSmsVo> result = null;
    	try {
    		result = this.iMessageService.qureyMessage(hm);
		} catch (Exception e) {
			e.printStackTrace();
			result = null;
		}
    	return result;
	}
    
    public String addMessage(ArrayList<AbSmsVo> abSmsVos){
		String result ="success";
		try{
			this.iMessageService.addMessage(abSmsVos);
		}
		catch(Exception e){
			e.printStackTrace();
			result ="fail";
		}
		
		return result;
	}
    
    public String updateMessage(ArrayList<AbSmsVo> abSmsVos){
		String result ="success";
		try{
			this.iMessageService.modifyMessage(abSmsVos);
		}
		catch(Exception e){
			e.printStackTrace();
			result ="fail";
		}
		
		return result;
	}
    
    public String deleteMessage(ArrayList<AbSmsVo> abSmsVos){
		String result ="success";
		try{
			this.iMessageService.deleteMessage(abSmsVos);
		}
		catch(Exception e){
			e.printStackTrace();
			result ="fail";
		}
		
		return result;
	}
    
    public List<HashMap> onMessageImport(HashMap params){
		
		String filepath = "";//完整路径
		String filename = params.get("filename")+"";//文件名称	
		String ifuncregedit = params.get("ifuncregedit").toString();
		String url = this.getClass().getResource("").getFile();
		
		url = url.replaceAll("%20", " ");
		
		File fpath = new File(url.substring(0, url.indexOf("WEB-INF"))+ "/importdata/");
		if(fpath.exists() == false){
			fpath.mkdir();
			System.out.println("路径不存在,但是已经成功创建了:->"+fpath);
			return null;
		}
		
		filepath = fpath +"/"+filename;
				
		try{
			Workbook workbook = new HSSFWorkbook(new POIFSFileSystem(
					new FileInputStream(filepath)));// 以文件流的方式读取文件
			Sheet sheet = workbook.getSheetAt(0);// 获取工作簿
			
			List<HashMap> list = onExecDataImport(sheet,ifuncregedit,params.get("imaker")+"");
			onDelFile(filepath);
			return list;
		}catch(Exception ex){
			ex.printStackTrace();
			return null;
		}
		
	}
    
    private List<HashMap> onExecDataImport(Sheet sheet,String ifuncregedit,String imaker){
		
		List<HashMap> list = new ArrayList<HashMap>();
		Row row = null;
		String contents = "";
		list.clear();
		//获取导入数据库的字段信息,从第二行开始
		for (int i = 1; i <= sheet.getLastRowNum();i++) {
			row = sheet.getRow(i);// 当前行
			HashMap<String, Object> hm = new HashMap<String, Object>();
			for(int j=0; j <= 4; j++) {
				if(row.getCell(j) == null) {
					contents = "";
				}else {
					contents = row.getCell(j).getStringCellValue().trim();
				}				
				switch(j) {
					case 0 : 
						hm.put("ccusname", contents);
						break;
					case 1 : 
						hm.put("cpsnname", contents);
						break;
					case 2 : 
						hm.put("ctitle", contents);
						break;
					case 3 : 
						hm.put("cdetail", contents);
						break;
					case 4 : 
						hm.put("cmobile", contents);
						break;
					default : break;
				}
			}
			hm.put("imaker", imaker);
			hm.put("dmaker", new Date());
			hm.put("istate", 0);
			hm.put("ifuncregedit", ifuncregedit);
			list.add(hm);
		}
		return list;
	}

	private void onDelFile(String fpath){		
		try{
			
			File file= new File(fpath);
			file.delete();
			
		}catch(Exception ex){
			System.out.println("文件删除失败");
			ex.printStackTrace();
		}
		
	}
	
    public String SendMessage(List<AbSmsVo> abSmsVos) {
    	String result = "success";
    	ArrayList<AbSmsVo> listForAdd = new ArrayList<AbSmsVo>();
    	ArrayList<AbSmsVo> listForUpdate = new ArrayList<AbSmsVo>();
    	List<HashMap> list = this.ias_smssetService.get_all_as_smsset();
    	if(list.size() == 0) {
    		result = "noConnect";
    		return result;
    	}
    	Iterator<AbSmsVo> it = abSmsVos.iterator();
    	AbSmsVo abSmsVo = new AbSmsVo();
    	String cphoneprefix = "";
    	String ipAddress = "";
    	int port = 0;
    	String username = "";
    	String password = "";
    	int connFlag = -1;
    	while(it.hasNext()) {
    		abSmsVo = it.next(); 		
    		for(int i=0; i < list.size(); i++){
    			if(list.get(i) != null) {
    				cphoneprefix = list.get(i).get("cphoneprefix").toString();
        			ipAddress = list.get(i).get("caddress").toString();
        			port = Integer.parseInt(list.get(i).get("cport").toString());
        			username = list.get(i).get("cuser").toString();
    				password = DesEncryptUtil.decodeDes(list.get(i).get("cpassword").toString(), DesEncryptUtil.DEFAULT_KEY);
    			}
    			if (abSmsVo.getCmobile().startsWith("0") || abSmsVo.getCmobile().startsWith("+860")) {
    				abSmsVo.setCmobile(abSmsVo.getCmobile().substring(abSmsVo.getCmobile().indexOf("0") + 1, abSmsVo.getCmobile().length()));
    			}
    			if(cphoneprefix.contains(abSmsVo.getCmobile().substring(0, 3)) || cphoneprefix.contains(abSmsVo.getCmobile().substring(0, 4))) {
    				//连接电信端口并发送
    				if(list.get(i).get("cname").toString().equals("1")) {
    					try {
    						connFlag = sendMessageTelecomImpl.conn(ipAddress, port, username, password);
    						if(connFlag == 0) {
    							sendMessageTelecomImpl.send(abSmsVo);
    							if(abSmsVo.getIid() == -1) {
    				    			abSmsVo.setIstate(1);
    				    			listForAdd.add(abSmsVo);
    				    		}else {
    				    			listForUpdate.add(abSmsVo);
    				    		}
    						}else {
    							result = "fail";
    						}
						} catch (Exception e) {
							e.printStackTrace();
							result = "fail";
						}
    				//连接移动端口并发送	
    				}else if(list.get(i).get("cname").toString().equals("2")) {
    					try {
    						connFlag = sendMessageMobileImpl.conn(ipAddress, port, username, password);
    						if(connFlag == 0) {
    							sendMessageMobileImpl.sendMessage(abSmsVo);
    							if(abSmsVo.getIid() == -1) {
    				    			abSmsVo.setIstate(1);
    				    			listForAdd.add(abSmsVo);
    				    		}else {
    				    			listForUpdate.add(abSmsVo);
    				    		}
    						}else {
    							result = "fail";
    						}
						} catch (Exception e) {
							e.printStackTrace();
							result = "fail";
						}
    				}
    			} else {
                    result = "fail";
                }
    		}
    	}
    	this.addMessage(listForAdd);
    	this.updateMessage(listForUpdate);
    	return result;
    }

    public String SendMsgForWorkFlow() {
        String registerMessage = this.getLicense();
        if(!registerMessage.equals("1")) {
            try {
                List<AbSmsVo> list = iMessageService.getMsgForWorkFlow();
                for(int i=0; i<list.size(); i++) {
                    if(list.get(i).getCdetail() != null && !list.get(i).getCdetail().equals("")) {
                        int iid = list.get(i).getIid();
                        list.get(i).setIid(-1);
                        String res = this.SendMessageOneByOne(list.get(i));
                        int ismsstatus = 0;
                        if(res.equals("success")) {
                            ismsstatus = 1;
                        }else {
                            ismsstatus = 2;
                        }
                        HashMap hm = new HashMap();
                        hm.put("iid", iid);
                        hm.put("ismsstatus", ismsstatus);
                        msgView.updateMsgIsmsStatus(hm);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return "";
    }

    public String SendMessageOneByOne(AbSmsVo abSmsVo) {
        String result = "success";
        ArrayList<AbSmsVo> listForAdd = new ArrayList<AbSmsVo>();
        ArrayList<AbSmsVo> listForUpdate = new ArrayList<AbSmsVo>();
        List<HashMap> list = this.ias_smssetService.get_all_as_smsset();
        if(list.size() == 0) {
            result = "noConnect";
            return result;
        }
        String cphoneprefix = "";
        String ipAddress = "";
        int port = 0;
        String username = "";
        String password = "";
        int connFlag = -1;

        for(int i=0; i < list.size(); i++){
            if(list.get(i) != null) {
                cphoneprefix = list.get(i).get("cphoneprefix").toString();
                ipAddress = list.get(i).get("caddress").toString();
                port = Integer.parseInt(list.get(i).get("cport").toString());
                username = list.get(i).get("cuser").toString();
                password = DesEncryptUtil.decodeDes(list.get(i).get("cpassword").toString(), DesEncryptUtil.DEFAULT_KEY);
            }
            if (abSmsVo.getCmobile().startsWith("0") || abSmsVo.getCmobile().startsWith("+860")) {
                abSmsVo.setCmobile(abSmsVo.getCmobile().substring(abSmsVo.getCmobile().indexOf("0") + 1, abSmsVo.getCmobile().length()));
            }
            if(cphoneprefix.contains(abSmsVo.getCmobile().substring(0, 3)) || cphoneprefix.contains(abSmsVo.getCmobile().substring(0, 4))) {
                //连接电信端口并发送
                if(list.get(i).get("cname").toString().equals("1")) {
                    try {
                        connFlag = sendMessageTelecomImpl.conn(ipAddress, port, username, password);
                        if(connFlag == 0) {
                            sendMessageTelecomImpl.send(abSmsVo);
                            if(abSmsVo.getIid() == -1) {
                                abSmsVo.setIstate(1);
                                listForAdd.add(abSmsVo);
                            }else {
                                listForUpdate.add(abSmsVo);
                            }
                        }else {
                            result = "fail";
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        result = "fail";
                    }
                    //连接移动端口并发送
                }else if(list.get(i).get("cname").toString().equals("2")) {
                    try {
                        connFlag = sendMessageMobileImpl.conn(ipAddress, port, username, password);
                        if(connFlag == 0) {
                            sendMessageMobileImpl.sendMessage(abSmsVo);
                            if(abSmsVo.getIid() == -1) {
                                abSmsVo.setIstate(1);
                                listForAdd.add(abSmsVo);
                            }else {
                                listForUpdate.add(abSmsVo);
                            }
                        }else {
                            result = "fail";
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        result = "fail";
                    }
                }
            } else {
                result = "fail";
            }
        }

        this.addMessage(listForAdd);
        this.updateMessage(listForUpdate);
        return result;
    }

    
}