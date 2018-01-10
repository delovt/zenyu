package yssoft.vos;
/**
 * 
 * 项目名称： 
 * 类名称：as_operauthVo类描述： 
 * as_operauth的Java实体类 
 * 创建人：刘磊
 * 创建时间：2011-10-5 16:28:30
 * 修改人：刘磊
 * 修改时间：2011-10-5 16:28:30
 * 修改备注：无
 * @version 1.0
 * 
 */

public class as_operauthVo
{
     	public int iid;
        public int irole;
        public String copercode;
                
		public int getiid()
        {
              return iid;
        }
        public void setiid(int _iid)
        {
              iid = _iid; 
        }
        public int getirole()
        {
              return irole;
        }
        public void setirole(int _irole)
        {
              irole = _irole; 
        }
        public String getcopercode()
        {
              return copercode;
        }
        public void setcopercode(String _copercode)
        {
              copercode = _copercode; 
        }
                
}