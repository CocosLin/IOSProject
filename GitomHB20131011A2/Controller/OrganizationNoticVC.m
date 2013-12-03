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
#import "QueryMessageModel.h"
#import "HBServerKit.h"
#import "WTool.h"
#import "RecordQeryReportsVcCellForios5.h"
#import "DetailQeryViewController.h"

@interface OrganizationNoticVC (){
    NSMutableArray *_urls;
    NSArray *tableArray;
}

@end

@implementation OrganizationNoticVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"公告";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.querMessage == YES) {  //消息
        GetCommonDataModel;
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        [hbKit getNotcFromMemberOrgId:comData.organization.organizationId orgunitId:comData.organization.orgunitId andUserName:comData.userModel.username andBeginTime:@"1279865600000" andFirst:0 andMax:1000 getQueryMessageArray:^(NSArray *messageArray) {
            tableArray = messageArray;
            for (QueryMessageModel *messageMod in messageArray) {
                NSLog(@"Menu meassageMod nst =  /%@ / %@ / %@ / %@ / %@ /%@",messageMod.sender,messageMod.readUser,messageMod.messageId,messageMod.organizationId,messageMod.dtx,messageMod.senderReadname);
                NSLog(@"tableArray.count == %d",tableArray.count);
                massageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-65)];
                massageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                massageTableView.delegate = self;
                massageTableView.dataSource = self;
                [self.view addSubview:massageTableView];
                
            }
        }];
        
    }else{                          //公告
        [self creatNewsView];
    }
}

- (void)creatNewsView{
    NSLog(@"biaoti %@",self.userId);
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width-20, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""]; //过滤字符串
//    titleLabel.text = [self.textTitle stringByTrimmingCharactersInSet:set];
    titleLabel.text = self.textTitle;
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


#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSLog(@"OrganizationNoticVC tableArray.count ==%d",tableArray.count);
    return tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tableArray.count %d",tableArray.count);
    static NSString *CellIdentifier = @"Cell";
    RecordQeryReportsVcCellForios5 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[RecordQeryReportsVcCellForios5 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.removeBut.tag = indexPath.row;
        NSLog(@"OrganizationNoticVC indexPath.row == %d , %d",cell.removeBut.tag,indexPath.row);
    }
    
    QueryMessageModel *messageMod = [[QueryMessageModel alloc]init];
    messageMod = [tableArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",messageMod.senderReadname,messageMod.sender];
    cell.timeLabel.text = [WTool getStrDateTimeWithDateTimeMS:[messageMod.createDate doubleValue] DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
    if ([messageMod.dtx isEqualToString:@"report"]) {
        cell.addressLabel.text = @"提交了新的汇报";
    }else{
        cell.addressLabel.text = @"新的点评";
    }
    UIImageView *tempBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
    cell.backgroundView = tempBackgroundView;
    [tempBackgroundView release];
    UIImageView *selectedBackgroundView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
    cell.selectedBackgroundView = selectedBackgroundView;
    [selectedBackgroundView release];

    return cell;
}

#pragma mark -- 移除对应通知
- (void)cellButtonClick:(UIButton *)sender{
    GetCommonDataModel;
    NSLog(@"(UIButton *)sender == %d",sender.tag);
    QueryMessageModel *mesMod = [tableArray objectAtIndex:sender.tag];
    
    //移除对应通知
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit setMsgReadStatusOrgId:[mesMod.organizationId integerValue]orgunitId:[mesMod.orgunitId integerValue] andMessageId:mesMod.messageId andUsername:comData.userModel.username];
    
    //刷新界面
    [hbKit getNotcFromMemberOrgId:comData.organization.organizationId orgunitId:comData.organization.orgunitId andUserName:comData.userModel.username andBeginTime:@"1279865600000" andFirst:0 andMax:10 getQueryMessageArray:^(NSArray *messageArray) {
        tableArray = messageArray;
        [massageTableView reloadData];
    }];
    [hbKit release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" indexPath.row == %d",indexPath.row);
    QueryMessageModel *messageMod = [[QueryMessageModel alloc]init];
    messageMod = [tableArray objectAtIndex:indexPath.row];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit findReportWithOrganizationId:[messageMod.organizationId integerValue] OrgunitId:[messageMod.orgunitId integerValue] andReportId:messageMod.extend getReportMod:^(ReportModel *reportMod) {
        DetailQeryViewController *detailQeryView = [[DetailQeryViewController alloc]init];
        detailQeryView.reportModel = reportMod;
        [self.navigationController pushViewController:detailQeryView animated:YES];
        [detailQeryView release];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
