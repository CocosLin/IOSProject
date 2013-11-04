//
//  RecordListVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "RecordListVC.h"
#import "WCommonMacroDefine.h"
#import "ReportManager.h"
#import "ReportModel.h"
#import "WTool.h"
#import "DetailRecordVC.h"
//#define TypeReport_GoOut @"REPORT_TYPE_GO_OUT"// 外出汇报
//#define TypeReport_Travel @"REPORT_TYPE_TRAVEL"// 出差汇报
//#define TypeReport_Work @"REPORT_TYPE_DAY_REPORT"// 工作汇报
//#define TypeReport_ALL @"REPORT_TYPE_ALL"// 所有汇报 (暂时没用)

@interface RecordListVC ()
{
    NSString * _strRecordType;
    NSString * _strTimeInfoStart;
    NSString * _strTimeInfoEnd;
    NSArray * _arrMenuRecordNames;
    UILabel * _lblRecordPromptUserInfo;
    UILabel * _lblRecordPromptTimeInfo;
    UITableView * _tvbRecordInfo;
    NSArray * _arrTypeReport;
}
@end

@implementation RecordListVC
-(id)initWithRecordType:(NSInteger)typeRecord
               Username:(NSString *)username
           UserRealname:(NSString *)userRealname
{
    if (self = [super init]) {
        [self initData];
        self.typeRecord = typeRecord;
        self.username = username;
        self.userRealname = userRealname;
    }return self;
}
-(void)initData
{
    _strRecordType = @"记录";
    _arrTypeReport = @[TypeReport_Work,TypeReport_GoOut,TypeReport_Travel,TypeReport_ALL];
}
#pragma mark - 表格代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"RecordListVC tableView 含有的数据内容是 == %@",self.arrData);
    return self.arrData.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell * myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    if (!myCell) {
        myCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID]autorelease];
    }
    [myCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    ReportModel * reModel = (ReportModel *)[self.arrData objectAtIndex:indexPath.row];
    myCell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",self.userRealname,self.username];
    [myCell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    myCell.textLabel.textColor = [UIColor blackColor];
//    NSLog(@"%lli",reModel.updateDate);
    //myCell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",[WTool getStrDateTimeWithDateTimeMS:reModel.updateDate DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"],[reModel address]];
    myCell.detailTextLabel.textColor = [UIColor grayColor];
    [myCell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    [myCell.detailTextLabel setNumberOfLines:3];
    [myCell.detailTextLabel setLineBreakMode:NSLineBreakByCharWrapping];
    return myCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailRecordVC * dvc = [[DetailRecordVC alloc]init];//WithNibName:@"DetailRecordVC_Iphone" bundle:nil];
    dvc.username = self.username;
    dvc.realname = self.userRealname;
    GetCommonDataModel;
    dvc.phone =comData.userModel.telephone;
    dvc.reportModel = [self.arrData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [dvc release];
}

#pragma mark - UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDateComponents * componets = [WTool getDateComponentsWithDate:[NSDate date]];
    switch (buttonIndex)//:@"今天",@"这周内",@"这个月内",@"自定义",@"取消"
    {
        case 0://今天
        {
            self.dtBegin = [WTool getBeginDateTimeMsWithNSDate:[NSDate date]];
            self.dtEnd = [WTool getEndDateTimeMsWithNSDate:[NSDate date]];
            break;
        }
        case 1://这周内
        {
            NSLog(@"7天=604 800秒  1天=86 400秒");
            // 7天=604 800秒  1天=86 400秒
            int week = [componets weekday]-2;
            week = week == -1 ? 6 :week;
            long long int sec = (long long int)(week * 86400000);
            
            self.dtEnd = [WTool getEndDateTimeMsWithNSDate:[NSDate date]];
            self.dtBegin = self.dtEnd - sec;
            
            break;
        }
        case 2://这个月内
        {
             self.dtEnd = [WTool getEndDateTimeMsWithNSDate:[NSDate date]];
             self.dtBegin = self.dtEnd - ((long long int)(componets.day -1)*24*60*60*1000);
             break;
        }
        case 3://自定义
        {
//            UIDatePicker * dp = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
//            [alertView addSubview:dp];
            NSLog(@"RecordListVC 自定义时间还未定");
            return;
            break;
        }
        case 4://取消
        {
            return;
            break;
        }
        default:
            break;
    }
    _lblRecordPromptTimeInfo.text = [NSString stringWithFormat:@"从%@至%@",_strTimeInfoStart,_strTimeInfoEnd];
    if (!self.typeRecord)
    {
        //考勤记录
        
    }else//汇报记录
    {
        //查汇报记录
        NSString * strReportType = [ReportManager getStrTypeReportWithIntReportType:self.typeRecord];
        ReportManager * rm = [ReportManager sharedReportManager];
        GetCommonDataModel;
        
        [rm findReportsWithOrganizationId:comData.organization.organizationId
                                OrgunitId:comData.organization.orgunitId
                                 Username:comData.userModel.username
                               ReportType:strReportType
                             BeginDateLli:self.dtBegin
                               EndDateLli:self.dtEnd
                        FirstReportRecord:0
                          MaxReportRecord:50
                            GotArrReports:^(NSArray *arrReports, BOOL isOk)
         {
             self.arrData = arrReports;
             NSLog(@"RecordListVC tableView 重新获得数据内容是 == %@",self.arrData);
         }];
    }

}

#pragma mark - 用户事件
-(void)btnAction:(UIButton *)btn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"按时间查询"
                                                    message:@"请选择相应的时间"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"今天",@"这周内",@"这个月内",@"自定义",@"取消", nil];
    [alert show];
    [alert release];
}
#pragma mark - 属性控制
-(void)setDtBegin:(long long)dtBegin
{
    _dtBegin = dtBegin;
    NSString * strDate = [WTool getStrDateTimeWithDateTimeMS:dtBegin DateTimeStyle:@"yyyy-MM-dd"];
    NSString * strWeekday = [WTool getStrWeekdayWithNSdate:[NSDate dateWithTimeIntervalSince1970:dtBegin/1000]];
    _strTimeInfoStart = [NSString stringWithFormat:@"%@(%@)",strDate,strWeekday];
}
-(void)setDtEnd:(long long)dtEnd
{
    _dtEnd = dtEnd;
    NSString * strDate = [WTool getStrDateTimeWithDateTimeMS:dtEnd DateTimeStyle:@"yyyy-MM-dd"];
    NSString * strWeekday = [WTool getStrWeekdayWithNSdate:[NSDate dateWithTimeIntervalSince1970:dtEnd/1000]];
    _strTimeInfoEnd = [NSString stringWithFormat:@"%@(%@)",strDate,strWeekday];
//    _lblRecordPromptTimeInfo.text = [NSString stringWithFormat:@"从%@至%@",_strTimeInfoStart,_strTimeInfoEnd];
}
-(void)setTypeRecord:(NSInteger)typeRecord
{
    _typeRecord = typeRecord;
    _strRecordType = [_arrMenuRecordNames objectAtIndex:typeRecord];
    self.title = [NSString stringWithFormat:@"%@查询",_strRecordType];
}

#pragma mark - 视图
//记录提示信息
-(void)initRecordPromptInfo
{
    CGFloat hViewRecordPromptInfo = 40;
    UIView * viewRecordPromptInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, hViewRecordPromptInfo)];
    [viewRecordPromptInfo setBackgroundColor:[UIColor whiteColor]];
    
    _lblRecordPromptUserInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, hViewRecordPromptInfo/2)];
    [viewRecordPromptInfo addSubview:_lblRecordPromptUserInfo];
    _lblRecordPromptUserInfo.textAlignment = NSTextAlignmentCenter;
    _lblRecordPromptUserInfo.textColor = [UIColor blackColor];
    [_lblRecordPromptUserInfo setFont:[UIFont systemFontOfSize:13]];
    _lblRecordPromptUserInfo.text = [NSString stringWithFormat:@"%@的%@",self.userRealname,_strRecordType];
    [_lblRecordPromptUserInfo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewRecordPromptInfo];
    
    _lblRecordPromptTimeInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, hViewRecordPromptInfo/2, Width_Screen, hViewRecordPromptInfo/2)];
    [viewRecordPromptInfo addSubview:_lblRecordPromptTimeInfo];
    _lblRecordPromptTimeInfo.textAlignment = NSTextAlignmentCenter;
    _lblRecordPromptTimeInfo.textColor = [UIColor blackColor];
     [_lblRecordPromptTimeInfo setFont:[UIFont systemFontOfSize:13]];
    _lblRecordPromptTimeInfo.text = [NSString stringWithFormat:@"从%@至%@",_strTimeInfoStart,_strTimeInfoEnd];
    [_lblRecordPromptTimeInfo setBackgroundColor:[UIColor clearColor]];
    
    [viewRecordPromptInfo release];
}
-(void)initRecordInfoTableView
{
    _tvbRecordInfo = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, Width_Screen, Height_Screen-41)];
    [self.view addSubview:_tvbRecordInfo];
    [_tvbRecordInfo setBackgroundColor:[UIColor whiteColor]];
    [_tvbRecordInfo setDelegate:self];
    [_tvbRecordInfo setDataSource:self];
}
#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _arrMenuRecordNames = @[@"打卡考勤",@"工作汇报",@"外出汇报",@"出差汇报"];
        self.title = @"我的记录";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_On"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    
    UIButton * btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMore.frame = CGRectMake(0, 0, 50, 44);
    [btnMore setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_On"] forState:UIControlStateNormal];
    [btnMore  setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btnMore addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc]initWithCustomView:btnMore];
    [self.navigationItem setRightBarButtonItem:moreItem];
    [moreItem release];
    
    [self initRecordPromptInfo];
    
    [self initRecordInfoTableView];
    
    
    self.dtBegin = [WTool getBeginDateTimeMsWithNSDate:[NSDate date]];
    self.dtEnd = [WTool getEndDateTimeMsWithdtBeginMS:self.dtBegin];
        _lblRecordPromptTimeInfo.text = [NSString stringWithFormat:@"从%@至%@",_strTimeInfoStart,_strTimeInfoEnd];
    
    if (!self.typeRecord)
    {
        //考勤记录
        
    }else//汇报记录
    {
        NSString * strReportType = TypeReport_Work;
        if (self.typeRecord == 2)
            strReportType = TypeReport_GoOut;
        else if(self.typeRecord == 3)
            strReportType = TypeReport_Travel;
        ReportManager * rm = [ReportManager sharedReportManager];
        GetCommonDataModel;
        [rm findReportsWithOrganizationId:comData.organization.organizationId
                                OrgunitId:comData.organization.orgunitId
                                 Username:comData.userModel.username
                               ReportType:strReportType
                             BeginDateLli:self.dtBegin
                               EndDateLli:self.dtEnd
                        FirstReportRecord:0
                          MaxReportRecord:50
                            GotArrReports:^(NSArray *arrReports, BOOL isOk)
         {
             self.arrData = arrReports;
             NSLog(@"RecordListVC arrData == %@",self.arrData);
         }];
    }
}

-(void)setArrData:(NSArray *)arrData
{
    if (_arrData != arrData)
    {
        [_arrData release];
        _arrData = [arrData retain];
        //重新写
    }
    [_tvbRecordInfo reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_tvbRecordInfo reloadData];
    [_lblRecordPromptUserInfo release];
    [_lblRecordPromptTimeInfo release];
    [_username release];
    [_userRealname release];
    [super dealloc];
}

@end
