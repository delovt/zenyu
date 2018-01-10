package yssoft.utils;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import javax.xml.stream.events.Attribute;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * Created by Lenovo on 14-5-6.
 */
public class SwitchBaiduAddree {
    private String X;
    private String Y;
    public double lng = 0.0;
    public double lat = 0.0;
    private String surl;
    public String address="";

    public SwitchBaiduAddree(String X, String Y) {
        this.X = X;
        this.Y = Y;
        this.surl = "http://api.map.baidu.com/geocoder?output=xml&location="+X+","+Y;

        //this.surl = "http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x=120.0&y=40.0";
    }

    public void changeLocation() {
        URL url;
        try {
            url = new URL(surl);
            HttpURLConnection http = (HttpURLConnection) url.openConnection();
            http.setRequestProperty("content-type", "text/html");
            http.setDoInput(true);
            http.setDoOutput(true);
            http.connect();
            http.getOutputStream().flush();
            BufferedReader in = new BufferedReader(new InputStreamReader(
                    http.getInputStream(), "UTF-8"));

            String line = "";
            StringBuilder sb = new StringBuilder();
            while ((line = in.readLine()) != null) {
                sb.append(line);
            }
            System.out.println(sb);

           jsonParse(sb.toString());

        } catch (MalformedURLException e1) {
            e1.printStackTrace();
            System.out.println("获取地址出错");
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("获取地址出错");
        }

    }

    public void jsonParse(String xmlURL)
    {
        HashMap<Object, Object> map = new HashMap<Object, Object>();
        SAXReader saxReader = new SAXReader();
        Document document = null;
        try{
            document = saxReader.read(new StringReader(xmlURL));
        }catch(DocumentException e){
            e.printStackTrace();
        }
        if(document==null)
            return;
        //获取跟节点
        Element element = document.getRootElement();

        //获得根节点所有属性值
        List<?> iList = element.attributes();
        for(int i=0;i<iList.size();i++){
            Attribute attribute = (Attribute)iList.get(i);
            map.put(attribute.getName(), attribute.getValue());
        }
        //遍历根节点下属性为formatted_address的子节点

        Iterator<?> pIterator = element.elementIterator("result");

        while(pIterator.hasNext()){
            Element ele = (Element)pIterator.next();
            Iterator<?> pIterator2 = ele.elementIterator("formatted_address");
            //子节点的name的值，和Text
            while(pIterator2.hasNext()){
                Element ele2 = (Element)pIterator2.next();
                address =ele2.getText();
            }
        }

    }
}
