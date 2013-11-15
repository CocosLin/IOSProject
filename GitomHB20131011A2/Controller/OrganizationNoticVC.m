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

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface OrganizationNoticVC (){
    NSMutableArray *_urls;
}

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
        
        [_urls addObject:imgUrlStr];
        //        CGFloat margin = 20;
        //        CGFloat startX = (self.view.frame.size.width - 3 * width - 2 * margin) * 0.5;
        //        CGFloat startY = 50;
        for (int i = 0; i<1; i++) {
            //UIImageView *imageView = [[UIImageView alloc] init];
            //[self.view addSubview:imageView];
            NSLog(@"下载图片0");
            
            //[self.view addSubview:imageView];
            
            // 计算位置
            //int row = i/3;
            //int column = i%3;
            //CGFloat x = 60;
            //CGFloat y = 2;
            //imageView.frame = CGRectMake(x, y, width, height);
            NSLog(@"下载图片1");
            // 下载图片
            //[imageView setImageURLStr:imgString placeholder:placeholder];
            NSLog(@"下载图片2");
            // 事件监听
            imgView.tag = 1000+i;
            NSLog(@"imageView.tag == %d",imgView.tag);
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            //[myCell addSubview:imageView];
            // 内容模式
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
        }
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

#pragma mark -- 放大图片
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = 1;
    NSLog(@"封装图片数据 %@",_urls);
    //NSLog(@"_urls == %@",_urls);
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<1; i++) {
        NSLog(@"替换为中等尺寸图片");
        // 替换为中等尺寸图片
        //NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        NSString *url = [_urls objectAtIndex:0];
        NSLog(@"url == %@",url);
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1000+i];
        photo.srcImageView = imgView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    NSLog(@"显示相册");
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //browser.is
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
