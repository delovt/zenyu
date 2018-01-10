/**
 * Created with IntelliJ IDEA.
 * User: yj
 * Date: 14-7-15
 * Time: 上午11:30
 * To change this template use File | Settings | File Templates.
 */
package yssoft.views.callcenter_new {
import flash.events.Event;
import flash.net.Socket;

public class SocketMsgEvent extends Event{

    private var _socket:Socket;

    public static const SocketMsg:String="socketmsg"; 	// 操作执行成功

    public function SocketMsgEvent(type:String,socket:Socket)
    {
        super(type,false,true);
        this._socket = socket;
    }

    public function get socket():Socket {
        return _socket;
    }
}

}
