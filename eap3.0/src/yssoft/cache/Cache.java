package yssoft.cache;

import java.io.Serializable;
import java.util.Collection;
import java.util.Set;

/**
 * 缓存统一接口，注意由于可能出现跨机器或跨JVM的缓存，因此要求Key和Value都必须实现序列化接口。
 * 另外：缓存可能被放到不同的机器上，需要根据一定的算法来决定取哪个地方的缓存，当然这样的工作
 * 都将被屏蔽在整体缓存架构下。
 * 
 * @author ndq
 */
public interface Cache<K extends Serializable, V extends Serializable> {

	/**
	 * 保存数据
	 * @param key
	 * @param value
	 * @return
	 */
	V put(K key,V value);
	
	/**
	 * 获取缓存数据
	 * @param key
	 * @return
	 */
	V get(K key);
	
	/**
	 * 移出缓存数据
	 * @param key
	 * @return
	 */
	V remove(K key);	
	
	/**
	 * 删除所有缓存内的数据
	 * @return
	 */
	boolean clear();
	
	/**
	 * 缓存数据数量
	 * @return
	 */
	int size();
	
	/**
	 * 缓存所有的key的集合
	 * @return
	 */
	Set<K> keySet();
	
	/**
	 * 缓存的所有value的集合
	 * @return
	 */
	Collection<V> values();
	
	/**
	 * 是否包含了指定key的数据
	 * @param key
	 * @return
	 */
	boolean containsKey(K key);
	
	/**
	 * 释放Cache占用的资源
	 */
	void destroy();
	
}
