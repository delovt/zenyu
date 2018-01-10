package NT124DOG;

public class NT124JNI {
	//========================以下为引用语JNI动态库==============================		
			static{
				System.out.println( System.getProperty("java.library.path"));
					System.loadLibrary("NT124JNI");//载入dll
				}
			
	//========================以下为宏定义=======================================			
			public static final int OP_OK=0;           // 操作成功状态字   
			public static final int MODE_ERR=1;          // 权限不够         
			public static final int EEPROM_ERR=2;           // EEPROM写失败     
			public static final int PIN_ERR=3;           // 校验PIN密码失败  
			public static final int CHK_ZERO=4;           // 没有校验次数(已烧死)     
			public static final int PARA_ERR=5;           // 参数错误         
			public static final int CMD_ERR=6;           // 操作失败状态字   

			public static final int SEND_ERR=-1;			//为发送数据失败
			public static final int REC_ERR=-2;			//为接收数据失败
			public static final int EN_ERR=-3;			//为加密失败
			public static final int DE_ERR=-4;			//为解密失败
			public static final int READ_ERR=-5;			//读数据出错
			public static final int OPEN_ERR=-6;			//设备已打开
			public static final int OPENNOT_ERR=-7;			//设备未打开
			public static final int PASS_ERR=-8;			//密码不正确
			
	//========================以下为DLL函数定义==========================================		
			/*
			*********************************************************************
			* 函数: 查找指定产品设备
			* 参数: pPidData 16字节产品标识 
			* 返回: 查找到设备个数
			* 权限: 匿名
			* 说明: 打开设备前用来查询，是否是有多个设备
			*********************************************************************
			*/
			public native static short NT124FindDev(byte pPidData[]);//查找设备

			/*
			*********************************************************************
			* 函数: 打开设备
			* 参数: pPidData 16字节产品标识字符串  Index  相应的设备索引
			* 返回: >0正确,
			* 权限: 匿名
			* 说明: 取得相应的操作句柄
			*********************************************************************
			*/
			public native static int NT124OpenDev(byte pPidData[],short  Index);//打开设备
				
			/*
			*********************************************************************
			* 函数: 写数据
			* 参数: handle 操作设备句柄,StartAdd 开始地址 pWriteBuff 要写的数据,nBuffLen 数据长度 
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 用户或超级用户
			* 说明: 校验超级用户密码及普通用户密码正确后进行操作。
			*********************************************************************
			*/
			public native static short NT124DevWrite(int handle,short StartAdd,byte pWriteBuff[], short nBuffLen); //写设备

			/*
			*********************************************************************
			* 函数: 读数据
			* 参数: handle 操作设备句柄,StartAdd 开始地址 pReadBuff 要读的数据指针,nBuffLen 数据长度 
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 用户或超级用户
			* 说明: 校验超级用户密码及普通用户密码正确后进行操作。
			*********************************************************************
			*/
			public native static short NT124DevRead(int handle,short StartAdd,byte pReadBuff[], short nBuffLen);  //读设备

			/*
			*********************************************************************
			* 函数: 打开指示灯
			* 参数: handle 操作设备句柄
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 匿名
			* 说明: 校验超级用户密码及普通用户密码正确后进行操作。
			*********************************************************************
			*/	
			public native static short NT124LedOpen(int handle);    //LED亮

			/*
			*********************************************************************
			* 函数: 关闭指示灯
			* 参数: handle 操作设备句柄
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 匿名
			* 说明: 校验超级用户密码及普通用户密码正确后进行操作。
			*********************************************************************
			*/
			public native static short NT124LedClose(int handle);    //LED灭


			/*
			*********************************************************************
			* 函数: 获取设备编号全球唯一
			* 参数: handle 操作设备句柄,pDidData 12字节取设备编号
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 匿名
			* 说明: 任何时候都可以获取
			*********************************************************************
			*/
			public native static short NT124GetDID(int handle,byte pDidData[]);    //取DID值

			/*
			*********************************************************************
			* 函数: 验证超级用户密码
			* 参数: handle 操作设备句柄,pSuperPassword 16字节密码
			* 返回: 验证次数>0为正确,255为不限次数
			* 权限: 匿名
			* 说明: 验证后可以进行任何操作
			*********************************************************************
			*/
			public native static short NT124VerifySuperPassword(int handle,byte pSuperPassword[],short nLen);    //验证超级密码

			/*
			*********************************************************************
			* 函数: 验证用户密码
			* 参数: handle 操作设备句柄,UserPassword 16字节密码
			* 返回: 验证次数>0为正确,255为不限次数
			* 权限: 匿名
			* 说明: 验证后可以进行任何操作
			*********************************************************************
			*/
			public native static short NT124VerifyUserPassword(int handle,byte pUserPassword[],short nLen);    //验证用户密码

			/*
			*********************************************************************
			* 函数: 设置超级用户密码
			* 参数: handle 操作设备句柄,SuperPassword 16字节密码
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 超级用户
			* 说明: 验证超级用户后可以进行任何操作
			*********************************************************************
			*/
			public native static short NT124SetSuperPassword(int handle,byte pSuperPassword[],short nLen);    //设置超级密码

			/*
			*********************************************************************
			* 函数: 设置用户密码
			* 参数: handle 操作设备句柄,UserPassword 16字节密码
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 超级用户或用户
			* 说明: 验证超级用户或用户密码后可以进行任何操作
			*********************************************************************
			*/	
			public native static short NT124SetUserPassword(int handle,byte pUserPassword[],short nLen);    //设置用户密码

			/*
			*********************************************************************
			* 函数: 设置权限数据
			* 参数: handle 操作设备句柄, SuperNum 超级密码重试次数，UserNum 用户密码重试次数(0为不限)
			*		 pRWSwitch 块读写权限参数操作 16字节	
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 超级用户
			* 说明: 验证超级用户或用户密码后可以进行任何操作
			*********************************************************************
			*/
			public native static short NT124SetAuthorityData(int handle,short SuperNum,short UserNum,byte pRWSwitch[]);    //设置权限数据

			/*
			*********************************************************************
			* 函数: 获取授权数据
			* 参数: handle 操作设备句柄,pRWSwitch 块读写权限参数操作 16字节('0'或'1')	
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 超级用户或用户
			* 说明: 任何权限都可以操作
			*********************************************************************
			*/
			public native static short NT124GetAuthorityData(int handle,byte pRWSwitch[]);    //读取权限数据

			/*
			*********************************************************************
			* 函数: 设置显示信息
			* 参数: handle 操作设备句柄,DispData 显示信息 34字节数据	
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 超级用户
			* 说明: 验证超级用户可以设置后可以操作
			*********************************************************************
			*/
			public native static short NT124SetDispInfo(int handle,byte pDispData[],short nLen);    //设置显示信息

			/*
			*********************************************************************
			* 函数: 取产品标识ID
			* 参数: handle 操作设备句柄,pPidData 返回的16字节ID
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 匿名
			* 说明: 获取当前设备的产品标识
			*********************************************************************
			*/	
			public native static short NT124GetPID(int handle,byte pPidData[]);    //取PID值

			/*
			*********************************************************************
			* 函数: 设置产品标识ID
			* 参数: handle 操作设备句柄,pProductPassword 1-56字节 nLen 密码长度，
			*       pPidData 返回的产品标识16字节
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 超级用户
			* 说明: 设置产品标识
			*********************************************************************
			*/
			public native static short NT124SetPID(int handle,byte pProductPassword[],short nBuffLen,byte pPidData[]);    //设置PID值

			/*
			*********************************************************************
			* 函数: 关闭设备
			* 参数: handle 操作设备句柄,
			* 返回: 0为正确，其它请参考返回值说明 
			* 权限: 匿名
			* 说明: 复位DEV
			*********************************************************************
			*/
			public native static short NT124CloseDev(int handle);	// 关闭设备	
			
	//========================以下为演示函数及执行代码==========================================	
			public static short m_st;        //返回状态  
			public static int   m_handle=-1;  //设备句柄
			public static short m_vst=0;  //密码校验状态0为未校验,1为超级密码,2为用户
			public static short m_DevNum=0; //找到的设备数 
			public static String StrProductID="";//查找到的产品ID
		    
			/*
			*********************************************************************
			* 函数: 根据不同的返回值输入相应的信息
			* 参数: st 返回值
			* 返回: 无
			*********************************************************************
			*/		
			public static void CheckErr(short st)  
			{
				switch( st ) 
				{
			    case OP_OK:
			    	System.out.println("操作成功！");
			        break;
			    case MODE_ERR :
			    	System.out.println("权限不够！");
			        break;
			    case EEPROM_ERR :
			    	System.out.println("写数据失败！");
			        break;
				case PIN_ERR:
					System.out.println("校验PIN密码失败！");
			        break;
			    case CHK_ZERO :
			    	System.out.println("没有校验次数(已烧死) ！");
			        break;
			    case PARA_ERR :
			    	System.out.println("参数错误 ！");
			        break;
				case CMD_ERR:
					System.out.println("操作失败状态字！");
			        break;
			    case SEND_ERR :
			    	System.out.println("为发送数据失败！");
			        break;
			    case REC_ERR :
			    	System.out.println("为接收数据失败！");
			        break;
			    case EN_ERR:
			    	System.out.println("为加密失败！");
			        break;
			    case DE_ERR :
			    	System.out.println("为解密失败！");
			        break;
			    case READ_ERR :
			    	System.out.println("读数据出错！");
			        break;
			    case PASS_ERR:
			    	System.out.println("密码错误！");
			        break;
				default :
					System.out.println("对不起，未知错误码！");
				}
			}
			
			/*
			*********************************************************************
			* 函数: 取指定长度的输入数据
			* 参数: 无
			* 返回: 相应的字符串
			*********************************************************************
			*/			
			public static String readLine()  
			{ 
				int ch;
				String r = "";
				boolean done = false;
				while (!done)
				{ 
					try
					{ 
						ch = System.in.read();
						
						if (ch < 0 || (char)ch == '\n')
							done = true;
						else if ((char)ch != '\r') // weird--it used to do \r\n translation
							r = r + (char) ch;
						
					}
					catch(java.io.IOException e)
					{ 
						done = true;
					}
				}
				return r;
			}

			/*
			*********************************************************************
			* 功能: 查找指定产品ID的设备个数
			* 说明:通过 FindDev函数查找出相应的设备，并显示出来
			*********************************************************************
			*/		
			public static void OnButFind() 
			{
			byte[] PidData = new byte[16];		
			int i;
			
				System.out.println("请输入16位产品编码:");	
				StrProductID=readLine();

			   if(StrProductID.length()!=16)
			   {
				   System.out.println("输入长度不正确，请重新操作!");
				   return;
			   }
			
			   for(i=0;i<16;i++)
				{
				   PidData[i] = (byte)StrProductID.charAt(i);
				}	
			   
			   m_DevNum=NT124FindDev(PidData);
			   if(m_DevNum==0)
			   {
				   System.out.println("没有设备!");
			       return;
			   }

			   System.out.println("设备个数为:"+m_DevNum);
			}		

			/*
			*********************************************************************
			* 功能:  打开指定索引的的设备
			* 说明:指定相应的产品ID及相应的索引，如果成功则返回相应的句柄
			*********************************************************************
			*/		
			public static void OnButOpen() 
			{
				short Index;
				byte[] PidData = new byte[16];		
				String StrIndex="";
				int i;			

				if(m_DevNum<1)
				{
					   System.out.println("没有设备，请重新进行查找操作!");
					   return;				
				}
				
			   if(StrProductID.length()!=16)
			   {
				   System.out.println("产品编码长度不正确，请重新进行查找操作!");
				   return;
			   }
				   
			   System.out.println("产品编码["+StrProductID+"] 索引范围是(0-"+(m_DevNum-1)+"),请输入要打开的设备索引:");
			   StrIndex=readLine();
			   if(StrIndex.length()>3 || StrIndex.length()<1)
			   {
				   System.out.println("输入索引值不正确!");
				   return;
			   }	   
			  
				try
				{ 
					Index=(short) Integer.parseInt(StrIndex); 
					
				}
				catch(Exception ex)
				{ 
					   System.out.println("输入数据有误,请重新操作!");
					   return;
				}
				
			   for(i=0;i<16;i++)
				{
				   PidData[i] = (byte)StrProductID.charAt(i);
				}	
				   
			   m_handle=NT124OpenDev(PidData,Index);
			   if(m_handle<1)
			   {
				   System.out.println("打开设备失败!");
			        return;
			   }
			   System.out.println("打开设备成功!");
			}		
			
			/*
			*********************************************************************
			* 功能: 把设备LED设为亮
			* 说明:当LED为闪烁时设后则不再闪烁
			*********************************************************************
			*/
			public static void OnButLEDT() 
			{
				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }
				   
			        m_st=NT124LedOpen(m_handle);    //LED亮
			        CheckErr(m_st);
			}

			/*
			*********************************************************************
			* 功能:把设备LED设为灭
			* 说明: LED为闪烁时设后则不再闪烁
			*********************************************************************
			*/		
			public static void OnButLEDF() 
			{
				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }
				   
			        m_st=NT124LedClose(m_handle);    //LED灭
			        CheckErr(m_st);	
			}


			/*
			*********************************************************************
			* 功能:获取设备编号
			* 说明:无须校验密码直接获取
			*********************************************************************
			*/		
			public static void OnButDevID() 
			{
				byte[] DevData = new byte[12];		
				int i;
				String StrDid="";			


				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }

			       m_st=NT124GetDID(m_handle,DevData);    //取DID值
			       CheckErr(m_st);
			       if(m_st==OP_OK)
			        {
			    	   for(i=0;i<12;i++)
			    		   StrDid = StrDid + (char) DevData[i];	
			    	   
			    	   System.out.println("设备编号为:"+StrDid);
			        }	
			         
					 
			}

			/*
			*********************************************************************
			* 功能:获取产品编号
			* 说明:无须校验密码直接获取
			*********************************************************************
			*/		
			public static void OnButProduct() 
			{
			byte[] PidData = new byte[16];		
			int i;
			String StrPid="";
			
				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }
				   
			       m_st=NT124GetPID(m_handle,PidData);
			       CheckErr(m_st);
			       if(m_st==OP_OK)
			        {
			    	   for(i=0;i<16;i++)
			    	      StrPid = StrPid + (char) PidData[i];	
			    	   
			    	   System.out.println("产品编号为:"+StrPid);
			        }		       
			}

			/*
			*********************************************************************
			* 功能: 校验超级用户密码
			* 说明: 校验正确后，反回相应的校验次数，不限制次时则返回255
			*********************************************************************
			*/		
			public static void OnButVerifySuperPassword() 
			{
			 short VerifyNum;
			 short m_len;
			 String m_EVerifyPass="";
			 byte[] Password = new byte[16];

				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }
			   
					System.out.println("请输入1-16位字符串超级用户密码:");	
					m_EVerifyPass=readLine();
		
				   if(m_EVerifyPass.length()>16 || m_EVerifyPass.length()<1)
				   {
					   System.out.println("输入长度不正确，请重新操作!");
					   return;
				   }
				
				   m_len=(short) m_EVerifyPass.length();
				   for(int i=0;i<m_len;i++)
					{
					   Password[i] = (byte)m_EVerifyPass.charAt(i);
					}
			   
			       VerifyNum=NT124VerifySuperPassword(m_handle,Password,m_len);
			       if(VerifyNum==0)
			         {
			        	 System.out.println("对不起，校验失败!");
			             return;
			         }

			         if(VerifyNum<0)
			         {
			           CheckErr(VerifyNum);
			           return;
			          }
			         
			         m_vst=2;
			         System.out.println("校验超级用户密码成功!");
			}		

			/*
			*********************************************************************
			* 功能: 校验用户密码
			* 说明: 校验正确后，反回相应的校验次数，不限制次时则返回255
			*********************************************************************
			*/		
			public static void OnButVerifyUserPassword() 
			{
			 short VerifyNum;
			 short m_len;
			 String m_EVerifyPass="";
			 byte[] Password = new byte[16];
			
				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }
			   
					System.out.println("请输入1-16位字符串用户密码:");	
					m_EVerifyPass=readLine();
		
				   if(m_EVerifyPass.length()>16 || m_EVerifyPass.length()<1)
				   {
					   System.out.println("输入长度不正确，请重新操作!");
					   return;
				   }
				
				   m_len=(short) m_EVerifyPass.length();
				   for(int i=0;i<m_len;i++)
					{
					   Password[i] = (byte)m_EVerifyPass.charAt(i);
					}
			   
			         VerifyNum=NT124VerifyUserPassword(m_handle,Password,m_len);
			         if(VerifyNum==0)
			         {
			        	 System.out.println("对不起，校验失败!");
			             return;
			         }

			         if(VerifyNum<0)
			         {
			           CheckErr(VerifyNum);
			           return;
			          }
			         
			         m_vst=1;
			         System.out.println("校验用户密码成功!");
			}				
			
			/*
			*********************************************************************
			* 功能:修改超级用户密码
			* 说明:校验后就可以进行设置，超级用户可以设两个密码
			*********************************************************************
			*/		
			public static void OnButModifySuperPassword() 
			{
			 short m_len;
			 String StrNewPass="";
			 byte[] Password = new byte[16];
			
				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }
				   
				   if(m_vst<2)
				   {
					   System.out.println("权限不足,请用超级用户操作!");
				        return;
				   }
				   
					System.out.println("请输入1-16位字符串新超级用户密码:");	
					StrNewPass=readLine();
		
				   if(StrNewPass.length()>16 || StrNewPass.length()<1)
				   {
					   System.out.println("输入长度不正确，请重新操作!");
					   return;
				   }
				
				   m_len=(short) StrNewPass.length();
				   for(int i=0;i<m_len;i++)
					{
					   Password[i] = (byte)StrNewPass.charAt(i);
					}
				   
					m_st=NT124SetSuperPassword(m_handle,Password,m_len);
					CheckErr(m_st);
			}

			/*
			*********************************************************************
			* 功能:修改用户密码
			* 说明:普通用户只能设自己已的密码  
			*********************************************************************
			*/		
			public static void OnButModifyUserPassword() 
			{
			 short m_len;
			 String StrNewPass="";
			 byte[] Password = new byte[16];
			
				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }
				   
				   if(m_vst<1)
				   {
					   System.out.println("权限不足,请用超级用户操作!");
				        return;
				   }
				   
					System.out.println("请输入1-16位字符串新用户密码:");	
					StrNewPass=readLine();
		
				   if(StrNewPass.length()>16 || StrNewPass.length()<1)
				   {
					   System.out.println("输入长度不正确，请重新操作!");
					   return;
				   }
				
				   m_len=(short) StrNewPass.length();
				   for(int i=0;i<m_len;i++)
					{
					   Password[i] = (byte)StrNewPass.charAt(i);
					}
				   
					m_st=NT124SetUserPassword(m_handle,Password,m_len);
					CheckErr(m_st);
			}		
			
			/*
			*********************************************************************
			* 功能:  根据输入的产品密码产生相应的产品ID
			* 说明: 通过这样设置，可以达到防止复制设备
			*********************************************************************
			*/		
			public static void OnButProductPass() 
			{
			 short m_len;
			 String StrProductPass="";
			 String StrPid="";
			 byte[] PidData = new byte[16];
			 byte[] ProductPassword = new byte[56];
			 int i;
			 
			   if(m_handle<1)
			   {
				   System.out.println("没有打开设备,请先打开设备!");
			        return;
			   }
			   
			   if(m_vst<2)
			   {
				   System.out.println("权限不足,请用超级用户操作!");
			        return;
			   }
			   
				System.out.println("请输入1-56位字符串产品密码:");	
				StrProductPass=readLine();

			   if(StrProductPass.length()>56 || StrProductPass.length()<1)
			   {
				   System.out.println("输入长度不正确，请重新操作!");
				   return;
			   }
			
			   m_len=(short) StrProductPass.length();
			   for(i=0;i<m_len;i++)
				{
				   ProductPassword[i] = (byte)StrProductPass.charAt(i);
				}			

			   m_st=NT124SetPID(m_handle,ProductPassword,m_len,PidData);
			   CheckErr(m_st); 
		       if(m_st==OP_OK)
		        {
		    	   for(i=0;i<16;i++)
		    	      StrPid = StrPid + (char) PidData[i];	
		    	   
		    	   System.out.println("产品新编号为:"+StrPid);
		        }		    	    
			}		

			/*
			*********************************************************************
			* 功能: 设置新插入设备时显示的信息或在硬件管理中设备属性显示的字符串
			*  说明: 显示时为17个ASCII码或17个汉字
			*********************************************************************
			*/		
			public static void OnButDispInfo() 
			{
			 short m_len;
			 String StrInfo="";
			 byte[] DispData = new byte[34];

			   if(m_handle<1)
			   {
				   System.out.println("没有打开设备,请先打开设备!");
			        return;
			   }
			   
			   if(m_vst<2)
			   {
				   System.out.println("权限不足,请用超级用户操作!");
			        return;
			   }
			   
				System.out.println("请输入1-34位字符串显示信息:");	
				StrInfo=readLine();

			   if(StrInfo.length()>34 || StrInfo.length()<1)
			   {
				   System.out.println("输入长度不正确，请重新操作!");
				   return;
			   }
			
			   m_len=(short) StrInfo.length();
			   for(int i=0;i<m_len;i++)
				{
				   DispData[i] = (byte)StrInfo.charAt(i);
				}		 

			   m_st=NT124SetDispInfo(m_handle,DispData,m_len);
			    CheckErr(m_st);
			}		

			/*
			*********************************************************************
			* 功能: 向设备写数据
			* 说明:如果为超级用户则可以任意写数据，如果某块(64字节)设为只读权限，
			*      普通用户则不能对该块进行写操作，只能读操作。
			*********************************************************************
			*/		
			public static void OnButWrite() 
			{
			short m_len=0;
			short m_Add=0;
			String StrData="";
			String StrAdd="";
			byte[] WriteData = new byte[1024];		

			   if(m_handle<1)
			   {
				   System.out.println("没有打开设备,请先打开设备!");
			        return;
			   }
			   
			   if(m_vst<1)
			   {
				   System.out.println("权限不足,先校验密码!");
			        return;
			   }
			   
				System.out.println("请输入开始地址(0-1024):");	
				StrAdd=readLine();

			   if(StrAdd.length()>4 || StrAdd.length()<1)
			   {
				   System.out.println("输入长度不正确，请重新操作!");
				   return;
			   }
			   
				try
				{ 
					m_Add=(short) Integer.parseInt(StrAdd); 
					
				}
				catch(Exception ex)
				{ 
					   System.out.println("输入数据有误,请重新操作!");
					   return;
				}		   
			   
			   
				System.out.println("请输入要写入的数据:");	
				StrData=readLine();

			   if(StrData.length()>1024 || StrData.length()<1)
			   {
				   System.out.println("输入长度不正确，请重新操作!");
				   return;
			   }
			
			   m_len=(short) StrData.length();
			   for(int i=0;i<m_len;i++)
				{
				   WriteData[i] = (byte)StrData.charAt(i);
				}

			   if((m_Add+m_len)>1024)
				   m_len=(short) (1024-m_Add);
			   
			   m_st=NT124DevWrite(m_handle,m_Add,WriteData,m_len);
			   CheckErr(m_st);	
			}		

			/*
			*********************************************************************
			* 功能: 从设备中读取相应的数据
			* 说明:验证密码后就可以读写
			*********************************************************************
			*/		
			public static void OnButRead() 
			{
				short m_len=0;
				short m_Add=0;
				String StrData="";
				String StrAdd="";
				String StrLen="";
				byte[] ReadBuff = new byte[1024];		

				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }
				   
				   if(m_vst<1)
				   {
					   System.out.println("权限不足,先校验密码!");
				        return;
				   }
				   
					System.out.println("请输入读数据开始地址(0-1024):");	
					StrAdd=readLine();

				   if(StrAdd.length()>4 || StrAdd.length()<1)
				   {
					   System.out.println("输入长度不正确，请重新操作!");
					   return;
				   }
				   
					System.out.println("请输入读数据长度(1-1024):");	
					StrLen=readLine();

				   if(StrLen.length()>4 || StrLen.length()<1)
				   {
					   System.out.println("输入长度不正确，请重新操作!");
					   return;
				   }
				   
					try
					{ 
						m_Add=(short) Integer.parseInt(StrAdd); 
						m_len=(short) Integer.parseInt(StrLen); 
						
					}
					catch(Exception ex)
					{ 
						   System.out.println("输入数据有误,请重新操作!");
						   return;
					}

				   if((m_Add+m_len)>1024)
					   m_len=(short) (1024-m_Add);		
				   
				   m_st=NT124DevRead(m_handle,m_Add,ReadBuff,m_len);
				   CheckErr(m_st);
				   if(m_st==OP_OK)
				   {
			    	   for(int i=0;i<m_len;i++)
			    		   StrData = StrData + (char) ReadBuff[i];	
				    	   
			    	   System.out.println("读到的数据为:"+StrData);				   
				   }   
			}

			/*
			*********************************************************************
			* 功能: 获取当前设备读写权限。
			* 说明: 任何密码验证都可以获取读写权限
			*********************************************************************
			*/		
			public static void OnButGetPriv() 
			{
			byte[] RWSwitch = new byte[16];	
			
			   if(m_handle<1)
			   {
				   System.out.println("没有打开设备,请先打开设备!");
			        return;
			   }
			   
			   if(m_vst<1)
			   {
				   System.out.println("权限不足,先校验密码!");
			        return;
			   }
			   
		        m_st=NT124GetAuthorityData(m_handle,RWSwitch);
		        CheckErr(m_st);
		        if(m_st==OP_OK)
		          {
		        	System.out.println("当前设备用户权限如何下(1为任可写，0为只读):");
					 System.out.println("============================================================");
					 for(int i=0;i<16;i++)
					 {
						 if(RWSwitch[i]==48)
						   System.out.println("   "+(i*64)+" - "+((i+1)*64-1)+"=0");	 
						 else 	 
						   System.out.println("   "+(i*64)+" - "+((i+1)*64-1)+"=1");	 
					 }

					 System.out.println("============================================================");
		          }
			}

			/*
			*********************************************************************
			* 功能:设置相应的读写权限,及密码校验次数
			* 说明:只有超级用户能够设置读写权限
			*********************************************************************
			*/		
			public static void OnButSetPriv() 
			{
				byte[] RWSwitch = new byte[16];	
				short m_ESuperNum=0;
				short m_EUserNum=0;
				String StrSuperNum="";
				String StrUserNum="";
				String StrPriv="";
				
				   if(m_handle<1)
				   {
					   System.out.println("没有打开设备,请先打开设备!");
				        return;
				   }
				   
				   if(m_vst<2)
				   {
					   System.out.println("权限不足,先校验超级用户密码!");
				        return;
				   }
				
					System.out.println("请输入超级用户密码校验次数(0-255):");	
					StrSuperNum=readLine();

				   if(StrSuperNum.length()>3 || StrSuperNum.length()<1)
				   {
					   System.out.println("输入长度不正确，请重新操作!");
					   return;
				   }

					System.out.println("请输入用户密码校验次数(0-255):");	
					StrUserNum=readLine();

				   if(StrUserNum.length()>3 || StrUserNum.length()<1)
				   {
					   System.out.println("输入长度不正确，请重新操作!");
					   return;
				   }
				   
					try
					{ 
						m_ESuperNum=(short) Integer.parseInt(StrSuperNum); 
						m_EUserNum=(short) Integer.parseInt(StrUserNum); 
						
					}
					catch(Exception ex)
					{ 
						   System.out.println("输入数据有误,请重新操作!");
						   return;
					}
				
			         if(m_ESuperNum>255)
			         {
			             m_ESuperNum=255;
			             System.out.println("超级密码最大校验次数为255!");
			         }

			         if(m_EUserNum>255)
			         {
			             m_EUserNum=255;
			             System.out.println("用户密码最大校验次数为255!");
			         }
			         
			         System.out.println("请输入各块的用户权限(0为只读，1为可写):"); 
					 for(int i=0;i<16;i++)
					 {	
				         System.out.println("   "+(i*64)+" - "+((i+1)*64-1)+"=");	
				         StrPriv=readLine();
						 if(StrPriv.length()!=1)
						   {
							   System.out.println("输入长度不正确，请重新操作!");
							   return;
						   }					 
						RWSwitch[i]=(byte)StrPriv.charAt(0);	    
					 }
					 
			        m_st=NT124SetAuthorityData(m_handle,m_ESuperNum,m_EUserNum,RWSwitch);
			        CheckErr(m_st);	
			}
			
			/*
			*********************************************************************
			* 函数: 显示命令列表
			* 参数: 无
			* 返回: 无
			*********************************************************************
			*/		
			public static void DispCmd()  
			{
				 System.out.println("============================================================");
				 System.out.println("| F.查找设备                        | O.打开设备                      | T.灯亮                             |");
				 System.out.println("| C.灯灭                                  |                   | D.获取设备编号         |");
				 System.out.println("| P.获取产品编号              | V.校验超级用户密码  | U.校验用户密码         |");          
				 System.out.println("| M.修改超级用户密码    | E.修改用户密码            | K.设置产品密码         |");
				 System.out.println("| I.设置显示信息              | W.写数据                           | R.读数据                        |");
				 System.out.println("| G.获取权限数据              | X.设置权限数据            | Q.退出                             |");
				 System.out.println("============================================================");
				 System.out.println("请选择相应的操作命令:[如 F]");	
			}
			
			/*
			*********************************************************************
			* 函数: 执行主函数
			* 参数: args 字符串参数数组，现暂时没有使用
			* 返回: 无
			*********************************************************************
			*/			
			public static void main(String[] args)
			{
				String StrCmd;	
				char   CharCmd;
				boolean m_Quit = false;			
				DispCmd(); 
				while (!m_Quit) 
				{
					StrCmd=readLine();
					if(StrCmd.length()!=1)
						continue;
					
					StrCmd=StrCmd.toUpperCase();
					CharCmd=StrCmd.charAt(0);

					switch(CharCmd) 
					{
				    case 'F':
				    	OnButFind(); //查找设备
				        break;
				    case 'O' :
				    	OnButOpen();  //打开设备
				        break;
				    case 'T' :
				    	OnButLEDT() ; //设灯亮
				        break;
					case 'C':
						OnButLEDF();  //设灯灭
				        break;
				    case 'D' :
				    	OnButDevID(); // 获取设备编号！
				        break;
					case 'P':
						OnButProduct();  // 获取产品编号  ！
				        break;
				    case 'V' :
				    	OnButVerifySuperPassword(); // ("校验超级用户密码！");
				        break;
				    case 'U' :
				    	OnButVerifyUserPassword(); //("校验用户密码！");
				        break;
				    case 'M':
				    	OnButModifySuperPassword(); //("修改超级用户密码！");
				        break;
				    case 'E' :
				    	OnButModifyUserPassword(); //"修改用户密码 ！");
				        break;
				    case 'K' :
				    	OnButProductPass(); //"设置产品密码 ！");
				        break;
				    case 'I':
				    	OnButDispInfo();  //"设置显示信息 ！");
				        break;
				    case 'W' :
				    	OnButWrite();   //("写数据！");
				        break;
				    case 'R':
				    	OnButRead();      //"读数据！");
				        break;
				    case 'G' :
				    	OnButGetPriv();  // "获取权限数据 ！");
				        break;
				    case 'X' :
				    	OnButSetPriv();  //"设置权限数据！");
				        break;
				    case 'Q':
				    	m_Quit = true;	 //"退出 ！"
				        break;			        
					default :
						System.out.println("命令输入错误,请重新输入:");
						DispCmd();
					}
				}

			  if(m_handle>0)
				  NT124CloseDev(m_handle);
		      System.out.println("再见!欢迎再次使用权广州广州飞盾电子有限公司的产品，谢谢!");			
			}
}
