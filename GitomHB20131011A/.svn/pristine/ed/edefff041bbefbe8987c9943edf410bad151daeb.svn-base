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
    UILabel *realNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, Screen_Width-20, 30)];
    realNameLabel.backgroundColor = [UIColor clearColor];
    realNameLabel.textColor = [UIColor grayColor];
    if (self.realName != NULL) {
        
        NSString *realStr = [NSString stringWithFormat:@"来源：%@（%ld）",[self.realName stringByTrimmingCharactersInSet:set],(long)self.userId];
        realNameLabel.text = realStr;
        [self.view addSubview:realNameLabel];
        }
    //内容
    UITextView *contentText = [[UITextView alloc]initWithFrame:CGRectMake(10, 100, Screen_Width-20, 200)];
    contentText.layer.cornerRadius = 10;
    if (self.content != NULL) {
        NSString *contentStr = [self.content stringByTrimmingCharactersInSet:set];
        
        NSString *cutStr = [contentStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        contentText.text = cutStr;
        //contentText.text = [[self.content stringByTrimmingCharactersInSet:set] stringByReplacingOccurrencesOfString:@"/n" withString:@""];
        [self.view addSubview:contentText];
        [contentText release];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
