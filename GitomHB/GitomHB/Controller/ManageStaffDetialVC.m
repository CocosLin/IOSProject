//
//  ManageStaffDetialVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-24.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ManageStaffDetialVC.h"
#import "ManageStaffDetialCell.h"
#import "MemberOrgModel.h"
#import "HBServerKit.h"
#import "UserManager.h"
#import "ShowStaffInfomationVC.h"//显示员工详细信息界面
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
@interface ManageStaffDetialVC ()

@end

@implementation ManageStaffDetialVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"员工列表";
    }
    return self;
}

#pragma mark - 刷新
- (void)refreshAction{
    NSLog(@"refreshAction - 刷新");
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    [hbKit findOrgunitMembersWithOrganizationId:comData.organization.organizationId
                                      orgunitId:self.orgNumber
                                        Refresh:YES
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
                 memberIfo.telePhone = [dicReports objectForKey:@"telephone"];
                 memberIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                 [mArrReports addObject:memberIfo];
             }
             self.orgArray = mArrReports;
             [self.organizationTableView reloadData];
         }else
         {
             [SVProgressHUD showErrorWithStatus:@"无人员数据"];
         }
     }];

    
    
}
/*
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear - 刷新");
    [super viewWillAppear:animated];
    [self.organizationTableView reloadData];
}*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"刷新" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 50, 44);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    [btn1  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = barButtonItem;

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
 
    
    self.title = @"部门人员";
    self.organizationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-66)];
    [self.organizationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.organizationTableView.delegate = self;
    self.organizationTableView.dataSource = self;
    [self.view addSubview:self.organizationTableView];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:194.0/255.0 green:214.0/255.0 blue:243.0/255.0 alpha:1];
    self.navigationController.navigationItem.leftBarButtonItem.tintColor = BlueColor;
    
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
        [cell.imageView setImageWithURL:[NSURL URLWithString:memberInfo.photoUrl] placeholderImage:[UIImage imageNamed:@"icon_avatar_user.png"]];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        static NSString *CellIdentifier = @"ManageStaffDetialCell";
        ManageStaffDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ManageStaffDetialCell" owner:self options:nil];
            //cell = [[OrganizationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
        
        [cell.headImg setImageWithURL:[NSURL URLWithString:memberInfo.photoUrl] placeholderImage:[UIImage imageNamed:@"icon_avatar_user.png"]];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
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
     ShowStaffInfomationVC *detailViewController = [[ShowStaffInfomationVC alloc] initWithNibName:@"ShowStaffInfomationVC" bundle:nil];
    MemberOrgModel *memberIfo = [[MemberOrgModel alloc]init];
    memberIfo = [self.orgArray objectAtIndex:indexPath.row];
    NSLog(@"self.orgArray = %@",memberIfo.photoUrl);
    detailViewController.memberIfo = [self.orgArray objectAtIndex:indexPath.row];
    detailViewController.unitName = self.unitName;
    [self.navigationController pushViewController:detailViewController animated:YES];
 
}




@end
