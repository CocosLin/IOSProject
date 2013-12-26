//
//  RecordQeryVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-10.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "RecordQeryVC.h"
//#import "OrganizationCell.h"
#import "HBServerKit.h"
#import "OrganizationsModel.h"//部门信息
#import "MemberOrgModel.h"//部门成员信息
#import "RecordQeryDetialVC.h"
#import "SVProgressHUD.h"

#import "RecordQeryReportsVC.h"
#import "WTool.h"
#import "ReportModel.h"
#import "AttendanceModel.h"

#import "KxMenu.h"

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
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"刷新" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 50, 44);
    /*
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_On.png"] forState:UIControlStateNormal];
    [btn1  setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_Off.png"] forState:UIControlStateHighlighted];*/
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    [btn1  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = barButtonItem;
  
    
	// Do any additional setup after loading the view.
    self.organizationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-66)];
    [self.organizationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.organizationTableView.delegate = self;
    self.organizationTableView.dataSource = self;
    [self.view addSubview:self.organizationTableView];
//    OrganizationsModel *orgModel = [[OrganizationsModel alloc]init];
//    orgModel = [self.orgArray objectAtIndex:0];
//    NSLog(@"[self.orgArray objectAtIndex:0]%@  %@  [[self.orgArray objectAtIndex:indexPath.row]orgunitId]%@",[[self.orgArray objectAtIndex:0] organizationName],orgModel.organizationName,orgModel.orgunitId);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新
- (void)refreshAction:(UIButton *)sender{
    
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
                orgIfo.orgunitName = [dicReports objectForKey:@"name"];
                orgIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                orgIfo.organizationId = [dicReports objectForKey:@"organizationId"];
                [mArrReports addObject:orgIfo];
                
            }
            self.orgArray = mArrReports;
            [self.organizationTableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"无部门"];
        }
    }];
    /*为AppStore准备
    NSArray *menuItems =
    @[
      
      
      [KxMenuItem menuItem:@"刷新列表"
                     image:[UIImage imageNamed:@"reload"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"加载员工"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],

      [KxMenuItem menuItem:@"搜索员工"
                     image:[UIImage imageNamed:@"search_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],

      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(sender.frame.origin.x, sender.frame.origin.y-40, sender.frame.size.width, sender.frame.size.height)
                 menuItems:menuItems];*/
}


#pragma mark -- 选择菜单
- (void) pushMenuItem:(KxMenuItem *)sender
{
    NSLog(@"%@", sender.title);
    
    if ([sender.title isEqualToString:@"刷新列表"]) {
        
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
                    orgIfo.orgunitName = [dicReports objectForKey:@"name"];
                    orgIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                    orgIfo.organizationId = [dicReports objectForKey:@"organizationId"];
                    [mArrReports addObject:orgIfo];
                    
                }
                self.orgArray = mArrReports;
                [self.organizationTableView reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:@"无部门"];
            }
        }];
        
        
    }else if ([sender.title isEqualToString:@"加载员工"]){
        
        NSLog(@"加载员工");
        NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *docPath = [ doc objectAtIndex:0 ];
        
        if( [[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingPathComponent:@"OrgunitMembers.plist"]]==NO ) {
            
            GetCommonDataModel;
            HBServerKit *hbKit = [[HBServerKit alloc]init];
            [hbKit findOrgunitMembersWithOrganizationId:comData.organization.organizationId
                                              orgunitId:comData.organization.orgunitId
                                                Refresh:NO
                                          GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 if (arrDicReports.count) {
                     NSLog(@"RecordQeryVC 数组循环次数 ==  %d",arrDicReports.count);
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         MemberOrgModel *memberIfo = [[MemberOrgModel alloc]init];
                         memberIfo.realName = [dicReports objectForKey:@"realname"];
                         memberIfo.username = [dicReports objectForKey:@"username"];
                         memberIfo.roleId = [dicReports objectForKey:@"roleId"];
                         memberIfo.photoUrl = [dicReports objectForKey:@"photo"];
                         memberIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                         [mArrReports addObject:memberIfo];
                     }
                     
                     NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     
                     NSString *docPath = [ doc objectAtIndex:0 ];
                     
                     [mArrReports writeToFile:[docPath stringByAppendingPathComponent:@"OrgunitMembers.plist"] atomically:YES ];
                     NSLog(@"membersIfo.plist path == %@",docPath);
                 }
             }];
           
            
            
            
            
        }
        
        
    }else if ([sender.title isEqualToString:@"搜索员工"]){
        
        NSLog(@"搜索员工");
        
    }
    
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
    
    OrganizationsModel *orgaMod = [[OrganizationsModel alloc ]init];
    orgaMod = [self.orgArray objectAtIndex:indexPath.row] ;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }//275,5
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = indexPath.row +100;
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_On.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_Off.png"] forState:UIControlStateHighlighted];
    [cell addSubview:rightBtn];
    rightBtn.frame = CGRectMake(Screen_Width-45, 5, 42, 35);
    [rightBtn addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.textLabel.text = orgaMod.orgunitName;
    NSLog(@"cell orgMod == %@ %@",orgaMod.orgunitId,orgaMod.orgunitName);
    cell.imageView.image = [UIImage imageNamed:@"btn_list_extra_arrow.png"];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
    cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
    return cell;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0) {//系统版本
    
    /*}else{
        static NSString *CellIdentifier = @"OrganizationCell";
        OrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OrganizationCell" owner:self options:nil];
            //cell = [[OrganizationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = [nib objectAtIndex:0];
        }
        cell.organizationName.text = orgaMod.orgunitName;
        NSLog(@"cell orgMod == %@ %@",orgaMod.orgunitId,orgaMod.orgunitName);
        cell.reportBtu.tag = indexPath.row +100;
        [cell.reportBtu addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        return cell;
    }*/

    
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
    GetCommonDataModel;
    OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
    orgMod = [self.orgArray objectAtIndex:index];
    NSLog(@"orgMod == %@",orgMod.orgunitId);
    
    if (comData.organization.roleId == 1 || [orgMod.orgunitId integerValue]== comData.organization.orgunitId) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询部门"
                                                        message:@"请选择查询类别"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"打卡考勤查询",@"工作汇报查询",@"外出汇报查询",@"出差汇报查询",@"取消", nil];
        self.seledBtIdx = index;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您不能查看其他部门汇报" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UIAlertView代理方法 (查询的汇报类型：打卡考勤、工作汇报、外出汇报、出差汇报)
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    OrganizationsModel *orgMod = [self.orgArray objectAtIndex:self.seledBtIdx];
    NSLog(@"OrganizationsModel *orgMod %@ %@",orgMod.orgunitId,orgMod.orgunitName);
    
    NSDateComponents * componets = [WTool getDateComponentsWithDate:[NSDate date]];
    //GetCommonDataModel;
    switch (buttonIndex)
    {
        case 0://打卡考勤查询
        {
            NSLog(@"打卡考勤查询");
            //[SVProgressHUD showWithStatus:@"加载工作汇报…"];
            NSLog(@"工作汇报查询");
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findAttendanceReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]
                                                             orgunitId:[orgMod.orgunitId integerValue]orgunitAttendance:YES
                                                              userName:@"123"
                                                          BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                            EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
                                                     FirstReportRecord:0
                                                       MaxReportRecord:10
                                                           RefreshData:NO
                                                         GotArrReports:^(NSArray *arrDicReports, WError *myError) {
                if (arrDicReports.count) {
                    NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                    for (NSDictionary * dicReports in arrDicReports)
                    {
                        NSLog(@"RecordQeryVC realname == %@",dicReports);
                        NSLog(@"RecordQeryVC 444name == %@",[dicReports objectForKey:@"createDate"]);
                        AttendanceModel *repMod = [[AttendanceModel alloc]init];
                        repMod.realName = [dicReports objectForKey:@"realname"];
                        repMod.userName = [dicReports objectForKey:@"username"];
                        repMod.note = [dicReports objectForKey:@"note"];
                        repMod.createTime = [[dicReports objectForKey:@"createTime"]longLongValue];
                        repMod.updateDate = [[dicReports objectForKey:@"createDate"]longLongValue];
                         
                        
                        NSLog(@"RecordQeryVC note = %@",repMod.note);
                        [mArrReports addObject:repMod];
            
                    }
                    NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                    NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                    RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                    rdVC.playCard = YES;
                    rdVC.arrData = mArrReports;//存放具体汇报内容的数组
                    rdVC.title = [NSString stringWithFormat:@"%@记录",@"打卡"];
                    rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);//[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day-1)*24*60*60*1000);
                    rdVC.orgunitId = orgMod.orgunitId;
                    //[SVProgressHUD dismissWithSuccess:@"加载成功"];
                    [self.navigationController pushViewController:rdVC animated:YES];
               
                    
                    [SVProgressHUD dismissWithSuccess:@"加载成功"];
                }else
                {
                    [hbServer findAttendanceReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]
                                                                     orgunitId:[orgMod.orgunitId integerValue]orgunitAttendance:YES
                                                                      userName:@"123"
                                                                  BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                                    EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]FirstReportRecord:0
                                                               MaxReportRecord:10
                                                                   RefreshData:YES
                                                                 GotArrReports:^(NSArray *arrDicReports, WError *myError) {
               if (arrDicReports.count) {
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                   for (NSDictionary * dicReports in arrDicReports)
                          {
                                         AttendanceModel *repMod = [[AttendanceModel alloc]init];
                                         repMod.realName = [dicReports objectForKey:@"realname"];
                                         repMod.userName = [dicReports objectForKey:@"username"];
                                         repMod.note = [dicReports objectForKey:@"note"];
                                         repMod.createTime = [[dicReports objectForKey:@"createDate"]longLongValue];
                                         [mArrReports addObject:repMod];
                 
                                                                         }
                                RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                                rdVC.playCard = YES;
                                rdVC.arrData = mArrReports;//存放具体汇报内容的数组
                                rdVC.title = [NSString stringWithFormat:@"%@记录",@"打卡"];
                                rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                                rdVC.orgunitId = orgMod.orgunitId;
                                [self.navigationController pushViewController:rdVC animated:YES];
                   
                                [SVProgressHUD dismissWithSuccess:@"加载成功"];
                    }else
                    {
                    nil;
                    }
                }];
                }
            }];
  
            break;
        }
        case 1://工作汇报查询
        {
            //[SVProgressHUD showWithStatus:@"加载工作汇报…"];
            NSLog(@"工作汇报查询");
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findOrgunitReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]
                                                          orgunitId:[orgMod.orgunitId integerValue]
                                                         ReportType:@"REPORT_TYPE_DAY_REPORT"
                                                       BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                         EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
                                                  FirstReportRecord:0
                                                    MaxReportRecord:10
                                                        RefreshData:NO
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
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = @"REPORT_TYPE_DAY_REPORT";
                     rdVC.userRealname = orgMod.orgunitName;
                     rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId; 
 
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.orgunitName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);//[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day-1)*24*60*60*1000);
                     
                     //[SVProgressHUD dismissWithSuccess:@"加载成功"];
                     [self.navigationController pushViewController:rdVC animated:YES];
         
                 }else
                 {
                     [hbServer findOrgunitReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]
                                                                   orgunitId:[orgMod.orgunitId integerValue]
                                                                  ReportType:@"REPORT_TYPE_DAY_REPORT"
                                                                BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                                  EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
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
                              RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                              rdVC.arrData = arrDicReports;//存放公司信息的数组
                              rdVC.strTypeRecord = @"REPORT_TYPE_DAY_REPORT";
                              rdVC.userRealname = orgMod.orgunitName;
                              rdVC.organizationId = orgMod.organizationId;
                              rdVC.orgunitId = orgMod.orgunitId;
                              
                              rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                              rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.orgunitName];
                              rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                              [self.navigationController pushViewController:rdVC animated:YES];
                 
                          }else
                          {
                              nil;
                          }
                      }];
                 }
             }];
            
        
            break;
        }
        case 2://外出汇报查询
        {
            NSLog(@"外出汇报查询");
            //[SVProgressHUD showWithStatus:@"加载工作汇报…"];
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findOrgunitReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]
                                                          orgunitId:[orgMod.orgunitId integerValue]
                                                         ReportType:@"REPORT_TYPE_GO_OUT"
                                                       BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                         EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
                                                  FirstReportRecord:0
                                                    MaxReportRecord:10
                                                        RefreshData:NO
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
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = @"REPORT_TYPE_GO_OUT";
                     rdVC.userRealname = orgMod.orgunitName;
                     rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId;
                     
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.orgunitName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                     [self.navigationController pushViewController:rdVC animated:YES];
         
                 }else
                 {
                     [hbServer findOrgunitReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]
                                                                   orgunitId:[orgMod.orgunitId integerValue]
                                                                  ReportType:@"REPORT_TYPE_GO_OUT"
                                                                BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                                  EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
                                                           FirstReportRecord:0
                                                             MaxReportRecord:10
                                                                 RefreshData:YES
                                                               GotArrReports:^(NSArray *arrDicReports, WError *myError)
                      {
                          if (arrDicReports.count) {
                              NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                              for (NSDictionary * dicReports in arrDicReports)
                              {
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
                              RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                              rdVC.arrData = arrDicReports;//存放公司信息的数组
                              rdVC.strTypeRecord = @"REPORT_TYPE_GO_OUT";
                              rdVC.userRealname = orgMod.orgunitName;
                              rdVC.organizationId = orgMod.organizationId;
                              rdVC.orgunitId = orgMod.orgunitId;
                              
                              rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                              rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.orgunitName];
                              rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                              [self.navigationController pushViewController:rdVC animated:YES];
                 
                          }else
                          {
                              nil;
                          }
                      }];

                 }
             }];
            
       
            break;
        }
        case 3://出差汇报查询
        {
            NSLog(@"出差汇报查询");
            //[SVProgressHUD showWithStatus:@"加载工作汇报…"];
            HBServerKit *hbServer = [[HBServerKit alloc]init];
            [hbServer findOrgunitReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]
                                                          orgunitId:[orgMod.orgunitId integerValue]
                                                         ReportType:@"REPORT_TYPE_TRAVEL"
                                                       BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                         EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
                                                  FirstReportRecord:0
                                                    MaxReportRecord:10
                                                        RefreshData:NO
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
                     NSLog(@"RecordQeryVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                     NSLog(@"RecordQeryVC == 工作汇报查询成功! %@",arrDicReports);
                     RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                     rdVC.arrData = arrDicReports;//存放公司信息的数组
                     rdVC.strTypeRecord = @"REPORT_TYPE_TRAVEL";
                     rdVC.userRealname = orgMod.orgunitName;
                     rdVC.organizationId = orgMod.organizationId;
                     rdVC.orgunitId = orgMod.orgunitId;
                     
                     rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                     rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.orgunitName];
                     rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                     [self.navigationController pushViewController:rdVC animated:YES];
    
                 }else
                 {
                     [hbServer findOrgunitReportsOfMembersWithOrganizationId:[orgMod.organizationId integerValue]
                                                                   orgunitId:[orgMod.orgunitId integerValue]
                                                                  ReportType:@"REPORT_TYPE_TRAVEL"
                                                                BeginDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000)
                                                                  EndDateLli:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
                                                           FirstReportRecord:0
                                                             MaxReportRecord:10
                                                                 RefreshData:YES
                                                               GotArrReports:^(NSArray *arrDicReports, WError *myError)
                      {
                          if (arrDicReports.count) {
                              NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                              for (NSDictionary * dicReports in arrDicReports)
                              {
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
                                  [mArrReports addObject:repMod];
   
                              }
                              RecordQeryReportsVC *rdVC= [[RecordQeryReportsVC alloc]init];
                              rdVC.arrData = arrDicReports;//存放公司信息的数组
                              rdVC.strTypeRecord = @"REPORT_TYPE_TRAVEL";
                              rdVC.userRealname = orgMod.orgunitName;
                              rdVC.organizationId = orgMod.organizationId;
                              rdVC.orgunitId = orgMod.orgunitId;
                              
                              rdVC.reportArrData = mArrReports;//存放具体汇报内容的数组
                              rdVC.title = [NSString stringWithFormat:@"%@记录",orgMod.orgunitName];
                              rdVC.dtBegin = [WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.month)*30*24*60*60*1000);
                              [self.navigationController pushViewController:rdVC animated:YES];
       
                          }else
                          {
                              nil;
                          }
                      }];
                 }
             }];
     
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
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    
    OrganizationsModel *organization = [[OrganizationsModel alloc]init];
    
    organization = [self.orgArray objectAtIndex:indexPath.row];
    NSString *orgIdStr = organization.orgunitId;
    NSInteger orgNumber = [orgIdStr intValue];
    
    if (comData.organization.roleId == 1 || [organization.orgunitId integerValue]== comData.organization.orgunitId) {
    
        [hbKit findOrgunitMembersWithOrganizationId:comData.organization.organizationId
                                          orgunitId:orgNumber
                                            Refresh:NO
                                      GotArrReports:^(NSArray *arrDicReports, WError *myError)
         {
             if (arrDicReports.count) {
                 NSLog(@"RecordQeryVC 数组循环次数 ==  %d",arrDicReports.count);
                 NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                 for (NSDictionary * dicReports in arrDicReports)
                 {
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
                 detailViewController.orgNumber = orgNumber;
                 [self.navigationController pushViewController:detailViewController animated:YES];
              }
         }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您不能查看其他部门汇报" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void) passToNestView{
    
}


@end
