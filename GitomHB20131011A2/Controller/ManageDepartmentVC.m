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
    if (self.createrUser == YES) {//创建者帐号操作重新定制按钮
        //返回按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 50, 44);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
        [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [self.navigationItem setLeftBarButtonItem:backItem];
        [backItem release];
    }
    
    
    [self initRecordPromptInfo];

    self.arrSet = [NSArray arrayWithObjects:@"修改部门名称",@"修改考勤配置",@"修改验证方式",@"位置上传时间间隔",@"编辑主管权限",@"删除部门", nil];
    GetCommonDataModel;
    if (comData.organization.roleId == 1) {
        NSLog(@"创建者权限");
    }if (comData.organization.roleId == 2) {
        NSLog(@"管理者权限");
    }
    _settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, Screen_Width, Screen_Height-40) style:UITableViewStyleGrouped];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    _settingTableView.scrollEnabled = NO;
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
    _lblRecordPromptUserInfo.text = [NSString stringWithFormat:@"当前部门:%@",self.orgMod.orgunitName];
    
    [recordType release];
    [_lblRecordPromptUserInfo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewRecordPromptInfo];
    
    [viewRecordPromptInfo release];
}

#pragma mark - UITableView Delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    GetCommonDataModel;
    if (indexPath.row==4 || indexPath.row == 5) {
        if (comData.organization.roleId!=1) {
            return NO;
            
        }else{
            return YES;
        }
    }else{
        return YES;
    }
    
}

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
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    GetCommonDataModel;
    if (indexPath.row==4 || indexPath.row == 5) {
        if (comData.organization.roleId!=1) {
            cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
            cell.textLabel.text = [NSString stringWithFormat:@"%@(创建者)",[self.arrSet objectAtIndex:indexPath.row]];
            
        }else{
            cell.textLabel.text = [self.arrSet objectAtIndex:indexPath.row];
            cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
        }
    }else{
        cell.textLabel.text = [self.arrSet objectAtIndex:indexPath.row];
        cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
    }
    
    
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
        nameText.placeholder = self.orgMod.orgunitName;
        
        [changeOrgNameAler show];
        
        [changeOrgNameAler release];
    }if (indexPath.row ==1) {
        NSLog(@"修改考勤配置");
        GetCommonDataModel;
        GetGitomSingal;
        [hbKit getAttendanceConfigWithOrganizationId:comData.organization.organizationId
                                           orgunitId:[self.orgMod.orgunitId integerValue]
                                             Refresh:YES
                                       GotDicReports:^(NSDictionary *dicAttenConfig) {
                                           NSLog(@"向单例存放考勤设置");
                                           NSString * offTimeStr1 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:0]objectForKey:@"offTime"];
                                           NSString * onTimeStr1 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:0]objectForKey:@"onTime"];
                                           NSString * offTimeStr2 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:1]objectForKey:@"offTime"];
                                           NSString * onTimeStr2 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:1]objectForKey:@"onTime"];
                                           NSArray *countAr = [dicAttenConfig objectForKey:@"attenWorktime"];
                                           
                                           singal.latitude = [[[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"latitude"]floatValue];
                                           singal.longitude = [[[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"longitude"]floatValue];
                                           
                                           singal.inMinute = [[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"inMinute"];
                                           singal.outMinute = [[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"outMinute"];
                                           
                                           singal.distance = [[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"distance"];
                                           singal.oneTime1 = [onTimeStr1 intValue];
                                           singal.offTime1 = [offTimeStr1 intValue];
                                           singal.offTime2 = [offTimeStr2 intValue];
                                           singal.oneTime2 = [onTimeStr2 intValue];
                                           
                                           if (countAr.count>2) {
                                               NSString * offTimeStr3 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:2]objectForKey:@"offTime"];
                                               NSLog(@"offTimeStr 3 = %@",offTimeStr3);
                                               NSString * onTimeStr3 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:2]objectForKey:@"onTime"];
                                               singal.offTime3 = [onTimeStr3 intValue] ;
                                               singal.oneTime3 = [offTimeStr3 intValue];
                                           }else{
                                               singal.oneTime3 = 00;
                                               singal.offTime3 = 00;
                                           }
                                       }];
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
        if (comData.organization.roleId == 1) {
            RolePrivilegeVC *nv = [[RolePrivilegeVC alloc]init];
            [self.navigationController pushViewController:nv animated:YES];
        }
        
    }if (indexPath.row == 5) {
        if (comData.organization.roleId == 1) {
            configType = 5;
            UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除部门？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
            [changeOrgNameAler show];
            [changeOrgNameAler release];
        }
        
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
            if (configType == 5) {//删除部门
                [hbKit deleteOrgunitWithOrganizationId:comData.organization.organizationId
                                          andOrgunitId:[self.orgMod.orgunitId intValue]
                                         andUpdateUser:comData.userModel.username];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if (configType == 3){//更改坐标上传的间隔
                if (tf.text.length > 0) {
                [hbKit changeSendPositionPointIntervalorganitzationId:comData.organization.organizationId
                                                             andOrgunitId:[self.orgMod.orgunitId integerValue]
                                                              andInterval:orgNameString andUsername:comData.userModel.username];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"时间间隔不能为空!"];
                }
            }
            else{
                if (tf.text.length > 0) {//更部门名称
                    [hbKit changeOrgNameWith:comData.organization.organizationId
                                andOrgunitId:[self.orgMod.orgunitId intValue]
                                 andUsername:comData.userModel.username
                                     andName:orgNameString];
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
