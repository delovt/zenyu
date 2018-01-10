/*
 * @auth zmm
 * @description spring 上下文管理类
 */
package yssoft.utils;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Component
public class ApplicationContextContainerUtil extends BeanFactoryUtil.BeanFactoryProvider implements ApplicationContextAware{

	@Override
	public void setApplicationContext(ApplicationContext context) {
		super.setApplicationContext(context);
	}
}
