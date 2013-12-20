//
//  registerVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-4.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "registerVC.h"
#import "HBServerKit.h"
#import "NextStepRegisterVC.h"
#import "SVProgressHUD.h"

#define NUMBERS @"0123456789\n"
@interface registerVC ()

@end

@implementation registerVC
//@synthesize phoneNumber;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"注册帐号";
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
  
    
    
    UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftViewLb setBackgroundColor:[UIColor clearColor]];
    leftViewLb.textColor = [UIColor grayColor];
    leftViewLb.text = @"手机";
    //leftViewLb.image = [UIImage imageNamed:@"user_control_msg.png"];
	self.phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 30, Screen_Width-20, 40)];
    self.phoneNumber.delegate = self;
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneNumber.leftView = leftViewLb;
    self.phoneNumber.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumber.placeholder = @"请输入11位手机号码";
    [self.view addSubview:self.phoneNumber];
    //[self.phoneNumber release];
    
    
    [self creatVerificationcodeButton];
    [self creatPushNextViewButton];
    
    UITapGestureRecognizer *tapHideKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tpeToDismissAction)];
    [self.view addGestureRecognizer:tapHideKeyBoard];
}

- (void)getMsmAction{
    NSLog(@"获得验证码");
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit registerWithPhoneNumber:self.phoneNumber.text];
    [self tpeToDismissAction];
}

- (void)creatVerificationcodeButton{
    UIButton * btnVerificationcode = [UIButton buttonWithType:UIButtonTypeCustom];
    UIColor *color = [UIColor colorWithRed:(208/255.0) green:(208/255.0) blue:(208/255.0) alpha:1];
    [btnVerificationcode setBackgroundImage:[[UIImage imageNamed:@"btn_group_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btnVerificationcode setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [btnVerificationcode setBackgroundImage:[[UIImage imageNamed:@"btn_group_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    btnVerificationcode.frame = CGRectMake(10, 75, Screen_Width/2+10, 40);
    [btnVerificationcode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnVerificationcode.titleLabel setFont:[UIFont systemFontOfSize:13]];
    btnVerificationcode.layer.borderColor = color.CGColor;
    btnVerificationcode.layer.borderWidth = 1.0;
    [self.view addSubview:btnVerificationcode];
    [btnVerificationcode addTarget:self action:@selector(getMsmAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)nextStepAction{
    NSString *resultStr = self.phoneNumber.text;
    NSLog(@"已经有%d位数验证码",resultStr.length);
    if (resultStr.length<11) {
        [SVProgressHUD showErrorWithStatus:@"请填写手机号"];
    }else{
        NextStepRegisterVC *nextVC = [[NextStepRegisterVC alloc]init];
        nextVC.phoneNumber = self.phoneNumber.text;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    
}

- (void)creatPushNextViewButton{
    UIButton * btnVerificationcode = [UIButton buttonWithType:UIButtonTypeCustom];
    UIColor *color = [UIColor colorWithRed:(208/255.0) green:(208/255.0) blue:(208/255.0) alpha:1];
    [btnVerificationcode setBackgroundImage:[[UIImage imageNamed:@"btn_group_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btnVerificationcode setTitle:@"已有验证码" forState:UIControlStateNormal];
    [btnVerificationcode setBackgroundImage:[[UIImage imageNamed:@"btn_group_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    btnVerificationcode.frame = CGRectMake(Screen_Width/2+30, 75, Screen_Width/2-40, 40);
    [btnVerificationcode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnVerificationcode.titleLabel setFont:[UIFont systemFontOfSize:13]];
    btnVerificationcode.layer.borderColor = color.CGColor;
    btnVerificationcode.layer.borderWidth = 1.0;
    [self.view addSubview:btnVerificationcode];
    [btnVerificationcode addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- UITextFiled delegate 只能输入数字
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSCharacterSet *cs;
//    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
//    BOOL canChange = [string isEqualToString:filtered];
//    if (range.location >= 11)return NO;
//    return canChange;
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    if (range.location >= 11)return NO;
    return canChange;
    
}

#pragma mark -- 点击任意位置收起键盘
- (void)tpeToDismissAction{
    [self.phoneNumber resignFirstResponder];
    //self.hideKeyBoardView.hidden = YES;
}
@end
