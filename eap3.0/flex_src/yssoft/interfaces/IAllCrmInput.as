/**
 * Created with IntelliJ IDEA.
 * User: Aruis
 * Date: 13-7-12
 * Time: 下午1:39
 * To change this template use File | Settings | File Templates.
 */
package yssoft.interfaces {
public interface IAllCrmInput {
    function set ctable(value:String);

    function get ctable():String;

    function set cfield(value:String);

    function get cfield():String;

    function set cvalue(value:String);

    function get cvalue():String;
}
}
