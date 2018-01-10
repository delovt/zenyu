package yssoft.evts
{
	import flash.events.Event;
	
	public class FormEvent extends Event
	{
		public static const formsavefail:String="";
		public static const formsavesuc:String="";
		
		public static const formcoopsubmitfail:String="";
		public static const formcoopsubmitsuc:String="";
		
		public static const formcooprevocationfail:String="";
		public static const formcooprevocationsuc:String="";
		
		public function FormEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}