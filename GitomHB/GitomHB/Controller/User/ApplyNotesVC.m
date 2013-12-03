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
    }
    return self;
}

#pragma mark - 申请加入公司
- (void)applyAction{
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GitomSingal *singal = [GitomSingal getInstance];
    UITextField *text1 = (UITextField*)[self.view viewWithTag:1001];
    UITextField *text2 = (UITextField*)[self.view viewWithTag:1002];
    UITextField *text3 = (UITextField*)[self.view viewWithTag:1003];
    NSString *noteStr = [NSString stringWithFormat:@"[%@(%@)]%@",text1.text,text2.text,text3.text];
    if ([checkWay isEqual:NEED_QUESTION]) {
        UITextField *text4 = (UITextField*)[self.view viewWithTag:1004];
        if ([text4.text isEqual:[[self.orgPropsArray objectAtIndex:1]objectForKey:@"propValue"]]) {
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"答案错误，审核未通过" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [aler show];
         
        }else{
            
            [hbKit noApplyJoinToCompanyWithOrganizationId:self.companyId andOrgunitId:self.orgId andUseName:singal.registerName andRealName:text1.text andTelephone:text2.text andUpdateUser:singal.registerName];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } else if ([checkWay isEqual:ALWAYS_ACCEPT]){
        [hbKit noApplyJoinToCompanyWithOrganizationId:self.companyId andOrgunitId:self.orgId andUseName:singal.registerName andRealName:text1.text andTelephone:text2.text andUpdateUser:singal.registerName];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([checkWay isEqual:ALWAYS_DECLINE]){
        [SVProgressHUD showErrorWithStatus:@"拒绝任何人加入" duration:0.6];
    }else{
        [hbKit applyJoinToCompanyWithOrganizationId:self.companyId andOrgunitId:self.orgId andNote:noteStr andUseName:singal.registerName andVerifyType:@"0"];
        [SVProgressHUD showSuccessWithStatus:@"成功提交"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.orgPropsArray.count>0) {
        checkWay = [[self.orgPropsArray objectAtIndex:0]objectForKey:@"propValue"];
        NSLog(@"ApplyNotesVC propValue = %@",checkWay);
        if (self.orgPropsArray.count>1){
            checkWay = [[self.orgPropsArray objectAtIndex:1]objectForKey:@"propValue"];
        NSLog(@"ApplyNotesVC propValue == %@",checkWay);
        }
        if (self.orgPropsArray.count>2){
            checkWay = [[self.orgPropsArray objectAtIndex:2]objectForKey:@"propValue"];
            NSLog(@"ApplyNotesVC propValue = %@",checkWay);
        }
        
    }
    
    
    
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
  
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rightbtn.frame = CGRectMake(0, 0, 50, 44);
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    // 高亮
    [rightbtn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [rightbtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
 
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tpeToDismissAction)];
    [self.view addGestureRecognizer:tap];
  
    
    [self creatInfomationsView];
    
    registerTableV = [[UITableView alloc]initWithFrame:CGRectMake(10, 85, Screen_Width-20, 0) style:UITableViewStylePlain];
    [registerTableV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    registerTableV.dataSource = self;
    registerTableV.delegate = self;
    registerTableV.scrollEnabled = NO;
    registerTableV.layer.borderWidth = 0.7;
    registerTableV.layer.cornerRadius = 7;
    [self.view addSubview:registerTableV];

    
}



- (void) creatInfomationsView{
    UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, Screen_Width-20, 25)];
    companyName.backgroundColor =  BlueColor;
    companyName.text = [NSString stringWithFormat:@" 公司:%@",self.companyName];
    [self.view addSubview:companyName];
    
    UILabel *orgName = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, Screen_Width-20, 25)];
    orgName.backgroundColor = BlueColor;
    orgName.text = [NSString stringWithFormat:@" 部门:%@",self.orgName];
    [self.view addSubview:orgName];
    
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
    
    [self.view addSubview:method];
    
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
            
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 3, Screen_Width-20, 40)];
            phoneNumber.tag = 1001;
            //phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            //phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            phoneNumber.placeholder = @"输入姓名";
            [cell addSubview:phoneNumber];
        
        
            return cell;
        }
        case 1:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            leftViewLb.text = @"手机";
            
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Screen_Width-20, 40)];
            phoneNumber.secureTextEntry = YES;
            phoneNumber.tag = 1002;
            //phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            //phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
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
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            if ([checkWay isEqual:NEED_QUESTION]) {
                leftViewLb.text = @"问题";
                phoneNumber.text = [[self.orgPropsArray objectAtIndex:3]objectForKey:@"propValue"];
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
            phoneNumber.secureTextEntry = YES;
            phoneNumber.tag = 1004;
            phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
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

#pragma mark - UITextDelegate
//#pragma mark -- UITextFiledDelegate
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    _baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
//    _baseView.contentSize = self.view.frame.size;
//    //self.view.frame = CGRectMake(0, -80, Screen_Width, Screen_Height-70);
//}

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
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-35);
    }];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
