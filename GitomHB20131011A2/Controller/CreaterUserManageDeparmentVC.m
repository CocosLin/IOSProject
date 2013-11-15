//
//  CreaterUserManageDeparmentVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-15.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "CreaterUserManageDeparmentVC.h"
#import "HBServerKit.h"
#import "OrganizationsModel.h"
#import "SVProgressHUD.h"
#import "ManageDepartmentVC.h"
#import "ManageStaffCell.h"

@interface CreaterUserManageDeparmentVC ()

@end

@implementation CreaterUserManageDeparmentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"部门列表";
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
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    [btn1  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    self.manageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-111)];
    self.manageTableView.delegate = self;
    self.manageTableView.dataSource = self;
    [self.manageTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.manageTableView];
    
    OrganizationsModel *orgModel = [[OrganizationsModel alloc]init];
    orgModel = [self.orgArray objectAtIndex:0];
    NSLog(@"[self.orgArray objectAtIndex:0]%@  %@",[[self.orgArray objectAtIndex:0] organizationName],orgModel.organizationName);
    
    
    //新建部门按钮
    UIButton * btnSaveReoprt = [UIButton buttonWithType:0];
    btnSaveReoprt.tag = 1002;
    [btnSaveReoprt setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btnSaveReoprt  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [btnSaveReoprt setTitle:@"新增部门" forState:UIControlStateNormal];
    [btnSaveReoprt setFrame:CGRectMake(5, Height_Screen-111, Width_Screen - 10, 45)];
    [btnSaveReoprt addTarget:self action:@selector(addOrgunitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSaveReoprt];
    
    //[self showTableViews];
}

- (void)addOrgunitAction:(id)sender
{
    UIAlertView *addOrgNameAler = [[UIAlertView alloc]initWithTitle:@"部门名称" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    addOrgNameAler.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *nameText = [addOrgNameAler textFieldAtIndex:0];
    nameText.placeholder = @"为您的部门命名";
    [addOrgNameAler show];
    [addOrgNameAler release];
}

#pragma mark - UIAlerView代理方法
- (void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    UITextField *tf = [[UITextField alloc]init];
    tf=[alertView textFieldAtIndex:0];
    
    NSString * orgNameString = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)tf.text, NULL, NULL,  kCFStringEncodingUTF8 );
    switch (buttonIndex) {
        case 0:
        {
            [hbKit addOrgunitWithrganitzationId:comData.organization.organizationId
                                 andOrgunitName:orgNameString
                                    andUsername:comData.userModel.username];
            [self refreshAction];
        }
            break;
        default:
            break;
    }
    [hbKit release];
    
}

- (void)refreshAction{
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    [hbKit findReportsWithOrganizationId:comData.organization.organizationId Refresh:YES GotArrReports:^(NSArray *arrDicReports, WError *myError) {
        if (arrDicReports.count) {
            NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
            for (NSDictionary * dicReports in arrDicReports)
            {
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

}

- (void)showTableViews{
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    [hbKit findReportsWithOrganizationId:comData.organization.organizationId Refresh:NO GotArrReports:^(NSArray *arrDicReports, WError *myError) {
        if (arrDicReports.count) {
            NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
            for (NSDictionary * dicReports in arrDicReports)
            {
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[self.orgArray objectAtIndex:indexPath.row] orgunitName];
        cell.imageView.image = [UIImage imageNamed:@"btn_list_extra_arrow.png"];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
        cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
        return cell;
    }else{
        static NSString *CellIdentifier = @"ManageStaffCell";
        ManageStaffCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ManageStaffCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.orgName.text = [[self.orgArray objectAtIndex:indexPath.row] orgunitName];
        cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
        cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
        return cell;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"CreaterUserManageDeparmentVC indexPath.row == %d",indexPath.row);
    OrganizationsModel *orgMod = [self.orgArray objectAtIndex:indexPath.row];
    NSLog(@"orgMod.orgunitName ==  %@ %@",orgMod.orgunitId,orgMod.orgunitName);
    ManageDepartmentVC *vc = [[ManageDepartmentVC alloc]init];
    vc.title = @"管理部门";
    vc.orgMod = orgMod;
    vc.createrUser = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
