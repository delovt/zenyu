package yssoft.vos;

import java.text.DecimalFormat;

public class BmInterimVo {
	
	private String department  ;  //部门 
	private String projectName;  //项目名称
	private String percent ; //百分比
	
	private String df_1_0 ;
	private String df_1_1 ;
	private String df_1_2 ;
	private String df_1_sum;
	private String df_2_0 ;
	private String df_2_1 ;
	private String df_2_2 ;
	private String df_2_sum;
	private String df_3_0 ;
	private String df_3_1 ;
	private String df_3_2 ;
	private String df_3_sum;
	private String df_4_0 ;
	private String df_4_1;
	private String df_4_2 ;
	private String df_4_sum;
	private String df_sum;
	
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getProjectName() {
		return projectName;
	}
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	public String getPercent() {
		return percent;
	}
	public void setPercent(String percent) {
		this.percent = percent;
	}
	public String getDf_1_0() {
		return df_1_0;
	}
	public void setDf_1_0(String df_1_0) {
		this.df_1_0 = df_1_0;
	}
	public String getDf_1_1() {
		return df_1_1;
	}
	public void setDf_1_1(String df_1_1) {
		this.df_1_1 = df_1_1;
	}
	public String getDf_1_2() {
		return df_1_2;
	}
	public void setDf_1_2(String df_1_2) {
		this.df_1_2 = df_1_2;
	}
	
	public String getDf_1_sum() {
		return convertStr(Double.parseDouble(df_1_0)+Double.parseDouble(df_1_1)+Double.parseDouble(df_1_2));
	}
	
	public String getDf_2_0() {
		return df_2_0;
	}
	public void setDf_2_0(String df_2_0) {
		this.df_2_0 = df_2_0;
	}
	public String getDf_2_1() {
		return df_2_1;
	}
	public void setDf_2_1(String df_2_1) {
		this.df_2_1 = df_2_1;
	}
	public String getDf_2_2() {
		return df_2_2;
	}
	public void setDf_2_2(String df_2_2) {
		this.df_2_2 = df_2_2;
	}
	public String getDf_2_sum() {
		return convertStr(Double.parseDouble(df_2_0)+Double.parseDouble(df_2_1)+Double.parseDouble(df_2_2));
	}

	public String getDf_3_0() {
		return df_3_0;
	}
	public void setDf_3_0(String df_3_0) {
		this.df_3_0 = df_3_0;
	}
	public String getDf_3_1() {
		return df_3_1;
	}
	public void setDf_3_1(String df_3_1) {
		this.df_3_1 = df_3_1;
	}
	public String getDf_3_2() {
		return df_3_2;
	}
	public void setDf_3_2(String df_3_2) {
		this.df_3_2 = df_3_2;
	}
	public String getDf_3_sum() {
		return convertStr(Double.parseDouble(df_3_0)+Double.parseDouble(df_3_1)+Double.parseDouble(df_3_2));
	}

	public String getDf_4_0() {
		return df_4_0;
	}
	public void setDf_4_0(String df_4_0) {
		this.df_4_0 = df_4_0;
	}
	public String getDf_4_1() {
		return df_4_1;
	}
	public void setDf_4_1(String df_4_1) {
		this.df_4_1 = df_4_1;
	}
	public String getDf_4_2() {
		return df_4_2;
	}
	public void setDf_4_2(String df_4_2) {
		this.df_4_2 = df_4_2;
	}
	public String getDf_4_sum() {
		return convertStr(Double.parseDouble(df_4_0)+Double.parseDouble(df_4_1)+Double.parseDouble(df_4_2));
	}

	public void setDf_1_sum(String df_1Sum) {
		df_1_sum = df_1Sum;
	}
	public void setDf_2_sum(String df_2Sum) {
		df_2_sum = df_2Sum;
	}
	public void setDf_3_sum(String df_3Sum) {
		df_3_sum = df_3Sum;
	}
	public void setDf_4_sum(String df_4Sum) {
		df_4_sum = df_4Sum;
	}
	
	public void setDf_sum(String dfSum) {
		df_sum = dfSum;
	}
	
	public String getDf_sum() {
		return  convertStr(Double.parseDouble(getDf_1_sum())+Double.parseDouble(getDf_2_sum())+Double.parseDouble(getDf_3_sum())+Double.parseDouble(getDf_4_sum()));
	}
	
	//四舍五入
	private String convertStr(double d){
		 DecimalFormat   fnum   =   new   DecimalFormat("##0.00");  
		  return fnum.format(d);      
	}
}
