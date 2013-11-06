//
//  RecordQeryVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-10.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "RecordQeryVC.h"
#import "OrganizationCell.h"
#import "HBServerKit.h"
#import "OrganizationsModel.h"//部门信息
#import "MemberOrgModel.h"//部门成员信息
#import "RecordQeryDetialVC.h"
#import "SVProgressHUD.h"

#import "RecordQeryReportsVC.h"
#import "WTool.h"
#import "ReportModel.h"
#import "AttendanceModel.h"

@interface RecordQeryVC ()

@end

@implementation RecordQeryVC

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
	// Do any additional setup after loading the view.
    self.organizationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-66)];
    [self.organizationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.organizationTableView.delegate = self;
    self.organizationTableView.dataSource = self;
    [self.view addSubview:self.organizationTableView];
    OrganizationsModel *orgModel = [[OrganizationsModel alloc]init];
    orgModel = [self.orgArray objectAtIndex:0];
    NSLog(@"[self.orgArray objectAtIndex:0]%@  %@  [[self.orgArray objectAtIndex:indexPath.row]orgunitId]%@",[[self.orgArray objectAtIndex:0] organizationName],orgModel.organizationName,orgModel.orgunitId);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self orgArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{/*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    // Configure the cell...
    cell.textLabel.text = [[self.orgArray objectAtIndex:indexPath.row] organizationName];*/
    static NSString *CellIdentifier = @"OrganizationCell";
    OrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OrganizationCell" owner:self options:nil];
        //cell = [[OrganizationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [nib objectAtIndex:0];
    }
    cell.organizationName.text = [[self.orgArray objectAtIndex:indexPath.row] organizationName];
    
    cell.reportBtu.tag = indexPath.row +100;
    [cell.reportBtu addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
    cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
    return cell;
}

- (void)reportAction:(id)sender{
    [self reportDetails:((UIButton *)sender).tag-100];
}

-(void) reportDetails:(NSInteger)index{
    
    NSLog(@"indexPath.row=%d",index);
    [self btnAction:index];
}

#pragma mark - 部门查询种类
-(void)btnAction:(NSInteger)index
{
    OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
    orgMod = [self.orgArray objectAtIndex:index];
    NSLog(@"%@ %@ %@",orgMod.organizationId,orgMod.organizationName,orgMod.orgunitId);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询部门"
                                                    message:@"请选择查询类别"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"打卡考勤查询",@"工作汇报查询",@"外出汇报查询",@"出差汇报查询",@"取消", nil];
    self.seledBtIdx = index;
    [alert show];
    [alert release];
}

#pragma mark - UIAlertView代理方法 (查询的汇报类型：打卡考勤、工作汇报、外出汇报、出差汇报)
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    OrganizationsModel *orgMod = [self.orgArray objectAtIndex:self.seledBtIdx];
    NSLog(@"OrganizationsModel *orgMod %@ %@",orgMod.orgunitId,orgMod.organizationName);
    
    NSDateComponents * componets = [WTool getDateComponentsWithDate:[NSDate date]];
    //GetCommonDataModel;
    switch (buttonIndex)
    {
        case 0://打卡考勤查询
        {
            NSLog(@"打卡考勤查询");
            [SVProgressHUD showWithStatus:@"加载工作汇报…"];
            NSLog(@"工作汇报查询");
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]
                                                             orgunitId:[orgMod.orgunitId integerValue]orgunitAttendance:YES
                                                              userName:nil
                                                          BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day -1)*24*60*60*1000)
                                                            EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]FirstReportRecord:0
                                                       MaxReportRecord:150 GotArrReports:^(NSArray *arrDicReports, WError *myError) {
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
                        
                        NSLog(@"RecordQeryVC note = %@",repMod.note);
                        [mArrReports addObject:repMod];
                        [repMod release];
                    }
                    NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                    NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                    RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                    rdVC.playCard = YES;
                    rdVC.arrData = mArrReports;//存放具体汇报内容的数组
                    rdVC.title = [NSString stringWithFormat:@"%@记录",@"打卡"];
                    rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day-1)*24*60*60*1000);
                    
                    [SVProgressHUD dismissWithSuccess:@"加载成功"];
                    [self.navigationController pushViewController:rdVC animated:YES];
                    [rdVC release];
                    
                    [SVProgressHUD dismissWithSuccess:@"加载成功"];
                }else
                {
                    [SVProgressHUD dismissWithIsOk:NO String:@"无记录"];
                }
            }];
            [hbServer release];
            break;
        }
        case 1://工作汇报查询
        {
            [SVProgressHUD showWithStatus:@"加载工作汇报…"];
            NSLog(@"工作汇报查询");
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findOrgunitReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]    orgunitId:[orgMod.orgunitId integerValue] ReportType:@"REPORT_TYPE_DAY_REPORT" BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day -1)*24*60*60*1000) EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] FirstReportRecord:nil MaxReportRecord:nil GotArrReports:^(NSArray *arrDicReports, WError *myError)
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
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = @"REPORT_TYPE_DAY_REPORT";
                     rdVC.userRealname = orgMod.organizationName;
                     rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId;
 
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     ReportModel *mdo = [mArrReports objectAtIndex:0];
                     NSLog(@"mArrReports == %@",mdo.address);
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.organizationName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day-1)*24*60*60*1000);
                     
                     [SVProgressHUD dismissWithSuccess:@"加载成功"];
                     [self.navigationController pushViewController:rdVC animated:YES];
                     [rdVC release];
                 }else
                 {
                     [SVProgressHUD dismissWithIsOk:NO String:@"无记录"];
                 }
             }];
            
            [hbServer release];
            break;
        }
        case 2://外出汇报查询
        {
            NSLog(@"外出汇报查询");
            [SVProgressHUD showWithStatus:@"加载工作汇报…"];
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findOrgunitReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue] orgunitId:[orgMod.orgunitId integerValue]ReportType:@"REPORT_TYPE_GO_OUT" BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day -1)*24*60*60*1000) EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] FirstReportRecord:nil MaxReportRecord:nil GotArrReports:^(NSArray *arrDicReports, WError *myError)
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
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = @"REPORT_TYPE_GO_OUT";
                     rdVC.userRealname = orgMod.organizationName;
                     rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId;
                     
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     ReportModel *mdo = [mArrReports objectAtIndex:0];
                     NSLog(@"mArrReports == %@",mdo.address);
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.organizationName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day-1)*24*60*60*1000);
                     
                     [SVProgressHUD dismissWithSuccess:@"加载成功"];
                     [self.navigationController pushViewController:rdVC animated:YES];
                     [rdVC release];
                 }else
                 {
                     [SVProgressHUD dismissWithIsOk:NO String:@"无记录"];
                 }
             }];
            
            [hbServer release];
            break;
        }
        case 3://出差汇报查询
        {
            NSLog(@"出差汇报查询");
            [SVProgressHUD showWithStatus:@"加载工作汇报…"];
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findOrgunitReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]     orgunitId:[orgMod.orgunitId integerValue] ReportType:@"REPORT_TYPE_TRAVEL" BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day -1)*24*60*60*1000) EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] FirstReportRecord:nil MaxReportRecord:nil GotArrReports:^(NSArray *arrDicReports, WError *myError)
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
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = @"REPORT_TYPE_GO_OUT";
                     rdVC.userRealname = orgMod.organizationName;
                     rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId;
                     
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     ReportModel *mdo = [mArrReports objectAtIndex:0];
                     NSLog(@"mArrReports == %@",mdo.address);
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.organizationName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day-1)*24*60*60*1000);
                     
                     [SVProgressHUD dismissWithSuccess:@"加载成功"];
                     [self.navigationController pushViewController:rdVC animated:YES];
                     [rdVC release];
                 }else
                 {
                     [SVProgressHUD dismissWithIsOk:NO String:@"无记录"];
                 }
             }];
            
            [hbServer release];
            
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
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[SVProgressHUD showErrorWithStatus:@"加载人员数据…" duration:1.0];
    [SVProgressHUD showWithStatus:@"加载部门数据…"];
    
    // Navigation logic may go here. Create and push another view controller.
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    OrganizationsModel *organization = [[OrganizationsModel alloc]init];
    organization = [self.orgArray objectAtIndex:indexPath.row];
    NSString *orgIdStr = organization.orgunitId;
    NSInteger intS = [orgIdStr intValue];
    [hbKit findOrgunitMembersWithOrganizationId:comData.organization.organizationId
                                  orgunitId:intS
                                  GotArrReports:^(NSArray *arrDicReports, WError *myError)
     {
         if (arrDicReports.count) {
             NSLog(@"RecordQeryVC 数组循环次数 ==  %d",arrDicReports.count);
             NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
             for (NSDictionary * dicReports in arrDicReports)
             {
                 NSLog(@"RecordQeryVC ReportManager 获得数据内容 == %@",dicReports);
                 
                 NSLog(@"RecordQeryVC  realname == %@",[dicReports objectForKey:@"realname"]);
                 NSLog(@"RecordQeryVC  roleId == %@",[dicReports objectForKey:@"roleId"]);
                 MemberOrgModel *memberIfo = [[MemberOrgModel alloc]init];
                 memberIfo.realName = [dicReports objectForKey:@"realname"];
                 memberIfo.username = [dicReports objectForKey:@"username"];
                 memberIfo.roleId = [dicReports objectForKey:@"roleId"];
                 memberIfo.photoUrl = [dicReports objectForKey:@"photo"];
                 memberIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                 [mArrReports addObject:memberIfo];
             }
             NSLog(@"RecordQeryVC 获取部门成员信息成功! %@",mArrReports);
             RecordQeryDetialVC *detailViewController = [[RecordQeryDetialVC alloc] initWithNibName:nil bundle:nil];
             detailViewController.orgArray = mArrReports;
             //[SVProgressHUD showSuccessWithStatus:@"加载人员数据…"];
             [SVProgressHUD dismissWithIsOk:YES String:@"加载成功"];//显示出结果
             [self.navigationController pushViewController:detailViewController animated:YES];
             [detailViewController release];
         }else
         {
             //[SVProgressHUD dismissWithIsOk:NO String:@"无汇报记录"];
             [SVProgressHUD showErrorWithStatus:@"无人员数据"];
         }
     }];
}

- (void)dealloc{
    [_organizationTableView release];
    [_orgArray release];
    [super dealloc];
}


@end
