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
@interface ManageStaffDetialVC ()

@end

@implementation ManageStaffDetialVC

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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_On"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    
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
{/*
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
  }
  // Configure the cell...
  cell.textLabel.text = [[self.orgArray objectAtIndex:indexPath.row] organizationName];*/
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
    //只要设置了图片地址，就去下载图片
    UserManager * um = [UserManager sharedUserManager];
    
    if (memberInfo.photoUrl != nil) {
        [um getUserPhotoImageWithStrUserPhotoUrl:memberInfo.photoUrl GotResult:^(UIImage *imgUserPhoto, BOOL isOK)
         {
             if (isOK)
             {
                 //_imgUserPhoto = imgUserPhoto;
                 cell.headImg.image = imgUserPhoto;
             }
         }];
    }
    cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
    cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
    return cell;
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

     ShowStaffInfomationVC *detailViewController = [[ShowStaffInfomationVC alloc] initWithNibName:@"ShowStaffInfomationVC" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    MemberOrgModel *memberIfo = [[MemberOrgModel alloc]init];
    memberIfo = [self.orgArray objectAtIndex:indexPath.row];
    NSLog(@"self.orgArray = %@",memberIfo.photoUrl);
     detailViewController.memberIfo = [self.orgArray objectAtIndex:indexPath.row];
    detailViewController.unitName = self.unitName;
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
    
}


- (void)dealloc{
    [_orgArray release];
    [_organizationTableView release];
    [_unitName release];
    [super dealloc];
}


@end
