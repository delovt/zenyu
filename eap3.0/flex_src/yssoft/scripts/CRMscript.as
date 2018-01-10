import flash.events.UncaughtErrorEvent;

import yssoft.models.ConstsModel;
import yssoft.tools.CRMtool;

/**
 * app创建完成
 * @auth zmm
 * 
 */
public function appComplete():void{
	onUncaughtError();
}
/**
 *处理全局异常
 */
private function onUncaughtError():void{
	this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{
		CRMtool.tipAlert(ConstsModel.SYS_ALERT_ERROR);
	});
}
/**
 * 视图状态切换时，调用
 */
private function app_stateChangeCompleteHandler():void
{
	/* 				if(CRMmodel.isLogout){
	if(this.currentState=="loginview"){// 注销后再次进入登陆窗体
	loginview["resetQueryParam"]();
	loginview.imageCarousel.startTimer(true);
	}else{// 注销后，再次进入 主窗体
	mainview["logoutEnter"]();
	}
	} */
	// 关闭 登陆窗体的 图片轮播
/*	if(this.currentState=="mainview"){
		loginview.imageCarousel.stopTimer();
	}*/
}