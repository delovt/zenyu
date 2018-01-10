/**
 *
 * 文件名：TestJob.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-10-18    
 * 版权所有  徐州市增宇软件有限公司
 *
 */
package yssoft.job;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

import yssoft.servlets.LicenseServlet;
import yssoft.utils.EncryptUtil;
import yssoft.utils.ToolUtil;
import yssoft.views.SendMessageView;
import NT124DOG.NT124JNI;

/**
 * 以后后台的轮询执行都放在此类中
 * <p/>
 * 项目名称：rkycrm_zg 类名称：TestJob 类描述： 创建人：XZQWJ 创建时间：2011-2011-10-18 下午12:53:49 lr
 * modify 2013-01-07
 */
public class CRMTimer {
    public static short m_DevNum = 0; // 找到的设备数
    public static int count = 0;

    public static boolean bool = true;//未到期

    private SendMessageView sendMessageView;

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

    public void setSendMessageView(SendMessageView sendMessageView) {
        this.sendMessageView = sendMessageView;
    }

    /**
     * 功能：轮询方法
     * count % 6 == 0 表示：每一分钟执行一次
     */
    public void work() {
        count++;
        System.out.print(count);
        if (count == 9000)
            count = 0;

        if (bool) {//试用版本未过期

            if (count == 1) {
                sendMsgForWorkFlow();
            }
            // 验证加密狗
            if (LicenseServlet.getLicenseMap().containsKey("nt124dog")) {
                if (count % 1 == 0)
                    checkDog();
            } else {
                System.out.print("*");
            }
            if (count % 3 == 0)
                checkThingPlan();

            if (String.valueOf(LicenseServlet.getLicenseMap().get("RegisterMac")).trim().equals(".")) {//试用版
                if (count % 12 == 0)
                    calculateDay();
            }
            if (count % 60 == 0)
                // send messages every 10 minutes
                sendMsgForWorkFlow();
        } else {
            System.out.print("*");
        }

    }

    private int testcount = 0;

    private void checkDog() {
        if (LicenseServlet.getLicenseMap().containsKey("nt124dog")) {
            NT124JNI nt124jni = new NT124JNI();
            String RegisterMac = (String) LicenseServlet.getLicenseMap().get(
                    "RegisterMac");
            String RegisterMaxUser = (String) LicenseServlet.getLicenseMap()
                    .get("RegisterMaxUser");
            byte[] PidData = new byte[16];
            PidData = RegisterMac.trim().getBytes();
            m_DevNum = nt124jni.NT124FindDev(PidData);
            if (m_DevNum == 0) {
                System.out.println("--Spring--Quartz的任务调度！！！  没有找到加密狗");
                testcount++;
                doTestCheck();
            } else {
                testcount = 0;
                System.out.println("--Spring--Quartz的任务调度！！！找到加密狗，加密狗号为："
                        + RegisterMac);
                System.out.println(RegisterMaxUser);
            }
        } else {
            System.out.print("*");
            System.out.println("试用版已过期，请联系供应商");
        }

    }

    private void doTestCheck() {
        if (testcount > 100)
            exit();
    }

    private void exit() {
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        System.exit(0);
    }

    private void checkThingPlan() {

    }

    private void sendMsgForWorkFlow() {
        sendMessageView.SendMsgForWorkFlow();
    }

    /**
     * 作者：XZQWJ 功能：计算系统从使用到当前的天数
     */
    private void calculateDay() {

        if (LicenseServlet.getLicenseMap().containsKey("RegisterDays")) {// 试用天数
            String RegisterDays = (String) LicenseServlet.getLicenseMap().get(
                    "RegisterDays");
            String RegisterMac = (String) LicenseServlet.getLicenseMap().get(
                    "RegisterMac");
            String path = this.getClass().getResource("/").getFile()
                    + "version.properties";
            File f = new File(path);
            if (RegisterMac.equals(".")) {// 试用版本
                if (!f.exists()) {
                    bool = false;
                    LicenseServlet.getLicenseMap().put("RegisterExpire",
                            "false");// 过期
                    System.out.println("试用版已过期，请联系供应商");
                    return;
                } else {
                    try {
                        EncryptUtil encryptUtil = new EncryptUtil();// 默认密钥
                        FileInputStream fis = new FileInputStream(path);
                        Properties p = new Properties();
                        p.load(fis);

                        String yseap = p.getProperty("yseap");
                        yseap = encryptUtil.decrypt(yseap);
                        fis.close();
                        String str[] = yseap.split("@");
                        String last_date = str[0].trim();
                        String s_days = str[1].trim();
                        Date currDate = new Date();
                        int days = ToolUtil.getDaySub(last_date, formatter.format(currDate));
                        if (days >= 0) {
                            days = days + Integer.parseInt(s_days);// 使用天数
                            OutputStream o = new FileOutputStream(path);
                            Properties properties = new Properties();


                            String temp = formatter.format(currDate).toString()
                                    + "@" + String.valueOf(days);

                            temp = encryptUtil.encrypt(temp);

                            properties.setProperty("yseap", temp);
                            properties.store(o, "yseap");
                            o.close();
                            if (days - Integer.parseInt(RegisterDays) > 0) {
                                bool = false;
                                LicenseServlet.getLicenseMap().put(
                                        "RegisterExpire", "false");// 过期
                                System.out.println("试用版已过期，请联系供应商");
                                return;
                            }

                        } else {
                            bool = false;
                            LicenseServlet.getLicenseMap().put(
                                    "RegisterExpire", "false");// 过期
                            System.out.println("试用版已过期，请联系供应商");
                            return;
                        }
                    } catch (FileNotFoundException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    } catch (IOException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    } catch (Exception e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                }
            }
        }

    }
}
