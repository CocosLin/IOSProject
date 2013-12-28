//
//  ManageStaffVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-10.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ManageStaffVC.h"
//#import "ManageStaffCell.h"
#import "OrganizationsModel.h"//部门信息类
#import "MemberOrgModel.h"//部门员工信息类
#import "HBServerKit.h"//post获得服务器json数据
#import "ManageStaffDetialVC.h"
#import "SVProgressHUD.h"
#import "KxMenu.h"
#import "SearchStaffVC.h"

@interface ManageStaffVC ()

@end

@implementation ManageStaffVC{
    NSMutableDictionary *d;
}

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
    [btn1 setTitle:nil forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 50, 44);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_On.png"] forState:UIControlStateNormal];
    [btn1  setBackgroundImage:[UIImage imageNamed:@"btnMoreFromNavigationBar_Off.png"] forState:UIControlStateHighlighted];
//    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
//    [btn1  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = barButtonItem;
 
    
    self.manageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-66)];
    self.manageTableView.delegate = self;
    self.manageTableView.dataSource = self;
    [self.manageTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.manageTableView];
    
    OrganizationsModel *orgModel = [[OrganizationsModel alloc]init];
    orgModel = [self.orgArray objectAtIndex:0];
    NSLog(@"[self.orgArray objectAtIndex:0]%@  %@",[[self.orgArray objectAtIndex:0] organizationName],orgModel.organizationName);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 刷新
- (void)refreshAction:(UIButton *)sender{
    NSLog(@"refreshAction - 刷新");
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
                 menuItems:menuItems];
    
    /*
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
    */
    
    
    
}

#pragma mark -- 选择菜单
- (void) pushMenuItem:(KxMenuItem *)sender
{
    NSLog(@"%@", sender.title);
    GetCommonDataModel;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistStr = [NSString stringWithFormat:@"%@/Members%@.plist",docPath,comData.userModel.username];
    
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
                [self.manageTableView reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:@"无部门"];
            }
        }];
        
        
    }else if ([sender.title isEqualToString:@"加载员工"]){
        
        NSLog(@"加载员工");
        GetCommonDataModel;
        
        if( [[NSFileManager defaultManager] fileExistsAtPath:plistStr]==NO ) {
            
            
            HBServerKit *hbKit = [[HBServerKit alloc]init];
            [hbKit findOrgunitMembersWithOrganizationId:comData.organization.organizationId
                                              orgunitId:comData.organization.orgunitId
                                                Refresh:YES
                                          GotArrReports:^(NSArray *arrDicReports, WError *myError)
             {
                 
                 if (arrDicReports.count) {
                     NSLog(@"RecordQeryVC 数组循环次数 ==  %d",arrDicReports.count);
                     NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                     for (NSDictionary * dicReports in arrDicReports)
                     {
                         
                         [mArrReports addObject:dicReports];
                     }
                     
                     [[NSFileManager defaultManager] createFileAtPath:[docPath stringByAppendingPathComponent:plistStr] contents:nil attributes:nil];
                     
                     [mArrReports writeToFile:plistStr atomically:YES ];
                     NSLog(@"membersIfo.plist path == %@",docPath);
                 }
             }];
            
        }else{
            
            [SVProgressHUD showSuccessWithStatus:@"已加载"];
            
        }
        
        
        
    }else if ([sender.title isEqualToString:@"搜索员工"]){
        
        NSLog(@"搜索员工");
        
        NSLog(@"RecordQeryVC path = %@",plistStr);
        if ([[NSFileManager defaultManager] fileExistsAtPath:plistStr]== NO) {
            
            [SVProgressHUD showErrorWithStatus:@"请先加载员工" duration:0.7];
            
        }else{
            SearchStaffVC *searVC = [[SearchStaffVC alloc]init];
            [self.navigationController pushViewController:searVC animated:YES];
            
        }
        
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
    static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[self.orgArray objectAtIndex:indexPath.row] organizationName];
        cell.imageView.image = [UIImage imageNamed:@"btn_list_extra_arrow.png"];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        return cell;
    /*if ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0) {*/
        
    /*}else{
        static NSString *CellIdentifier = @"ManageStaffCell";
        ManageStaffCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ManageStaffCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.orgName.text = [[self.orgArray objectAtIndex:indexPath.row] organizationName];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        return cell;
    }*/
    
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
    //[SVProgressHUD showWithStatus:@"加载部门数据…"];
    
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    OrganizationsModel *organization = [[OrganizationsModel alloc]init];
    organization = [self.orgArray objectAtIndex:indexPath.row];
    NSString *orgIdStr = organization.orgunitId;
    NSInteger intS = [orgIdStr intValue];
    [hbKit findOrgunitMembersWithOrganizationId:comData.organization.organizationId
                                      orgunitId:intS
                                        Refresh:YES
                                  GotArrReports:^(NSArray *arrDicReports, WError *myError)
     {
         if (arrDicReports.count) {
             NSLog(@"RecordQeryVC 数组循环次数 ==  %d",arrDicReports.count);
             NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
             for (NSDictionary * dicReports in arrDicReports)
             {

                 NSLog(@"RecordQeryVC ReportManager 获得数据内容 == %@",dicReports);

                 MemberOrgModel *memberIfo = [[MemberOrgModel alloc]init];
                 memberIfo.realName = [dicReports objectForKey:@"realname"];
                 memberIfo.username = [dicReports objectForKey:@"username"];
                 memberIfo.roleId = [dicReports objectForKey:@"roleId"];
                 memberIfo.photoUrl = [dicReports objectForKey:@"photo"];
                 memberIfo.telePhone = [dicReports objectForKey:@"telephone"];
                 memberIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                 [mArrReports addObject:memberIfo];
  
             }
             
             NSLog(@"RecordQeryVC 获取部门成员信息成功! %@",mArrReports);
             ManageStaffDetialVC *detailViewController = [[ManageStaffDetialVC alloc] initWithNibName:nil bundle:nil];
             detailViewController.orgArray = mArrReports;
             detailViewController.unitName = [[self.orgArray objectAtIndex:indexPath.row] organizationName];
             detailViewController.orgNumber = intS;
             
             [self.navigationController pushViewController:detailViewController animated:YES];
  
         }else
         {
             //[SVProgressHUD dismissWithIsOk:NO String:@"无人员数据"];
         }
     }];
}


@end
