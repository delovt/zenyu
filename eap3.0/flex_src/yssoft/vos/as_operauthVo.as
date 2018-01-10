package yssoft.vos
{
/**
 * 
 * 项目名称： 
 * 类名称：as_operauthVo类描述： 
 * as_operauth的Flex实体类 
 * 创建人：刘磊
 * 创建时间：2011-10-5 16:28:26
 * 修改人：刘磊
 * 修改时间：2011-10-5 16:28:26
 * 修改备注：无
 * @version 1.0
 * 
 */
    [Bindable]
    [RemoteClass(alias="yssoft.vos.as_operauthVo")]
    public class as_operauthVo
    {
          public function as_operauthVo()
   		  {
    	  }
       	  public var iid:int;
          
          public var irole:int;
          
          public var copercode:String;
          
                    
          public function getiid():int          
          {
              return iid;
          }
          public function setiid(_iid:int):void
          {
              iid = _iid;
          }   
          public function getirole():int          
          {
              return irole;
          }
          public function setirole(_irole:int):void
          {
              irole = _irole;
          }   
          public function getcopercode():String          
          {
              return copercode;
          }
          public function setcopercode(_copercode:String):void
          {
              copercode = _copercode;
          }   
                    
    }
}