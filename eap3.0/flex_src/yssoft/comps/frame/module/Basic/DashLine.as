package yssoft.comps.frame.module.Basic {
import flash.display.Graphics;
import flash.geom.Point;

import mx.core.UIComponent;

[Style(name="lineColor", type="uint", format="Color", inherit="no")] // 虚线线条颜色
[Style(name="lineAlpha", type="Number", format="Number", inherit="no")] // 虚线线条透明度
[Style(name="pointWidth", type="Number", format="Number", inherit="no")] // 虚线线条中单个点厚度
[Style(name="pointHeight", type="Number", format="Number", inherit="no")] // 虚线线条中单个点长度
[Style(name="pointDistance", type="Number", format="Number", inherit="no")] // 虚线线条中两个点间距

public class DashLine extends UIComponent {
    public function MyDashLine() {
    }

    override protected function createChildren():void {
        var lineColor:uint = getStyle('lineColor');
        var lineAlpha:Number = getStyle('Alpha');
        var pointWidth:Number = getStyle('pointWidth');
        var pointHeight:Number = getStyle('pointHeight');
        var pointDistance:Number = getStyle('pointDistance');
        if (isNaN(lineColor)) {
            lineColor = 0x333333;
        }
        if (isNaN(lineAlpha)) {
            lineAlpha = 1;
        }
        if (isNaN(pointWidth)) {
            pointWidth = 1;
        }
        if (isNaN(pointHeight)) {
            pointHeight = 1;
        }
        if (isNaN(pointDistance)) {
            pointDistance = 1;
        }
        drawDashed(graphics, lineColor, lineAlpha, new Point(x, y), new Point(x, y + height), pointWidth, pointHeight, pointDistance);
    }

    private function drawDashed(graphics:Graphics, lineColor:uint, lineAlpha:Number, p1:Point, p2:Point, pointWidth:Number, pointLength:Number, twoPointDistance:Number):void {
        graphics.lineStyle(pointWidth, lineColor, lineAlpha);
        var max:Number = Point.distance(p1, p2);
        var dis:Number = 0;
        var p3:Point;
        var p4:Point;
        while (dis < max) {
            p3 = Point.interpolate(p2, p1, dis / max);
            dis += pointLength;
            if (dis > max) {
                dis = max;
            }
            p4 = Point.interpolate(p2, p1, dis / max);
            graphics.moveTo(p3.x, p3.y);
            graphics.lineTo(p4.x, p4.y);
            dis += twoPointDistance;
        }
    }
}
}