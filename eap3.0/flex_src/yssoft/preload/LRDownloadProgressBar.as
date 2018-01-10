package yssoft.preload
{
	import flash.events.ProgressEvent;
	import flash.system.Capabilities;
	
	import mx.controls.Alert;
	import mx.events.RSLEvent;
	import mx.preloaders.DownloadProgressBar;
	
	public class DownloadProgressBar extends mx.preloaders.DownloadProgressBar
	{
		private var downloadDisplay:DownloadProgressBarDisplay;
		public function DownloadProgressBar()
		{
			super();
			downloadDisplay=new DownloadProgressBarDisplay();
		}
		override protected function createChildren():void
		{
			addChild(downloadDisplay);
			downloadDisplay.x=(stageWidth-downloadDisplay.width)/2;
			downloadDisplay.y=(stageHeight-downloadDisplay.height)/2;
		}
		override protected function setProgress(completed:Number,total:Number):void
		{
			var per:Number=completed/total;
			downloadDisplay.progressBar.scaleX=per;
			downloadDisplay.progressText.text=(100*per).toFixed(0)+"%";
		}
		//加载运行时
/*		override protected function rslProgressHandler(evt:RSLEvent):void{
			var per:Number = Math.round((evt.bytesLoaded/evt.bytesLoaded)*100);
			downloadDisplay.progressBar.scaleX=per;
			downloadDisplay.progressText.text="运行库:"+(100*per).toFixed(0)+"%";
		}*/
		//修改系统 初始加载时，显示进度条的时机
/*		override protected function showDisplayForDownloading(elapsedTime:int,event:ProgressEvent):Boolean{
			return elapsedTime > 600;
		}*/
	}
}