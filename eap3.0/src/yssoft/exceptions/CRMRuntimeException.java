/**    
 * 文件名：CRMRuntimeException.java    
 *    
 * 版本信息：    
 * 日期：2011-8-2    
 * Copyright 足下 Corporation 2011     
 * 版权所有    
 *    
 */
package yssoft.exceptions;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：CRMRuntimeException    
 * 类描述：    
 * 创建人：zmm    
 * 创建时间：2011-8-2 下午04:27:48    
 * 修改人：zmm    
 * 修改时间：2011-8-2 下午04:27:48    
 * 修改备注：    
 * @version     
 *     
 */
public class CRMRuntimeException extends RuntimeException {

	   
	/**    
	 * serialVersionUID:TODO（用一句话描述这个变量表示什么）    
	 *    
	 * @since Ver 1.1    
	 */    
	
	private static final long serialVersionUID = 1L;


	/**    
	 * 创建一个新的实例 CRMRuntimeException.    
	 *        
	 */
	public CRMRuntimeException() {
		super();
		// TODO Auto-generated constructor stub
	}

	   
	/**    
	 * 创建一个新的实例 CRMRuntimeException.    
	 *    
	 * @param message
	 * @param cause    
	 */
	public CRMRuntimeException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

	   
	/**    
	 * 创建一个新的实例 CRMRuntimeException.    
	 *    
	 * @param message    
	 */
	public CRMRuntimeException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	   
	/**    
	 * 创建一个新的实例 CRMRuntimeException.    
	 *    
	 * @param cause    
	 */
	public CRMRuntimeException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

}
