<%@ page language="java" import="java.util.*,java.net.*,java.io.*" pageEncoding="utf-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    String ip = request.getHeader("x-forwarded-for");
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("WL-Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getRemoteAddr();
    }


    //http://pv.sohu.com/cityjson?ie=utf-8 搜狐
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0014)about:internet -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<!--
Smart developers always View Source.

This application was built using Adobe Flex, an open source framework
for building rich Internet applications that get delivered via the
Flash Player or to desktops via Adobe AIR.

Learn more about Flex at http://flex.org
// -->
<head>
    <title>增宇协同供应链管理软件</title>
    <meta name="google" value="notranslate"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <!-- Include CSS to eliminate any default margins/padding and set the height of the html element and
         the body element to 100%, because Firefox, or any Gecko based browser, interprets percentage as
         the percentage of the height of its parent container, which has to be set explicitly.  Fix for
         Firefox 3.6 focus border issues.  Initially, don't display flashContent div so it won't show
         if JavaScript disabled.
    -->
    <style type="text/css" media="screen">
        html, body {
            height: 100%;
        }

        body {
            margin: 0;
            padding: 0;
            overflow: auto;
            text-align: center;
            background-color: #eaedf0;
        }

        object:focus {
            outline: none;
        }

        #flashContent {
            display: none;
        }
    </style>

    <!-- Enable Browser History by replacing useBrowserHistory tokens with two hyphens -->
    <!-- BEGIN Browser History required section -->
    <link rel="stylesheet" type="text/css" href="history/history.css"/>
    <script type="text/javascript" src="history/history.js"></script>
    <!-- END Browser History required section -->

    <script type="text/javascript" src="swfobject.js"></script>
    <script type="text/javascript" src="key.js"></script>
    <!--         <script src="http://fw.qq.com/ipaddress" type="text/javascript" charset="GBK"></script> -->
    <script src="http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js" type="text/javascript"
            charset="UTF-8"></script>
    <script type="text/javascript">
        // For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection.
        var swfVersionStr = "10.2.0";
        // To use express install, set to playerProductInstall.swf, otherwise the empty string.
        var xiSwfUrlStr = "playerProductInstall.swf";
        var flashvars = {};
        var params = {};
        params.quality = "high";
        //             params.bgcolor = "#eaedf0";
        params.bgcolor = "#FFFFFF";
        params.allowscriptaccess = "always";
        params.allowfullscreen = "true";
        params.id = "index";
        params.name = "index"
        var attributes = {};
        attributes.id = "index";
        attributes.name = "index";
        attributes.align = "middle";
        //判断版本号
        var verson = swfobject.getFlashPlayerVersion();
        if (10 > verson.major) {
            window.location.href = "./plugin/index.html";
        }

        swfobject.embedSWF(
                        "index.swf?" + "22811"+Math.random(), "flashContent",
                "100%", "100%",
                swfVersionStr, xiSwfUrlStr,
                flashvars, params, attributes);
        // JavaScript enabled so display the flashContent div in case it is not replaced with a swf object.
        swfobject.createCSS("#flashContent", "display:block;text-align:left;");

        function onloadHanlder() { // swf 主体获得焦点
            var appid = "index";
            document.getElementById(appid).focus();
        }
        function getRemoteIp() {
            return document.getElementById("clientip").value;
        }

        function getRemoteIpAndAddress() {
            try {
                var address = (remote_ip_info.province.toString() + "省" + " " + remote_ip_info.city.toString() + "市");
                return address;
            } catch (e) {
                return "未获取到地址";
            }
        }

        //function onbeforeunloadHandler(){
        //	return "确认离开本页面?";
        //}

        function onunloadHandler() {
            var appid = "${application}";
            document.getElementById(appid).logout();
            //alert("退出成功");
        }
        function openWindow(url) {
            window.open(url, "", "toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no") //写成一行
        }

        //下载页面
        //function openDownFile(url){
        //	window.open(document.getElementById("basePathId").value+url);
        //	alert(document.getElementById("basePathId").value+url);
        //}

        //执行本地 程序
        function runLocalSoft(path) {
            if (path == null || path == "") {
                return "程序路径错误";
            }
            //if(window.ActiveXObject){
            //return "请使用IE内核的浏览器,当前浏览器，不支持打开本地程序";
            //}

            try {
                var objShell = new ActiveXObject("wscript.shell");
                objShell.Run("\"" + path);
                objShell = null;
                return "suc";
            } catch (e) {
                return "不能执行路径[" + path + "]下的应用，原因可能如下:1 文件路径错误;2 该站点不是可信站点;3 您的浏览器安全级别太高了";
            }
        }

        //选择本地文件--打开文件选择窗口
        function flexSelectLocalFilePath() {
            document.getElementById("fileInput").click();
        }
        //获取文件路径，并转给flex
        function OnFileChange() {
            if (document.getElementById("fileInput").value == null || document.getElementById("fileInput").value == "") {
                return;
            }
            var appid = "index";
            document.getElementById(appid).onFile(document.getElementById("fileInput").value);
            document.getElementById("fileInput").value = "";
        }


    </script>
</head>
<body onload="onloadHanlder()">
<input type="file" id="fileInput" style="display:none" onchange="OnFileChange()"/><!--fileInput控件-->
<input id="clientip" type="hidden" value="<%=ip%>"/>
<input id="basePathId" type="hidden" value="<%=basePath%>"/>
<!-- SWFObject's dynamic embed method replaces this alternative HTML content with Flash content when enough
     JavaScript and Flash plug-in support is available. The div is initially hidden so that it doesn't show
     when JavaScript is disabled.
-->
<div id="flashContent">
    <p>
        To view this page ensure that Adobe Flash Player version
        10.2.0 or greater is installed.
    </p>
</div>

<noscript>
    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%" id="index" name="index">
        <param name="movie" value="index.swf"/>
        <param name="quality" value="high"/>
        <param name="bgcolor" value="#eaedf0"/>
        <param name="allowScriptAccess" value="always"/>
        <param name="allowFullScreen" value="true"/>
        <!--[if !IE]>-->
        <object type="application/x-shockwave-flash" data="index.swf" width="100%" height="100%" name="index"
                id="index2">
            <param name="quality" value="high"/>
            <param name="bgcolor" value="#eaedf0"/>
            <param name="allowScriptAccess" value="always"/>
            <param name="allowFullScreen" value="true"/>
            <!--<![endif]-->
            <!--[if gte IE 6]>-->
            <p>
                Either scripts and active content are not permitted to run or Adobe Flash Player version
                10.2.0 or greater is not installed.
            </p>
            <!--<![endif]-->
            <!--                    <a href="http://www.adobe.com/go/getflashplayer">-->
            <!--                        <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash Player" />-->
            <!--                    </a>-->
            <!--[if !IE]>-->
        </object>
        <!--<![endif]-->
    </object>
</noscript>
</body>
</html>
