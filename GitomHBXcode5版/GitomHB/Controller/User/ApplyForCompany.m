//
//  ApplyForCompany.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ApplyForCompany.h"
#import "SearchComanyVC.h"
#import "SVProgressHUD.h"

@interface ApplyForCompany ()

@end

@implementation ApplyForCompany

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"请绑定公司";
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
 
    
    [self creatTextAndButtonView];
}
#pragma mark -- 申请加入公司
- (void)applyJoin{
    NSLog(@"join");
    SearchComanyVC *searchCompany = [[SearchComanyVC alloc]init];
    [self.navigationController pushViewController:searchCompany animated:YES];
 
}
#pragma mark -- 创建公司
- (void)applyCreatCompany{
    [SVProgressHUD showErrorWithStatus:@"抱歉该版本暂未提供在线创建公司服务，请联系代理商为您办理，谢谢" duration:1.1];
}
- (void)creatTextAndButtonView{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-120)];
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:15];
    textView.editable = NO;
    textView.text = @"您尚未绑定公司，无法进入移动汇报\n出现此情况有可能是：\n1、未申请加入公司\n2、加入公司申请未通过\n3、被管理员从公司中移除\n\n申请加入公司：根据每个公司设置的加入验证方式，有的公司可以直接加入，有的需要验证信息等\n\n创建公司：需要先填写企业地址，让话付费购买创建权限，再填写公司资料进行创建";
    [self.view addSubview:textView];
 
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [but1 setTitle:@"申请加入公司" forState:UIControlStateNormal];
    but1.frame = CGRectMake(5, Screen_Height-114, Screen_Width/2-5, 50);
    [but1 setBackgroundImage:[[UIImage imageNamed:@"03.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [but1 setBackgroundImage:[[UIImage imageNamed:@"04.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [but1 addTarget: self action:@selector(applyJoin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
    
    
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [but2 setTitle:@"创建公司" forState:UIControlStateNormal];
    but2.frame = CGRectMake(Screen_Width/2, Screen_Height-114, Screen_Width/2-5, 50);
    [but2 setBackgroundImage:[[UIImage imageNamed:@"03.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [but2 setBackgroundImage:[[UIImage imageNamed:@"04.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [but2 addTarget: self action:@selector(applyCreatCompany) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
