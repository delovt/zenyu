package yssoft.utils;

import sun.misc.BASE64Decoder;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class SwitchBaiduLocation {
    private String X;
    private String Y;
    public double lng = 0.0;
    public double lat = 0.0;
    private String surl;

    public SwitchBaiduLocation(String X, String Y) {
        this.X = X;
        this.Y = Y;
        this.surl = "http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x="
                + X + "&y=" + Y;
        //this.surl = "http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x=120.0&y=40.0";
    }

    public void changeLocation() {
        URL url;
        try {
            url = new URL(surl);
            HttpURLConnection http = (HttpURLConnection) url.openConnection();
            http.setDoInput(true);
            http.setDoOutput(true);
            http.connect();
            http.getOutputStream().flush();
            BufferedReader in = new BufferedReader(new InputStreamReader(
                    http.getInputStream(), "UTF-8"));

            String line;
            line = in.readLine();
            System.out.println(line);
            jsonParse(line);

        } catch (MalformedURLException e1) {
            e1.printStackTrace();
            System.out.println("转换坐标出错");
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("转换坐标出错");
        }

    }

    public void jsonParse(String line) throws IOException {
        String line1 = line.replace("}", "").replace("\"", "").replace("{", "");
        System.out.println(line1);
        if (!line1.split(",")[0].split(":")[1].equals("0")) return;
        String x = line1.split(",")[1].split(":")[1];
        String y = line1.split(",")[2].split(":")[1];
        BASE64Decoder decoder = new BASE64Decoder();

        String x1 = new String(decoder.decodeBuffer(x));
        String y1 = new String(decoder.decodeBuffer(y));

        this.lng = Double.parseDouble(x1);
        this.lat = Double.parseDouble(y1);
    }
}
