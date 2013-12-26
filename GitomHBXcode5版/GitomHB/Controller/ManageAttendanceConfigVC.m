//
//  ManageAttendanceConfigVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-15.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ManageAttendanceConfigVC.h"
#import "SetMapPositionVC.h"
#import "SVProgressHUD.h"
#import "WTool.h"
#import "HBServerKit.h"
#import "ManagDatePickerVC.h"

@interface ManageAttendanceConfigVC ()

@end

@implementation ManageAttendanceConfigVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"修改考勤配置";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
   
    [self.configTableView reloadData];
}

#pragma mark -- 更新考勤配置
- (void)saveAction{
    GetCommonDataModel;
   
    if (self.attendModle.oneTime1 >self.attendModle.offTime1||self.attendModle.oneTime2>self.attendModle.offTime2) {
        
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"设置不合理" message:@"下班时间不能比上班时间早" delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil, nil];
        [aler show];
   
    }else if (self.attendModle.oneTime2!=kNotSetTime&&self.attendModle.offTime1+([self.attendModle.outMinute integerValue]+[self.attendModle.inMinute integerValue])*60000>self.attendModle.oneTime2){
        
        NSLog(@"self.attendModle.oneTime3");
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"上班时间段/打卡时间设置有误" message:@"下个时间段上班时间-上班时间，不能早于上个时间段的下班时间+下班打卡时间" delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil, nil];
        [aler show];
        
    }else if(self.attendModle.oneTime3!=kNotSetTime && self.attendModle.offTime2+([self.attendModle.outMinute integerValue]+[self.attendModle.inMinute integerValue])*60000>self.attendModle.oneTime3){
        
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"上班时间段/打卡时间设置有误" message:@"下个时间段上班时间-上班时间，不能早于上个时间段的下班时间+下班打卡时间" delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil, nil];
        [aler show];
        
    }else if (self.attendModle.offTime1 > self.attendModle.oneTime2 && self.attendModle.oneTime2!= kNotSetTime|self.attendModle.offTime2 > self.attendModle.oneTime3 && self.attendModle.oneTime3!= kNotSetTime){
        
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"设置不合理" message:@"下个时间段上班时间不能早于上个时间段的下班时间" delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil, nil];
        [aler show];
  
    }else if ([self.attendModle.distance integerValue]>999|[self.attendModle.distance integerValue]<1){
        
        [SVProgressHUD showErrorWithStatus:@"打卡距离应为1～999" duration:1];
        
    }else{
        
        HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit saveUpdateAttendanceConfigWithAttenInfoByUpdateUser:comData.userModel.unitName
                                                   andDistance:self.attendModle.distance
                                                   andInMinute:self.attendModle.inMinute
                                                  andOutMinute:self.attendModle.outMinute
                                                   andLatitude:self.attendModle.latitude
                                                  andLongitude:self.attendModle.longitude
                                             andOrganizationId:comData.organization.organizationId
                                                  andOrgunitId:[self.orgunitId integerValue]
                                                   SetOutTime1:self.attendModle.offTime1
                                                    andInTime1:self.attendModle.oneTime1
                                                   SetOutTime2:self.attendModle.offTime2
                                                    andInTime2:self.attendModle.oneTime2
                                                   SetOutTime3:self.attendModle.offTime3
                                                    andInTime3:self.attendModle.oneTime3];

    }
}

#pragma mark -- 通知的相关方法

- (void)changeTimes1:(NSNotification *)notificaiton{
    
    NSArray *timesAr = [notificaiton.object componentsSeparatedByString:@","];
    self.attendModle.oneTime1 = [[timesAr objectAtIndex:0] longLongValue];
    self.attendModle.offTime1 = [[timesAr objectAtIndex:1] longLongValue];
    NSLog(@"oneTime1,offTime1 == %ld ,%ld",self.attendModle.oneTime1,self.attendModle.offTime1);
    
}

- (void)changeTimes2:(NSNotification *)notificaiton{
    
    NSArray *timesAr = [notificaiton.object componentsSeparatedByString:@","];
    self.attendModle.oneTime2 = [[timesAr objectAtIndex:0] longLongValue];
    self.attendModle.offTime2 = [[timesAr objectAtIndex:1] longLongValue];
    
}

- (void)changeTimes3:(NSNotification *)notificaiton{
    
    NSArray *timesAr = [notificaiton.object componentsSeparatedByString:@","];
    self.attendModle.oneTime3 = [[timesAr objectAtIndex:0] longLongValue];
    self.attendModle.offTime3 = [[timesAr objectAtIndex:1] longLongValue];
    
}

- (void)changePosition:(NSNotification *)notificaiton{
    
    NSArray *timesAr = [notificaiton.object componentsSeparatedByString:@","];
    self.attendModle.latitude = [[timesAr objectAtIndex:0] floatValue];
    self.attendModle.longitude = [[timesAr objectAtIndex:1] floatValue];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimes1:) name:@"changeTimes1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimes2:) name:@"changeTimes2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimes3:) name:@"changeTimes3" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePosition:) name:@"changePosition" object:nil];
    
    
    NSLog(@"ManageAttendanceConfigVC viewWillAppear == ");
    
    self.navigationController.title = @"修改考勤配置";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
  
    
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
 
    
    self.configTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-60) style:UITableViewStyleGrouped];
    //self.configTableView.backgroundColor = [UIColor clearColor];
    self.configTableView.delegate = self;
    self.configTableView.dataSource = self;
    self.configTableView.backgroundView = nil;
    //[self.configTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main_menu2.png"]]];
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
            cell.textLabel.text = [NSString stringWithFormat:@"位置：%f，%f",self.attendModle.latitude,self.attendModle.longitude];
//            cell.textLabel.backgroundColor = [UIColor clearColor];
            break;
        case 1:
            
            switch (indexPath.row) {
                case 0:
                    if (self.attendModle.offTime1!=kNotSetTime) {
                        cell.textLabel.text = [NSString stringWithFormat:@"时间段1：%@-%@",[WTool getStrDateTimeWithDateTimeMS:self.attendModle.oneTime1 DateTimeStyle:@"HH:mm:ss"],[WTool getStrDateTimeWithDateTimeMS:self.attendModle.offTime1 DateTimeStyle:@"HH:mm:ss"]];
                    }else{
                        cell.textLabel.text = @"--";
                    }

                    break;
                case 1:
                    if (self.attendModle.offTime2!=kNotSetTime && self.attendModle.offTime2 != 0 | self.attendModle.oneTime2 != 0) {
                        cell.textLabel.text = [NSString stringWithFormat:@"时间段2：%@-%@",[WTool getStrDateTimeWithDateTimeMS:self.attendModle.oneTime2 DateTimeStyle:@"HH:mm:ss"],[WTool getStrDateTimeWithDateTimeMS:self.attendModle.offTime2 DateTimeStyle:@"HH:mm:ss"]];
                    }else{
                        cell.textLabel.text = @"--";
                    }
//                    cell.textLabel.backgroundColor =[UIColor clearColor];
                    
                    break;
                case 2:
                    if (self.attendModle.offTime3!=kNotSetTime&& self.attendModle.offTime3 != 0 | self.attendModle.oneTime3 != 0){
                        NSLog(@"offTime3 == %@",[WTool getStrDateTimeWithDateTimeMS:self.attendModle.offTime3 DateTimeStyle:@"HH:mm:ss"]);
                        NSLog(@"onTime3 == %@",[WTool getStrDateTimeWithDateTimeMS:self.attendModle.oneTime3 DateTimeStyle:@"HH:mm:ss"]);
                         cell.textLabel.text = [NSString stringWithFormat:@"时间段3：%@-%@",[WTool getStrDateTimeWithDateTimeMS:self.attendModle.oneTime3 DateTimeStyle:@"HH:mm:ss"],[WTool getStrDateTimeWithDateTimeMS:self.attendModle.offTime3 DateTimeStyle:@"HH:mm:ss"]];
                    }else{
                        cell.textLabel.text = @"--";
                    }
//                    cell.textLabel.backgroundColor= [UIColor clearColor];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"上班前：%@",self.attendModle.inMinute];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"下班后：%@",self.attendModle.outMinute];
            }
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"距离：%@",self.attendModle.distance];
            break;
        default:
            break;
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];

    [sectionView setBackgroundColor:[UIColor clearColor]];
    //增加UILabel
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 320, 18)];
    [text setTextColor:[UIColor whiteColor]];
    [text setBackgroundColor:[UIColor clearColor]];
    NSArray *array=[NSArray arrayWithObjects:@"地理位置",@"上班时段",@"打卡时间",@"打卡有效距离",nil];
    [text setText:[array objectAtIndex:section]];
    text.textColor = [UIColor blackColor];
    [text setFont:[UIFont boldSystemFontOfSize:18.0]];
    
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
    if (indexPath.section == 0) {
        
        NSLog(@"%d",indexPath.section);
        SetMapPositionVC *setVC = [[SetMapPositionVC alloc]init];
        setVC.locStr = self.location;
        [self.navigationController pushViewController:setVC animated:YES];
        
    }else if (indexPath.section ==1){
        
        NSLog(@"%d",indexPath.section);
        ManagDatePickerVC *datePicker = [[ManagDatePickerVC alloc]init];
        datePicker.setTimeType = indexPath.row;
        [self.navigationController pushViewController:datePicker animated:YES];
        
    }else if (indexPath.section ==2){
        if (indexPath.row ==0) {
            
            configType = 1;
            UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"上班前" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
            changeOrgNameAler.alertViewStyle = UIAlertViewStylePlainTextInput;
            [changeOrgNameAler show];
            
        }else{
            
            configType = 2;
            UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"下班前" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
            changeOrgNameAler.alertViewStyle = UIAlertViewStylePlainTextInput;
            [changeOrgNameAler show];
            
        }
        
    }else if (indexPath.section ==3){
        
        configType = 3;
        UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"有效打卡距离" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        changeOrgNameAler.alertViewStyle = UIAlertViewStylePlainTextInput;
        [changeOrgNameAler show];
        
    }else if (indexPath.section ==4){
        
        nil;
        
    }
    
}

#pragma mark - UIAlerView代理方法
- (void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UITextField *tf = [[UITextField alloc]init];
    //得到输入框
    tf=[alertView textFieldAtIndex:0];
    
    NSString * orgNameString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)tf.text, NULL, NULL,  kCFStringEncodingUTF8 ));
    switch (buttonIndex) {
        case 0:
        {
            if (tf.text.length>0) {
                if (configType == 1) {
                    self.attendModle.inMinute = orgNameString;
                }else if (configType == 2){
                    self.attendModle.outMinute = orgNameString;
                }else{
                    self.attendModle.distance = orgNameString;
                }
                [self viewWillAppear:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"设置不能为空！"];
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
