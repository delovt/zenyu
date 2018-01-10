package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IFormRelationService;

import java.util.HashMap;
import java.util.List;

public class FormRelationImpl extends BaseDao implements IFormRelationService {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6331948540522315406L;

	@Override
	public List<?> getTables() {
		return this.queryForList("fr.getTables");
	}

	@Override
	public List<?> getTableFields(HashMap<?, ?> params) {
		return this.queryForList("fr.getTableFields", params);
	}

	@Override
	public int insertFormRelation(HashMap<?, ?> params) {
		return (Integer) this.insert("fr.insertFormRelation", params);
	}

	@Override
	public void insertFormFields(HashMap<?, ?> params) {
		this.insert("fr.insertFormFields", params);
	}

}
