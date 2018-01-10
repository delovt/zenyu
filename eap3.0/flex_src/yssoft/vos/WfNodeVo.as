package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.WfNodeVo")]
	public class WfNodeVo
	{
		
		
		public function WfNodeVo()
		{
			
		}
		public var iid:int;
		public var ipid:int;
		public var inodeid:String;
		public var ipnodeid:String;
		public var inodelevel:int;
		public var ioainvoice:int;
		public var inodetype:int;
		public var inodevalue:int;
		public var inodeattribute:int;
		public var inodemode:int;
		public var bfinalverify:int;
		public var baddnew:int;
		public var bsendnew:int;
		public var istatus:int;
		public var cnotice:String;
		public var baddnode:int;
		public var nodesIstatus:int; // wf_nodes 下当前用户节点的 状态
		public var source:String;	// 标示该节点是来自 wf_node 表 还是 wf_nodes表，只有在 组织节点时有效
		
		public var iinvoset:int;
		public var ccomefield:String;

        public var cexecsql:String;
        public var iistatus:int;

	}
}