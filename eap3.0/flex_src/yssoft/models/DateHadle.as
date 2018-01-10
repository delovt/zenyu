/*
	YJ Add 
	日期的一些相关操作
	
*/
package yssoft.models
{
	import mx.controls.DateField;
	import mx.formatters.DateFormatter;
	import mx.utils.ObjectUtil;
	
	public class DateHadle
	{
		private static var now:Date=new Date();	  
		
		public function DateHadle(dnow:Date=null)
		{
			if (dnow!=null)
			{
				now=dnow;
			}
		}
		
		public static function getYear():String{
			return now.fullYear+"";
		}
		
		public static function getMonth():String{
			return (now.month+1).toString();
		}
		
		public static function getFirstOfYear():String{// 取本年的第一天
			return now.fullYear+"-"+"01-01";
		}
		
		public static function getEndOfYear():String{// 取本年的最后天
			return now.fullYear+"-"+"12-31";
		}
		
		public static function getFirstOfMonth():String{// 取本月的第一天
			var tp:String="";  
			var cur:int=now.getMonth()+1;
			if( cur <= 9){
				tp="0"+cur;
			}else{
				tp=""+cur;
			}
			return now.fullYear+"-"+tp+"-01";
		}
		
		public static function getEndOfMonth():String{// 取本月的最后天
			var startDate:Date=new Date(now.getFullYear(),now.getMonth()+1);		
			var endDate:Date=new Date(startDate.getTime());  	          
			endDate['date']+=-1;
			var FormatDate:DateFormatter=new DateFormatter();
			// 定义日期格式		
			FormatDate.formatString="YYYY-MM-DD";	     	
			return FormatDate.format(endDate);
		}
		
		public static function getFirstOfWeek():String{// 取本星期的第一天
			var week:Number=now.getDay();
            if(week ==0)
                week = 7;
			var endDate:Date=new Date(now.getTime());
			endDate['date']=now.getDate()-week+1;
			var FormatDate:DateFormatter=new DateFormatter();
			// 定义日期格式		
			FormatDate.formatString="YYYY-MM-DD";   	
			return FormatDate.format(endDate);
		}
		
		public static function getEndOfWeek():String{// 取本星期的最后一天
			var week:Number=now.getDay();
            if(week ==0)
                week = 7;
			var endDate:Date=new Date(now.getTime());
			endDate['date']=now.getDate()-week+7;
			var FormatDate:DateFormatter=new DateFormatter();
			// 定义日期格式		
			FormatDate.formatString="YYYY-MM-DD";	     	
			return FormatDate.format(endDate);
		}
		
		
		public static function myDateCompare(dtstart:String,dtend:String):Boolean{
			
			var dbegin:Date = DateField.stringToDate(dtstart,"YYYY-MM-DD");
			var dend:Date =  DateField.stringToDate(dtend,"YYYY-MM-DD");
			
			if(ObjectUtil.dateCompare(dbegin,dend)==1) return false;
			
			return true;
		}
		
		//计算日期相差的天数
		public static function myDateDiffer(dtstart:String,dtend:String):int{
			
			var dbegin:Date = DateField.stringToDate(dtstart,"YYYY-MM-DD");
			var dend:Date =  DateField.stringToDate(dtend,"YYYY-MM-DD");
			
			var num1:Number =dbegin.valueOf(); 
			var num2:Number =dend.valueOf(); 
			
			var different:Number = num2-num1; 
			
			var day:int  = int(different/24/60/60/1000);//方法

			return day;
		}
		
		public static function getToday():String{// 取今天
			var fmt:DateFormatter = new DateFormatter();
			fmt.formatString = "YYYY-MM-DD";
			return fmt.format(now);
		}
		
		public static function getYestoday():String{// 取昨天
			return getYearMonDay(now);
		}
		
		private static function getYearMonDay(date:Date):String
		{
			var strYMD:String;
			var strMon:String;
			var strDay:String;
			if(date == null)
			{
				strYMD = "2020-12-31";
			}
			else
			{
				if((date.getMonth()+1)<10)
				{
					strMon = "0" + (date.getMonth()+1).toString();
					if((date.getDate()-1)<10 &&(date.getDate()-1)>0)
						strDay = "0" + (date.getDate()-1).toString();
					else if(date.getDate() - 1 == 0)
					{
						switch(strMon)
						{
							case "01":
								strDay = "31";
								strMon = "12";
								break;
							case "02":
								strDay = "31";
								strMon = "01";
								break;
							case "03":
								strDay = "28";
								strMon = "02";
								break;
							case "04":
								strDay = "31";
								strMon = "03";
								break;
							case "05":
								strDay ="30";
								strMon = "04";
								break;
							case "06":
								strDay = "31";
								strMon = "05";
								break;
							case "07":
								strDay = "30";
								strMon = "06";
								break;
							case "08":
								strDay = "31";
								strMon = "07";
								break;
							case "09":
								strDay = "31";
								strMon = "08";
								break;
							case "10":
								strDay = "30";
								strMon = "09";
								break;
							case "11":
								strDay = "31";
								strMon ="10";
								break;
							case "12":
								strDay ="30";
								strMon = "11";
								break;
						}
					}
					else
						strDay = (date.getDate()-1).toString();
				}
					
				else
				{
					strMon = (date.getMonth()+1).toString();
					if((date.getDate()-1)<10 &&(date.getDate()-1)>0)
						strDay = "0" + (date.getDate()-1).toString();
					else if(date.getDate() - 1 == 0)
					{
						switch(strMon)
						{
							case "01":
								strDay = "31";
								strMon = "12";
								break;
							case "02":
								strDay = "31";
								strMon = "01";
								break;
							case "03":
								strDay = "28";
								strMon = "02";
								break;
							case "04":
								strDay = "31";
								strMon = "03";
								break;
							case "05":
								strDay ="30";
								strMon = "04";
								break;
							case "06":
								strDay = "31";
								strMon = "05";
								break;
							case "07":
								strDay = "30";
								strMon = "06";
								break;
							case "08":
								strDay = "31";
								strMon = "07";
								break;
							case "09":
								strDay = "31";
								strMon = "08";
								break;
							case "10":
								strDay = "30";
								strMon = "09";
								break;
							case "11":
								strDay = "31";
								strMon ="10";
								break;
							case "12":
								strDay ="30";
								strMon = "11";
								break;
						}
					}
					else
						strDay = (date.getDate()-1).toString();
					
				} 
				strYMD = date.getFullYear().toString()+"-"+strMon+"-"+
					strDay;
			}
			return strYMD;
		} 
	}

}