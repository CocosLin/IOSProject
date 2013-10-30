//
//  ManageDepartmentVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-10.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ManageDepartmentVC.h"
#import "SVProgressHUD.h"
#import "ManageAttendanceConfigVC.h"
#import "HBServerKit.h"
#import "WTool.h"
#import "RolePrivilegeVC.h"

@interface ManageDepartmentVC (){
    UITableView *_settingTableView;
    UILabel *_lblRecordPromptUserInfo;
}

@end

@implementation ManageDepartmentVC




#pragma mark - 生命周期
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
    
    [self initRecordPromptInfo];

    self.arrSet = [NSArray arrayWithObjects:@"修改部门名称",@"修改考勤配置",@"修改验证方式",@"修改员工位置上传时间间隔",@"编辑主管权限",@"删除部门", nil];
    GetCommonDataModel;
    if (comData.organization.roleId == 1) {
        NSLog(@"创建者权限");
    }if (comData.organization.roleId == 2) {
        NSLog(@"管理者权限");
    }
    _settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, Screen_Width, Screen_Height-40) style:UITableViewStyleGrouped];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    [self.view addSubview:_settingTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_arrSet release];
    [super dealloc];
}


#pragma mark - 提示信息
-(void)initRecordPromptInfo
{
    CGFloat hViewRecordPromptInfo = 40;
    UIView * viewRecordPromptInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, hViewRecordPromptInfo)];
    [viewRecordPromptInfo setBackgroundColor:BlueColor];
    
    _lblRecordPromptUserInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, hViewRecordPromptInfo)];
    [viewRecordPromptInfo addSubview:_lblRecordPromptUserInfo];
    _lblRecordPromptUserInfo.textAlignment = NSTextAlignmentCenter;
    _lblRecordPromptUserInfo.textColor = [UIColor blackColor];
    [_lblRecordPromptUserInfo setFont:[UIFont systemFontOfSize:20]];
    
    NSString *recordType = [[NSString alloc]init];
    GetCommonDataModel;
    _lblRecordPromptUserInfo.text = [NSString stringWithFormat:@"当前部门:%@",comData.userModel.unitName];
    [recordType release];
    [_lblRecordPromptUserInfo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewRecordPromptInfo];
    
    [viewRecordPromptInfo release];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrSet.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    cell.textLabel.text = [self.arrSet objectAtIndex:indexPath.row];
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
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    if (indexPath.row == 0) {
        NSLog(@"修改部门名称");
        configType = 0;
        //http://hb.m.gitom.com/3.0/organization/updateOrgunit?organizationId=204&orgunitId=16&username=58200&name=WTO&cookie=5533098A-43F1-4AFC-8641-E64875461345
        UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"修改部门名称" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        changeOrgNameAler.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *nameText = [changeOrgNameAler textFieldAtIndex:0];
        nameText.placeholder = comData.userModel.unitName;
        
        [changeOrgNameAler show];
        
        [changeOrgNameAler release];
    }if (indexPath.row ==1) {
        NSLog(@"修改考勤配置");
        ManageAttendanceConfigVC *manageVC = [[ManageAttendanceConfigVC alloc]init];
        [self.navigationController pushViewController:manageVC animated:YES];
        [manageVC release];
    }if (indexPath.row == 2) {
        NSLog(@"修改验证方式");
        [SVProgressHUD showErrorWithStatus:@"无该功能,期待下一版本"];
    }if (indexPath.row ==3) {
        NSLog(@"修改上传时间间隔");
        configType = 3;
        UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"间隔时长（1-30）分钟" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        changeOrgNameAler.alertViewStyle = UIAlertViewStylePlainTextInput;
        [changeOrgNameAler show];
        [changeOrgNameAler release];
    }if (indexPath.row == 4) {
        NSLog(@"编辑主管权限");
        RolePrivilegeVC *nv = [[RolePrivilegeVC alloc]init];
        [self.navigationController pushViewController:nv animated:YES];
    }if (indexPath.row == 5) {
        NSLog(@"删除部门");
        configType = 5;
        UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除部门？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        [changeOrgNameAler show];
        [changeOrgNameAler release];
    }
    [hbKit release];
}
- (void)willPresentAlertView:(UIAlertView *)alertView{
    
}
#pragma mark - UIAlerView代理方法
- (void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    UITextField *tf = [[UITextField alloc]init];
    if (configType == 5) {
        nil;
    }else{
        //得到输入框
        tf=[alertView textFieldAtIndex:0];
    }
    
    NSString * orgNameString = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)tf.text, NULL, NULL,  kCFStringEncodingUTF8 );
    switch (buttonIndex) {
        case 0:
        {
            if (configType == 5) {
                [hbKit deleteOrgunitWithOrganizationId:comData.organization.organizationId andOrgunitId:comData.organization.orgunitId andUpdateUser:comData.userModel.username];
            }else if (configType == 3){
                if (tf.text.length > 0) {
                    NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/util/saveUploadLocationTime?organizationId=%ld&orgunitId=%ld&time==%@&updateUser=%@&cookie=%@",(long)comData.organization.organizationId,(long)comData.organization.orgunitId,orgNameString,comData.userModel.username,comData.cookie];
                    NSLog(@"ManageDepartmentVC url = %@ ||ManageDepartmentVC UrlStr %@",changeRoleUrlStr,tf.text);
                    NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
                    NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
                    [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"时间间隔不能为空!"];
                }
            }
            else{
                if (tf.text.length > 0) {
                    NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/updateOrgunit?organizationId=%ld&orgunitId=%ld&username=%@&name=%@&cookie=%@",(long)comData.organization.organizationId,(long)comData.organization.orgunitId,comData.userModel.username,orgNameString,comData.cookie];
                    NSLog(@"ManageDepartmentVC url = %@ ||ManageDepartmentVC UrlStr %@",changeRoleUrlStr,tf.text);
                    NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
                    NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
                    [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"部门名称不能设置为空!"];
                }
            }
            
        }
            break;
            
        default:
            break;
    }
    [hbKit release];
}

@end
