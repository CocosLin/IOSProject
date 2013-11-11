//
//  AddCommentVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-8.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "AddCommentVC.h"
#import "HBServerKit.h"
#import "SVProgressHUD.h"

@interface AddCommentVC ()

@end

@implementation AddCommentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"点评";
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
    [backItem release];
 
    
    
    DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(0, 40, Screen_Width, 70) andStars:5 isFractional:YES];
    customNumberOfStars.delegate = self;
	customNumberOfStars.backgroundColor = [UIColor groupTableViewBackgroundColor];
	customNumberOfStars.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	customNumberOfStars.rating = 0.0;
	[self.view addSubview:customNumberOfStars];
    [customNumberOfStars release];

    self.stars = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    self.stars.textAlignment = NSTextAlignmentCenter;
    self.stars.backgroundColor = [UIColor clearColor];
    self.stars.textColor = [UIColor blueColor];
    self.stars.text = @"0";
    [self.view addSubview:self.stars];
    
    self.commentView = [[UITextView alloc]initWithFrame: CGRectMake(10, 85, Screen_Width-20, 80)];
    self.commentView.delegate = self;
    [self.view addSubview: self.commentView];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [but1 setTitle:@"提交点评" forState:UIControlStateNormal];
    but1.frame = CGRectMake(10, Screen_Height-110, Screen_Width-20, 42);
    [but1 setBackgroundImage:[[UIImage imageNamed:@"03.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [but1 setBackgroundImage:[[UIImage imageNamed:@"04.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [but1 addTarget: self action:@selector(saveReportComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark -- 提交点评
- (void)saveReportComment{
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    NSString *commentStr = [NSString stringWithFormat:@"%@",self.commentView.text];
    NSString * commentStrEncod = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)commentStr, NULL, NULL,  kCFStringEncodingUTF8 );
    if (self.commentView.text.length >0) {
        [hbKit addCommentWithOrganizationId:self.reportMod.organizationId
                                  OrgunitId:self.reportMod.orgunitId
                                   ReportId:self.reportMod.reportId
                                    Content:commentStrEncod
                                      Score:self.stars.text
                                 CreateUser:comData.userModel.username
                                   Username:self.reportMod.userName];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"评价内容不能为空！" duration:0.6];
    }
    
    [hbKit release];
}

#pragma mark -- 隐藏键盘
- (void)hideKeyBoard{
    [self.commentView resignFirstResponder];
}

#pragma mark Delegate implementation of NIB instatiated DLStarRatingControl

-(void)newRating:(DLStarRatingControl *)control :(float)rating {
	self.stars.text = [NSString stringWithFormat:@"%.1f",rating*2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.stars release];
    [super dealloc];
}
@end
