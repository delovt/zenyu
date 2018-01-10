/**
 * Created with IntelliJ IDEA.
 * User: Aruis
 * Date: 12-12-14
 * Time: 下午12:53
 * To change this template use File | Settings | File Templates.
 */
package yssoft.comps.frame.module.Basic.datagrid {
public class ListItemColor {

    private var _itemTextColor:uint = uint.MAX_VALUE ;
    private var _itemBackgroundColor:uint = uint.MAX_VALUE;

    public function ListItemColor() {
    }

    public function get itemTextColor():uint {
        return _itemTextColor;
    }

    public function set itemTextColor(value:uint):void {
        _itemTextColor = value;
    }

    public function get itemBackgroundColor():uint {
        return _itemBackgroundColor;
    }

    public function set itemBackgroundColor(value:uint):void {
        _itemBackgroundColor = value;
    }
}
}
