/**
 * @author zmm 
 * @description 获取spring bean 工厂工具类
 * 
 */
package yssoft.utils;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

@Component
public class BeanFactoryUtil {
	private static Logger logger = Logger.getLogger(BeanFactoryUtil.class);
	/**
	 */
	private static ApplicationContext applicationContext;
	/**
	 */
	private static Map<Class<?>, Serializable> cacheServices = new HashMap<Class<?>, Serializable>();

	/**
	 * @param <T>
	 * @param beanClass
	 */
	public static <T extends Serializable> T getBean(Class<T> beanClass) {
		@SuppressWarnings("unchecked")
		T bean = (T) cacheServices.get(beanClass);
		if (bean == null) {
			bean = getBeanFromContext(beanClass);
			cacheServices.put(beanClass, bean);
		}
		return bean;
	}

	/**
	 * @param <T>
	 * @param beanClass
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private static <T> T getBeanFromContext(Class<T> beanClass) {
		Map<String, T> beanMap = applicationContext.getBeansOfType(beanClass);
		Collection<T> beans = beanMap.values();
		if (beans.size() == 0) {
			throw new RuntimeException("�޷����ҵ�[" + beanClass + "]��ʵ��");
		} else if (beans.size() > 1) {
			logger.warn("���ҵ�" + beanClass + "��" + beans.size()
					+ "��ʵ��ϵͳ�����Զ�ѡ������һ��");
		}
		T bean = beans.iterator().next();
		return bean;
	}

	public static class BeanFactoryProvider {
		/**
		 * @param context
		 */
		protected void setApplicationContext(ApplicationContext context) {
			BeanFactoryUtil.applicationContext = context;
		}
	}

}
