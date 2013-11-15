//
//  RecordQeryDetialVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-24.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "RecordQeryDetialVC.h"
#import "RecordQeryDetialCell.h"
#import "MemberOrgModel.h"
#import "UserManager.h"
#import "MemberOrgModel.h"
#import "ReportManager.h"
#import "WTool.h"
#import "RecordQeryReportsVC.h"
#import "SVProgressHUD.h"
#import "AttendanceModel.h"
#import "UIImageView+MJWebCache.h"

@interface RecordQeryDetialVC ()

@end

@implementation RecordQeryDetialVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"人员列表";
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
    
	// Do any additional setup after loading the view.
    self.organizationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-66)];
    [self.organizationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.organizationTableView.delegate = self;
    self.organizationTableView.dataSource = self;
    [self.view addSubview:self.organizationTableView];
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
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] <6.0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
        }
        
        MemberOrgModel *memberInfo = [[MemberOrgModel alloc]init];
        memberInfo = [self.orgArray objectAtIndex:indexPath.row];
        NSString *nameS = [NSString stringWithFormat:@"%@(%@)",memberInfo.realName,memberInfo.username];
        cell.textLabel.text = nameS;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        NSString *roleIdStr = [NSString stringWithFormat:@"%@",memberInfo.roleId];
        if ([roleIdStr isEqualToString:@"1"]) {
            cell.detailTextLabel.text = @"创建者";
        }else if ([roleIdStr isEqualToString:@"2"] ){
            cell.detailTextLabel.text = @"部门主管";
        }else{
            cell.detailTextLabel.text = @"员工";
        }
        cell.detailTextLabel.backgroundColor  = [UIColor clearColor];
        cell.imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_avatar_user.png"]];
        UserManager * um = [UserManager sharedUserManager];
        if (memberInfo.photoUrl != nil) {
            [um getUserPhotoImageWithStrUserPhotoUrl:memberInfo.photoUrl GotResult:^(UIImage *imgUserPhoto, BOOL isOK)
             {
                 if (isOK)
                 {
                     cell.imageView.image = imgUserPhoto;
                 }
             }];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"icon_avatar_user.png"];
        }
        cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
        cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        static NSString *CellIdentifier = @"RecordQeryDetialCell";
        RecordQeryDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RecordQeryDetialCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        MemberOrgModel *memberInfo = [[MemberOrgModel alloc]init];
        memberInfo = [self.orgArray objectAtIndex:indexPath.row];
        NSString *nameS = [NSString stringWithFormat:@"%@(%@)",memberInfo.realName,memberInfo.username];
        cell.name.text = nameS;
        
        NSString *roleIdStr = [NSString stringWithFormat:@"%@",memberInfo.roleId];
        if ([roleIdStr isEqualToString:@"1"]) {
            cell.roleId.text = @"创建者";
        }else if ([roleIdStr isEqualToString:@"2"] ){
            cell.roleId.text = @"部门主管";
        }else{
            cell.roleId.text = @"员工";
        }
        
        UserManager * um = [UserManager sharedUserManager];
        if (memberInfo.photoUrl != nil) {
            [um getUserPhotoImageWithStrUserPhotoUrl:memberInfo.photoUrl GotResult:^(UIImage *imgUserPhoto, BOOL isOK)
             {
                 if (isOK)
                 {
                     cell.headImg.image = imgUserPhoto;
                 }
             }];
        }
        cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
        cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
        return cell;
    }
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    [self btnAction:indexPath.row];
}

#pragma mark - 部门查询种类
-(void)btnAction:(NSInteger)index
{
//    MemberOrgModel *orgMod = [[MemberOrgModel alloc]init];
//    orgMod = [self.orgArray objectAtIndex:index];
//    NSLog(@"RecordQeryDetialVC == orgunitId %@ realName %@ realName %@",orgMod.orgunitId,orgMod.realName,orgMod.username);
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
    MemberOrgModel *orgMod = [[MemberOrgModel alloc]init];
    orgMod = [self.orgArray objectAtIndex:self.seledBtIdx];
    GetCommonDataModel;
    NSDateComponents * componets = [WTool getDateComponentsWithDate:[NSDate date]];
    switch (buttonIndex)
    {
        case 0://打卡考勤查询
        {
            NSLog(@"打卡考勤查询");
            NSLog(@"打卡考勤查询");
            [SVProgressHUD showWithStatus:@"加载工作汇报…"];
            NSLog(@"工作汇报查询");
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:comData.organization.organizationId
                                                             orgunitId:[orgMod.orgunitId integerValue]
                                                     orgunitAttendance:NO
                                                              userName:[orgMod.username integerValue]
                                                          BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                            EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]FirstReportRecord:0
                                                       MaxReportRecord:10
                                                           RefreshData:YES
                                                         GotArrReports:^(NSArray *arrDicReports, WError *myError) {
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
                        NSLog(@"repMod.createTime == %@",repMod.createTime);
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
                    rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                    
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
            [hbServer findReportsWithOrganizationId:comData.organization.organizationId
                                          OrgunitId:[orgMod.orgunitId integerValue]
                                           Username:orgMod.username ReportType:@"REPORT_TYPE_DAY_REPORT"
                                       BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                         EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
                                  FirstReportRecord:0
                                    MaxReportRecord:10
                                        RefreshData:YES
                                      GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count   ];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         NSLog(@"RecordQeryDetial realname == %@",dicReports);
                         
                         NSLog(@"RecordQeryDetial 444name == %@",[dicReports objectForKey:@"name"]);
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
                         [repMod release];
                     }
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = @"REPORT_TYPE_DAY_REPORT";
                     rdVC.userRealname = orgMod.realName;
                     rdVC.username = orgMod.username;
                     //rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId;
                     rdVC.personalOrOrgRecod = 1;
                     
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     ReportModel *mdo = [mArrReports objectAtIndex:0];
                     NSLog(@"mArrReports == %@",mdo.address);
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.realName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                     
                     [SVProgressHUD dismissWithSuccess:@"加载成功"];
                     [self.navigationController pushViewController:rdVC animated:YES];
                     [rdVC release];
                 }else
                 {
                     [SVProgressHUD dismissWithIsOk:NO String:@"无工作记录"];
                 }
             }];
            
            [hbServer release];
            break;
        }
        case 2://外出汇报查询
        {
            [SVProgressHUD showWithStatus:@"加载外出汇报…"];
            NSLog(@"外出汇报查询");
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findReportsWithOrganizationId:comData.organization.organizationId
                                          OrgunitId:[orgMod.orgunitId integerValue]
                                           Username:orgMod.username ReportType:@"REPORT_TYPE_GO_OUT"
                                       BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                         EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
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
                     
                         NSLog(@"RecordQeryVC repMod.address= %@",repMod.address);
                         [mArrReports addObject:repMod];
                         [repMod release];
                     }
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                 rdVC.strTypeRecord = @"REPORT_TYPE_GO_OUT";
                 rdVC.userRealname = orgMod.realName;
                 rdVC.username = orgMod.username;
                 rdVC.orgunitId = orgMod.orgunitId;
                 rdVC.personalOrOrgRecod = 1;
                     
                 rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                 ReportModel *mdo = [mArrReports objectAtIndex:0];
                 NSLog(@"mArrReports == %@",mdo.address);
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.realName];
                 rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                 
                 [SVProgressHUD dismissWithSuccess:@"加载成功"];
                 [self.navigationController pushViewController:rdVC animated:YES];
                 [rdVC release];
             }else
             {
                 [SVProgressHUD dismissWithIsOk:NO String:@"无外出记录"];
             }
         }];
        
        [hbServer release];
        break;
    }
        case 3://出差汇报查询
        {
            //[SVProgressHUD showWithStatus:@"加载出差汇报…"];
            NSLog(@"出差汇报查询");
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findReportsWithOrganizationId:comData.organization.organizationId
                                          OrgunitId:[orgMod.orgunitId integerValue]
                                           Username:orgMod.username ReportType:@"REPORT_TYPE_TRAVEL"
                                       BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                         EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
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
                         
                         NSLog(@"RecordQeryVC repMod.address= %@",repMod.address);
                         [mArrReports addObject:repMod];
                         [repMod release];
                     }
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = @"REPORT_TYPE_TRAVEL";
                     rdVC.userRealname = orgMod.realName;
                     rdVC.username = orgMod.username;
                     //rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId;
                     rdVC.personalOrOrgRecod = 1;

                     
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     ReportModel *mdo = [mArrReports objectAtIndex:0];
                     NSLog(@"mArrReports == %@",mdo.address);
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.realName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                     
                     //[SVProgressHUD dismissWithSuccess:@"加载成功"];
                     [self.navigationController pushViewController:rdVC animated:YES];
                     [rdVC release];
                 }else
                 {
                     //[SVProgressHUD dismissWithIsOk:NO String:@"无出差记录"];
                 }
             }];
            
            [hbServer release];
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

- (void)dealloc{
    [_orgArray release];
    [_organizationTableView release];
    [super dealloc];
}
@end
