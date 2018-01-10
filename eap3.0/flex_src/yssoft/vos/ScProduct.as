/**
 * 存货档案
 * @author 孙东亚
 *
 */

package yssoft.vos{
	
import flashx.textLayout.formats.Float;
	
	[Bindable]
	[RemoteClass(alias="yssoft.vos.ScProduct")]
	public class ScProduct  {
		
		public function ScProduct()
		{
		}
		
		public var iid:int ;
		public var iproductclass:int;
		public var iproductgroup:int;
		
		public var ccode:String;
		public var cname:String;
		public var cpdstv:String;
		public var cmnemonic:String ;
		
		public var iunitclass:int ;
		public var iunitdefault:int ;
		public var iunit:int ;
		public var itaxtype:int ;
		//public var itaxrate:int ;
		
		public var ftaxquotedprice:Number ;
		public var freferencecost:Number ;
		public var fsafequantity:Number ;
		
		public var bassets:Boolean ;
		public var bservice:Boolean ;
		public var bfittings:Boolean ;
		public var bsn:Boolean ;
		public var bfree1:Boolean ;
		public var bfree2:Boolean ;
		public var bfree3:Boolean ;
		public var bpurchase:Boolean ;
		public var bsale:Boolean ;
		public var bconsume:Boolean ;
		public var bselfmake:Boolean ;
		public var istatus:int ;
		
	}
}
