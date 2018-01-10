package yssoft.cache;

/**
 * 缓存管理器，用于屏蔽具体使用哪个缓存框架，例如：在前期项目较小的时候将使用EHCache作为整体
 * 缓存服务，而如果系统发展到一定程度后可能会考虑使用MEMCache进行跨机器的缓存，这时仅需要修改
 * 此配置既可以。
 * @author ndq
 */
public interface CacheManager<T extends Cache<?, ?>> {
	
	/**
	 * 根据缓存名称得到缓存对象
	 * @param cacheName 缓存名称
	 * @return
	 */
	T getCache(String cacheName);
	
	/**
	 * 根据配置信息刷新缓存
	 * @param cacheName  待刷新的缓存名称
	 * @param configInfo 缓存的配置信息
	 * @return 返回已经刷新的缓存的实例
	 */
	T refreshCache(String cacheName, String configInfo);
	
}
