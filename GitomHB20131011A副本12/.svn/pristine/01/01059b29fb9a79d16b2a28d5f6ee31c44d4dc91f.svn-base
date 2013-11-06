//
//  MobileReportVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "MobileReportVC.h"
#import "WCommonMacroDefine.h"
#import "WTool.h"
#import <QuartzCore/QuartzCore.h>
#import "AttendanceVC.h"
#import "ReportVC.h"
#import "AttendanceManager.h"
#import "WTool.h"
@class ReportManager;
typedef NS_ENUM(NSInteger, TagFlag)
{
    TagFlag_TvbConfigInfo = 101,
    TagFlag_TvbMenuReport = 102
    
};
@interface MobileReportVC ()
{
    UILabel * _lblServerTime;
    NSArray * _arrLblWorktime;
    UIImageView * _imgViewConfigBg;
    UITableView * _tvbWorktimeShow;
    UITableView * _tvbMenuReport;
    UIImage * _imgWorkTime;
}
@end

@implementation MobileReportVC

#pragma mark -
-(void)initConfigInfo
{
    //    UIView * viewConfigInfo = [[UIView alloc]initWithFrame:CGRectMake(10, 10,Width_Screen - 20 , 180)];
    _imgViewConfigBg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10,Width_Screen - 20 , 180)];
    _imgViewConfigBg.image = [UIImage imageNamed:@"staff_main_bg"];
    [self.view addSubview:_imgViewConfigBg];
    
    UILabel * lblServerTimePro = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    [_imgViewConfigBg addSubview:lblServerTimePro];
    [lblServerTimePro setText:@"服务器时间"];
    [lblServerTimePro setTextColor:[UIColor whiteColor]];
    [lblServerTimePro setFont:[UIFont systemFontOfSize:13]];
    [lblServerTimePro setBackgroundColor:[UIColor  clearColor]];
    [lblServerTimePro release];
    
    _lblServerTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 280, 40)];
    NSDate *getTime = [NSDate date];
    NSDateFormatter *dateForma = [[NSDateFormatter alloc]init];
    [dateForma setDateFormat:@"HH:mm"];
    NSString *nowTime = [dateForma stringFromDate:getTime];
    _lblServerTime.text = nowTime;
    [_lblServerTime setFont:[UIFont systemFontOfSize:34]];
    [_lblServerTime setBackgroundColor:[UIColor clearColor]];
    [_lblServerTime setTextColor:[UIColor whiteColor]];
    [_lblServerTime setHighlighted:YES];
    _lblServerTime.textAlignment = NSTextAlignmentLeft;
    [_imgViewConfigBg addSubview:_lblServerTime];
    [_lblServerTime release];
    
}
-(void)initViewWorkTime
{
    CGRect rImgViewConfigBG = _imgViewConfigBg.frame;
    _tvbWorktimeShow = [[UITableView alloc]initWithFrame:CGRectMake(10, 90, rImgViewConfigBG.size.width - 20, 180 - 90 - 10)];
    _tvbWorktimeShow.tag = TagFlag_TvbConfigInfo;
    [_imgViewConfigBg addSubview:_tvbWorktimeShow];
    [_tvbWorktimeShow setScrollEnabled:NO];
    [_tvbWorktimeShow setSeparatorColor:[UIColor clearColor]];
    [_tvbWorktimeShow setDelegate:self];
    [_tvbWorktimeShow setDataSource:self];
    [_tvbWorktimeShow setBackgroundColor:[UIColor clearColor]];
}
-(void)initViewMenu
{
    _tvbMenuReport = [[UITableView alloc]initWithFrame:CGRectMake(10, 200, Width_Screen - 20, Height_Screen - 200 - 20 - 49)];
    [self.view addSubview:_tvbMenuReport];
    [_tvbMenuReport setTag:TagFlag_TvbMenuReport];
    [_tvbMenuReport setBackgroundColor:[UIColor whiteColor]];
    [_tvbMenuReport.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [_tvbMenuReport.layer setBorderWidth:0.3];
    [_tvbMenuReport.layer setCornerRadius:7];
    [_tvbMenuReport setScrollEnabled:YES];
    [_tvbMenuReport setDataSource:self];
    [_tvbMenuReport setDelegate:self];
}

#pragma mark - 表格代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * myCell = nil;
    if (tableView.tag  == TagFlag_TvbConfigInfo) {
        static NSString * sCellId = @"sCellID";
        NSLog(@"breakOne");
        //myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sCellId];
        myCell = [tableView dequeueReusableCellWithIdentifier:sCellId];
        if (!myCell) {
            myCell = [[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:sCellId]autorelease];
        }
        myCell.textLabel.text = self.arrStrWorkTime[indexPath.row];
        [myCell.textLabel setFont:[UIFont systemFontOfSize:18 - self.arrStrWorkTime.count * 1]];
        myCell.textLabel.textColor = [UIColor whiteColor];
        myCell.imageView.image = _imgWorkTime;
    }else if(TagFlag_TvbMenuReport == tableView.tag)
    {
        NSArray * arrStrMenu = [NSArray arrayWithObjects:@"上班打卡",@"下班打卡",@"工作汇报",@"外出汇报",@"出差汇报",nil];
        NSArray * arrImgNameMenu = [NSArray arrayWithObjects:@"icon_staff_addendance_on.png",@"icon_staff_addendance_off.png",@"icon_staff_report_work.png",@"icon_staff_report_goout.png",@"icon_staff_report_business.png",nil];
        static NSString * sCellId2 = @"sCellID2";
        NSLog(@"breakOne");
        //myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sCellId2];
        myCell = [tableView dequeueReusableCellWithIdentifier:sCellId2];
        if (!myCell) {
            myCell = [[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:sCellId2]autorelease];
        }
        myCell.textLabel.text =arrStrMenu[indexPath.row];
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [myCell.textLabel setFont:[UIFont systemFontOfSize:14]];
        myCell.textLabel.textColor = [UIColor blackColor];
        myCell.imageView.image = [UIImage imageNamed:arrImgNameMenu[indexPath.row]];
    }
    
    return myCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView.tag == TagFlag_TvbConfigInfo) {
        count =  self.arrStrWorkTime.count;
    }else if(tableView.tag == TagFlag_TvbMenuReport)
    {
        count = 5;
    }
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat count = 0;
    if (tableView.tag == TagFlag_TvbConfigInfo) {
        count =  _tvbWorktimeShow.frame.size.height / self.arrStrWorkTime.count;
    }else if(tableView.tag == TagFlag_TvbMenuReport)
    {
        count = _tvbMenuReport.frame.size.height / 5;
    }
    return count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 || indexPath.row == 1) {
        //打卡
        
        
        GetCommonDataModel;
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        [hbKit getAttendanceConfigWithOrganizationId:comData.organization.organizationId orgunitId:comData.organization.orgunitId GotDicReports:^(NSDictionary *dicAttenConfig) {
            AttendanceVC * avc = [[AttendanceVC alloc]init];
            if (indexPath.row == 0) {
                avc.isAttenWork = YES;
            }else if (indexPath.row == 1) {
                avc.isAttenWork = NO;
            }
            NSLog(@"打卡距离 == %@",[[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"distance"]);
            NSString *distanceStr = [[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"distance"];
            //avc.rangeAtten2Org = [distanceStr longLongValue];
            avc.rangeAtten2Org = [distanceStr longLongValue];
            avc.companyLongitude = [[[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"longitude"] floatValue];
            avc.companyLatitude = [[[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"latitude"] floatValue];
            NSLog(@"公司 经纬：%f，%f  要求打卡距离：%lld",avc.companyLongitude,avc.companyLatitude,[distanceStr longLongValue]);
            
            [self.navigationController pushViewController:avc animated:YES];
            [avc release];
            [hbKit release];
        }];
        
       
    }else
    {
        //汇报
        ReportVC * rvc = [[ReportVC alloc]initWithNibName:@"ReportVC" bundle:nil];
        rvc.intReportType = indexPath.row - 1;
        [self.navigationController pushViewController:rvc animated:YES];
        [rvc release];
    }
    
}

#pragma mark - 属性控制
//-(void)setServerTimeMS:(long long)serverTimeMS
//{
//    _serverTimeMS = serverTimeMS;
//    //    NSDate * dateServer = [NSDate dateWithTimeIntervalSince1970:serverTimeMS/1000];
//    NSString * strDate = [WTool getStrDateTimeWithDateTimeMS:serverTimeMS DateTimeStyle:@"HH:mm"];
//    _lblServerTime.text = strDate;
//}

#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"移动汇报";
        [self initData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self initConfigInfo];
    [self initViewMenu];
    GetCommonDataModel;
    self.serverTimeMS = comData.serverDate;
    self.arrStrWorkTime = @[@"09:00 - 12:00",@"14:00 - 18:00",@"19:00 - 22:00"];
    
    [self initViewWorkTime];

    NSMutableArray * arrDic = [NSMutableArray arrayWithCapacity:3];
    
    [[AttendanceManager sharedAttendanceManager] getAttendanceConfigWithOrganizationID:comData.organization.organizationId OrgunitID:comData.organization.orgunitId GotAttenConfig:^(AttendanceConfigModel * attenConfig)
    {
        comData.arrDicWorkTime = attenConfig.attenWorktimes;
        comData.dicAttenConfig = attenConfig.attenConfig;
        NSArray * arrDicWorkTime = attenConfig.attenWorktimes;
        for (NSDictionary * dicWorkTime in arrDicWorkTime) {
            AttendanceWorktimeModel * worktime = [[[AttendanceWorktimeModel alloc]initForAllJsonDataTypeWithDicFromJson:dicWorkTime]autorelease];
            [arrDic addObject:[NSString stringWithFormat:@"%@ - %@",[WTool getStrDateTimeWithDateTimeMS:worktime.onTime DateTimeStyle:@"HH:mm"],[WTool getStrDateTimeWithDateTimeMS:worktime.offTime DateTimeStyle:@"HH:mm"]]];
            self.arrStrWorkTime = arrDic;
            [_tvbWorktimeShow reloadData];
        }
    }];
    
}

-(void)initData
{
    _imgWorkTime = [UIImage imageNamed:@"icon_staff_clock"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_tvbMenuReport reloadData];
    [_tvbWorktimeShow reloadData];
    [super dealloc];
}

@end
