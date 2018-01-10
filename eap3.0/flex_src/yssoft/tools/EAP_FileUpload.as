package yssoft.tools
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.events.ResultEvent;

	/**
	 * 	EAP1.0平台,文件上传
	 *  @auth	YJ
	 */
	
	public class EAP_FileUpload
	{
		[Bindable]
		private var _filename:String;//文件名称
		
		public function get filename():String{
			return _filename;
		}
		
		public function set filename(value:String):void{
			_filename =	value;
		}
		
		[Bindable]   
		private var _file:FileReference=new FileReference();//文件 
		
		public function get file():FileReference{   
			return _file;   
		}
		
		public function set file(value:FileReference):void{   
			_file = value;   
		}

		[Bindable]
		private var _serveraddress:String;//上传服务器地址 
		
		public function get serveraddress():String{   
			return _serveraddress;   
		}   
		
		public function set serveraddress(value:String):void{   
			_serveraddress = value;   
		}   
		
		[Bindable]
		private var _description:String="选择文件";//用户上传文件时可以看见的描述自符串
		
		public function get description():String{
			return _description;
		}
		
		public function set description(value:String):void{
			_description = value;
		}
		
		[Bindable]
		private var _extension:String="*.*";//文件扩展名列表
		
		public function get extension():String{
			return _extension;
		}
		
		public function set extension(value:String):void{
			_extension = value;
		}
		
		[Bindable]
		private var _url:String;//所请求的URL
		
		public function get url():String{
			return _url;
		}
		
		public function set url(value:String):void{
			_url = value;
		}
		
		public function EAP_FileUpload(){}
		
		/**	creationComplete
		 * @param null   
		 * @author YJ Add 20120328
		 * @return void   
		 * */   
		public function CreationCompletedHandler():void{
			
			var fileFilter:FileFilter = new FileFilter(this.description,this.extension);
			file.addEventListener(Event.SELECT,onFileSelectUploadHandle);
			file.addEventListener(Event.COMPLETE,onFileCompleteHandle);
			file.browse([fileFilter]);
		}
		
		private function onFileSelectUploadHandle(evt:Event):void{
			var request:URLRequest = new URLRequest(url);
			file.upload(request);
			this.filename = file.name;
		}
		
		private function onFileCompleteHandle(evt:Event):void{
			var objvalue:Object = {};
			objvalue.filename = filename;
			AccessUtil.remoteCallJava("MrCustomerDest","onMrCustomerImport",null,objvalue);
		}
		
	}
}