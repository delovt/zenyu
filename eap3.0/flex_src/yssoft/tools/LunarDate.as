package yssoft.tools
{
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.http.HTTPService;
	
	public class LunarDate
	{
		
		public function LunarDate()
		{
		}
		
		private static var lunarInfo:Array = new Array(
			0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0,
			0x09ad0, 0x055d2, 0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540,
			0x0d6a0, 0x0ada2, 0x095b0, 0x14977, 0x04970, 0x0a4b0, 0x0b4b5, 0x06a50,
			0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970, 0x06566, 0x0d4a0,
			0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,
			0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2,
			0x0a950, 0x0b557, 0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0, 0x14573,
			0x052d0, 0x0a9a8, 0x0e950, 0x06aa0, 0x0aea6, 0x0ab50, 0x04b60, 0x0aae4,
			0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0, 0x096d0, 0x04dd5,
			0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6,
			0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46,
			0x0ab60, 0x09570, 0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58,
			0x055c0, 0x0ab60, 0x096d5, 0x092e0, 0x0c960, 0x0d954, 0x0d4a0, 0x0da50,
			0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5, 0x0a950, 0x0b4a0,
			0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
			0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260,
			0x0ea65, 0x0d530, 0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0,
			0x1d0b6, 0x0d250, 0x0d520, 0x0dd45, 0x0b5a0, 0x056d0, 0x055b2, 0x049b0,
			0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0);
		public static var lFtv:Array = new Array(
			"0101*春节",
			"0115*元宵",
			"0505*端午",
			"0707*七夕",
			"0815*中秋",
			"0909*重阳",
			"1208*腊八",
			"1223*小年",
			"0100*除夕");
		private static var solarTerm:Array = new Array(
			"小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨","立夏",
			"小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分",
			"寒露","霜降","立冬","小雪","大雪","冬至");
		private static var sTermInfo:Array = new Array(
			0,21208,42467,63836,85337,107014,128867,150921,173149,195551,218072,
			240693,263343,285989,308563,331033,353350,375494,397447,419210,440795,
			462224,483532,504758);
		
		public static var yjState:int = 10;
		public static var yjObj:Object = new Object();
		//public static var tstStr:String;
		
		//====== 传回农历 y年的总天数
		public static function lYearDays(y:int):int
		{
			var i:int, sum:int = 348;
			for (i = 0x8000; i > 0x8; i >>= 1)
			{
				if ((lunarInfo[y - 1900] & i) != 0)
					sum += 1;
			}
			return (sum + leapDays(y));
		}
		
		//====== 传回农历 y年闰月的天数
		public static function leapDays(y:int):int
		{
			if (leapMonth(y) != 0)
			{
				if ((lunarInfo[y - 1900] & 0x10000) != 0)
					return 30;
				else
					return 29;
			}
			else
				return 0;
		}
		
		//====== 传回农历 y年闰哪个月 1-12 , 没闰传回 0
		public static function leapMonth(y:int):int
		{
			return (int)(lunarInfo[y - 1900] & 0xf);
		}
		
		//====== 传回农历 y年m月的总天数
		public static function monthDays(y:int, m:int):int
		{
			if ((lunarInfo[y - 1900] & (0x10000 >> m)) == 0)
				return 29;
			else
				return 30;
		}
		
		//====== 传回农历 y年的生肖
		public static function AnimalsYear(y:int):String
		{
			var Animals:Array = new Array("鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪");
			return Animals[(y - 4) % 12];
		}
		
		//====== 传入 月日的offset 传回干支, 0=甲子
		public static function cyclicalm(num:int):String
		{
			var Gan:Array = new Array("甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸");
			var Zhi:Array = new Array("子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥");
			return (Gan[num % 10] + Zhi[num % 12]);
		}
		
		//====== 传入 offset 传回干支, 0=甲子
		public static function cyclical(y:int):String
		{
			var num:int = y - 1900 + 36;
			return (cyclicalm(num));
		}
		
		//传出农历.year0 .month1 .day2 .yearCyl3 .monCyl4 .dayCyl5 .isLeap6
		public static function Lunar(y:int, m:int):Array
		{
			var year20:Array = new Array(1, 4, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1);
			var year19:Array = new Array(0, 3, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0);
			var year2000:Array = new Array(0, 3, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1);
			var nongDate:Array = new Array(7);
			var i:int = 0, temp:int = 0, leap:int = 0;
			var baseDate:Date = new Date(1900, 1, 31);
			var objDate:Date = new Date(y, m, 1);
			var offset:Number = (objDate.getTime() - baseDate.getTime()) / 86400000;
			if (y < 2000)
				offset += year19[m - 1];
			if (y > 2000)
				offset += year20[m - 1];
			if (y == 2000)
				offset += year2000[m - 1];
			nongDate[5] = offset + 40;
			nongDate[4] = 14;
			for (i = 1900; i < 2050 && offset > 0; i++)
			{
				temp = lYearDays(i);
				offset -= temp;
				nongDate[4] += 12;
			}
			if (offset < 0)
			{
				offset += temp;
				i--;
				nongDate[4] -= 12;
			}
			nongDate[0] = i;
			nongDate[3] = i - 1864;
			leap = leapMonth(i); //闰哪个月
			nongDate[6] = 0;
			for (i = 1; i < 13 && offset > 0; i++)
			{
				//闰月
				if (leap > 0 && i == (leap + 1) && nongDate[6] == 0)
				{
					--i;
					nongDate[6] = 1;
					temp = leapDays((int)(nongDate[0]));
				}
				else
				{
					temp = monthDays((int)(nongDate[0]), i);
				}
				//解除闰月
				if (nongDate[6] == 1 && i == (leap + 1))
					nongDate[6] = 0;
				offset -= temp;
				if (nongDate[6] == 0)
					nongDate[4]++;
			}
			if (offset == 0 && leap > 0 && i == leap + 1)
			{
				if (nongDate[6] == 1)
				{
					nongDate[6] = 0;
				}
				else
				{
					nongDate[6] = 1;
					--i;
					--nongDate[4];
				}
			}
			if (offset < 0)
			{
				offset += temp;
				--i;
				--nongDate[4];
			}
			nongDate[1] = i;
			nongDate[2] = offset + 1;
			return nongDate;
		}
		
		//传出公历y年m月d日对应的农历.year0 .month1 .day2 .yearCyl3 .monCyl4 .dayCyl5 .isLeap6
		public static function calElement(y:int, m:int, d:int):Array
		{
			var nongDate:Array = new Array(7);
			var i:int = 0, temp:int = 0, leap:int = 0;
			var baseDate:Date = new Date(00, 0, 31);
			var objDate:Date = new Date(y, m - 1, d);
			var offset:Number = (Number)((objDate.getTime() - baseDate.getTime()) / 86400000);
			nongDate[5] = offset + 40;
			nongDate[4] = 14;
			for (i = 1900; i < 2050 && offset > 0; i++)
			{
				temp = lYearDays(i);
				offset -= temp;
				nongDate[4] += 12;
			}
			if (offset < 0)
			{
				offset += temp;
				i--;
				nongDate[4] -= 12;
			}
			nongDate[0] = i;
			nongDate[3] = i - 1864;
			leap = leapMonth(i); //闰哪个月
			nongDate[6] = 0;
			for (i = 1; i < 13 && offset > 0; i++)
			{
				//闰月
				if (leap > 0 && i == (leap + 1) && nongDate[6] == 0)
				{
					--i;
					nongDate[6] = 1;
					temp = leapDays((int)(nongDate[0]));
				}
				else
				{
					temp = monthDays((int)(nongDate[0]), i);
				}
				//解除闰月
				if (nongDate[6] == 1 && i == (leap + 1))
					nongDate[6] = 0;
				offset -= temp;
				if (nongDate[6] == 0)
					nongDate[4]++;
			}
			if (offset == 0 && leap > 0 && i == leap + 1)
			{
				if (nongDate[6] == 1)
				{
					nongDate[6] = 0;
				}
				else
				{
					nongDate[6] = 1;
					--i;
					--nongDate[4];
				}
			}
			if (offset < 0)
			{
				offset += temp;
				--i;
				--nongDate[4];
			}
			nongDate[1] = i;
			nongDate[2] = offset + 1;
			return nongDate;
		}
		//传回 农历 xx年xx月初几 如  农历 辛卯年 【兔年】 正月初十
		public static function getLunar(date:Date=null):String{
			if(date==null){
				date=new Date();
			}
			var y:int=date.getFullYear();
			var m:int=date.getMonth();
			var d:int=date.getDate();
			
			//返回 
			var lunarY:String=getLunarGZ(y,m,d)[0];
			var lunarDate:Array=calElement(y,m+1,d);
			var lunarM:String=getChnMonth(lunarDate[1]);
			var lunarD:String=getChnDate(lunarDate[2]);
			
			return "农历："+lunarY+" "+AnimalsYear(y)+"年 "+lunarM+" "+lunarD +" "+getSoralTerm(y,m+1,d)+" "+getLunarHoliday(lunarDate[1],lunarDate[2]);
			
		}
		
		//通过公历年月日获取农历年柱月柱日柱
		//m月份从0开始算
		public static function getLunarGZ(y:int, m:int, d:int):Array
		{
			var days:Array = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
			var cY:String = "";
			var cM:String = "";
			var cD:String = "";
			
			if (y % 400 == 0 || (y % 4 == 0 && y % 100 != 0)) days[1]++;
			
			////////年柱 1900年立春后为庚子年(60进制36)
			if (m  < 2)
			{
				cY = cyclicalm(y - 1900 + 36 - 1);
			}
			else
			{
				cY = cyclicalm(y - 1900 + 36);
			}
			var sterm:int = sTerm(y, 2); //立春日期
			
			////////月柱 1900年1月小寒以前为 丙子月(60进制12)
			var firstNode:int = sTerm(y, m * 2); //返回当月「节」为几日开始
			if(d >= firstNode)
			{
				cM = cyclicalm((y - 1900) * 12 + m + 13);
			}
			else
			{
				cM = cyclicalm((y - 1900) * 12 + m + 12);
			}
			
			//当月一日与 1900/1/1 相差天数
			//1900/1/1与 1970/1/1 相差25567日, 1900/1/1 日柱为甲戌日(60进制10)
			var dayCyclical:Number = Date.UTC(y, m, d, 0, 0, 0, 0) / 86400000 + 25567 + 10;
			
			cD = cyclicalm(dayCyclical);
			
			return (new Array(cY, cM, cD));
		}
		
		//获取公历月份对应的农历信息
		public static function getLunarByMonth(pdate:Date):Array
		{
			var ary:Array = new Array();
			var days:Array = new Array(0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
			
			var year:int = pdate.getFullYear();
			var month:int = pdate.getMonth() + 1;
			var info:Array;
			
			if(year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) days[2]++;
			
			for(var i:int = 1; i <= days[month]; i++)
			{
				info = calElement(year, month, i);
				if(info[2] == 1)
				{
					if(info[6] == 1)	//闰月
					{
						ary.push("闰" + getChnMonth(info[1]));
					}
					else
					{
						ary.push(getChnMonth(info[1]));
					}
				}
				else
				{
					ary.push(getChnDate(info[2]));
				}
			}
			
			//获取节气
			ary[sTerm(year, month*2-2)-1] = solarTerm[month*2-2];
			ary[sTerm(year, month*2-1)-1] = solarTerm[month*2-1];
			
			return ary;
		}
		
		//获取农历月份中文
		public static function getChnMonth(month:int):String
		{
			
			switch(month){
				case 1:return "正月";
				case 2:return "二月";
				case 3:return "三月";
				case 4:return "四月";
				case 5:return "五月";
				case 6:return "六月";
				case 7:return "七月";
				case 8:return "八月";
				case 9:return "九月";
				case 10:return "十月";
				case 11:return "十一月";
				case 12:return "十二月";
			}
			return "";
		}
		
		//获取农历日期中文
		public static function getChnDate(day:int):String
		{
			var a:String = "";
			if (day == 10)
				return "初十";
			if (day == 20)
				return "二十";
			if (day == 30)
				return "三十";
			var two:int = (int)((day) / 10);
			if (two == 0)
				a = "初";
			else if (two == 1)
				a = "十";
			else if (two == 2)
				a = "廿";
			else if (two == 3)
				a = "卅";
			var one:int = (int)(day % 10);
			switch (one)
			{
				case 1:
					a += "一";
					break;
				case 2:
					a += "二";
					break;
				case 3:
					a += "三";
					break;
				case 4:
					a += "四";
					break;
				case 5:
					a += "五";
					break;
				case 6:
					a += "六";
					break;
				case 7:
					a += "七";
					break;
				case 8:
					a += "八";
					break;
				case 9:
					a += "九";
					break;
			}
			return a;
		}
		
		//===== 某年的第n个节气为几日(从0小寒起算)
		private static function sTerm(y:int, n:int):int
		{
			var offDate:Date = new Date((31556925974.7 * (y - 1900) + sTermInfo[n] * 60000) + Date.UTC(1900, 0, 6, 2, 5));
			return (offDate.getUTCDate());
		}
		
		/** 核心方法 根据日期(y年m月d日)得到节气 */
		public static function getSoralTerm(y:int,m:int,d:int):String {
			var solarTerms:String;
			if (d == sTerm(y, (m - 1) * 2))
				solarTerms = solarTerm[(m - 1) * 2];
			else if (d == sTerm(y, (m - 1) * 2 + 1))
				solarTerms = solarTerm[(m - 1) * 2 + 1];
			else {
				// 到这里说明非节气时间
				solarTerms = "";
			}
			return solarTerms;
		}
		// 获取农历节日 1月1日
		public static function getLunarHoliday(m:int,d:int):String{
			var ms:String=(m<10?"0"+m:""+m);
			var ds:String=(d<10?"0"+d:""+d);
			
			var mds:String=ms+ds;
			
			for(var i:int=0;i<lFtv.length;i++){
				if((lFtv[i] as String).indexOf(mds) !=-1 ){
					return (lFtv[i] as String).split("*")[1]
				}
			}
			return "";
			
		}
	}
}