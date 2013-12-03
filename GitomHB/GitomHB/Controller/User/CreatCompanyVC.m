//
//  CreatCompanyVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-7.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "CreatCompanyVC.h"

@interface CreatCompanyVC ()

@end

@implementation CreatCompanyVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"填写公司资料";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBtns];
	_baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 286)];
    _baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_baseView];
    
    //与隐藏键盘相关
    UIView *addToBaseView = [[UIView alloc]initWithFrame:_baseView.frame];
    [_baseView addSubview:addToBaseView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 120, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = @"标题:";
    [addToBaseView addSubview:titleLabel];
    
    self.companyNameText = [[UITextView alloc]initWithFrame:CGRectMake(20, 70, Screen_Width-40, 30)];
    self.companyNameText.delegate = self;
    self.companyNameText.textAlignment = NSTextAlignmentCenter;
    [addToBaseView addSubview:self.companyNameText];
    
    //内容
    UILabel *thanks = [[UILabel alloc]initWithFrame:CGRectMake(20, 126, Screen_Width-45, 30)];
    thanks.userInteractionEnabled = NO;
    thanks.backgroundColor = [UIColor clearColor];
    thanks.text = @"公告内容:";
    thanks.font = [UIFont systemFontOfSize:15.0];
    [addToBaseView addSubview:thanks];
    
    self.regulationText = [[UITextView alloc]initWithFrame:CGRectMake(20, 166, Screen_Width-40, 70)];
    self.regulationText.delegate = self;
    self.regulationText.keyboardType = UIKeyboardTypeTwitter;
    [addToBaseView addSubview:self.regulationText];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(tpeToDismissAction)];
    [addToBaseView addGestureRecognizer:tap];
}

- (void)initNavigationBtns{
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
    [rightbtn addTarget:self action:@selector(creatCompanyAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
 
}

- (void)creatCompanyAction{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
