//
//  ManageAttendanceConfigVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-15.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ManageAttendanceConfigVC.h"
#import "SetMapPositionVC.h"

@interface ManageAttendanceConfigVC ()

@end

@implementation ManageAttendanceConfigVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)saveAction{
    NSLog(@"saveAction");
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
    
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setTitle:@"保存" forState:UIControlStateNormal];
    [rbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rbtn.frame = CGRectMake(0, 0, 50, 44);
    [rbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    // 高亮
    [rbtn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [rbtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rbtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    self.configTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-60) style:UITableViewStyleGrouped];
    self.configTableView.delegate = self;
    self.configTableView.dataSource = self;
    [self.view addSubview:self.configTableView];
    
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.location;
            break;
        case 1:
            
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = self.time1;
                    break;
                case 1:
                    cell.textLabel.text = self.time2;
                    break;
                case 2:
                    cell.textLabel.text = self.time3;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                cell.textLabel.text = self.inMinute;
            }else{
                cell.textLabel.text = self.outMinute;
            }
            
            break;
        case 3:
            cell.textLabel.text = self.distance;
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    //[sectionView setBackgroundColor:BlueColor];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    //增加UILabel
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 320, 18)];
    [text setTextColor:[UIColor whiteColor]];
    [text setBackgroundColor:[UIColor clearColor]];
    NSArray *array=[NSArray arrayWithObjects:@"地理位置",@"上班时段",@"打卡时间",@"打卡有效距离",nil];
    [text setText:[array objectAtIndex:section]];
    [text setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    [sectionView addSubview:text];
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
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
    
    //ShowStaffInfomationVC *detailViewController = [[ShowStaffInfomationVC alloc] initWithNibName:@"ShowStaffInfomationVC" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
//    MemberOrgModel *memberIfo = [[MemberOrgModel alloc]init];
//    memberIfo = [self.orgArray objectAtIndex:indexPath.row];
//    NSLog(@"self.orgArray = %@",memberIfo.photoUrl);
//    detailViewController.memberIfo = [self.orgArray objectAtIndex:indexPath.row];
//    detailViewController.unitName = self.unitName;
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    [detailViewController release];
    switch (indexPath.section) {
        case 0:
            NSLog(@"%d",indexPath.section);
            SetMapPositionVC *setVC = [[SetMapPositionVC alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
            [setVC release];
            break;
        case 1:
            NSLog(@"%d",indexPath.section);
            break;
        case 2:
            NSLog(@"%d",indexPath.section);
            break;
        case 3:
            NSLog(@"%d",indexPath.section);
            break;
        default:
            break;
    }
}

- (void)dealloc{
    [_configTableView release];
    [_orgArray release];
    [super dealloc];
}

@end
