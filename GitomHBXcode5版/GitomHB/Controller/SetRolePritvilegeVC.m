//
//  SetRolePritvilegeVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-28.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "SetRolePritvilegeVC.h"
#import "HBServerKit.h"
#import "UserManager.h"

@interface SetRolePritvilegeVC ()

@end

@implementation SetRolePritvilegeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"权限编辑";
        
    }
    return self;
}

- (void)btnBack:(UIButton *)btn{
    
    GetCommonDataModel;
    UserManager *um = [[UserManager alloc]init];
    
    [um loggingWithLoggingInfo:comData.userlogingInfo WbLoggedInfo:^(UserLoggedInfo *loggedInfo, BOOL isLoggedOk) {
        
        if (isLoggedOk) {
            
            Organization * organizationInfo = [[Organization alloc]initForAllJsonDataTypeWithDicFromJson:[loggedInfo.organizations lastObject]];
            comData.organization = organizationInfo;//使用单例的获得解析到的用户信息
 
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- 保存编辑主管权限
- (void)saveAction{
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit saveRolePrivilegeWithOrganizationId:comData.organization.organizationId
                                     andRoleId:2 andOperations:self.appindStr
                                 andUpdateUser:comData.userModel.username];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
   
	//后退
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
   
    
    //保存
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setTitle:@"保存" forState:UIControlStateNormal];
    [rbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rbtn.frame = CGRectMake(0, 0, 50, 44);
    [rbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    [rbtn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [rbtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rbtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
  
    
    //
    _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-65)];
    _baseView.backgroundColor = [UIColor clearColor];
    _baseView.contentSize = CGSizeMake(Screen_Width, Screen_Height+50);//CGRectMake(0, 0, Screen_Width, Screen_Height+70);//self.view.frame.size;
    [self.view addSubview:_baseView];
    
    [self creatButtons];
    
}
/*
 "查看用户实时位置", 9
 
 "发布公告", 3
 
 "验证绑定申请", 1
 
 "编辑职位", 8
 "移动用户", 13
 "删除员工", 4,
 
 "更改部门名称", 12
 "修改考勤设置", 6
 "设置验证方式", 14 
 */
- (void)creatButtons{
    GetCommonDataModel;
    //self.appindStr = comData.organization.operations;
    self.appindStr = [[NSString alloc]init];
    NSLog(@"权限 comData.organization.operations == %@",comData.organization.operations);
    //记录查询
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
    lb1.font = [UIFont systemFontOfSize:15];
    lb1.backgroundColor = BlueColor;
    lb1.text = @"  记录查询";
    [self.baseView addSubview:lb1];
    
    QCheckBox *option9 = [[QCheckBox alloc] initWithDelegate:self];
    option9.tag = 9;
    option9.frame = CGRectMake(10, 30, 180, 40);
    [option9 setTitle:@"查询员工位置路线" forState:UIControlStateNormal];
    [option9 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [option9.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.baseView addSubview:option9];
    NSRange option9Rang = [comData.organization.operations rangeOfString:@"9"];
    if (option9Rang.location == NSNotFound) {
        NSLog(@"9 nil");
        nil;
    }else{
        NSLog(@"9 yes");
        [option9 setChecked:YES];
    }
   
    
    //公告发布
    UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, Screen_Width, 30)];
    lb2.font = [UIFont systemFontOfSize:15];
    lb2.backgroundColor = BlueColor;
    lb2.text = @"  公告发布";
    [self.baseView addSubview:lb2];
    
    QCheckBox *option3 = [[QCheckBox alloc] initWithDelegate:self];
    option3.tag = 3;
    option3.frame = CGRectMake(10, 100, 180, 40);
    [option3 setTitle:@"发布部门公告" forState:UIControlStateNormal];
    [option3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [option3.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.baseView addSubview:option3];
    NSRange option3Rang = [comData.organization.operations rangeOfString:@"3"];
    if (option3Rang.location == NSNotFound) {
        NSLog(@"3 nil");
        nil;
    }else{
        NSLog(@"3 yes");
        [option3 setChecked:YES];
    }

    
    //审核申请
    UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, Screen_Width, 30)];
    lb3.font = [UIFont systemFontOfSize:15];
    lb3.backgroundColor = BlueColor;
    lb3.text = @"  审核申请";
    [self.baseView addSubview:lb3];
    
    QCheckBox *option1 = [[QCheckBox alloc] initWithDelegate:self];
    option1.tag = 1;
    option1.frame = CGRectMake(10, 170, 180, 40);
    [option1 setTitle:@"审核加入部门的申请" forState:UIControlStateNormal];
    [option1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [option1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.baseView addSubview:option1];
    NSRange option1Rang = [comData.organization.operations rangeOfString:@"1"];
    if (option1Rang.location == NSNotFound){
        NSLog(@"1 nil");
        nil;
    }else{
        NSLog(@"1 yes");
        [option1 setChecked:YES];
    }
  
    
    //管理员工
    UILabel *lb4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, Screen_Width, 30)];
    lb4.font = [UIFont systemFontOfSize:15];
    lb4.backgroundColor = BlueColor;
    lb4.text = @"  管理员工";
    [self.baseView addSubview:lb4];
    
    QCheckBox *option8 = [[QCheckBox alloc] initWithDelegate:self];
    option8.tag = 8;
    option8.frame = CGRectMake(10, 240, 180, 40);
    [option8 setTitle:@"编辑员工职位" forState:UIControlStateNormal];
    [option8 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [option8.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.baseView addSubview:option8];
    NSRange option8Rang = [comData.organization.operations rangeOfString:@"8"];
    if (option8Rang.location == NSNotFound){
        NSLog(@"8 nil");
        nil;
    }else{
        NSLog(@"8 yes");
        [option8 setChecked:YES];
    }
  
    
    QCheckBox *option13 = [[QCheckBox alloc] initWithDelegate:self];
    option13.tag = 13;
    option13.frame = CGRectMake(10, 280, 180, 40);
    [option13 setTitle:@"转移员工到别的部门" forState:UIControlStateNormal];
    [option13 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [option13.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.baseView addSubview:option13];
    NSRange option13Rang = [comData.organization.operations rangeOfString:@"13"];
    if (option13Rang.location == NSNotFound){
        NSLog(@"13 nil");
        nil;
    }else{
        NSLog(@"13 yes");
        [option13 setChecked:YES];
    }
  
    
    QCheckBox *option4 = [[QCheckBox alloc] initWithDelegate:self];
    option4.tag = 4;
    option4.frame = CGRectMake(10, 320, 180, 40);
    [option4 setTitle:@"删除员工" forState:UIControlStateNormal];
    [option4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [option4.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.baseView addSubview:option4];
    NSRange option4Rang = [comData.organization.operations rangeOfString:@",4"];
    if (option4Rang.location == NSNotFound){
        NSLog(@",4 nil");
        nil;
    }else{
        NSLog(@",4 yes");
        [option4 setChecked:YES];
    }
  
    
    //管理部门
    UILabel *lb5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 360, Screen_Width, 30)];
    lb5.font = [UIFont systemFontOfSize:15];
    lb5.backgroundColor = BlueColor;
    lb5.text = @"  管理部门";
    [self.baseView addSubview:lb5];
    
    QCheckBox *option12 = [[QCheckBox alloc] initWithDelegate:self];
    option12.tag = 12;
    option12.frame = CGRectMake(10, 390, 180, 40);
    [option12 setTitle:@"修改部门名称" forState:UIControlStateNormal];
    [option12 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [option12.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.baseView addSubview:option12];
    NSRange option12Rang = [comData.organization.operations rangeOfString:@"12"];
    if (option12Rang.location == NSNotFound){
        NSLog(@"12 nil");
        nil;
    }else{
        NSLog(@"12 yes");
        [option12 setChecked:YES];
    }
   
    
    QCheckBox *option6 = [[QCheckBox alloc] initWithDelegate:self];
    option6.tag = 6;
    option6.frame = CGRectMake(10, 430, 180, 40);
    [option6 setTitle:@"修改部门考勤配置" forState:UIControlStateNormal];
    [option6 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [option6.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.baseView addSubview:option6];
    NSRange option6Rang = [comData.organization.operations rangeOfString:@"6"];
    if (option6Rang.location == NSNotFound){
        NSLog(@"6 nil");
        nil;
    }else{
        NSLog(@"6 yes");
        [option6 setChecked:YES];
    }
   
    
    QCheckBox *option14 = [[QCheckBox alloc] initWithDelegate:self];
    option14.tag = 14;
    option14.frame = CGRectMake(10, 470, 180, 40);
    [option14 setTitle:@"修改部门验证方式" forState:UIControlStateNormal];
    [option14 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [option14.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.baseView addSubview:option14];
    NSRange option14Rang = [comData.organization.operations rangeOfString:@"14"];
    if (option14Rang.location == NSNotFound){
        NSLog(@"14 nil");
        nil;
    }else{
        NSLog(@"14 yes");
        [option14 setChecked:YES];
    }

    
}

#pragma mark - QCheckBoxDelegate
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    
    NSLog(@"did tap on CheckBox:%@ checked:%c", checkbox.titleLabel.text, checked);
   
    NSString *checkBoxStr = [NSString stringWithFormat:@",%d",checkbox.tag];
    if (checked) {
        self.appindStr = [self.appindStr stringByAppendingString:checkBoxStr];
    }else{
        self.appindStr = [self.appindStr stringByReplacingOccurrencesOfString:checkBoxStr withString:@""];

    }
    NSLog(@"self.appindStr == %@",self.appindStr);
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
