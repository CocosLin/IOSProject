//
//  SearcgMemberVC.m
//  GitomHB
//
//  Created by jiawei on 13-12-26.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "SearcgMemberVC.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "HBServerKit.h"
#import "MemberOrgModel.h"
#import "WTool.h"
#import "AttendanceModel.h"
#import "RecordQeryReportsVC.h"
#import "UserPositionsViewController.h"


@interface SearcgMemberVC (){
    NSArray *membersArray;
    BOOL canChickUserPositionLine;

}

@end

@implementation SearcgMemberVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"搜索员工";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GetCommonDataModel;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistStr = [NSString stringWithFormat:@"%@/Members%@.plist",docPath,comData.userModel.username];
    
    membersArray = [NSArray arrayWithContentsOfFile:plistStr];
    NSLog(@"membersArray content == %@ path = %@",membersArray,plistStr);
    
    
    
    // 高亮
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    //搜索框
    self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    self.search.placeholder = @"输入部门成员名称";
    self.search.backgroundColor = BlueColor;
    self.search.delegate = self;
    [self.view addSubview:self.search];
    
    //列表
    self.searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, Screen_Width, Screen_Height-105)];
    [self.searchTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.searchTable.delegate = self;
    self.searchTable.dataSource = self;
    [self.view addSubview:self.searchTable];

}


#pragma mark search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    
//    NSLog(@"%@",searchText);
    if ([searchBar.text isEqualToString:@""]) {
      
        [self.searchTable reloadData];
        return;
    }
    

    /**< 模糊查找*/
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"realname contains[cd] %@",searchBar.text];
    /**< 精确查找*/
    //  NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K == %@", keyName, searchText];
    
    NSLog(@"predicate %@",predicateString);
    
    NSMutableArray  *filteredArray = [NSMutableArray arrayWithArray:[membersArray filteredArrayUsingPredicate:predicateString]];
    
    self.searchAr = filteredArray;
    [self.searchTable reloadData];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.search resignFirstResponder];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"searchA count == %d",self.searchAr.count);
    if (!self.searchAr) {
        return 0;
    }
    return self.searchAr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell");
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    }
    
    NSLog(@"array count = %d",self.searchAr.count);
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",[[self.searchAr objectAtIndex:indexPath.row]objectForKey:@"realname"],[[self.searchAr objectAtIndex:indexPath.row]objectForKey:@"username"]];
    
   
    cell.textLabel.backgroundColor = [UIColor clearColor];
    NSString *roleIdStr = [NSString stringWithFormat:@"%@",[[self.searchAr objectAtIndex:indexPath.row]objectForKey:@"roleId"]];
    if ([roleIdStr isEqualToString:@"1"]) {
        cell.detailTextLabel.text = @"创建者";
    }else if ([roleIdStr isEqualToString:@"2"] ){
        cell.detailTextLabel.text = @"部门主管";
    }else{
        cell.detailTextLabel.text = @"员工";
    }
    cell.detailTextLabel.backgroundColor  = [UIColor clearColor];
    cell.imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_avatar_user.png"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[[self.searchAr objectAtIndex:indexPath.row]objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"icon_avatar_user.png"]];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
    cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - TableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self btnAction:indexPath.row];
    
}

#pragma mark - 部门查询种类
-(void)btnAction:(NSInteger)index
{
    
    GetCommonDataModel;
    NSRange operationRange = [comData.organization.operations rangeOfString:@"9"];
    if (operationRange.location == NSNotFound && comData.organization.roleId != 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询部门"
                                                        message:@"请选择查询类别"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"打卡考勤查询",@"工作汇报查询",@"外出汇报查询",@"出差汇报查询",@"取消",nil];
        
        [alert show];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择查询类别"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"打卡考勤查询",@"工作汇报查询",@"外出汇报查询",@"出差汇报查询",@"位置路线查询[高级版]",@"取消", nil];
        canChickUserPositionLine = YES;
        [alert show];
    }
    
    
    
    self.seledBtIdx = index;
}

#pragma mark - UIAlertView代理方法 (查询的汇报类型：打卡考勤、工作汇报、外出汇报、出差汇报)
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MemberOrgModel *orgMod = [[MemberOrgModel alloc]init];
    orgMod.orgunitId = [[self.searchAr objectAtIndex:self.seledBtIdx] objectForKey:@"orgunitId"];
    orgMod.username = [[self.searchAr objectAtIndex:self.seledBtIdx] objectForKey:@"username"];
    orgMod.realName = [[self.searchAr objectAtIndex:self.seledBtIdx] objectForKey:@"realname"];
    GetCommonDataModel;
    NSDateComponents * componets = [WTool getDateComponentsWithDate:[NSDate date]];
    switch (buttonIndex)
    {
        case 0://打卡考勤查询
        {
            NSLog(@"RecordQeryDetialVC 打卡考勤查询");
            [SVProgressHUD showWithStatus:@"加载工作汇报…"];
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:comData.organization.organizationId
                                                             orgunitId:[orgMod.orgunitId integerValue]
                                                     orgunitAttendance:NO
                                                              userName:orgMod.username
                                                          BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                            EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]FirstReportRecord:0
                                                       MaxReportRecord:10
                                                           RefreshData:YES
                                                         GotArrReports:^(NSArray *arrDicReports, WError *myError) {
                                                             if (arrDicReports.count) {
                                                                 NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                                                                 for (NSDictionary * dicReports in arrDicReports)
                                                                 {
                                                                     
                                                                     NSLog(@"RecordQeryDetialVC realname == %@",dicReports);
                                                                     NSLog(@"RecordQeryDetialVC 444name == %@",[dicReports objectForKey:@"createDate"]);
                                                                     AttendanceModel *repMod = [[AttendanceModel alloc]init];
                                                                     repMod.orgunitId = [[dicReports objectForKey:@"orgunitId"]integerValue];
                                                                     repMod.realName = [dicReports objectForKey:@"realname"];
                                                                     repMod.userName = [dicReports objectForKey:@"username"];
                                                                     repMod.note = [dicReports objectForKey:@"note"];
                                                                     repMod.createTime = [[dicReports objectForKey:@"createTime"]longLongValue];
                                                                     repMod.updateDate = [[dicReports objectForKey:@"createDate"]longLongValue];
                                                                     NSLog(@"RecordQeryDetialVC repMod.createTime == %lld",repMod.createTime);
                                                                     NSLog(@"RecordQeryDetialVC note = %@",repMod.note);
                                                                     [mArrReports addObject:repMod];
                                                                     
                                                                 }
                                                                 NSLog(@"RecordQeryDetialVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                                                                 NSLog(@"RecordQeryDetialVC == 工作汇报查询成功! %@",arrDicReports);
                                                                 RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                                                                 rdVC.playCard = YES;
                                                                 rdVC.personalOrOrgRecod = 1;//1标记号，表示单人打卡数据
                                                                 rdVC.arrData = mArrReports;//存放具体汇报内容的数组
                                                                 rdVC.title = [NSString stringWithFormat:@"%@记录",@"打卡"];
                                                                 rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                                                                 rdVC.orgunitId = orgMod.orgunitId;
                                                                 rdVC.username = orgMod.username;
                                                                 [SVProgressHUD dismissWithSuccess:@"加载成功"];
                                                                 [self.navigationController pushViewController:rdVC animated:YES];
                                                                 
                                                             }else
                                                             {
                                                                 [SVProgressHUD dismissWithIsOk:NO String:@"无记录"];
                                                             }
                                                         }];
            
            break;
        }
        case 1://工作汇报查询
        {
            [SVProgressHUD showWithStatus:@"加载工作汇报…"];
            NSLog(@"工作汇报查询");
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findReportsWithOrganizationId:comData.organization.organizationId
                                          OrgunitId:[orgMod.orgunitId integerValue]
                                           Username:orgMod.username
                                         ReportType:@"REPORT_TYPE_DAY_REPORT"
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
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = REPORT_TYPE_DAY_REPORT;
                     rdVC.userRealname = orgMod.realName;
                     rdVC.username = orgMod.username;
                     //rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId;
                     rdVC.personalOrOrgRecod = 1;
                     
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     //                     ReportModel *mdo = [mArrReports objectAtIndex:0];
                     //                     NSLog(@"mArrReports == %@",mdo.address);
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.realName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                     
                     [SVProgressHUD dismissWithSuccess:@"加载成功"];
                     [self.navigationController pushViewController:rdVC animated:YES];
                     
                 }else
                 {
                     [SVProgressHUD dismissWithIsOk:NO String:@"无工作记录"];
                 }
             }];
            
            
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
                         
                     }
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = REPORT_TYPE_GO_OUT;
                     rdVC.userRealname = orgMod.realName;
                     rdVC.username = orgMod.username;
                     rdVC.orgunitId = orgMod.orgunitId;
                     rdVC.personalOrOrgRecod = 1;
                     
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     //                 ReportModel *mdo = [mArrReports objectAtIndex:0];
                     //                 NSLog(@"mArrReports == %@",mdo.address);
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.realName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                     
                     [SVProgressHUD dismissWithSuccess:@"加载成功"];
                     [self.navigationController pushViewController:rdVC animated:YES];
                     
                 }else
                 {
                     [SVProgressHUD dismissWithIsOk:NO String:@"无外出记录"];
                 }
             }];
            
            
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
                         
                     }
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = REPORT_TYPE_TRAVEL;
                     rdVC.userRealname = orgMod.realName;
                     rdVC.username = orgMod.username;
                     //rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId;
                     rdVC.personalOrOrgRecod = 1;
                     
                     
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     //                     ReportModel *mdo = [mArrReports objectAtIndex:0];
                     //                     NSLog(@"mArrReports == %@",mdo.address);
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.realName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                     
                     //[SVProgressHUD dismissWithSuccess:@"加载成功"];
                     [self.navigationController pushViewController:rdVC animated:YES];
                     
                 }else
                 {
                     //[SVProgressHUD dismissWithIsOk:NO String:@"无出差记录"];
                 }
             }];
            
            
            break;
        }
        case 4://位置路线查询
        {
            //如果不是高级版本
            if (![comData.organization.appLevelCode isEqualToString:kAdvance]) {
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"功能未购买" message:@"您当前使用的版本是[标准版]，如果想使用此功能，请让创建者购买更高级的版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [aler show];
                return;
            }
            if (canChickUserPositionLine) {
                
                //UserPositionLineVC *linkMap = [[UserPositionLineVC alloc]init];
                UserPositionsViewController *linkMap = [[UserPositionsViewController alloc]init];
                linkMap.username = orgMod.username;
                [self.navigationController pushViewController:linkMap animated:YES];
            }else{
                return;
            }
            break;
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
