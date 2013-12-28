//
//  ApplyNotesVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-6.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ApplyNotesVC.h"
#import "HBServerKit.h"
#import "GitomSingal.h"
#import "SVProgressHUD.h"

#define NUMBERS @"0123456789\n"

/*
 ALWAYS_ACCEPT	("该部门允许任何人加入"),
 NEED_VERIFY	("提交申请，等待批准"),
 NEED_QUESTION	("回答问题，自动加入"),
 ALWAYS_DECLINE	("该部门拒绝任何人加入");
 */
@interface ApplyNotesVC (){
    UITableView *registerTableV;
}

@end

@implementation ApplyNotesVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"申请加入";
    }
    return self;
}

#pragma mark - 申请加入公司
- (void)applyAction{
    
    [self tpeToDismissAction];
    
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GitomSingal *singal = [GitomSingal getInstance];
    
    UITextField *text1 = (UITextField*)[self.view viewWithTag:1001];
    UITextField *text2 = (UITextField*)[self.view viewWithTag:1002];
    UITextField *text3 = (UITextField*)[self.view viewWithTag:1003];
    NSString *noteStr = [NSString stringWithFormat:@"[%@(%@)]%@",text1.text,text2.text,text3.text];
    
    
    
    //答题通过验证
    if ([checkWay isEqual:NEED_QUESTION]) {
        
        UITextField *text4 = (UITextField*)[self.view viewWithTag:1004];
        if (text1.text.length == 0) {
            
            [SVProgressHUD showErrorWithStatus:@"请填写姓名"];
            return;
        }if (text2.text.length == 0) {
            
            [SVProgressHUD showErrorWithStatus:@"请填写手机"];
            return;
        }if (text4.text.length == 0) {
            
            [SVProgressHUD showErrorWithStatus:@"请填答案"];
            return;
            
        }else{
            
            if (![text4.text isEqual:[[self.orgPropsArray objectAtIndex:1]objectForKey:@"propValue"]]) {
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"答案错误，未通审核过" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [aler show];
                return;
            }else{
                
                [hbKit noApplyJoinToCompanyWithOrganizationId:self.companyId andOrgunitId:self.orgId andUseName:singal.registerName andRealName:text1.text andTelephone:text2.text andUpdateUser:singal.registerName];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"加入成功！"];
            }
            
        }
        
        
    //允许任何人加入公司
    } else if ([checkWay isEqual:ALWAYS_ACCEPT]){
        if (text1.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写姓名"];
            return;
        }if (text2.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写手机"];
            return;
        }else{
            [hbKit noApplyJoinToCompanyWithOrganizationId:self.companyId andOrgunitId:self.orgId andUseName:singal.registerName andRealName:text1.text andTelephone:text2.text andUpdateUser:singal.registerName];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
    //拒绝任何人
    }else if ([checkWay isEqual:ALWAYS_DECLINE]){
        
        [SVProgressHUD showErrorWithStatus:@"拒绝任何人加入" duration:0.6];
       
    //提交申请，等待批准
    }else{
        NSLog(@"ApplyNotesVC text == %@ length == %d",text1.text,text1.text.length);
        if (text1.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写姓名"];
            return;
        }if (text2.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写手机"];
            return;
        }else if (text3.text.length == 0){
            [SVProgressHUD showErrorWithStatus:@"请填理由"];
            return;
        }
        else{
            
            [hbKit applyJoinToCompanyWithOrganizationId:self.companyId andOrgunitId:self.orgId andNote:noteStr andUseName:singal.registerName andVerifyType:@"0"];
            [SVProgressHUD showSuccessWithStatus:@"成功提交，等待审批"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //申请加入验证的方法
    [self verifyMathWays];
    
    //
    baseView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:baseView];
    
    //返回
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
  
    //提交申请
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rightbtn.frame = CGRectMake(0, 0, 50, 44);
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    [rightbtn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [rightbtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
  
    
    [self creatInfomationsView];
    
    registerTableV = [[UITableView alloc]initWithFrame:CGRectMake(10, 85, Screen_Width-20, 0) style:UITableViewStylePlain];
    [registerTableV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    registerTableV.dataSource = self;
    registerTableV.delegate = self;
    registerTableV.scrollEnabled = NO;
    registerTableV.layer.borderWidth = 0.7;
    registerTableV.layer.cornerRadius = 7;
    [baseView addSubview:registerTableV];

    
}

- (void) verifyMathWays{
    //加入验证的方法
    if (self.orgPropsArray.count>0) {
        
        if (self.orgPropsArray.count >3) {
            checkWay = [[self.orgPropsArray objectAtIndex:2]objectForKey:@"propValue"];
            NSLog(@"ApplyNotesVC propValue == %@",checkWay);
        }else{
            checkWay = [[self.orgPropsArray objectAtIndex:1]objectForKey:@"propValue"];
            NSLog(@"ApplyNotesVC propValue == %@",checkWay);
        }
        
    }else{
        
        checkWay = NEED_VERIFY;
        
    }
    
    //如果是问答验证
    if ([checkWay isEqualToString:NEED_QUESTION]) {
        if (self.orgPropsArray.count >3) {
            
            question = [[self.orgPropsArray objectAtIndex:3]objectForKey:@"propValue"];
            answer = [[self.orgPropsArray objectAtIndex:1]objectForKey:@"propValue"];
            
        }else{
            
            question = [[self.orgPropsArray objectAtIndex:2]objectForKey:@"propValue"];
            answer = [[self.orgPropsArray objectAtIndex:0]objectForKey:@"propValue"];
            
        }
        
    }else{
        
        question = @"";
        answer = @"";
        
    }
}


- (void) creatInfomationsView{
    UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, Screen_Width-20, 25)];
    companyName.backgroundColor =  BlueColor;
    companyName.text = [NSString stringWithFormat:@" 公司:%@",self.companyName];
    [baseView addSubview:companyName];
    
    UILabel *orgName = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, Screen_Width-20, 25)];
    orgName.backgroundColor = BlueColor;
    orgName.text = [NSString stringWithFormat:@" 部门:%@",self.orgName];
    [baseView addSubview:orgName];
    
    UILabel *method = [[UILabel alloc]initWithFrame:CGRectMake(10, 57.5, Screen_Width-20, 25)];
    method.backgroundColor = BlueColor;
    if ([checkWay isEqual: ALWAYS_ACCEPT]) {
        method.text = [NSString stringWithFormat:@" 验证:%@",@"总是允许"];
    }else if ([checkWay isEqual:NEED_QUESTION]) {
        method.text = [NSString stringWithFormat:@" 验证:%@",@"回答问题，自动加入"];
    }else if ([checkWay isEqual:NEED_VERIFY]) {
        method.text = [NSString stringWithFormat:@" 验证:%@",@"提交申请，等待批准"];
    }else if ([checkWay isEqual:ALWAYS_DECLINE]) {
        method.text = [NSString stringWithFormat:@" 验证:%@",@"不接受加入"];
    }else{
        method.text = [NSString stringWithFormat:@" 验证:%@",@"提交申请，等待批准"];
    }
    
    [baseView addSubview:method];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([checkWay isEqual: ALWAYS_ACCEPT]) {
        NSLog(@"checkWay 2");
        registerTableV.frame = CGRectMake(10, 85, Screen_Width-20, 80);
        return 2;
    }else if ([checkWay isEqual:NEED_QUESTION]) {
        NSLog(@"checkWay 4");
        registerTableV.frame = CGRectMake(10, 85, Screen_Width-20, 160);
        return 4;
    }else if ([checkWay isEqual:NEED_VERIFY]) {
        NSLog(@"checkWay 3");
        registerTableV.frame = CGRectMake(10, 85, Screen_Width-20, 120);
        return 3;
    }else if ([checkWay isEqual:ALWAYS_DECLINE]) {
        NSLog(@"checkWay 0");
        return 0;
    }else{
        NSLog(@"checkWay 3");
        registerTableV.frame = CGRectMake(10, 85, Screen_Width-20, 120);
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    switch (indexPath.row) {
        case 0:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            leftViewLb.text = @"姓名";
            
            UITextField * logName = [[UITextField alloc]initWithFrame:CGRectMake(10, 3, Screen_Width-20, 40)];
            logName.tag = 1001;
            logName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            logName.leftView = leftViewLb;
            logName.leftViewMode = UITextFieldViewModeAlways;
            logName.placeholder = @"输入姓名";
            [cell addSubview:logName];
        
        
            return cell;
        }
        case 1:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            leftViewLb.text = @"手机";
            
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Screen_Width-20, 40)];
            phoneNumber.tag = 1002;
            phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            phoneNumber.placeholder = @"输入手机";
            [cell addSubview:phoneNumber];
            return cell;
        }
            break;
        case 2:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Screen_Width-20, 40)];
            phoneNumber.tag = 1003;
            phoneNumber.delegate = self;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            if ([checkWay isEqual:NEED_QUESTION]) {
                leftViewLb.text = @"问题";
                phoneNumber.text = question;
                phoneNumber.enabled = NO;
            }else{
                leftViewLb.text = @"申请";
                phoneNumber.placeholder = @"您申请的理由，如市场部“张三”";
            }
            [cell addSubview:phoneNumber];
           
           
            return cell;
        }case 3:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            leftViewLb.text = @"答案";
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Screen_Width-20, 40)];
            phoneNumber.placeholder = @"输入答案";
            phoneNumber.tag = 1004;
            phoneNumber.delegate = self;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            [cell addSubview:phoneNumber];
        
        
            return cell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark -- UITextFiled delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
 
    if (textField.tag == 1002) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        if (range.location >= 11)return NO;
        return canChange;
        
        
    }
    
    return YES;
    
}

#pragma mark -- 点击任意位置收起键盘
- (void)tpeToDismissAction{
    UITextField *textField = (UITextField *)[self.view viewWithTag:2];
    [textField resignFirstResponder];
    [UIView animateWithDuration:1 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y);
    }];
  
}
//执行代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//取消第一响应
    return YES;
}
//在用键盘输入内容时候，输入框上移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
    baseView.contentSize = self.view.frame.size;
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
