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

@interface OrganizationNoticVC ()

@end

@implementation OrganizationNoticVC

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
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width-20, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""]; //过滤字符串    
    titleLabel.text = [self.textTitle stringByTrimmingCharactersInSet:set];
    titleLabel.font = [UIFont systemFontOfSize:40.0];
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
    
    //内容
    UITextView *contentText = [[UITextView alloc]initWithFrame:CGRectMake(10, 100, Screen_Width-20, 200)];
    contentText.editable = NO;
    contentText.font = [UIFont systemFontOfSize:18];
    contentText.layer.cornerRadius = 5;
    if (self.content != NULL) {
        contentText.textAlignment = UITextAlignmentLeft;
        contentText.contentMode = UIControlContentVerticalAlignmentCenter;
        CGRect orgRect=contentText.frame;//获取原始UITextView的frame
        CGSize  size = [self.content sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(240, 2000) lineBreakMode:UILineBreakModeWordWrap];
        orgRect.size.height=size.height+10;//获取自适应文本内容高度
        contentText.frame=orgRect;//重设UITextView的frame
        contentText.text=self.content;
        [self.view addSubview:contentText];
        [contentText release];
    }else{
        [SVProgressHUD showErrorWithStatus:@"暂时无通知"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
