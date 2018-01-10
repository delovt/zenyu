package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IFditemService;

import java.util.List;

public class FditemServiceImpl extends BaseDao implements IFditemService {

	public List queryFditem()
	{
		return this.queryForList("getFditem");
	}
}
