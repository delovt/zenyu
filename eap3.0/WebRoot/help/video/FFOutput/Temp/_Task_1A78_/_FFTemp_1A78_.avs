try{SetMemoryMax(48)
F=DirectShowSource("F:\文档转化\录像\ls\视频\综合业务管理系统_产品档案.avi",18.000,convertfps=true)
F=LanczosResize(F,800,600)
return F
}catch(err_msg){BlankClip(0,1,1)}