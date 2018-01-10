/**
 * @auth zmm
 * @description 账号信息解密
 */
package yssoft.utils;

import org.springframework.beans.factory.FactoryBean;

import java.util.Properties;

public class AccountDecryptUtil implements FactoryBean {
	private Properties properties;
	
	public void setProperties(Properties properties) {
		this.properties = properties;
		String userName = properties.getProperty("username");   
        String password = properties.getProperty("password");   
        if (userName != null){   
            properties.put("user", DesEncryptUtil.decodeDes(userName, DesEncryptUtil.DEFAULT_KEY));   
        }   
        if (password != null){   
            properties.put("password", DesEncryptUtil.decodeDes(password, DesEncryptUtil.DEFAULT_KEY));   
        }   

	}

	@Override
	public Object getObject() throws Exception {
		// TODO Auto-generated method stub
		return this.properties;
	}

	@Override
	public Class getObjectType() {
		// TODO Auto-generated method stub
		return java.util.Properties.class;
	}

	@Override
	public boolean isSingleton() {
		// TODO Auto-generated method stub
		return true;
	}

}
