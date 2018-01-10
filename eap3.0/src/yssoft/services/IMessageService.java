package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：IMessageService
 * 类描述：短信增删改
 * 创建人：lzx
 * 创建时间：2012-12-03 13:40:25
 * 修改人：
 * 修改时间：
 * 修改备注：无
 * @version 1.0
 * 
 */
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import yssoft.vos.AbSmsVo;

public interface IMessageService {

    public List<AbSmsVo> qureyMessage(HashMap hm) throws Exception;
    
    public int addMessage(ArrayList<AbSmsVo> abSmsVos) throws Exception;
    
    public int modifyMessage(ArrayList<AbSmsVo> abSmsVos) throws Exception;
    
    public int deleteMessage(ArrayList<AbSmsVo> abSmsVos) throws Exception;

    public List<AbSmsVo> getMsgForWorkFlow() throws Exception;
}
