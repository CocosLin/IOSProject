//
//  OrganizationNoticVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-18.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "OrganizationNoticVC.h"
#import "ShowNoticView.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "ASIHTTPRequest.h"

@interface OrganizationNoticVC ()

@end

@implementation OrganizationNoticVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"公告";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"biaoti");
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width-20, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""]; //过滤字符串    
    titleLabel.text = [self.textTitle stringByTrimmingCharactersInSet:set];
    titleLabel.font = [UIFont systemFontOfSize:30.0];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    //来源
    UILabel *realNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, Screen_Width-20, 30)];
    realNameLabel.font = [UIFont systemFontOfSize:14];
    realNameLabel.backgroundColor = [UIColor clearColor];
    realNameLabel.textColor = [UIColor grayColor];
    if (self.realName != NULL) {
        
        NSString *realStr = [NSString stringWithFormat:@"来源：%@（%ld）",[self.realName stringByTrimmingCharactersInSet:set],(long)self.userId];
        realNameLabel.text = realStr;
        
        [self.view addSubview:realNameLabel];
        }
    //发布时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, Screen_Width-20, 30)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor grayColor];
    if (self.creatDate != NULL) {
        
        NSString *realStr = [NSString stringWithFormat:@"时间：%@",self.creatDate];
        timeLabel.text = realStr;
        [self.view addSubview:timeLabel];
    }
    
    
    NSArray *separatImgAndStr = [self.content componentsSeparatedByString:@"\n[附加图片]"];
    NSString *contentStr = [separatImgAndStr objectAtIndex:0];
    NSString *imgUrlStr = [[[NSString alloc]init]autorelease];
    if (separatImgAndStr.count>1) {
     imgUrlStr = [separatImgAndStr objectAtIndex:1];
    }
    NSLog(@"imgUrlStr == %@",imgUrlStr);
    //图片
    UIImageView *imgView = [[UIImageView alloc]init];
    if (imgUrlStr.length >1) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, Screen_Width-20, 160)];
        imgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_image_load_ing.png"]];
        NSURL *imgurl = [NSURL URLWithString:imgUrlStr];
        ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:imgurl];
        [req setCompletionBlock:^{
            imgView.image = [UIImage imageWithData:[req responseData]];
            imgView.backgroundColor = [UIColor clearColor];
            imgView.layer.borderWidth = 0.8;
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imgView];
        }];
        [req startAsynchronous];
    }
    
    
    //内容
    UITextView *contentText = [[UITextView alloc]initWithFrame:CGRectMake(10, imgView.frame.size.height+105, Screen_Width-20, 200)];
    contentText.editable = NO;
    contentText.font = [UIFont systemFontOfSize:18];
    contentText.layer.cornerRadius = 5;
    if (contentStr != NULL) {
        contentText.textAlignment = UITextAlignmentLeft;
        contentText.contentMode = UIControlContentVerticalAlignmentCenter;
        CGRect orgRect=contentText.frame;//获取原始UITextView的frame
        CGSize  size = [contentStr sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(240, 2000) lineBreakMode:UILineBreakModeWordWrap];
        orgRect.size.height=size.height+10;//获取自适应文本内容高度
        contentText.frame=orgRect;//重设UITextView的frame
        
        contentText.text=contentStr;
        [self.view addSubview:contentText];
        [contentText release];
    }else{
        [SVProgressHUD showErrorWithStatus:@"暂时无通知"];
    }
    
    
    [imgView release];
    //[imgUrlStr release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
