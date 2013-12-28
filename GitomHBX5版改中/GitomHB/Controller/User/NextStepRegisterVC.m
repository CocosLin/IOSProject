//
//  NextStepRegisterVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-4.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "NextStepRegisterVC.h"
#import "SVProgressHUD.h"
#import "HBServerKit.h"

@interface NextStepRegisterVC ()

@end

@implementation NextStepRegisterVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
 
    
	_baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 286)];
    _baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_baseView];
    
    UITableView *registerTableV = [[UITableView alloc]initWithFrame:CGRectMake(10, 15, Screen_Width-20, 130) style:UITableViewStylePlain];
    [registerTableV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    registerTableV.dataSource = self;
    registerTableV.scrollEnabled = NO;
    registerTableV.layer.borderWidth = 0.7;
    registerTableV.layer.cornerRadius = 7;
    [self.view addSubview:registerTableV];
    
    [self creatRegisterButton];
    
}
#pragma mark - 注册 13328786791 111111 858273
- (void)registerAction{
    UITextField *text1 = (UITextField*)[self.view viewWithTag:1001];
    UITextField *text2 = (UITextField*)[self.view viewWithTag:1002];
    UITextField *text3 = (UITextField*)[self.view viewWithTag:1003];
    if (![text2.text isEqualToString:text3.text]) {
        NSLog(@"text2 3 == %@,%@",text2.text,text3.text);
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
    }else if(text2.text.length<6){
        [SVProgressHUD showErrorWithStatus:@"密码不能少于6位" duration:0.45];
    }
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    BOOL success = [hbKit registerRealWithPhoneNumber:self.phoneNumber andSmscode:text1.text andPassword:text2.text];
    [self tpeToDismissAction];
    if (success) [self.navigationController popToRootViewControllerAnimated:NO];
 
}
- (void)creatRegisterButton{
    UIButton * btnVerificationcode = [UIButton buttonWithType:UIButtonTypeCustom];
    UIColor *color = [UIColor colorWithRed:(208/255.0) green:(208/255.0) blue:(208/255.0) alpha:1];
    [btnVerificationcode setBackgroundImage:[[UIImage imageNamed:@"btn_group_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btnVerificationcode setTitle:@"注册" forState:UIControlStateNormal];
    [btnVerificationcode setBackgroundImage:[[UIImage imageNamed:@"btn_group_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    btnVerificationcode.frame = CGRectMake(10, 155, Screen_Width-20, 40);
    [btnVerificationcode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnVerificationcode.titleLabel setFont:[UIFont systemFontOfSize:13]];
    btnVerificationcode.layer.borderColor = color.CGColor;
    btnVerificationcode.layer.borderWidth = 1.0;
    [self.view addSubview:btnVerificationcode];
    [btnVerificationcode addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - UITextFiledDelegat 
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
    _baseView.contentSize = self.view.frame.size;
    
}

#pragma mark - UITableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
            leftViewLb.text = @"验证";
            
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 3, Screen_Width-20, 40)];
            phoneNumber.tag = 1001;
            phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            //phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            phoneNumber.placeholder = @"请输入短信验证码";
            [cell addSubview:phoneNumber];
      
            return cell;
        }
        case 1:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            leftViewLb.text = @"密码";
            
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Screen_Width-20, 40)];
            phoneNumber.secureTextEntry = YES;
            phoneNumber.tag = 1002;
            phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            //phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            phoneNumber.placeholder = @"输入密码";
            [cell addSubview:phoneNumber];
      
            return cell;
        }
            break;
        case 2:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            leftViewLb.text = @"确认";
            
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Screen_Width-20, 40)];
            phoneNumber.secureTextEntry = YES;
            phoneNumber.tag = 1003;
            phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            //phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            phoneNumber.placeholder = @"密码确认";
            [cell addSubview:phoneNumber];
            return cell;
        }
    }
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 点击任意位置收起键盘
- (void)tpeToDismissAction{
    UITextField *text1 = (UITextField*)[self.view viewWithTag:1001];
    UITextField *text2 = (UITextField*)[self.view viewWithTag:1002];
    UITextField *text3 = (UITextField*)[self.view viewWithTag:1003];
    [text1 resignFirstResponder];
    [text2 resignFirstResponder];
    [text3 resignFirstResponder];
    //self.hideKeyBoardView.hidden = YES;
}
@end
