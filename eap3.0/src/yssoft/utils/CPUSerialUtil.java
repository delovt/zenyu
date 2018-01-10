package yssoft.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.io.LineNumberReader;

/**
 * 获得CPU编号
 * @author 刘磊
 */
public class CPUSerialUtil {

	/** 
	 * 根据CPU序列号获得机器码(即加密后的CPU序列号) 
	 */ 
	public static String getMachineCode()
	{
		String MachineCode=DesEncryptUtil.encodeDes(getCPUSerial(),"87654321");
		System.out.println("MachineCode："+MachineCode);
		return MachineCode;
	}
	/** 
	 * 获取第一个CPU序列号 
	 * 读取失败为"0000000000" 
	 */ 
	public static String getCPUSerial()
	{
		String result = "";
		try {
			File file = File.createTempFile("realhowto",".vbs");
			file.deleteOnExit();
			FileWriter fw = new java.io.FileWriter(file);

			String vbs =
					"Set objWMIService = GetObject(\"winmgmts:\\\\.\\root\\cimv2\")\n"
							+ "Set colItems = objWMIService.ExecQuery _ \n"
							+ "   (\"Select * from Win32_BaseBoard\") \n"
							+ "For Each objItem in colItems \n"
							+ "    Wscript.Echo objItem.SerialNumber \n"
							+ "    exit for  ' do the first cpu only! \n"
							+ "Next \n";

			fw.write(vbs);
			fw.close();
			Process p = Runtime.getRuntime().exec("cscript //NoLogo " + file.getPath().replaceAll("%20", " "));
			BufferedReader input =
					new BufferedReader
					(new InputStreamReader(p.getInputStream()));
			String line;
			while ((line = input.readLine()) != null) {
				result += line;
			}
			input.close();
			result=result.trim();
			if (result.length()==0)
			{
				result="0000000000";
			}
			System.out.println("CPUSerial："+result);
			return result;
		}
		catch(Exception e){
			result="0000000000";
			System.out.println("CPUSerial："+result);
			return result;
		}
	}

	public static void main(String[] args) {
		getMachineCode();
	}
	
	/**
	 * 配置硬盘-C盘序列号，CPU序列号，MAC地址，三合一组成字符串验证是否为一台机器
	 * replace("-", "");
	 */
	public static String getCCMCode(){
		String code = "";
		String hdd = CPUSerialUtil.getSerialNumber("c");
		code = hdd;
		return code;
		
	}
	
	//获取主板SN		eg:ES12563318
	public static String getMotherboardSN() {
        String result = "";
        try {
            File file = File.createTempFile("realhowto", ".vbs");
            file.deleteOnExit();
            FileWriter fw = new java.io.FileWriter(file);
 
            String vbs = "Set objWMIService = GetObject(\"winmgmts:\\\\.\\root\\cimv2\")\n"
                    + "Set colItems = objWMIService.ExecQuery _ \n"
                    + "   (\"Select * from Win32_BaseBoard\") \n"
                    + "For Each objItem in colItems \n"
                    + "    Wscript.Echo objItem.SerialNumber \n"
                    + "    exit for  ' do the first cpu only! \n" + "Next \n";
 
            fw.write(vbs);
            fw.close();
            Process p = Runtime.getRuntime().exec(
                    "cscript //NoLogo " + file.getPath());
            BufferedReader input = new BufferedReader(new InputStreamReader(
                    p.getInputStream()));
            String line;
            while ((line = input.readLine()) != null) {
                result += line;
            }
            input.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result.trim();
    }
	
	 /**
     * 获取硬盘序列号
     * 
     * @param drive
     * @return
     */
    public static String getSerialNumber(String drive) {  
        String result = "";  
        try {  
            File file = File.createTempFile("damn", ".vbs");  
            file.deleteOnExit();  
            FileWriter fw = new java.io.FileWriter(file);  
            String vbs = "Set objFSO = CreateObject(\"Scripting.FileSystemObject\")\n"  
                    + "Set colDrives = objFSO.Drives\n"  
                    + "Set objDrive = colDrives.item(\""  
                    + drive  
                    + "\")\n"  
                    + "Wscript.Echo objDrive.SerialNumber"; // see note  
            fw.write(vbs);  
            fw.close();  
            Process p = Runtime.getRuntime().exec(  
                    "cscript //NoLogo " + file.getPath());  
            BufferedReader input = new BufferedReader(new InputStreamReader(  
                    p.getInputStream()));  
            String line;  
            while ((line = input.readLine()) != null) {  
                result += line;  
  
            }  
            input.close();  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return result.trim();  
    }  
 
    /**
     * 获取CPU序列号
     * 
     * @return
     */
    public static String getCPUSerials() {
        String result = "";
        try {
            File file = File.createTempFile("tmp", ".vbs");
            file.deleteOnExit();
            FileWriter fw = new java.io.FileWriter(file);
            String vbs = "Set objWMIService = GetObject(\"winmgmts:\\\\.\\root\\cimv2\")\n"
                    + "Set colItems = objWMIService.ExecQuery _ \n"
                    + "   (\"Select * from Win32_Processor\") \n"
                    + "For Each objItem in colItems \n"
                    + "    Wscript.Echo objItem.ProcessorId \n"
                    + "    exit for  ' do the first cpu only! \n" + "Next \n";
 
            // + "    exit for  \r\n" + "Next";
            fw.write(vbs);
            fw.close();
            Process p = Runtime.getRuntime().exec(
                    "cscript //NoLogo " + file.getPath());
            BufferedReader input = new BufferedReader(new InputStreamReader(
                    p.getInputStream()));
            String line;
            while ((line = input.readLine()) != null) {
                result += line;
            }
            input.close();
            file.delete();
        } catch (Exception e) {
            e.fillInStackTrace();
        }
        if (result.trim().length() < 1 || result == null) {
            result = "无CPU_ID被读取";
        }
        return result.trim();
    }
	
}