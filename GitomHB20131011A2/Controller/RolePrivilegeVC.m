//
//  RolePrivilegeVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "RolePrivilegeVC.h"
#import "HBServerKit.h"

@interface RolePrivilegeVC ()
@end

@implementation RolePrivilegeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.appindStr = [[NSMutableString alloc]init];
        self.title = @"权限编辑";
    }
    return self;
}

#pragma mark -- 保存编辑主管权限
- (void)saveAction{
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit saveRolePrivilegeWithOrganizationId:comData.organization.organizationId andRoleId:2 andOperations:self.appindStr andUpdateUser:comData.userModel.username];
    [hbKit release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //后退
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_On"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    
    //保存
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setTitle:@"保存" forState:UIControlStateNormal];
    [rbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rbtn.frame = CGRectMake(0, 0, 50, 44);
    [rbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    [rbtn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [rbtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rbtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    //列表
    self.configTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-60) style:UITableViewStylePlain];
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
    return 5;
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
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 3;
            break;
        default:
            return 3;
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
            cell.textLabel.text = @"查询员工位置路线";
            break;
        case 1:
            cell.textLabel.text = @"发布部门公告";
            break;
        case 2:
            cell.textLabel.text = @"审核加入部门的申请";
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"编辑员工职位";
                    break;
                case 1:
                    cell.textLabel.text = @"转移员工到别的部门";
                    break;
                case 2:
                    cell.textLabel.text = @"删除员工";
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"修改部门名称";
                    break;
                case 1:
                    cell.textLabel.text = @"修改部门考勤配置";
                    break;
                case 2:
                    cell.textLabel.text = @"修改部门验证方式";
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionView setBackgroundColor:BlueColor];
    //增加UILabel
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 320, 18)];
    [text setTextColor:[UIColor whiteColor]];
    [text setBackgroundColor:[UIColor clearColor]];
    NSArray *array=[NSArray arrayWithObjects:@"记录查询",@"公告发布",@"审核申请",@"管理员工",@"管理部门",nil];
    [text setText:[array objectAtIndex:section]];
    [text setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    [sectionView addSubview:text];
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionDataNumStr;
    sectionDataNumStr = [[NSArray alloc] initWithObjects:
                       [NSArray arrayWithObjects:@"9", nil],
                       [NSArray arrayWithObjects:@"3", nil],
                       [NSArray arrayWithObjects:@"1", nil],
                       [NSArray arrayWithObjects:@"8", @"13", @"4", nil],
                       [NSArray arrayWithObjects:@"12", @"6", @"14", nil],
                       nil];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if ((cell.accessoryType = UITableViewCellEditingStyleNone)) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellEditingStyleNone;
    }
    
    NSLog(@"sectionDataNumStr == %@",[[sectionDataNumStr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
    [self.appindStr appendFormat:@"%@,",[[sectionDataNumStr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    NSLog(@"appindStr == %@",self.appindStr);
    [sectionDataNumStr release];
}
- (void)dealloc{
    [self.appindStr release];
    [self.configTableView release];
    [super dealloc];
}
@end
