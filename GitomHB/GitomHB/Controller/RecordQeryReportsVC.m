//
//  RecordQeryReportsVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-9.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "RecordQeryReportsVC.h"
#import "WTool.h"
#import "WCommonMacroDefine.h"
#import "ReportManager.h"
#import "DetailQeryViewController.h"

#import "RecordQeryReportsVcCell.h"
#import "OrganizationsModel.h"
#import "SVProgressHUD.h"
#import "ReportModel.h"
#import "AttendanceModel.h"
#import "RecordQeryReportsVcCellForios5.h"

@interface RecordQeryReportsVC ()
{
    NSString * _strRecordType;
    NSString * _strTimeInfoStart;
    NSString * _strTimeInfoEnd;
    NSArray * _arrMenuRecordNames;
    UILabel * _lblRecordPromptUserInfo;
    UILabel * _lblRecordPromptTimeInfo;
    UITableView * _tvbRecordInfo;
    NSArray * _arrTypeReport;
    AttendanceModel *_atteMod;
}

@end

@implementation RecordQeryReportsVC

#pragma mark - 表格代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"RecordQeryReportsVC tableView 含有的数据内容是 == %@",self.arrData);
    return self.arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0) {
        static NSString *CellIdentifier = @"Cell";
        RecordQeryReportsVcCellForios5 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[RecordQeryReportsVcCellForios5 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.removeBut.hidden = YES;
        }
        
        if (self.playCard==YES) {
            NSLog(@"打卡情况");
            _atteMod = [self.arrData objectAtIndex:indexPath.row];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",_atteMod.realName,_atteMod.userName];
            NSLog(@"RecordQeryReportsVC cell == %lld %@",_atteMod.createTime,[WTool getStrDateTimeWithDateTimeMS:_atteMod.createTime DateTimeStyle:@"HH:mm:ss"]);
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[WTool getStrDateTimeWithDateTimeMS:_atteMod.updateDate DateTimeStyle:@"yyyy-MM-dd"],[WTool getStrDateTimeWithDateTimeMS:_atteMod.createTime DateTimeStyle:@"HH:mm:ss"]];
            //cell.timeLabel.text = [WTool getStrDateTimeWithDateTimeMS:_atteMod.updateDate DateTimeStyle:@"yyyy-MM-dd"];
            cell.addressLabel.text = _atteMod.note;
        }else{
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"realname"],[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"createUserId"]];
            
            cell.timeLabel.text = [WTool getStrDateTimeWithDateTimeMS:[[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"updateDate"] doubleValue] DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
            cell.addressLabel.text = [[self.arrData objectAtIndex:indexPath.row] objectForKey:@"address"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        UIImageView *tempBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        cell.backgroundView = tempBackgroundView;
     
        UIImageView *selectedBackgroundView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        cell.selectedBackgroundView = selectedBackgroundView;
     
        return cell;
        
    }else{
        static NSString * cellID = @"RecordQeryReportsVcCell";
        RecordQeryReportsVcCell * myCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!myCell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RecordQeryReportsVcCell" owner:self options:nil];
            myCell = [nib objectAtIndex:0];
        }
        if (self.playCard==YES) {
            NSLog(@"打卡情况");
            _atteMod = [self.arrData objectAtIndex:indexPath.row];
            myCell.realName.text = [NSString stringWithFormat:@"%@(%@)",_atteMod.realName,_atteMod.userName];
            myCell.creatDate.text  = [NSString stringWithFormat:@"%@ %@",[WTool getStrDateTimeWithDateTimeMS:_atteMod.updateDate DateTimeStyle:@"yyyy-MM-dd"],[WTool getStrDateTimeWithDateTimeMS:_atteMod.createTime DateTimeStyle:@"HH:mm:ss"]];
            NSLog(@"RecordQeryReportsVC cell == %lld %@",_atteMod.createTime,[WTool getStrDateTimeWithDateTimeMS:_atteMod.createTime DateTimeStyle:@"HH:mm:ss"]);
            //myCell.creatDate.text = [WTool getStrDateTimeWithDateTimeMS:_atteMod.updateDate DateTimeStyle:@"yyyy-MM-dd"];
            myCell.address.text = _atteMod.note;
            myCell.rightImg.hidden = YES;
        }else{
            myCell.realName.text = [NSString stringWithFormat:@"%@(%@)",[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"realname"],[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"createUserId"]];
            myCell.creatDate.text = [WTool getStrDateTimeWithDateTimeMS:[[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"updateDate"] doubleValue] DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
            myCell.address.text = [[self.arrData objectAtIndex:indexPath.row] objectForKey:@"address"];
        }
        myCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        myCell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        return myCell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.playCard == YES) {
        return NO;
    }
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.playCard == YES) {
        return;
    }
    DetailQeryViewController * dvc = [[DetailQeryViewController alloc]init];
    GetCommonDataModel;
    dvc.phone =comData.userModel.telephone;
    dvc.reportModel = [self.reportArrData objectAtIndex:indexPath.row];
    dvc.realname = self.userRealname;
    dvc.username = self.username;
    [self.navigationController pushViewController:dvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
            NSLog(@"self.dtBegin == %lld",self.dtBegin);
            self.dtEnd = [WTool getEndDateTimeMsWithNSDate:[NSDate date]];
            NSLog(@"self.dtEnd == %lld",self.dtEnd);
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
            self.dtEnd = [WTool getEndDateTimeMsWithNSDate:[NSDate date]];
            self.dtBegin = self.dtEnd - ((long long int)(componets.month)*30*24*60*60*1000);
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

    //查汇报记录
    GetCommonDataModel;
    HBServerKit *hbServer = [[HBServerKit alloc]init];
    NSLog(@"self.dtBegin,self.dtEnd %lld %lld",self.dtBegin,self.dtEnd);
    if (self.playCard == YES) {
        [SVProgressHUD showWithStatus:@"加载…"];
        if (self.personalOrOrgRecod == 1) {//获得个人打卡数据
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:comData.organization.organizationId
                                                             orgunitId:[self.orgunitId integerValue]
                                                     orgunitAttendance:NO
                                                              userName:[self.username integerValue]
                                                          BeginDateLli:self.dtBegin
                                                            EndDateLli:self.dtEnd
                                                     FirstReportRecord:0
                                                       MaxReportRecord:10+addDataInt
                                                           RefreshData:YES
                                                         GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         NSLog(@"444name == %@",[dicReports objectForKey:@"createDate"]);
                         AttendanceModel *repMod = [[AttendanceModel alloc]init];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"username"];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.createTime = [[dicReports objectForKey:@"createTime"]longLongValue];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"] longLongValue];
                         NSLog(@"RecordQeryVC note = %@",repMod.note);
                         [mArrReports addObject:repMod];
                   
                     }
                     self.arrData = mArrReports;
                     [SVProgressHUD showSuccessWithStatus:@"完成"];
                 }else
                 {
                     self.arrData =nil;
                     [SVProgressHUD showErrorWithStatus:@"无记录"];
                 }
             }];
            
        }else{//获得部门打卡数据
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:comData.organization.organizationId
                                                             orgunitId:[self.orgunitId integerValue]
                                                     orgunitAttendance:YES
                                                              userName:nil
                                                          BeginDateLli:self.dtBegin
                                                            EndDateLli:self.dtEnd
                                                     FirstReportRecord:0
                                                       MaxReportRecord:10+addDataInt
                                                           RefreshData:YES
                                                         GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         NSLog(@"444name == %@",[dicReports objectForKey:@"createDate"]);
                         AttendanceModel *repMod = [[AttendanceModel alloc]init];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"username"];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.createTime = [[dicReports objectForKey:@"createTime"]longLongValue];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                         
                         NSLog(@"RecordQeryVC note = %@",repMod.note);
                         [mArrReports addObject:repMod];
                   
                     }
                     self.arrData = mArrReports;
                     [SVProgressHUD showSuccessWithStatus:@"完成!"];
                 }else
                 {
                     self.arrData = nil;
                     [SVProgressHUD showErrorWithStatus:@"无记录"];;
                 }
             }];
        }
    }else{
        [SVProgressHUD showWithStatus:@"加载…"];
        if (self.personalOrOrgRecod == 1) {
            [hbServer findReportsWithOrganizationId:comData.organization.organizationId
                                          OrgunitId:[self.orgunitId integerValue]
                                           Username:self.username
                                         ReportType:self.strTypeRecord
                                       BeginDateLli:self.dtBegin
                                         EndDateLli:self.dtEnd
                                  FirstReportRecord:0
                                    MaxReportRecord:10
                                        RefreshData:YES
                                      GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count   ];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         
                         NSLog(@"444name == %@",[dicReports objectForKey:@"name"]);
                         ReportModel *repMod = [[ReportModel alloc]init];
                         repMod.imageUrl = [dicReports objectForKey:@"imageUrl"];
                         repMod.latitude = [[dicReports objectForKey:@"latitude"]floatValue];
                         repMod.longitude = [[dicReports objectForKey:@"longitude"]floatValue];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.soundUrl = [dicReports objectForKey:@"soundUrl"];
                         repMod.telephone = [dicReports objectForKey:@"telephone"];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                         repMod.address = [dicReports objectForKey:@"address"];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"updateUserId"];
                         repMod.reportId = [dicReports objectForKey:@"reportId"];
                         repMod.organizationId = [[dicReports objectForKey:@"organizationId"]integerValue];
                         repMod.orgunitId = [[dicReports objectForKey:@"orgunitId"]integerValue];
                         NSLog(@"RecordQeryVC repMod.address 考勤 = %@",repMod.address);
                         [mArrReports addObject:repMod];
                        
                     }
                     self.arrData = arrDicReports;
                     self.reportArrData = mArrReports;
                     [SVProgressHUD showSuccessWithStatus:@"数据加载成功！"];
                 }else
                 {
                     self.arrData = nil;
                     [SVProgressHUD showErrorWithStatus:@"无记录"];
                 }
             }];
        }else{
            
            [hbServer findOrgunitReportsOfMembersWithOrganizationId:[self.organizationId integerValue]
                                                          orgunitId:[self.orgunitId integerValue] ReportType:self.strTypeRecord
                                                       BeginDateLli:self.dtBegin
                                                         EndDateLli:self.dtEnd
                                                  FirstReportRecord:0
                                                    MaxReportRecord:10
                                                        RefreshData:YES
                                                      GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         ReportModel *repMod = [[ReportModel alloc]init];
                         repMod.imageUrl = [dicReports objectForKey:@"imageUrl"];
                         repMod.latitude = [[dicReports objectForKey:@"latitude"]floatValue];
                         repMod.longitude = [[dicReports objectForKey:@"longitude"]floatValue];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.soundUrl = [dicReports objectForKey:@"soundUrl"];
                         repMod.telephone = [dicReports objectForKey:@"telephone"];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                         repMod.address = [dicReports objectForKey:@"address"];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"updateUserId"];
                         repMod.reportId = [dicReports objectForKey:@"reportId"];
                         repMod.organizationId = [[dicReports objectForKey:@"organizationId"]integerValue];
                         repMod.orgunitId = [[dicReports objectForKey:@"orgunitId"]integerValue];
                         
                         NSLog(@"RecordQeryVC repMod.address= %@",repMod.address);
                         [mArrReports addObject:repMod];
                      
                     }
                     self.arrData = arrDicReports;
                     self.reportArrData = mArrReports;
                     [SVProgressHUD showSuccessWithStatus:@"完成！"];
                 }else
                 {
                     self.arrData = nil;
                     [SVProgressHUD showErrorWithStatus:@"无记录"];
                 }
             }];
        }
    }
    
   
}

#pragma mark - 用户事件
-(void)btnAction:(UIButton *)btn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"按时间查询"
                                                    message:@"请选择相应的时间"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"今天",@"这周内",@"这个月内",@"本年度",@"取消", nil];
    [alert show];
  
}
#pragma mark - 属性控制
#pragma mark -- 转换毫秒时间
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
}


#pragma mark - 视图
//记录提示信息
-(void)initRecordPromptInfo
{
    CGFloat hViewRecordPromptInfo = 40;
    UIView * viewRecordPromptInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, hViewRecordPromptInfo)];
    [viewRecordPromptInfo setBackgroundColor:BlueColor];
    
    _lblRecordPromptUserInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, hViewRecordPromptInfo/2)];
    [viewRecordPromptInfo addSubview:_lblRecordPromptUserInfo];
    _lblRecordPromptUserInfo.textAlignment = NSTextAlignmentCenter;
    _lblRecordPromptUserInfo.textColor = [UIColor blackColor];
    [_lblRecordPromptUserInfo setFont:[UIFont systemFontOfSize:13]];
    if (self.playCard == YES) {
        _lblRecordPromptUserInfo.text = @"打卡考勤情况";
    }else{
        NSString *recordType = [[NSString alloc]init];
        if ([self.strTypeRecord isEqualToString:@"REPORT_TYPE_DAY_REPORT"]) {
            recordType = @"工作汇报";
        }else{
            recordType = @"外出/出差汇报";
        }
        _lblRecordPromptUserInfo.text = [NSString stringWithFormat:@"%@的%@",self.userRealname,recordType];
      
    }
    
    [_lblRecordPromptUserInfo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewRecordPromptInfo];
    
    _lblRecordPromptTimeInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, hViewRecordPromptInfo/2, Width_Screen, hViewRecordPromptInfo/2)];
    [viewRecordPromptInfo addSubview:_lblRecordPromptTimeInfo];
    _lblRecordPromptTimeInfo.textAlignment = NSTextAlignmentCenter;
    _lblRecordPromptTimeInfo.textColor = [UIColor blackColor];
    [_lblRecordPromptTimeInfo setFont:[UIFont systemFontOfSize:13]];
    _lblRecordPromptTimeInfo.text = [NSString stringWithFormat:@"从%@至%@",_strTimeInfoStart,_strTimeInfoEnd];
    [_lblRecordPromptTimeInfo setBackgroundColor:[UIColor clearColor]];
}

-(void)initRecordInfoTableView
{
    _tvbRecordInfo = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, Width_Screen, Height_Screen-102)];
    [_tvbRecordInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tvbRecordInfo];
    [_tvbRecordInfo setBackgroundColor:[UIColor whiteColor]];
    [_tvbRecordInfo setDelegate:self];
    [_tvbRecordInfo setDataSource:self];
    
    //上拉刷新的控件添加在tableView上
    refreshView = [[EGORefreshTableFooterView alloc]  initWithFrame:CGRectZero];
    refreshView.delegate = self;
    [_tvbRecordInfo addSubview:refreshView];
    reloading = NO;
    
    //下拉刷新界面
    [self initHeadRefreshVeiw];
}
#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
   
    
    UIButton * btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMore.frame = CGRectMake(0, 0, 50, 44);
    [btnMore setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_On"] forState:UIControlStateNormal];
    [btnMore  setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btnMore addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc]initWithCustomView:btnMore];
    [self.navigationItem setRightBarButtonItem:moreItem];
   
    
    [self initRecordPromptInfo];
    [self initRecordInfoTableView];
    
    //获得开始时间
    NSString *begineTime = [NSString stringWithFormat:@"%@(%@)",[WTool getStrDateTimeWithDateTimeMS:self.dtBegin DateTimeStyle:@"yyyy-MM-dd"],[WTool getStrWeekdayWithNSdate:[NSDate dateWithTimeIntervalSince1970:self.dtBegin/1000]]];
    
    //self.dtBegin = [WTool getBeginDateTimeMsWithNSDate:[NSDate date]];
    self.dtEnd = [WTool getEndDateTimeMsWithdtBeginMS:[WTool getBeginDateTimeMsWithNSDate:[NSDate date]]];
    _lblRecordPromptTimeInfo.text = [NSString stringWithFormat:@"从%@至%@",begineTime,_strTimeInfoEnd];
    
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
                          MaxReportRecord:10
                                   Refrsh:NO
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
        //[_arrData release];
        //_arrData = [arrData retain];
        //重新写
        _arrData = nil;
        _arrData = arrData;
    }
    [_tvbRecordInfo reloadData];
}

#pragma mark - 上拉刷新相关
-(void)viewDidAppear:(BOOL)animated
{
    //frame应在表格加载完数据源之后再设置
    [self setRefreshViewFrame];
    [super viewDidAppear:animated];
}
//请求数据
-(void)reloadData
{
    reloading = YES;
    //新建一个线程来加载数据
    [NSThread detachNewThreadSelector:@selector(requestData)
                             toTarget:self
                           withObject:nil];
}
static int addDataInt=0;
-(void)requestData
{   NSLog(@"上拉刷新 addDataInt == %d",addDataInt);
    addDataInt=addDataInt +10;
    GetCommonDataModel;
    
    //查汇报记录
    HBServerKit *hbServer = [[HBServerKit alloc]init];
    NSLog(@"self.dtBegin,self.dtEnd %lld %lld",self.dtBegin,self.dtEnd);
    if (self.playCard == YES) {//打卡数据
        if (self.personalOrOrgRecod == 1) {//获得个人打卡数据
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:comData.organization.organizationId
                                                             orgunitId:[self.orgunitId integerValue]
                                                     orgunitAttendance:NO
                                                              userName:[self.username integerValue]
                                                          BeginDateLli:self.dtBegin
                                                            EndDateLli:self.dtEnd
                                                     FirstReportRecord:0
                                                       MaxReportRecord:10+addDataInt
                                                           RefreshData:YES
                                                         GotArrReports:^(NSArray *arrDicReports, WError *myError)
            {
             if (arrDicReports.count) {
                NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                for (NSDictionary * dicReports in arrDicReports)
                {
                    NSLog(@"realname == %@",dicReports);
                    NSLog(@"444name == %@",[dicReports objectForKey:@"createDate"]);
                    AttendanceModel *repMod = [[AttendanceModel alloc]init];
                    repMod.realName = [dicReports objectForKey:@"realname"];
                    repMod.userName = [dicReports objectForKey:@"username"];
                    repMod.note = [dicReports objectForKey:@"note"];
                    repMod.createTime = [[dicReports objectForKey:@"long long int"]longLongValue];
                    repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                    NSLog(@"RecordQeryVC note = %@",repMod.note);
                    [mArrReports addObject:repMod];
            
                }
                    self.arrData = mArrReports;
                    }else
                     {
                      nil;
                     }
             }];
            
        }else{//获得部门打卡数据
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:comData.organization.organizationId
                                                             orgunitId:[self.orgunitId integerValue]
                                                     orgunitAttendance:YES
                                                              userName:nil
                                                          BeginDateLli:self.dtBegin
                                                            EndDateLli:self.dtEnd
                                                     FirstReportRecord:0
                                                       MaxReportRecord:10+addDataInt
                                                           RefreshData:YES
                                                         GotArrReports:^(NSArray *arrDicReports, WError *myError)
            {
                  if (arrDicReports.count) {
                       NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                       for (NSDictionary * dicReports in arrDicReports)
                         {
                             NSLog(@"realname == %@",dicReports);
                             NSLog(@"444name == %@",[dicReports objectForKey:@"createDate"]);
                             AttendanceModel *repMod = [[AttendanceModel alloc]init];
                             repMod.realName = [dicReports objectForKey:@"realname"];
                             repMod.userName = [dicReports objectForKey:@"username"];
                             repMod.note = [dicReports objectForKey:@"note"];
                             repMod.createTime = [[dicReports objectForKey:@"createTime"]longLongValue];
                             repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                            NSLog(@"RecordQeryVC note = %@",repMod.note);
                            [mArrReports addObject:repMod];
              
                            }
                            self.arrData = mArrReports;
                            }else
                            {
                            nil;
                            }
          }];
        }
    
    }else{//汇报数据（上班、出差、出门）
        if (self.personalOrOrgRecod == 1) {//个人汇报数据
            [hbServer findReportsWithOrganizationId:comData.organization.organizationId
                                          OrgunitId:[self.orgunitId integerValue]
                                           Username:self.username
                                         ReportType:self.strTypeRecord
                                       BeginDateLli:self.dtBegin
                                         EndDateLli:self.dtEnd
                                  FirstReportRecord:0
                                    MaxReportRecord:10+addDataInt
                                        RefreshData:YES
                                      GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count   ];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         
                         NSLog(@"444name == %@",[dicReports objectForKey:@"name"]);
                         ReportModel *repMod = [[ReportModel alloc]init];
                         repMod.imageUrl = [dicReports objectForKey:@"imageUrl"];
                         repMod.latitude = [[dicReports objectForKey:@"latitude"]floatValue];
                         repMod.longitude = [[dicReports objectForKey:@"longitude"]floatValue];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.soundUrl = [dicReports objectForKey:@"soundUrl"];
                         repMod.telephone = [dicReports objectForKey:@"telephone"];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                         repMod.address = [dicReports objectForKey:@"address"];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"updateUserId"];
                         repMod.reportId = [dicReports objectForKey:@"reportId"];
                         repMod.organizationId = [[dicReports objectForKey:@"organizationId"]integerValue];
                         repMod.orgunitId = [[dicReports objectForKey:@"orgunitId"]integerValue];
                         NSLog(@"RecordQeryVC repMod.address= %@",repMod.address);
                         [mArrReports addObject:repMod];
                   
                     }
                     self.arrData = arrDicReports;
                     self.reportArrData = mArrReports;
                     
                     NSLog(@"--------------||||||||||__________%@",self.arrData);
                 }else
                 {
                     nil;
                 }
             }];
        }else{//部门汇报数据
            
            [hbServer findOrgunitReportsOfMembersWithOrganizationId:[self.organizationId integerValue]
                                                          orgunitId:[self.orgunitId integerValue]
                                                         ReportType:self.strTypeRecord
                                                       BeginDateLli:self.dtBegin
                                                         EndDateLli:self.dtEnd
                                                  FirstReportRecord:0
                                                    MaxReportRecord:10+addDataInt
                                                        RefreshData:YES
                                                      GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         
                         NSLog(@"444name == %@",[dicReports objectForKey:@"name"]);
                         ReportModel *repMod = [[ReportModel alloc]init];
                         repMod.imageUrl = [dicReports objectForKey:@"imageUrl"];
                         repMod.latitude = [[dicReports objectForKey:@"latitude"]floatValue];
                         repMod.longitude = [[dicReports objectForKey:@"longitude"]floatValue];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.soundUrl = [dicReports objectForKey:@"soundUrl"];
                         repMod.telephone = [dicReports objectForKey:@"telephone"];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                         repMod.address = [dicReports objectForKey:@"address"];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"updateUserId"];
                         repMod.reportId = [dicReports objectForKey:@"reportId"];
                         repMod.organizationId = [[dicReports objectForKey:@"organizationId"]integerValue];
                         repMod.orgunitId = [[dicReports objectForKey:@"orgunitId"]integerValue];
                         NSLog(@"RecordQeryVC repMod.address= %@",repMod.address);
                         [mArrReports addObject:repMod];
                    
                     }
                     self.arrData = arrDicReports;
                     self.reportArrData = mArrReports;
                     NSLog(@"--------------||||||||||__________%@",self.arrData);
                 }else
                 {
                     nil;
                 }
             }];
        }
    }
    
    
    
    sleep(3);
    //在主线程中刷新UI
    [self performSelectorOnMainThread:@selector(reloadUI)
                           withObject:nil
                        waitUntilDone:NO];
}

-(void)reloadUI
{
	reloading = NO;
    
    //停止上拉的动作,恢复表格的便宜
	[refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_tvbRecordInfo];
    //更新界面
    [_tvbRecordInfo reloadData];
    [self setRefreshViewFrame];
}

-(void)setRefreshViewFrame
{
    //如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    int height = MAX(_tvbRecordInfo.bounds.size.height, _tvbRecordInfo.contentSize.height);
    refreshView.frame =CGRectMake(0.0f, height, self.view.frame.size.width, _tvbRecordInfo.bounds.size.height);
}
#pragma mark - EGORefreshTableFooterDelegate
//出发下拉刷新动作，开始拉取数据
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    [self reloadData];
}
//返回当前刷新状态：是否在刷新
- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return reloading;
}
//返回刷新时间
-(NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view
{
    return [NSDate date];
}

#pragma mark - UIScrollView

//此代理在scrollview滚动时就会调用
//在下拉一段距离到提示松开和松开后提示都应该有变化，变化可以在这里实现
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
}
//松开后判断表格是否在刷新，若在刷新则表格位置偏移，且状态说明文字变化为loading...
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - 下拉刷新相关
#pragma mark - 创建下拉刷新界面
- (void)initHeadRefreshVeiw{
    NSLog(@"reloading1 bool == %d",reloading1);
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
		view.delegate = self;
		[_tvbRecordInfo addSubview:view];
		_refreshHeaderView = view;
		
		
	}
    [_refreshHeaderView refreshLastUpdatedDate];
}


#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	NSLog(@"reloading1 bool == %c",reloading1);
    NSLog(@"下拉刷新数据");
	GetCommonDataModel;
    
    //查汇报记录
    HBServerKit *hbServer = [[HBServerKit alloc]init];
    NSLog(@"self.dtBegin,self.dtEnd %lld %lld",self.dtBegin,self.dtEnd);
    if (self.playCard == YES) {//打卡数据
        if (self.personalOrOrgRecod == 1) {//获得个人打卡数据
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:comData.organization.organizationId
                                                             orgunitId:[self.orgunitId integerValue]
                                                     orgunitAttendance:NO
                                                              userName:[self.username integerValue]
                                                          BeginDateLli:self.dtBegin
                                                            EndDateLli:self.dtEnd
                                                     FirstReportRecord:0
                                                       MaxReportRecord:10+addDataInt
                                                           RefreshData:YES
                                                         GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         NSLog(@"444name == %@",[dicReports objectForKey:@"createDate"]);
                         AttendanceModel *repMod = [[AttendanceModel alloc]init];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"username"];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.createTime = [dicReports objectForKey:@"createDate"];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                         NSLog(@"RecordQeryVC note = %@",repMod.note);
                         [mArrReports addObject:repMod];
            
                     }
                     self.arrData = mArrReports;
                 }else
                 {
                     nil;
                 }
             }];
            
        }else{//获得部门打卡数据
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:comData.organization.organizationId
                                                             orgunitId:[self.orgunitId integerValue]
                                                     orgunitAttendance:YES
                                                              userName:nil
                                                          BeginDateLli:self.dtBegin
                                                            EndDateLli:self.dtEnd
                                                     FirstReportRecord:0
                                                       MaxReportRecord:10+addDataInt
                                                           RefreshData:YES
                                                         GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         NSLog(@"444name == %@",[dicReports objectForKey:@"createDate"]);
                         AttendanceModel *repMod = [[AttendanceModel alloc]init];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"username"];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.createTime = [[dicReports objectForKey:@"createTime"]longLongValue];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                         NSLog(@"RecordQeryVC note = %@",repMod.note);
                         [mArrReports addObject:repMod];
             
                     }
                     self.arrData = mArrReports;
                 }else
                 {
                     nil;
                 }
             }];
        }
        
    }else{//汇报数据（上班、出差、出门）
        if (self.personalOrOrgRecod == 1) {//个人汇报数据
            [hbServer findReportsWithOrganizationId:comData.organization.organizationId
                                          OrgunitId:[self.orgunitId integerValue]
                                           Username:self.username
                                         ReportType:self.strTypeRecord
                                       BeginDateLli:self.dtBegin
                                         EndDateLli:self.dtEnd
                                  FirstReportRecord:0
                                    MaxReportRecord:10+addDataInt
                                        RefreshData:YES
                                      GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count   ];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         
                         NSLog(@"444name == %@",[dicReports objectForKey:@"name"]);
                         ReportModel *repMod = [[ReportModel alloc]init];
                         repMod.imageUrl = [dicReports objectForKey:@"imageUrl"];
                         repMod.latitude = [[dicReports objectForKey:@"latitude"]floatValue];
                         repMod.longitude = [[dicReports objectForKey:@"longitude"]floatValue];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.soundUrl = [dicReports objectForKey:@"soundUrl"];
                         repMod.telephone = [dicReports objectForKey:@"telephone"];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                         repMod.address = [dicReports objectForKey:@"address"];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"updateUserId"];
                         repMod.reportId = [dicReports objectForKey:@"reportId"];
                         repMod.organizationId = [[dicReports objectForKey:@"organizationId"]integerValue];
                         repMod.orgunitId = [[dicReports objectForKey:@"orgunitId"]integerValue];
                         NSLog(@"RecordQeryVC repMod.address= %@",repMod.address);
                         [mArrReports addObject:repMod];
                  
                     }
                     self.arrData = arrDicReports;
                     self.reportArrData = mArrReports;
                     
                     NSLog(@"--------------||||||||||__________%@",self.arrData);
                 }else
                 {
                     nil;
                 }
             }];
        }else{//部门汇报数据
            
            [hbServer findOrgunitReportsOfMembersWithOrganizationId:[self.organizationId integerValue]
                                                          orgunitId:[self.orgunitId integerValue]
                                                         ReportType:self.strTypeRecord
                                                       BeginDateLli:self.dtBegin
                                                         EndDateLli:self.dtEnd
                                                  FirstReportRecord:0
                                                    MaxReportRecord:10+addDataInt
                                                        RefreshData:YES
                                                      GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"realname == %@",dicReports);
                         
                         NSLog(@"444name == %@",[dicReports objectForKey:@"name"]);
                         ReportModel *repMod = [[ReportModel alloc]init];
                         repMod.imageUrl = [dicReports objectForKey:@"imageUrl"];
                         repMod.latitude = [[dicReports objectForKey:@"latitude"]floatValue];
                         repMod.longitude = [[dicReports objectForKey:@"longitude"]floatValue];
                         repMod.note = [dicReports objectForKey:@"note"];
                         repMod.soundUrl = [dicReports objectForKey:@"soundUrl"];
                         repMod.telephone = [dicReports objectForKey:@"telephone"];
                         repMod.updateDate = [[dicReports objectForKey:@"updateDate"]longLongValue];
                         repMod.address = [dicReports objectForKey:@"address"];
                         repMod.realName = [dicReports objectForKey:@"realname"];
                         repMod.userName = [dicReports objectForKey:@"updateUserId"];
                         repMod.reportId = [dicReports objectForKey:@"reportId"];
                         repMod.organizationId = [[dicReports objectForKey:@"organizationId"]integerValue];
                         repMod.orgunitId = [[dicReports objectForKey:@"orgunitId"]integerValue];
                         NSLog(@"RecordQeryVC repMod.address= %@",repMod.address);
                         [mArrReports addObject:repMod];
                     
                     }
                     self.arrData = arrDicReports;
                     self.reportArrData = mArrReports;
                     NSLog(@"--------------||||||||||__________%@",self.arrData);
                 }else
                 {
                     nil;
                 }
             }];
        }
    }
    
    
	[_tvbRecordInfo reloadData];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	NSLog(@"return reloading");
    //reloading1 = YES;
	return reloading1; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	NSLog(@"return [NSDate date]");
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    NSLog(@"reloading = YES;");
	reloading1 = YES;
    
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    NSLog(@"reloading = NO;");
	reloading1 = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tvbRecordInfo];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_tvbRecordInfo reloadData];
   
}

@end
