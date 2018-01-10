package yssoft.utils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;

public class ProcessManager {

//	private static String WinXPcommand = "ntsd -c q -p ";
//	private static String Win7command="taskkill /pid 916 /f";

	public ProcessManager() {
	}

	public static void killProcess() {
		String command="";
		try {
			Process process = Runtime.getRuntime().exec("tasklist");

			Scanner in = new Scanner(process.getInputStream());
			
			List list=new ArrayList();

			while (in.hasNextLine()) {
				String p = in.nextLine();
				// 打印所有进程
				System.out.println(p);
				if (p.contains("javaw.exe")) {
					StringBuffer buf = new StringBuffer();
					for (int i = 0; i < p.length(); i++) {
						char ch = p.charAt(i);
						if (ch != ' ') {
							buf.append(ch);
						}
					}
					// 打印 javaw.exe的pid
					String pid=buf.toString().split("Console")[0].substring("javaw.exe".length());
					System.out.println(pid);
					list.add(Integer.parseInt(pid));
					
				}
			}
			Collections.sort(list);//对javaw.exe进程的pid排序 选出最大的
			String pid=String.valueOf(list.get(list.size()-1));
			 if (MacUtils.getOSName().equals("windows 7")) 
			   {
			    command = command+"taskkill /pid "+pid+" /f";
			   } else
			   {
			    // 本地是windows
				 command = command+"ntsd -c q -p "+pid;
			   }
//			WinXPcommand=WinXPcommand+String.valueOf(list.get(list.size()-1));
			System.out.println(command);
			Runtime.getRuntime().exec(command);
			//break;
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		
		ProcessManager.killProcess();
	}
}
