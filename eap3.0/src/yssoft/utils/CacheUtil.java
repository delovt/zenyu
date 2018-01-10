/**
 * 该类提供缓存统一服务 
 * 
 * @author zmm
 */
package yssoft.utils;

import yssoft.consts.SysConstant;
import yssoft.env.InitEnv;

import java.util.List;

public class CacheUtil {
	public List getCacheData(){
		return (List) InitEnv.cacheManager.getCache(SysConstant.YSCRM_CACHE).get(SysConstant.YSCRM_CACHE).get("test");
	}
}
