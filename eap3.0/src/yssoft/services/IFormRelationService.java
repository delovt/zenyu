package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface IFormRelationService {
	public List<?> getTables();
	public List<?> getTableFields(HashMap<?, ?> params);
	public int insertFormRelation(HashMap<?, ?> params);
	public void insertFormFields(HashMap<?, ?> params);
}
