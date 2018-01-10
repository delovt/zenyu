/**
 * 作者:朱毛毛
 * 日期:2011-08-18
 * 功能:滤镜效果
 */
package yssoft.tools
{
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import mx.effects.Move;
	import mx.effects.Resize;
	import mx.events.EffectEvent;
	
	public class FilterUitls
	{
		/**
		 * 发光滤镜
		 **/
		public static function glowFilter(object:Object):void
		{
			var levelGlow:GlowFilter = new GlowFilter(0xffff00,0.5,5,5);
			object.filters=[levelGlow];
		}
		/**
		 * 阴影滤镜
		 */
		 public static function dropShadowFilter(object:Object):void{
		 	var DSFilter:DropShadowFilter=new DropShadowFilter(4,45);
		 		object.filters=[DSFilter];
		 }
		/**
		 * 模糊滤镜
		 **/
		public static function blurFilter(object:Object):void
		{
			var levelGlow:BlurFilter = new  BlurFilter();
			object.filters=[levelGlow];
		}
		/**
		 * 去除滤镜效果
		 * **/
		public static function removeFilters(removeDisplayObject:DisplayObject):void{
			removeDisplayObject.filters=[];
		}
		/**
		 * 改变高度  <mx:Resize id="expand" target="{img}" widthTo="100" heightTo="200"/>
		 **/
		public static function wipeFilter(object:DisplayObject,newHeight:int):void
		{
			var resizeEffect:Resize=new Resize(object);
			resizeEffect.heightFrom=object.height;
			resizeEffect.heightTo=newHeight;
			resizeEffect.play();
			resizeEffect.addEventListener(EffectEvent.EFFECT_END,function(e:EffectEvent):void{
				resizeEffect.end();
				resizeEffect.target=null;
				resizeEffect=null;
			});
		}
		public static function moveFilter(object:DisplayObject,x:int,y:int):void{
			var move:Move=new Move(object);
				move.xTo=x;
				move.xBy=10;
				move.yTo=y;
				move.yBy=10;
				move.duration=3000;
				move.play();
		}
	}
}