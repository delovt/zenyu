package yssoft.utils;

/**
 * 系统参数 
 * @author 孙东亚
 *
 */
public  class SystemParamter {
	
	/**
	 * 初始化用户密码iid
	 */
	public static int INIT_PWD = 1;
	
	/**
	 * 用户使用初始密码登录时强制修改密码 iid
	 */
	public static int IS_INIT_PWD_MOTITY = 2;
	
	/**
	 * 密码最小长度 iid
	 */
	public static int MIN_PWD_LENGTH    = 3;
	
	/**
	 * 密码最长使用天数 iid
	 */
	public static int USE_MAX_PWD_DAY  = 4;
	
	/**
	 *登录时密码验证的最多输入次数 iid
	 */
	public static int CHECK_PWD_COUNT  = 5;
	
	/**
	 *不允许同一用户在不同客户端同时登录 iid
	 */
	public static int NO_ALLOW_MPLACE_LOGIN = 6;
	
	/**
	 * 客户端自动清退时间 iid
	 */
	public static int CLEAR_TIMER = 7;
	
	//	public static int INIT_PWD = 1;
	
	
}
