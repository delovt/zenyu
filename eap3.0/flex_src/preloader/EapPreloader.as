package preloader
{	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.preloaders.IPreloaderDisplay;
	
	public class EapPreloader extends MovieClip implements IPreloaderDisplay
	{
		/* <IPreloaderDisplay IMPLEMENTATION> */
		
		[Bindable] public var backgroundAlpha:Number;
		[Bindable] public var backgroundColor:uint;
		[Bindable] public var backgroundImage:Object;
		[Bindable] public var backgroundSize:String;
		
		[Bindable] private var color:int = 999999;
		
		private var _preloader:Sprite
		public function set preloader(obj:Sprite):void
		{
			_preloader = obj as Sprite;
			_preloader.addEventListener(ProgressEvent.PROGRESS, onPreloaderProgress);
			_preloader.addEventListener(FlexEvent.INIT_PROGRESS, onPreloaderInitProgress, false, int.MAX_VALUE);
			_preloader.addEventListener(FlexEvent.INIT_COMPLETE, onPreloaderComplete);
			
		}
		
		private var _stageHeight:Number;
		public function get stageHeight():Number
		{
			return _stageHeight;
		}
		public function set stageHeight(value:Number):void
		{
			_stageHeight = value;
		}
		
		private var _stageWidth:Number;
		public function get stageWidth():Number
		{
			return _stageWidth;
		}
		
		public function set stageWidth(value:Number):void
		{
			_stageWidth = value;
		}
		
		private var _progressBar:Sprite;
		private var _progressText:TextField;
		public function initialize():void
		{
			_progressBar = new Sprite();
			_progressBar.graphics.beginFill(new uint("0x"+color));
			_progressBar.graphics.drawRect(0, 0, 400, 74);
			
			_progressBar.x = Math.round((stageWidth - 400)/2);
			_progressBar.y = Math.round((stageHeight - 74)/2);
			_progressBar.width = 0;
			
			addChild(_progressBar);
			
			_progressText = new TextField();
			_progressText.defaultTextFormat = new TextFormat(null, 25, 0x999999, true);
			_progressText.autoSize = TextFieldAutoSize.RIGHT;
			_progressText.x = _progressBar.x;
			_progressText.y = Math.round((stageHeight - 80)/2);
			
			addChild(_progressText);
		}
		
		/* </IPreloaderDisplay IMPLEMENTATION> */
		
		private var bytesTotal:Number = 0;
		
		private function onPreloaderProgress(e:ProgressEvent):void
		{
			if(bytesTotal!=e.bytesTotal){
				_progressBar.width = 0;
				color=442154;
				//_progressBar.beginFill(new uint("0x"+color));
			}
			bytesTotal = e.bytesTotal;
				
			_progressBar.width = e.bytesLoaded == 0 ? 0 : (e.bytesLoaded / e.bytesTotal) * 400;
			//_progressText.text = e.bytesLoaded == 0 ? "0%" : e.bytesTotal+"";
			_progressText.text = e.bytesLoaded == 0 ? "0%" : Math.round((e.bytesLoaded / e.bytesTotal) * 100) + "%    @"+e.bytesTotal;
		}
		
		private var _readyToAdvanceToSecondFrame:Boolean = false;
		private var _pendingInitProgressEvent:FlexEvent;
		private function onPreloaderInitProgress(e:FlexEvent):void
		{
			if (!_readyToAdvanceToSecondFrame)
			{
				_pendingInitProgressEvent = e.clone() as FlexEvent;
				e.stopImmediatePropagation();
			}
		}
		
		private var isPreloaderComplete:Boolean = false;
		private function onPreloaderComplete(e:FlexEvent):void
		{
			_readyToAdvanceToSecondFrame = true;
			if (_pendingInitProgressEvent != null)
			{
				dispatchEvent(_pendingInitProgressEvent);
			}
			isPreloaderComplete = true;
			
			dispatchComplete();
		}
		
		private function dispatchComplete():void 
		{
			if (isPreloaderComplete)
			{				
				// try commenting this line and see what happens:
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}
}