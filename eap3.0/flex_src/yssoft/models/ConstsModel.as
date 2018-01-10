/**
 * 作者：zmm
 * 日期：2011-8-2
 * 功能：系统常量类
 * 修改记录：
 * 修改人：zmm
 * 修改时间：2011-8-2
 */
package yssoft.models {
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.CalendarLayoutChangeEvent;

import yssoft.scripts.SpecialScript;
import yssoft.vos.ElementVo;
import yssoft.vos.SubElementsVo;

public class ConstsModel {
    public function ConstsModel() {
        Alert.show(CRMmodel.hrperson.cname);
    }

    /************************************* add zmm begin *************************************/
    //消息 图标
    [Embed(source="/yssoft/assets/images/new.png")]
    public static var gif_new:Class;
    //菜单图片
    [Embed(source="/yssoft/assets/images/menu1.png")]
    public static var png_menu1:Class;

    [Embed(source="/yssoft/assets/images/menu2.png")]
    public static var png_menu2:Class;

    [Embed(source="/yssoft/assets/images/menu3.png")]
    public static var png_menu3:Class;

    [Embed(source="/yssoft/assets/images/menu4.png")]
    public static var png_menu4:Class;

    [Embed(source="/yssoft/assets/index/del.png")]
    public static var png_cancel:Class;

    [Embed(source="/yssoft/assets/images/nucancel.png")]
    public static var png_nucancel:Class;

    [Embed(source="/yssoft/assets/index/add.png")]
    public static var png_arroww:Class;

    [Embed(source="/yssoft/assets/call/callin.png")]
    public static var callin:Class;

    [Embed(source="/yssoft/assets/call/callout.png")]
    public static var callout:Class;

    [Embed(source="/yssoft/assets/call/uncall.png")]
    public static var uncall:Class;

    /*****************************系统级提示**************************/
    public static var SYS_ALERT_ERROR:String = "项目中有未捕获异常发生!";
    /*****************************用户登录************************/

    public static var LOGIN_COPYRIGHT:String = "版权所有：徐州市增宇软件有限公司";
    public static var LOGIN_INFO:String = "欢迎使用增宇营销管理平台，请在右边输入用户名和密码登陆系统。如账号登陆遇到问题，请联系系统管理员。";

    public static var LOGIN_ALERT_NAME_NULL:String = "用户名不能为空";
    public static var LOGIN_ALERT_PSW_NULL:String = "密码不能为空";
    public static var LOGIN_ALERT_CHECKFAIL:String = "用户登录失败,用户与密码不匹配.";
    public static var LOGIN_ALERT_CHECKING:String = "正在验证用户，请等待...";


    //工作流 图标

    //节点类型 0人员、1部门、2相对角色、3岗位、4职务 ,对应修改头像
    [Embed(source="/yssoft/assets/wf/person.png")]
    // 人员
    public static var wf_inodetype_0:Class;

    [Embed(source="/yssoft/assets/wf/depart.png")]
    // 部门
    public static var wf_inodetype_1:Class;

    [Embed(source="/yssoft/assets/wf/role.png")]
    // 角色
    public static var wf_inodetype_2:Class;

    [Embed(source="/yssoft/assets/wf/job.png")]
    // 岗位
    public static var wf_inodetype_3:Class;

    [Embed(source="/yssoft/assets/wf/post.png")]
    // 职务
    public static var wf_inodetype_4:Class;


    //istate //节点处理状态 0待发送、1已发送、2未进入、3待处理、4暂存待办、5已处理, 对应显示 最下面的 小图标

    [Embed(source="/yssoft/assets/wf/tmpsend.png")]
    public static var wf_node_istatus_0:Class; // 待发送

    [Embed(source="/yssoft/assets/wf/done.png")]
    public static var wf_node_istatus_1:Class;   // 已发送

    [Embed(source="/yssoft/assets/wf/wjr.png")]
    public static var wf_node_istatus_2:Class;   // 未进入

    [Embed(source="/yssoft/assets/wf/stop.png")]
    public static var wf_node_istatus_3:Class; // 待处理

    [Embed(source="/yssoft/assets/wf/tmpdo.png")]
    public static var wf_node_istatus_4:Class;// 暂存待办

    [Embed(source="/yssoft/assets/wf/done.png")]
    public static var wf_node_istatus_5:Class; // 已处理

    [Embed(source="/yssoft/assets/wf/undo.png")]
    public static var wf_node_istatus_6:Class; // 已处理


    // 节点处理方式
    public static const WF_INODEMODE_0:String = "协同";
    //public static const WF_INODEMODE_0:String="知会";
    public static const WF_INODEMODE_1:String = "审批";
    public static const WF_INODEMODE_2:String = "发起人";

    //public static const WF_INODEMODE_3:String="协同";

    // 垃圾箱
    [Embed(source="/yssoft/assets/wf/trash.png")]
    public static var wf_trash:Class; // 已处理

    // 流程图 绘制时，相关提示
    public static var WF_ALERT_XTJD:String = "已经有相同的节点存在，此操作不予执行！";
    public static var WF_ALERT_NUDELETE:String = "删除后，有相同的[0]子节点\n该删除操作不予执行！";
    public static var WF_ALERT_DELETE_CNODE:String = "确认删除该节点以及所有子节点[0]，此操作不可恢复!";
    public static var WF_ALERT_DELETE_ALLNODE:String = "确认删除该节点的所有子节点[0]，此操作不可恢复!";

    // 协同管理
    [Embed(source="/yssoft/assets/images/dbsx.png")]
    public static var co_dbsx:Class;
    [Embed(source="/yssoft/assets/images/ybsx.png")]
    public static var co_ybsx:Class;
    [Embed(source="/yssoft/assets/images/gcsx.png")]
    public static var co_gcsx:Class;
    [Embed(source="/yssoft/assets/images/dfsx.png")]
    public static var co_dfsx:Class;
    [Embed(source="/yssoft/assets/images/yfsx.png")]
    public static var co_yfsx:Class;

    //协同管理的 操作类型
    public static const XTGL_OPT_DBSX:String = "dbsx";
    public static const XTGL_OPT_YBSX:String = "ybsx";
    public static const XTGL_OPT_GZSX:String = "gzsx";
    public static const XTGL_OPT_DFSX:String = "dfsx";
    public static const XTGL_OPT_YFSX:String = "yfsx";

    // 分页 bar
    /*[Embed(source="/yssoft/assets/images/top.png")]
    public static var page_top:Class;
    [Bindable]
    [Embed(source="/yssoft/assets/images/pre.png")]
    public static var page_pre:Class;
    [Bindable]
    [Embed(source="/yssoft/assets/images/next.png")]
    public static var page_next:Class;
    [Embed(source="/yssoft/assets/images/tail.png")]
    public static var page_tail:Class;*/
	//新分页按钮图标
	[Embed(source="/yssoft/assets/images/fanye/left_1.png")]
	public static var page_top:Class;
	[Bindable]
	[Embed(source="/yssoft/assets/images/fanye/left.png")]
	public static var page_pre:Class;
	[Bindable]
	[Embed(source="/yssoft/assets/images/fanye/next.png")]
	public static var page_next:Class;
	[Embed(source="/yssoft/assets/images/fanye/right_1.png")]
	public static var page_tail:Class;
    [Embed(source="/yssoft/assets/images/refresh.png")]
    public static var page_refresh:Class;
    [Embed(source="/yssoft/assets/images/go.png")]
    public static var page_go:Class;


    [Embed(source="/yssoft/assets/images/framepriev.png")]
    public static var page_billpre:Class;
    [Bindable]
    [Embed(source="/yssoft/assets/images/framenext.png")]
    public static var page_billnext:Class;


    //首页

    [Embed(source="/yssoft/assets/home/msg.png")]
    public static var home_msg:Class;
    [Embed(source="/yssoft/assets/home/zxyh.png")]
    public static var home_zxyh:Class;
    [Embed(source="/yssoft/assets/home/zx.png")]
    public static var home_zx:Class;
    [Embed(source="/yssoft/assets/home/raw_view.png")]
    public static var home_raw_view:Class;


    /************************************* add zmm   end *************************************/


    /********************** add by zhong_jing begin *************************************/
    //新增角色过度窗口显示的文字
    public static var ROLE_ADD_INFO:String = "新增角色处理中...";

    //新增角色成功
    public static var ROLE_ADD_SUCCESS:String = "新增角色成功！！";

    //修改角色过度窗口显示的文字
    public static var ROLE_UPDATE_INFO:String = "修改角色处理中...";

    //修改角色成功
    public static var ROLE_UPDATE_SUCCESS:String = "修改角色成功！！";

    //处理失败
    public static var FAIL:String = "处理失败...";

    //删除角色过度窗口显示的文字
    public static var ROLE_REMOVE_INFO:String = "删除角色处理中...";

    //删除角色成功
    public static var ROLE_REMOVE_SUCCESS:String = "删除角色成功！！";

    //确定是否删除头部
    public static var DETERMINE_HEAD:String = "确定删除[";

    //确定是否删除尾部
    public static var DETERMINE_TAIL:String = "角色]?";

    //节点存在
    public static var ROLE_CCODE_WARNMSG:String = "编码已存在！！";

    //父节点不存在
    public static var ROLE_PID_WARNMSG:String = "父节点不存在！！";

    //有子节点不能删除
    public static var ROLE_ROMEVE_PID:String = "该角色存在子节点，不能删除！！";

    public static var CHOOSE_ROLE:String = "请选择后，再操作！！";

    public static var ROLE_CCODE_ISNULL:String = "角色编码不能为空！！";

    public static var ROLE_CNAME_ISNULL:String = "角色名称不能为空！！";

    public static var ROLE_BUSE_ISNULL:String = "请选择角色状态！！";


    [Bindable]
    public static var TABLENAME_LABLE:String = "物理表";

    [Bindable]
    public static var ROLE_LABLE:String = "角色";

    [Bindable]
    public static var ROLE_MESS_LABLE:String = "角色信息";

    [Bindable]
    public static var ROLE_CCODE_LABLE:String = "编码:";

    [Bindable]
    public static var ROLE_CNAME_LABLE:String = "名称:";

    [Bindable]
    public static var ROLE_BUSE_LABLE:String = "状态:";

    [Bindable]
    public static var ROLE_ENABLED_LABLE:String = "启用";

    [Bindable]
    public static var ROLE_ENABLED_VALUE:Boolean = true;

    [Bindable]
    public static var ROLE_DISABLE_LABLE:String = "禁用";

    [Bindable]
    public static var ROLE_DISABLE_VALUE:Boolean = false;

    [Bindable]
    public static var ROLE_CMEMO_LABLE:String = "备注:";

    [Bindable]
    public static var USER_LABLE:String = "职员信息";

    [Bindable]
    public static var USER_DEPARTMENTNAME_COLUMN:String = "部门";

    [Bindable]
    public static var USER_JOBNAME_COLUMN:String = "主岗";

    [Bindable]
    public static var USER_POSTNAME_COLUMN:String = "职务";

    //linkButton初始化值
    [Bindable]
    public static var LBRITEM:ArrayCollection = new ArrayCollection([
        {label:"增加", name:"onNew"        },
        {label:"修改", name:"onEdit"        },
        {label:"删除", name:"onDelete"    },
        {label:"保存", name:"onSave"        },
        {label:"放弃", name:"onGiveUp"    }

    ]);

    //linkButton初始化值
    [Bindable]
    public static var FRAMELBRITEM:ArrayCollection = new ArrayCollection([
        {label:"提交", name:"onSubmit"        },
        {label:"撤销", name:"onRevocation"    },
        {label:"打印", name:"onPrint"    }
    ]);

    //YJ Add linkButton初始化值
    [Bindable]
    public static var LBUPDOWNITEM:ArrayCollection = new ArrayCollection([
        {label:"<", name:"Pre"        },
        {label:">", name:"Next"    }
    ]);

    //linkButton初始化值
    [Bindable]
    public static var LBRUSERITEM:ArrayCollection = new ArrayCollection([
        {label:"关联职员", name:"onSave"        },
        {label:"移除职员", name:"onDelete"    }

    ]);

    //linkButton初始化值
    [Bindable]
    public static var LBRAC_TABLEITEM:ArrayCollection = new ArrayCollection([
		{label:"增加", name:"onNew"        },
        {label:"修改", name:"onEdit"        },
        {label:"保存", name:"onSave"        },
        {label:"放弃", name:"onGiveUp"    },
        {label:"同步", name:"onUpdate"    },
		{label:"删除", name:"onDelete"    }
    ]);

    //linkButton初始化值
    [Bindable]
    public static var LISTCD_LBRITEM:ArrayCollection = new ArrayCollection([
        {label:"增加", name:"onNew"        },
        {label:"修改", name:"onEdit"        },
        {label:"删除", name:"onDelete"    },
        {label:"保存", name:"onSave"        },
        {label:"放弃", name:"onGiveUp"    },
        {label:"测试", name:"onTest"    }

    ]);

    //linkButton初始化值
    [Bindable]
    public static var AUTHCONTENTLBRITEM:ArrayCollection = new ArrayCollection([
        {label:"修改", name:"onEdit"        },
        {label:"保存", name:"onSave"        },
        {label:"放弃", name:"onGiveUp"    },
        {label:"复制", name:"onCopy"    }
    ]);

    //linkButton初始化值
    [Bindable]
    public static var PERSONLBRITEM:ArrayCollection = new ArrayCollection([
        {label:"浏览", name:"onBrowse"    },
        {label:"增加", name:"onNew"        },
        {label:"修改", name:"onEdit"        }
    ]);

    [Bindable]
    public static var REFRAN:ArrayCollection = new ArrayCollection([
        {label:"查询", name:"onQuery"    },
        {label:"刷新", name:"onRefresh"    }
    ]);

    //linkButton初始化值
    [Bindable]
    public static var RelatedItem:ArrayCollection = new ArrayCollection([
        {label:"浏览", name:"onBrowse"    },
        {label:"增加", name:"onNew"        },
        {label:"修改", name:"onEdit"        }
    ]);

    //linkButton初始化值
    [Bindable]
    public static var PERSONLBRITEM_01:ArrayCollection = new ArrayCollection([
        {label:"浏览", name:"onBrowse"        },
        {label:"增加", name:"onNew"        },
        {label:"修改", name:"onEdit"        },
        {label:"删除", name:"onDelete"    }
    ]);

    [Bindable]
    public static var MESSAGE_MIDDLE:ArrayCollection = new ArrayCollection([
        {label:"查询", name:"onQuery"    },
        {label:"重置", name:"onReset"    },
        {label:"  已阅", name:"onYRead"},
        {label:"未阅", name:"onNRead"    },
        {label:"删除", name:"onDelete"    }
    ]);

    //linkButton初始化值
    [Bindable]
    public static var BUDGET_OPERATE_0:ArrayCollection = new ArrayCollection([
        {label:"增加", name:"onNew"        },
        {label:"修改", name:"onEdit"        },
        {label:"删除", name:"onDelete"    }
    ]);

    [Bindable]
    public static var BUDGET_OPERATE_1:ArrayCollection = new ArrayCollection([
        {label:"增行", name:"addRow"        },
        {label:"删行", name:"delRow"        }
    ]);

    [Bindable]
    public static var BUDGET_OPERATE_2:ArrayCollection = new ArrayCollection([
        {label:"保存", name:"onSave"        },
        {label:"放弃", name:"onGiveUp"        }
    ]);

    [Bindable]
    public static var BUDGET_OPERATE_3:ArrayCollection = new ArrayCollection([
        {label:"分解", name:"onResolve"        },
        {label:"预算分解", name:"onBudget"        }
    ]);


    public static var LEFT_BRACKETS:String = "(";

    public static var RIGHT_BRACKETS:String = ")";

    public static var POINT:String = ".";

    public static var STAT:String = "*";

    public static var NULL:String = "";

    public static var ONNEW_LABLE:String = "onNew";

    public static var ONEDIT_LABLE:String = "onEdit";

    public static var ONDELETE_LABLE:String = "onDelete";

    public static var ONSAVE_LABLE:String = "onSave";

    public static var ONGIVEUP_LABLE:String = "onGiveUp";

    public static var ONMANAGEMENT_LABLE:String = "onManagement";

    public static var ROLE_USER_GET_INFO:String = "查询用户处理中...";

    public static var EPARTMENT_GET_INFO:String = "查询部门处理中...";

    [Bindable]
    public static var DEPARTMENT_LABLE:String = "部门";

    //linkButton初始化值
    [Bindable]
    public static var DEPARTMENTITEM:ArrayCollection = new ArrayCollection([
        {label:"保存岗位", name:"onSave"        },
        {label:"删除岗位", name:"onDelete"    }
    ]);

    [Bindable]
    public static var DEPARTMENT_CCODE_LABLE:String = "部门编码";

    [Bindable]
    public static var DEPARTMENT_CNAME_LABLE:String = "部门名称";

    [Bindable]
    public static var DEPARTMENT_IHEAD_LABLE:String = "部门主管";

    [Bindable]
    public static var DEPARTMENT_ICHARGE_LABLE:String = "分管主管";

    [Bindable]
    public static var DEPARTMENT_IPERSON_LABLE:String = "编制人数";

    [Bindable]
    public static var DEPARTMENT_IREALPERSON_LABLE:String = "在编人数";

    [Bindable]
    public static var JOB_CCODE_LABLE:String = "岗位编码";

    [Bindable]
    public static var JOB_CNAME_LABLE:String = "岗位名称";

    [Bindable]
    public static var JOB_IDEPARTMENT_LABLE:String = "所属部门";

    [Bindable]
    public static var JOB_CWORK_LABLE:String = "所属职责";

    [Bindable]
    public static var JOB_IPERSON_LABLE:String = "编制人数";

    [Bindable]
    public static var JOB_IREALPERSON_LABLE:String = "在编人数";

    //新增角色过度窗口显示的文字
    public static var DEPARTMENT_ADD_INFO:String = "新增部门处理中...";

    //新增角色成功
    public static var DEPARTMENT_ADD_SUCCESS:String = "新增部门成功！！";

    //修改角色过度窗口显示的文字
    public static var DEPARTMENT_UPDATE_INFO:String = "修改部门处理中...";

    //修改角色成功
    public static var DEPARTMENT_UPDATE_SUCCESS:String = "修改部门成功！！";


    //删除角色过度窗口显示的文字
    public static var DEPARTMENT_REMOVE_INFO:String = "删除部门处理中...";

    //删除角色成功
    public static var DEPARTMENT_REMOVE_SUCCESS:String = "删除部门成功！！";


    //确定是否删除尾部
    public static var DEPARTMENT_TAIL:String = "部门]?";


    //有子节点不能删除
    public static var DEPARTMENT_ROMEVE_PID:String = "存在子节点，不能删除！！";


    public static var DEPARTMENT_CCODE_ISNULL:String = "编码不能为空！！";

    public static var DEPARTMENT_CNAME_ISNULL:String = "名称不能为空！！";

    public static var DEPARTMENT_IHEAD_ISNULL:String = "部门主管不能为空！！";

    public static var DEPARTMENT_ICHARGE_ISNULL:String = "分管主管不能为空！！";

    public static var DEPARTMENT_IPERSON_ISNULL:String = "编制人数不能为空！！";

    //加号
    [Bindable]
    [Embed(source="/yssoft/assets/images/addition.png")]
    public static var _ADDITIONICON:Class;

    //减号
    [Bindable]
    [Embed(source="/yssoft/assets/images/Subtraction.png")]
    public static var _SUBTRACTIONICON:Class;

    //保存
    [Bindable]
    [Embed(source="/yssoft/assets/images/save.png")]
    public static var _SAVEICON:Class;

    //保存
    [Bindable]
    [Embed(source="/yssoft/assets/images/clear.png")]
    public static var _CLEARICON:Class;

    [Bindable]
    public static var POSTCLASS_LABLE:String = "职务";

    [Bindable]
    public static var POSTCLASS_CCODE_LABLE:String = "职类编码：";

    [Bindable]
    public static var POSTCLASS_CNAME_LABLE:String = "职类名称：";

    [Bindable]
    public static var POSTCLASS_CMEMO_LABLE:String = "职类描述：";

    [Bindable]
    public static var POST_CCODE_LABLE:String = "职务编码";

    [Bindable]
    public static var POST_CNAME_LABLE:String = "职务名称";

    [Bindable]
    public static var POST_IPOSTCLASS_LABLE:String = "所属职类";

    [Bindable]
    public static var POST_ILEVEL_LABLE:String = "职务级别";

    [Bindable]
    public static var POST_CWORK_LABLE:String = "职务描述";

    [Bindable]
    public static var POST_IREALPERSON_LABLE:String = "在职人数";

    public static var FAIL_LABLE:String = "fail";

    //新增角色成功
    public static var POSTCLASS_ADD_SUCCESS:String = "新增职类成功！！";

    //删除角色成功
    public static var POSTCLASS_REMOVE_SUCCESS:String = "删除职类成功！！";

    //修改角色成功
    public static var POSTCLASS_UPDATE_SUCCESS:String = "修改职类成功！！";


    //确定是否删除尾部
    public static var POSTCLASS_TAIL:String = "职类]?";

    //删除角色过度窗口显示的文字
    public static var POSTCLASS_REMOVE_INFO:String = "删除职类处理中...";

    //新增角色过度窗口显示的文字
    public static var POSTCLASS_ADD_INFO:String = "新增职类处理中...";

    //修改角色过度窗口显示的文字
    public static var POSTCLASS_UPDATE_INFO:String = "修改职类处理中...";

    public static var POST_ILEVEL_ISNULL:String = "职务级别不能为空！！";

    //新增角色成功
    public static var POST_ADD_SUCCESS:String = "保存成功！！";

    //新增角色成功
    public static var POST_FAIL_SUCCESS:String = "保存失败！！";

    //linkButton初始化值
    [Bindable]
    public static var LISTSET_LBRITEM:ArrayCollection = new ArrayCollection([
        {label:"修改", name:"onEdit"        },
        {label:"保存", name:"onSave"        },
        {label:"放弃", name:"onGiveUp"    },
        {label:"更新", name:"onRefresh"},
        {label:"重置", name:"onReset"}

    ]);

    public static var LINKBAR_VBOX_BCF:ArrayCollection = new ArrayCollection([
        {label:"保存", name:"onSave"        },
        {label:"重置", name:"onReset"   },
        {label:"放弃", name:"onGiveUp"    }
    ]);

    public static var LINKBAR_VBOX_BCF_1:ArrayCollection = new ArrayCollection([
        {label:"保存", name:"onSave"        },
        {label:"放弃", name:"onGiveUp"    }
    ]);


    //向上
    [Bindable]
    [Embed(source="/yssoft/assets/images/up.png")]
    public static var _UPICON:Class;

    //向最上
    [Bindable]
    [Embed(source="/yssoft/assets/images/upend.png")]
    public static var _UPENDICON:Class;

    //向下
    [Bindable]
    [Embed(source="/yssoft/assets/images/down.png")]
    public static var _DOWNICON:Class;

    //向最下
    [Bindable]
    [Embed(source="/yssoft/assets/images/downend.png")]
    public static var _DOWNENDICON:Class;

    // 下载
    [Embed(source="/yssoft/assets/images/downFile.png")]
    public static var DOWNFILE:Class;

    //预览
    [Embed(source="/yssoft/assets/images/preview.png")]
    public static var PREVIEW:Class;

    //数据类型
    [Bindable]
    public static var DATATYPEARR:ArrayCollection;

    /************************************* zhong_jing end *********************************************/

    /********************** 公共变量 add by liu_lei begin *************************************/
    //服务器URL根
    public static var publishUrlRoot:String;
    //发布后项目名称
    public static var publishAppName:String;
    /********************** 公共变量 add by liu_lei end *************************************/
    /********************** 图片资源 add by liu_lei begin *************************************/
    [Bindable]
    [Embed(source="/yssoft/assets/images/pre.png")]
    public static var leftarrow:Class;
    [Bindable]
    [Embed(source="/yssoft/assets/images/next.png")]
    public static var rightarrow:Class;
    [Bindable]
    [Embed(source="/yssoft/assets/images/dtj.png")]
    public static var dtjpng:Class;
    [Bindable]
    [Embed(source="/yssoft/assets/images/jtj.png")]
    public static var jtjpng:Class;
    [Bindable]
    [Embed(source="/yssoft/assets/images/wlc.png")]
    public static var wlcpng:Class;
    /********************** 图片资源 add by liu_lei end *************************************/
    /********************** 菜单设置 add by liu_lei begin *************************************/
    //新增菜单过度窗口显示的文字
    public static var MENU_ADD_INFO:String = "新增菜单处理中...";

    //新增菜单成功
    public static var MENU_ADD_SUCCESS:String = "新增菜单成功！！";

    //修改菜单过度窗口显示的文字
    public static var MENU_UPDATE_INFO:String = "修改菜单处理中...";

    //修改菜单成功
    public static var MENU_UPDATE_SUCCESS:String = "修改菜单成功！！";

    //处理失败
    public static var MENU_FAIL:String = "处理失败...";

    //删除菜单过度窗口显示的文字
    public static var MENU_REMOVE_INFO:String = "删除菜单处理中...";

    //删除菜单成功
    public static var MENU_REMOVE:String = "删除菜单成功！！";

    //确定是否删除头部
    public static var MENU_DETERMINE_HEAD:String = "确定删除[";

    //确定是否删除尾部
    public static var MENU_DETERMINE_TAIL:String = "菜单] ？";

    //有子节点不能删除
    public static var MENU_ROMEVE_PID:String = "该菜单存在子节点，不能删除！！";

    //节点存在
    public static var MENU_CCODE_WARNMSG:String = "编码已存在！！";


    public static var MENU_PID_WARNMSG:String = "父节点不存在！！";


    public static var MENU_CHOOSE:String = "请选择后，再操作！！";

    public static var MENU_CCODE_ISNULL:String = "菜单编码不能为空！！";

    public static var MENU_CNAME_ISNULL:String = "菜单名称不能为空！！";

    public static var MENU_IIMAGE_ISNULL:String = "菜单图标不能为空！！";

    public static var MENU_ITYPE_ISNULL:String = "请选择菜单类型！！";

    public static var MENU_IOPENTYPE_ISNULL:String = "请选择打开方式！！";

    public static var MENU_BSHOW_ISNULL:String = "请选择窗口状态！！";

    public static var MENU_IFUNCREGEDIT_ISNULL:String = "系统程序不能为空！！";

    public static var MENU_CPROGRAM_ISNULL:String = "链接程序不能为空！！";


    /**********************菜单设置 add by liu_lei end *************************************/
    /********************** 参照配置 add by liu_lei begin *************************************/
    //新增参照过度窗口显示的文字
    public static var CONSULT_ADD_INFO:String = "新增参照处理中...";

    //新增参照成功
    public static var CONSULT_ADD_SUCCESS:String = "新增参照成功！！";

    //修改参照过度窗口显示的文字
    public static var CONSULT_UPDATE_INFO:String = "修改参照处理中...";

    //修改参照成功
    public static var CONSULT_UPDATE_SUCCESS:String = "修改参照成功！！";

    //处理失败
    public static var CONSULT_FAIL:String = "处理失败...";

    //删除参照过度窗口显示的文字
    public static var CONSULT_REMOVE_INFO:String = "删除参照处理中...";

    //删除参照成功
    public static var CONSULT_REMOVE:String = "删除参照成功！！";

    //确定是否删除头部
    public static var CONSULT_DETERMINE_HEAD:String = "确定删除[";

    //确定是否删除尾部
    public static var CONSULT_DETERMINE_TAIL:String = "参照]?";

    //有子节点不能删除
    public static var CONSULT_ROMEVE_PID:String = "该参照存在子节点，不能删除！！";

    //节点存在
    public static var CONSULT_CCODE_WARNMSG:String = "编码已存在！！";

    public static var CONSULT_PID_WARNMSG:String = "父节点不存在！！";


    public static var CONSULT_CHOOSE:String = "请选择后，再操作！！";

    public static var CONSULT_CCODE_OVER:String = "参照编码禁止超出二级！！";

    public static var CONSULT_CCODE_ISNULL:String = "参照编码不能为空！！";

    public static var CONSULT_CNAME_ISNULL:String = "参照名称不能为空！！";

    public static var CONSULT_ITYPE_ISNULL:String = "请选择参照风格！！";

    public static var CONSULT_IOPENTYPE_ISNULL:String = "请选择打开方式！！";

    public static var CONSULT_TREESQL_ISNULL:String = "树SQL不能为空！！";
    public static var CONSULT_GRIDSQL_ISNULL:String = "列SQL不能为空！！";
    public static var CONSULT_CONNSQL_ISNULL:String = "树、列和树列关联SQL均不能为空！！";
    public static var CONSULT_JOINERR_ISNULL:String = "列SQL必须使用@join参数！！";
    public static var CONSULT_VALUEERR_ISNULL:String = "树列关联SQL必须使用@value参数！！";
    public static var CONSULT_IFUNCREGEDIT_ISNULL:String = "关联程序不能为空！！";

    public static var CONSULT_CPROGRAM_ISNULL:String = "链接程序不能为空！！";

    public static var CONSULT_REFRESHERR:String = "请先成功更新列，再进行保存！！";

    public static var CONSULT_EDITSTATEERR:String = "必需处于编辑状态，才能执行更新列！！";

    public static var CONSULT_NULLSTATEERR:String = "该SQL未获得任何数据，无法更新列！！";

    public static var CONSULT_FASTSEARCHERR:String = "快速搜索仅支持文本类型字段！！";

    public static var CONSULT_WARNONLYGETEND:String = "只能参照末节点！！";

    /********************** 参照配置 add by liu_lei end *************************************/

    /*YJ Add */
    public static var DATAGRID_DATANULL:String = "无数据修改!";

    public static var DATA_NOTNULL:String = "请填写必输项!";

    public static var DATA_FAIL:String = "数据操作失败!";

    public static var MENU_CLASS_CHOOSE:String = "请选择档案类型后，再操作！!";

    public static var MENU_CLASS_CHOOSEEND:String = "请选择末级分类后，再操作！!";

    public static var DATA_DEL_HAVEDATA:String = "当前分类已有档案，请先删除档案后才可删除分类！";


    /********************** 论坛 *************************************/
    public static var TWITTER_NOTNULL_INPUT:String = "请填写必输项！";
    public static var TWITTER_NOTNULL_SELECT:String = "请选择必选项！";

    public static var TWITTERTYPE_ADD_SUCCESS_INFO:String = "讨论类型保存成功！";
    public static var TWITTERTYPE_ADD_FAILED_INFO:String = "讨论类型保存失败！";

    public static var TWITTER_ADD_SUCCESS_INFO:String = "发帖成功！";
    public static var TWITTER_ADD_FAILED_INFO:String = "发帖失败！";

    public static var TWITTER_SAVE_SUCCESS_INFO:String = "帖子暂存成功！";
    public static var TWITTER_SAVE_FAILED_INFO:String = "帖子暂存失败！";

    public static var TWITTER_UPDATE_SUCCESS_INFO:String = "修改帖子成功！";
    public static var TWITTER_UPDATE_FAILED_INFO:String = "修改帖子失败！";

    public static var TWITTER_DELETE_SUCCESS_INFO:String = "删帖成功！";
    public static var TWITTER_DELETE_FAILED_INFO:String = "删帖失败！";

    public static var TWITTER_REPLY_SUCCESS_INFO:String = "回帖成功！";
    public static var TWITTER_REPLY_FAILED_INFO:String = "回帖失败！";

    //确定是否删除尾部
    public static var TWITTER_DETERMINE_TAIL:String = "类型] ？";

    /********************** 论坛 *************************************/

}
}
