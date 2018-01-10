package yssoft.tools
{
	import mx.formatters.DateFormatter;

	public class DateUtil
	{
		
		/**
		 * 格式化日期
		 */
		
		public static function formateDate(date:Date=null,format:String="YYYY-MM-DD HH:NN"):String
		{
			var dateformat:DateFormatter=new DateFormatter();
			dateformat.formatString=format;
			if(!date){
				date = new Date();
			}
			return dateformat.format(date);
		}

        public static function isLeapYear(iYear) {//是否是闰年
            if (iYear % 4 == 0 && iYear % 100 != 0) {
                return true;
            } else {
                if (iYear % 400 == 0) {
                    return true;
                } else {
                    return false;
                }
            }
        }
	}
}