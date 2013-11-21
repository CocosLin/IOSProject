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
#import "UIImageView+WebCache.h"


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
/*
#pragma mark - 刷新
- (void)refreshAction{
    NSLog(@"refreshAction - 刷新");
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    [hbKit findReportsWithOrganizationId:comData.organization.organizationId Refresh:YES GotArrReports:^(NSArray *arrDicReports, WError *myError) {
        if (arrDicReports.count) {
            NSLog(@"ReportManager 数组循环次数 ==  %d",arrDicReports.count);
            NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
            for (NSDictionary * dicReports in arrDicReports)
            {
                NSLog(@"444ReportManager 获得数据内容 == %@",dicReports);
                
                NSLog(@"444name == %@",[dicReports objectForKey:@"name"]);
                OrganizationsModel *orgIfo = [[OrganizationsModel alloc]init];
                orgIfo.organizationName = [dicReports objectForKey:@"name"];
                orgIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                orgIfo.organizationId = [dicReports objectForKey:@"organizationId"];
                [mArrReports addObject:orgIfo];
            }
            self.orgArray = mArrReports;
            [self.manageTableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"无部门"];
        }
    }];
    
    
    
}

*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"biaoti %@",self.userId);
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
        
        NSString *realStr = [NSString stringWithFormat:@"来源：%@（%@）",[self.realName stringByTrimmingCharactersInSet:set],self.userId];
        NSLog(@"OrganizationNoticVC 来源：%@",realStr);
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
        imgView.frame = CGRectMake(10, 100, Screen_Width-20, 160);
        [imgView setImageURL:[NSURL URLWithString:imgUrlStr] placeholder:[UIImage imageNamed:@"icon_image_load_ing.png"]];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.layer.borderWidth = 0.8;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imgView];
        [_urls addObject:imgUrlStr];
        for (int i = 0; i<1; i++) {
            NSLog(@"下载图片2");
            // 事件监听
            imgView.tag = 1000+i;
            NSLog(@"imageView.tag == %d",imgView.tag);
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            // 内容模式
            imgView.clipsToBounds = YES;
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
}

#pragma mark -- 放大图片
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = 1;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<1; i++) {
        NSLog(@"替换为中等尺寸图片");
        NSString *url = [_urls objectAtIndex:0];
        NSLog(@"url == %@",url);
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 图片路径
        photo.url = [NSURL URLWithString:url]; 
        UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1000+i];
        // 来源于哪个UIImageView
        photo.srcImageView = imgView; 
        [photos addObject:photo];
    }
    NSLog(@"显示相册");
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时显示的第一张图片是？
    browser.currentPhotoIndex = 0;
    // 设置所有的图片
    browser.photos = photos; 
    [browser show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
