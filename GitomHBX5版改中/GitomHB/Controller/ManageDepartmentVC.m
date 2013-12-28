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
//#import "RolePrivilegeVC.h"
#import "SetRolePritvilegeVC.h"
#import "SetVerifyMethodVC.h"
#import "UserManager.h"

#define NUMBERS @"0123456789\n"
#define STRINGS @"0123456789@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\\n"
@interface ManageDepartmentVC (){
    UITableView *_settingTableView;
    UILabel *_lblRecordPromptUserInfo;
    UITextField *tf;
}

@end

@implementation ManageDepartmentVC




#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"管理部门";
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
    _settingTableView.backgroundView = nil;
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




#pragma mark - 提示信息
-(void)initRecordPromptInfo
{
    GetCommonDataModel;
    
    CGFloat hViewRecordPromptInfo = 40;
    UIView * viewRecordPromptInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, hViewRecordPromptInfo)];
    [viewRecordPromptInfo setBackgroundColor:BlueColor];
    
    _lblRecordPromptUserInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, hViewRecordPromptInfo)];
    [viewRecordPromptInfo addSubview:_lblRecordPromptUserInfo];
    _lblRecordPromptUserInfo.textAlignment = NSTextAlignmentCenter;
    _lblRecordPromptUserInfo.textColor = [UIColor blackColor];
    [_lblRecordPromptUserInfo setFont:[UIFont systemFontOfSize:20]];
    
    //NSString *recordType = [[NSString alloc]init];
    if (self.createrUser) {
        _lblRecordPromptUserInfo.text = [NSString stringWithFormat:@"当前部门:%@",self.orgMod.orgunitName];
    }else{
        
        _lblRecordPromptUserInfo.text = [NSString stringWithFormat:@"当前部门:%@",comData.userModel.unitName];
        NSLog(@"ManageDepartmentVC unitName == %@ hobby %@",comData.organization.name,comData.userModel.hobby);
    }
    
    
 
    [_lblRecordPromptUserInfo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewRecordPromptInfo];
    
 
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
    }else if (indexPath.row == 0){
        NSRange rage = [comData.organization.operations rangeOfString:@"12"];
        if (comData.organization.roleId !=1 &&rage.location == NSNotFound){
            return NO;
        }else{
            return YES;
        }
    }else if (indexPath.row == 1){
        NSRange rage = [comData.organization.operations rangeOfString:@"6"];
        if (comData.organization.roleId !=1 &&rage.location == NSNotFound){
            return NO;
        }else{
            return YES;
        }
    }else if (indexPath.row == 2){
        NSRange rage = [comData.organization.operations rangeOfString:@"1"];
        if (comData.organization.roleId !=1 &&rage.location == NSNotFound){
            return NO;
        }else{
            return YES;
        }
    }else if (indexPath.row == 3){
        if ([comData.organization.appLevelCode isEqualToString:kAdvance]) {
            return YES;
        }else{
            return  NO;
        }
    }else {
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
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@(创建者)",[self.arrSet objectAtIndex:indexPath.row]];
            
        }else{
            cell.textLabel.text = [self.arrSet objectAtIndex:indexPath.row];
            cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        }
        
    }else if (indexPath.row == 0){
        
        NSRange rage = [comData.organization.operations rangeOfString:@"12"];
        if (comData.organization.roleId !=1 &&rage.location == NSNotFound) {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@(禁用)",[self.arrSet objectAtIndex:indexPath.row]];
        }else{
            cell.textLabel.text = [self.arrSet objectAtIndex:indexPath.row];
            cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        }

    }else if (indexPath.row ==1){
        
        NSRange rage = [comData.organization.operations rangeOfString:@"6"];
        if (comData.organization.roleId !=1 &&rage.location == NSNotFound) {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@(禁用)",[self.arrSet objectAtIndex:indexPath.row]];
            //cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        }else{
            cell.textLabel.text = [self.arrSet objectAtIndex:indexPath.row];
            cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];

        }
        
    }
    else if (indexPath.row == 2) {
        
        NSRange rage = [comData.organization.operations rangeOfString:@"1"];
        if (comData.organization.roleId !=1 &&rage.location == NSNotFound) {
            
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@(禁用)",[self.arrSet objectAtIndex:indexPath.row]];

        }else{
            cell.textLabel.text = [self.arrSet objectAtIndex:indexPath.row];
            cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];

        }
    }
    
    else{//上传员工位置的时间间隔
        
        
        if ([comData.organization.appLevelCode isEqualToString:kAdvance]) {
            
            cell.textLabel.text = [self.arrSet objectAtIndex:indexPath.row];
            cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
            
        }else{
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@(高级版)",[self.arrSet objectAtIndex:indexPath.row]];
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
            
        }
        
        
    
    }
    

    
    return cell;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL canChange;
    if (textField.tag == 3301) {
        NSLog(@"---3301");
   
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:STRINGS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        canChange = [string isEqualToString:filtered];
        if (canChange) {
            NSLog(@"yes");
        }else{
            NSLog(@"No");
        }
//        return canChange;
        
    }else {
        
        NSLog(@"---3302");
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        canChange = [string isEqualToString:filtered];
        
        if (canChange) {
            NSLog(@"yes");
        }else{
            NSLog(@"No");
        }
        
    }
    
    return canChange;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    if (indexPath.row == 0) {
        NSRange rage = [comData.organization.operations rangeOfString:@"12"];
        if (comData.organization.roleId !=1 && rage.location == NSNotFound){
            return;
        }
        NSLog(@"修改部门名称");
        configType = 0;
        //http://hb.m.gitom.com/3.0/organization/updateOrgunit?organizationId=204&orgunitId=16&username=58200&name=WTO&cookie=5533098A-43F1-4AFC-8641-E64875461345
        UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"修改部门名称" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        changeOrgNameAler.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *nameText = [changeOrgNameAler textFieldAtIndex:0];
        nameText.placeholder = self.orgMod.orgunitName;
        if (self.createrUser) {
            nameText.placeholder = self.orgMod.orgunitName;
        }else{
            
           nameText.placeholder = comData.userModel.unitName;

        }
        [changeOrgNameAler show];
        
 
    }if (indexPath.row ==1) {
        NSRange rage = [comData.organization.operations rangeOfString:@"6"];
        if (comData.organization.roleId !=1 && rage.location == NSNotFound){
            return;
        }
        NSLog(@"修改考勤配置");
        GetCommonDataModel;
       
        [hbKit getAttendanceConfigWithOrganizationId:comData.organization.organizationId
                                           orgunitId:[self.orgMod.orgunitId integerValue]
                                             Refresh:YES
                                       GotDicReports:^(AttendanceWorktimeModel *dicAttenConfig) {
                                           NSLog(@"向单例存放考勤设置");
                                           
                                           ManageAttendanceConfigVC *manageVC = [[ManageAttendanceConfigVC alloc]init];
                                           manageVC.attendModle = dicAttenConfig;
                                           manageVC.orgunitId = self.orgMod.orgunitId;
                                           NSLog(@"ManageDepartmentVC == %@ %@",self.orgMod.orgunitId,manageVC.orgunitId);
                                           [self.navigationController pushViewController:manageVC animated:YES];
                                           
                                           
                                       }];

        
 
    }if (indexPath.row == 2) {
        
        NSRange rage = [comData.organization.operations rangeOfString:@"1"];
        if (comData.organization.roleId !=1 && rage.location == NSNotFound){
            return;
        }
        NSLog(@"修改验证方式");
        SetVerifyMethodVC *vc = [[SetVerifyMethodVC alloc]init];
       /* UserManager *um = [[UserManager alloc]init];
        
        [um loggingWithLoggingInfo:comData.userlogingInfo
                      WbLoggedInfo:^(UserLoggedInfo *loggedInfo, BOOL isLoggedOk) {
            if (isLoggedOk) {
                
                Organization * organizationInfo = [[Organization alloc]initForAllJsonDataTypeWithDicFromJson:[loggedInfo.organizations lastObject]];
                comData.organization = organizationInfo;//使用单例的获得解析到的用户信息
                
            }
        }];*/
        
        
        
        vc.orgunitId = self.orgMod.orgunitId;
        vc.verifyIdx = self.orgMod.verifyIndex;
        [self.navigationController pushViewController:vc animated:YES];
        
    }if (indexPath.row ==3) {
        
        NSLog(@"修改上传时间间隔");
        //如果为高级版本
        if ([comData.organization.appLevelCode isEqualToString:kAdvance]) {
            configType = 3;
            UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"间隔时长（1-30）分钟" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
            changeOrgNameAler.alertViewStyle = UIAlertViewStylePlainTextInput;
            [changeOrgNameAler show];
            
        }
  
    }if (indexPath.row == 4) {//编辑主管权限
        
        if (comData.organization.roleId == 1) {
            
            SetRolePritvilegeVC *vc = [[SetRolePritvilegeVC alloc]init];
            //重新获得登入信息
            NSLog(@"MenuVC userManager ifo == %@",comData.userlogingInfo);
            UserManager *um = [[UserManager alloc]init];
            [um loggingWithLoggingInfo:comData.userlogingInfo WbLoggedInfo:^(UserLoggedInfo *loggedInfo, BOOL isLoggedOk) {
                if (isLoggedOk) {
                    
                    Organization * organizationInfo = [[Organization alloc]initForAllJsonDataTypeWithDicFromJson:[loggedInfo.organizations lastObject]];
                    comData.organization = organizationInfo;//使用单例的获得解析到的用户信息
                    
                }
            }];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }if (indexPath.row == 5) {//删除部门
        
        if (comData.organization.roleId == 1) {
            configType = 5;
            
            [hbKit findOrgunitMembersWithOrganizationId:comData.organization.organizationId orgunitId:[self.orgMod.orgunitId integerValue] Refresh:NO GotArrReports:^(NSArray *arrDicReports, WError *myError) {
                if (arrDicReports.count >= 1) {
                    
                    
                    //NSString *memberNumber = [NSString stringWithFormat:,self.orgMod.unitName,arrDicReports.count];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该部门?\n注：如果当前部门下有员工,将会删除失败,请先将员工转移到其他部门" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];//comData.userModel.unitName
                    [alert show];
                    
                }else{
                    
                    UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除部门？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
                    [changeOrgNameAler show];
                    
                }
            }];
  
        }
        
    }

}
- (void)willPresentAlertView:(UIAlertView *)alertView{
    
}
#pragma mark - UIAlerView代理方法
- (void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    tf = [[UITextField alloc]init];
    tf.delegate = self;
    tf = [alertView textFieldAtIndex:0];
    if (configType == 5) {
        nil;
    }else if(configType == 3){
        NSLog(@"3301");
        tf.tag = 3301;
    }else{
        NSLog(@"3302");
//        tf = [alertView textFieldAtIndex:0];
        tf.tag = 3302;
    }
    
    NSString * orgNameString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)tf.text, NULL, NULL,  kCFStringEncodingUTF8 ));
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
                    
                    if (![hbKit isNumbers:tf.text]) {
                         [SVProgressHUD showErrorWithStatus:@"请输入数字!" duration:1.6];
                    }else{
                        [hbKit changeSendPositionPointIntervalorganitzationId:comData.organization.organizationId
                                                                 andOrgunitId:[self.orgMod.orgunitId integerValue]
                                                                  andInterval:orgNameString
                                                                  andUsername:comData.userModel.username];

                    }
                    
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:@"时间间隔不能为空!" duration:1.6];
                    
                }
            }
            else{
                if (tf.text.length > 0) {//更改部门名称
                    
                    if ([hbKit isNumbers:tf.text]) {
 
                        [SVProgressHUD showErrorWithStatus:@"名称不能含数字!" duration:1.6];
                           
                    }else if ([tf.text rangeOfString:@"网即通"].location != NSNotFound){
                        
                        [SVProgressHUD showErrorWithStatus:@"不能含网即通字样!" duration:1.6];
                        
                    }else{
                        
                        [hbKit changeOrgNameWith:comData.organization.organizationId
                                    andOrgunitId:[self.orgMod.orgunitId intValue]
                                     andUsername:comData.userModel.username
                                         andName:orgNameString];
                        
                    }
                    
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:@"部门名称不能设置为空!"];
                    
                }
            }
            
        }
            break;
            
        default:
            break;
    }
 
}



@end
