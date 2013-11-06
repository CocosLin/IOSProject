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
    NSLog(@"RecordListVC tableView 含有的数据内容是 == %@",self.arrData);
    return self.arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"RecordQeryReportsVcCell";
    RecordQeryReportsVcCell * myCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!myCell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RecordQeryReportsVcCell" owner:self options:nil];
        myCell = [nib objectAtIndex:0];
    }
    if (self.playCard==YES) {
        NSLog(@"打卡情况");
        _atteMod = [self.arrData objectAtIndex:indexPath.row];
        NSLog(@"_atteMod.realName  %@",_atteMod.realName);

        myCell.realName.text = [NSString stringWithFormat:@"%@(%@)",_atteMod.realName,_atteMod.userName];
        myCell.creatDate.text = [WTool getStrDateTimeWithDateTimeMS:[_atteMod.createTime doubleValue] DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
        myCell.address.text = _atteMod.note;
    }else{
        NSLog(@"RecordQerReportsVC user ifo  updateDate== %@ address== %@ ",[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"updateDate"],[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"address"]);
        
        myCell.realName.text = [NSString stringWithFormat:@"%@(%@)",[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"realname"],[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"createUserId"]];
        myCell.creatDate.text = [WTool getStrDateTimeWithDateTimeMS:[[[self.arrData objectAtIndex:indexPath.row] objectForKey:@"updateDate"] doubleValue] DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
        myCell.address.text = [[self.arrData objectAtIndex:indexPath.row] objectForKey:@"address"];
    }
    myCell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
    myCell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
    if (!self.typeRecord) myCell.rightImg.hidden = NO;
    return myCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
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
    DetailQeryViewController * dvc = [[DetailQeryViewController alloc]init];//WithNibName:@"DetailRecordVC_Iphone" bundle:nil];
    dvc.username = self.username;
    dvc.realname = self.userRealname;
    GetCommonDataModel;
    dvc.phone =comData.userModel.telephone;
    dvc.reportModel = [self.reportArrData objectAtIndex:indexPath.row];
    dvc.realname = self.userRealname;
    dvc.username = self.username;
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
            //            UIDatePicker * dp = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
            //            [alertView addSubview:dp];
            self.dtEnd = [WTool getEndDateTimeMsWithNSDate:[NSDate date]];
            self.dtBegin = self.dtEnd - ((long long int)(componets.month)*30*24*60*60*1000);
            //NSLog(@"RecordListVC 自定义时间还未定");
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
    HBServerKit *hbServer = [[HBServerKit alloc]init];
    NSLog(@"self.dtBegin,self.dtEnd %lld %lld",self.dtBegin,self.dtEnd);
    if (self.personalOrOrgRecod == 1) {
        GetCommonDataModel;
        [hbServer findReportsWithOrganizationId:comData.organization.organizationId
                                      OrgunitId:[self.orgunitId integerValue]
                                       Username:self.username
                                     ReportType:self.strTypeRecord
                                   BeginDateLli:self.dtBegin
                                     EndDateLli:self.dtEnd
                              FirstReportRecord:0
                                MaxReportRecord:150
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
                     
                     NSLog(@"RecordQeryVC repMod.address= %@",repMod.address);
                     [mArrReports addObject:repMod];
                     [repMod release];
                 }
                 self.arrData = arrDicReports;
                 self.reportArrData = mArrReports;
                 //[_tvbRecordInfo reloadData];
                 //[self viewWillAppear:YES];

                 NSLog(@"--------------||||||||||__________%@",self.arrData);
                 [SVProgressHUD showSuccessWithStatus:@"数据加载成功！"];
             }else
             {
                 [SVProgressHUD showErrorWithStatus:@"无记录"];
             }
         }];
    }else{
        
        [hbServer findOrgunitReportsOfMembersWithOrganizationId:[self.organizationId integerValue]
                                                      orgunitId:[self.orgunitId integerValue] ReportType:self.strTypeRecord
                                                   BeginDateLli:self.dtBegin
                                                     EndDateLli:self.dtEnd
                                              FirstReportRecord:nil
                                                MaxReportRecord:nil
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
                     
                     NSLog(@"RecordQeryVC repMod.address= %@",repMod.address);
                     [mArrReports addObject:repMod];
                     [repMod release];
                 }
                 self.arrData = arrDicReports;
                 //[_tvbRecordInfo reloadData];
                 self.reportArrData = mArrReports;
                 //[self viewWillAppear:YES];
                 NSLog(@"--------------||||||||||__________%@",self.arrData);
                 [SVProgressHUD showSuccessWithStatus:@"数据加载成功！"];
             }else
             {
                 [SVProgressHUD showErrorWithStatus:@"无记录"];
             }
         }];
    }
    [hbServer release];
}

//- (void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.arrData = self.arrData;
//    [_tvbRecordInfo reloadData];
//    
//    
//}
#pragma mark - 用户事件
-(void)btnAction:(UIButton *)btn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"按时间查询"
                                                    message:@"请选择相应的时间"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"今天",@"这周内",@"这个月内",@"本年度",@"取消", nil];
    [alert show];
    [alert release];
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
    //    _lblRecordPromptTimeInfo.text = [NSString stringWithFormat:@"从%@至%@",_strTimeInfoStart,_strTimeInfoEnd];
}
//-(void)setTypeRecord:(NSInteger)typeRecord
//{
//    _typeRecord = typeRecord;
//    _strRecordType = [_arrMenuRecordNames objectAtIndex:typeRecord];
//    self.title = [NSString stringWithFormat:@"%@查询",_strRecordType];
//}

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
        [recordType release];
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
    
    [viewRecordPromptInfo release];
}
-(void)initRecordInfoTableView
{
    _tvbRecordInfo = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, Width_Screen, Height_Screen-102)];
    [_tvbRecordInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    
    //获得开始时间
    NSString *begineTime = [NSString stringWithFormat:@"%@(%@)",[WTool getStrDateTimeWithDateTimeMS:self.dtBegin DateTimeStyle:@"yyyy-MM-dd"],[WTool getStrWeekdayWithNSdate:[NSDate dateWithTimeIntervalSince1970:self.dtBegin/1000]]];
    
    self.dtBegin = [WTool getBeginDateTimeMsWithNSDate:[NSDate date]];
    self.dtEnd = [WTool getEndDateTimeMsWithdtBeginMS:self.dtBegin];
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
    [_organizationId release];
    [_orgunitId release];
    [super dealloc];
}

@end
