//
//  SetVerifyMethodVC.m
//  GitomHB
//
//  Created by jiawei on 13-11-30.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "SetVerifyMethodVC.h"
#import "HBServerKit.h"
#import "UserManager.h"
#import "SVProgressHUD.h"

@interface SetVerifyMethodVC (){
    NSString *checkWay;
}

@end

@implementation SetVerifyMethodVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"部门验证方式";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadVerifyMethodData];
    
    
}

- (void)btnBack:(UIButton *)btn{
    
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit getVerifyOfOrgunitWithOrganizationName:comData.organization.name getVerifyArr:^(NSArray *verifyArr) {
        comData.verifyMethodArr = verifyArr;
    }];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -- 获得验证方法
- (void)loadVerifyMethodData{
    GetCommonDataModel;
    //重新获得登入信息
    NSLog(@"SetVerifyMethodVC == %d",self.verifyIdx);
    NSArray *orgPropsArray = [comData.verifyMethodArr objectAtIndex:self.verifyIdx];
    NSLog(@"SetVerifyMethodVC orgPropsArray == %@",comData.verifyMethodArr);
    
    //如果不是创建者，直接获得存储在单例中的验证方式
    if (comData.organization.roleId != 1) {
        
        //checkWay = comData.organization.checkWay;
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        [hbKit loggingWithUsername:comData.userlogingInfo.username Md5PasswordUp:comData.userlogingInfo.password VersionCode:@"9999" GotJsonDic:^(NSDictionary *dicUserLogged, WError *myError) {
            
            NSArray *orgPropsArray = [[[dicUserLogged objectForKey:@"organizations"]firstObject]objectForKey:@"orgunitProps"];
            
            if (orgPropsArray.count>0) {
                
                if (orgPropsArray.count>1){
                    checkWay = [[orgPropsArray objectAtIndex:2]objectForKey:@"propValue"];
                    NSLog(@"SetVerifyMethodVC propValue == %@",checkWay);
                }
//                if (orgPropsArray.count>2){
//                    checkWay = [[orgPropsArray objectAtIndex:2]objectForKey:@"propValue"];
//                    NSLog(@"SetVerifyMethodVC propValue = %@",checkWay);
//                }
            }
            
            if ([checkWay isEqual:NEED_QUESTION]) {
                comData.organization.question = [[orgPropsArray objectAtIndex:3]objectForKey:@"propValue"];
                comData.organization.answers = [[orgPropsArray objectAtIndex:1]objectForKey:@"propValue"];
            }else{
                comData.organization.question = @"";
                comData.organization.answers = @"";
            }
            
            [self initRecordPromptInfo];
            [self creatButtons];
        }];
        
    //如果是创建者，由于手下有众多部门，得到一个验证方式的数组，从中辨别出对应部门的验证方式
    }else{
        
        
        
        if (orgPropsArray.count>0) {
            
            if (orgPropsArray.count >3) {
                
                checkWay = [[orgPropsArray objectAtIndex:2]objectForKey:@"propValue"];
                NSLog(@"SetVerifyMethodVC propValue == %@",checkWay);
                
            }else{
                
                checkWay = [[orgPropsArray objectAtIndex:1]objectForKey:@"propValue"];
                NSLog(@"SetVerifyMethodVC propValue == %@",checkWay);
                
            }
            
        }else{
            
            checkWay = NEED_VERIFY;
            
        }
        if ([checkWay isEqual:NEED_QUESTION]) {
            
            if (orgPropsArray.count >3) {
                
                comData.organization.question = [[orgPropsArray objectAtIndex:3]objectForKey:@"propValue"];
                comData.organization.answers = [[orgPropsArray objectAtIndex:1]objectForKey:@"propValue"];
                
            }else{
                
                comData.organization.question = [[orgPropsArray objectAtIndex:2]objectForKey:@"propValue"];
                comData.organization.answers = [[orgPropsArray objectAtIndex:0]objectForKey:@"propValue"];
                
            }
            
        }else{
            comData.organization.question = @"";
            comData.organization.answers = @"";
        }
        
        NSLog( @"MenuVC comData.organization.question == question %@ answers %@ chechWay %@ ",comData.organization.question,comData.organization.answers,checkWay);
        
        [self initRecordPromptInfo];
        [self creatButtons];
        
    }
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    verifyIndex = 4;
    
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
    
    baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-70)];
    baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:baseView];
    
    
    
    UITapGestureRecognizer *tapHiddenKb = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction)];
    [baseView addGestureRecognizer:tapHiddenKb];

    [self creatTextFields];
    
}

#pragma mark -- 验证方式按钮
- (void)creatButtons{
    
    UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(50, 55, 180, 20)];
    
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"允许任何人加入";
    [baseView addSubview:label1];
    
    UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(50, 95, 180, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = @"拒绝任何人加入";
    [baseView addSubview:label2];
    
    UILabel *label3 =[[UILabel alloc] initWithFrame:CGRectMake(50, 135, 180, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = @"提交申请，等待批准";
    [baseView addSubview:label3];
    
    UILabel *label4 =[[UILabel alloc] initWithFrame:CGRectMake(50, 175, 180, 20)];
    label4.backgroundColor = [UIColor clearColor];
    label4.font = [UIFont systemFontOfSize:12];
    label4.text = @"回答问题，自动加入";
    [baseView addSubview:label4];
    
    RadioButton *rb1 = [[RadioButton alloc] initWithGroupId:@"first group" index:0];
    RadioButton *rb2 = [[RadioButton alloc] initWithGroupId:@"first group" index:1];
    RadioButton *rb3 = [[RadioButton alloc] initWithGroupId:@"first group" index:2];
    RadioButton *rb4 = [[RadioButton alloc] initWithGroupId:@"first group" index:3];

    GetCommonDataModel;
    NSLog(@"SetVerifyMethodVC comData.organization.checkWay == %@",checkWay);
    if ([checkWay isEqualToString:ALWAYS_ACCEPT]) {
        [rb1 setChecked:YES];
    }else if ([checkWay isEqualToString:ALWAYS_DECLINE]) {
        [rb2 setChecked:YES];
    }else if ([checkWay isEqualToString:NEED_VERIFY]){
        [rb3 setChecked:YES];
    }else if ([checkWay isEqualToString:NEED_QUESTION]) {
        [rb4 setChecked:YES];
        question.hidden = NO;
        answers.hidden = NO;
        question.text = comData.organization.question;
        NSLog(@"SetVerifyMethodVC question == %@",comData.organization.question);
        answers.text = comData.organization.answers;
    }
    
    rb1.frame = CGRectMake(20,55,22,220);
    rb2.frame = CGRectMake(20,95,22,22);
    rb3.frame = CGRectMake(20,135,22,22);
    rb4.frame = CGRectMake(20,175,22,22);
    
    [baseView addSubview:rb1];
    [baseView addSubview:rb2];
    [baseView addSubview:rb3];
    [baseView addSubview:rb4];
    
    [RadioButton addObserverForGroupId:@"first group" observer:self];
    
    
    
    
    
}

#pragma mark -- RRadioButtonDelegate
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    NSLog(@"changed to %d in %@",index,groupId);
    if (index == 3) {
        question.hidden = NO;
        answers.hidden = NO;
    }else{
        question.hidden = YES;
        answers.hidden = YES;
    }
    verifyIndex = index;
}

#pragma mark -- 保存配置
- (void)saveAction{
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    NSString *methodVerify = nil;
    switch (verifyIndex) {
        case 0:
            methodVerify = ALWAYS_ACCEPT;
            break;
        case 1:
            methodVerify = ALWAYS_DECLINE;
            break;
        case 2:
            methodVerify = NEED_VERIFY;
            break;
        case 3:
            methodVerify = NEED_QUESTION;
            break;
        case 4:
            methodVerify = checkWay;
            break;
        default:
            break;
    }
    
    if ([methodVerify isEqual: NEED_QUESTION]) {
        
        if ([question.text isEqualToString:@""]|[answers.text isEqualToString:@""]) {

            [SVProgressHUD showErrorWithStatus:@"对不起，问题、答案不能为空！" duration:1.5];
            return;
            
        }
    }
    [hbKit changeApplyJoinWayToCompanyWithOrganizationId:comData.organization.organizationId
                                            andOrgunitId:[self.orgunitId integerValue]
                                               andMethod:methodVerify
                                             andQuestion:question.text
                                               andAnswer:answers.text
                                           andUpdateUser:comData.userModel.username];
    
    UserManager *um = [[UserManager alloc]init];
    
    [um loggingWithLoggingInfo:comData.userlogingInfo
                  WbLoggedInfo:^(UserLoggedInfo *loggedInfo, BOOL isLoggedOk) {
                      if (isLoggedOk) {
                          
                          Organization * organizationInfo = [[Organization alloc]initForAllJsonDataTypeWithDicFromJson:[loggedInfo.organizations lastObject]];
                          comData.organization = organizationInfo;//使用单例的获得解析到的用户信息
                          NSLog(@"SetVerifyMethode comData 0= %@ com = %@",organizationInfo,comData.organization.checkWay);
                      }
                  }];
    
}

#pragma mark -- 问题、答案输入框
- (void)creatTextFields{
    question = [[UITextField alloc]initWithFrame:CGRectMake(10, 210, Screen_Width-20, 40)];
    answers = [[UITextField alloc]initWithFrame:CGRectMake(10, 255, Screen_Width-20, 40)];
    question.hidden = YES;
    answers.hidden = YES;
    
    UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftViewLb setBackgroundColor:[UIColor clearColor]];
    leftViewLb.textColor = [UIColor grayColor];
    leftViewLb.text = @"问题:";
    
    question.delegate = self;
    question.borderStyle = UITextBorderStyleRoundedRect;
    question.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    question.leftView = leftViewLb;
    question.leftViewMode = UITextFieldViewModeAlways;
    question.placeholder = @"请输入问题";
    [baseView addSubview:question];
    
    UILabel * leftViewLb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftViewLb1 setBackgroundColor:[UIColor clearColor]];
    leftViewLb1.textColor = [UIColor grayColor];
    leftViewLb1.text = @"答案:";
    
    answers.delegate = self;
    answers.borderStyle = UITextBorderStyleRoundedRect;
    answers.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    answers.leftView = leftViewLb1;
    answers.leftViewMode = UITextFieldViewModeAlways;
    answers.placeholder = @"请输入答案";
    [baseView addSubview:answers];
}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
    baseView.contentSize = self.view.frame.size;
}

#pragma mark - 隐藏键盘
- (void)tapViewAction{
    [answers resignFirstResponder];
    [question resignFirstResponder];
    baseView.frame = self.view.frame;
    baseView.contentSize = self.view.frame.size;
}

-(void)initRecordPromptInfo
{
    
    NSString *checkWayStr = nil;
    if ([checkWay isEqualToString:ALWAYS_ACCEPT]) {
        checkWayStr = @"允许任何人加入";
    }else if ([checkWay isEqualToString:ALWAYS_DECLINE]) {
        checkWayStr = @"拒绝任何人加入";
    }else if ([checkWay isEqualToString:NEED_VERIFY]){
        checkWayStr = @"提交申请，等待批准";
    }else if ([checkWay isEqualToString:NEED_QUESTION]) {
        checkWayStr = @"回答问题，自动加入";
    }
    
    CGFloat hViewRecordPromptInfo = 40;
    UIView * viewRecordPromptInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, hViewRecordPromptInfo)];
    [viewRecordPromptInfo setBackgroundColor:BlueColor];
    
    _lblRecordPromptUserInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, hViewRecordPromptInfo)];
    [viewRecordPromptInfo addSubview:_lblRecordPromptUserInfo];
    _lblRecordPromptUserInfo.textAlignment = NSTextAlignmentCenter;
    _lblRecordPromptUserInfo.textColor = [UIColor blackColor];
    [_lblRecordPromptUserInfo setFont:[UIFont systemFontOfSize:18]];
    [_lblRecordPromptUserInfo setBackgroundColor:[UIColor clearColor]];
    _lblRecordPromptUserInfo.text = [NSString stringWithFormat:@"当前验证方式:%@",checkWayStr];
    [self.view addSubview:viewRecordPromptInfo];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
