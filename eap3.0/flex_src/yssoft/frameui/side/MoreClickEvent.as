/**
 * Created with IntelliJ IDEA.
 * User: aruis
 * Date: 13-4-26
 * Time: 下午1:49
 * To change this template use File | Settings | File Templates.
 */
package yssoft.frameui.side {

import flash.events.Event;

public class MoreClickEvent extends Event {
    public static const BillMoreClick:String = "billMoreClick";

    public var clickItem:Object;

    override public function clone():Event {
        return new MoreClickEvent(type, clickItem, bubbles, cancelable);
    }

    public function MoreClickEvent(type:String, clickItem:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
        this.clickItem = clickItem;
        super(type, bubbles, cancelable);
    }
}
}
