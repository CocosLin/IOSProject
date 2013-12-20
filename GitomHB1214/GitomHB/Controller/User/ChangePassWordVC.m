//
//  ChangePassWordVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-21.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ChangePassWordVC.h"
#import "HBServerKit.h"
#import "SVProgressHUD.h"
#import "NSString+MD5.h"

@interface ChangePassWordVC ()

@end

@implementation ChangePassWordVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"修改密码";
    }
    return self;
}


- (void)btnSavePassWord:(id)sender{
    
    UITextField *ft1 = (UITextField *)[self.view viewWithTag:2000];
    UITextField *ft2 = (UITextField *)[self.view viewWithTag:2001];
    UITextField *ft3 = (UITextField *)[self.view viewWithTag:2002];
    UITextField *ft4 = (UITextField *)[self.view viewWithTag:2003];
    NSLog(@"ft3,ft4 == %@ %@",ft3.text,ft4.text);
    if (ft1.text.length == 0|ft2.text.length == 0|ft3.text.length == 0|ft4.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写内容"];
        return;
    }
    if (![ft3.text isEqualToString:ft4.text] ) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit changePassWordWithName:ft1.text andOldPwd:[ft2.text MD5Hash] andNewPwd:[ft3.text MD5Hash]];
   
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //退出按钮
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
   
    
    //确定
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setTitle:@"确定" forState:UIControlStateNormal];
    [rbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rbtn.frame = CGRectMake(0, 0, 50, 44);
    [rbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    // 高亮
    [rbtn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [rbtn addTarget:self action:@selector(btnSavePassWord:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rbtn];
    self.navigationItem.rightBarButtonItem = rbarButtonItem;
  
    
    NSArray *textNameAr = @[@" 帐号",@" 原密码",@" 新密码",@" 新密码"];
    NSArray *placeholderAr = @[@"请输入帐号",@"输入原来密码",@"输入密码",@"再次输入新密码"];
    for (int i = 0; i<4; i++) {
        //修改
        UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
        leftViewLb.font = [UIFont systemFontOfSize:13];
        leftViewLb.tag = 1000+i;
        [leftViewLb setBackgroundColor:[UIColor clearColor]];
        leftViewLb.textColor = [UIColor blackColor];
        leftViewLb.text = [textNameAr objectAtIndex:i];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10+40*i, Screen_Width-20, 30)];
        if (i>0) {
            textField.secureTextEntry = YES;
        }
        textField.font= [UIFont systemFontOfSize:13];
        textField.delegate = self;
        textField.tag = 2000+i;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.leftView = leftViewLb;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.placeholder = [placeholderAr objectAtIndex:i];
        [self.view addSubview:textField];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiedKeyBoard)];
    [self.view addGestureRecognizer:tap];
}

- (void)hiedKeyBoard{
    UITextField *ft1 = (UITextField *)[self.view viewWithTag:2000];
    [ft1 resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
