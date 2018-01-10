/**
 *@auth zmm
 *@date 2011-07-28
 *@description crm 自定义error类
 */
package yssoft.errors
{
	public class CRMerror extends Error
	{
		public function CRMerror(message:*="", id:*=0)
		{
			//TODO: implement function
			super(message, id);
		}
	}
}