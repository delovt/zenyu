package yssoft.models
{
	import mx.collections.ArrayCollection;

	public class ExplorerImage
	{
		[Embed(source="yssoft/assets/explorer/add.png")]
		public static var ExplorerImage_1000:Class;
		
		[Embed(source="yssoft/assets/explorer/0.png")]
		public static var ExplorerImage_0:Class;
		
		[Embed(source="yssoft/assets/explorer/1.png")]
		public static var ExplorerImage_1:Class;
		
		[Embed(source="yssoft/assets/explorer/2.png")]
		public static var ExplorerImage_2:Class;
		
		[Embed(source="yssoft/assets/explorer/3.png")]
		public static var ExplorerImage_3:Class;
		
		[Embed(source="yssoft/assets/explorer/4.png")]
		public static var ExplorerImage_4:Class;
		
		[Embed(source="yssoft/assets/explorer/5.png")]
		public static var ExplorerImage_5:Class;
		
		
		public static var imageac:ArrayCollection=new ArrayCollection([
			{label:"图标0",source:ExplorerImage_0,value:"0"},
			{label:"图标1",source:ExplorerImage_1,value:"1"},
			{label:"图标2",source:ExplorerImage_2,value:"2"},
			{label:"图标3",source:ExplorerImage_3,value:"3"},
			{label:"图标4",source:ExplorerImage_4,value:"4"},
			{label:"图标5",source:ExplorerImage_5,value:"5"},
		]);
		
	}
}