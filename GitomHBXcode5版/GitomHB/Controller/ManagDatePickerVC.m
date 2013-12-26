//
//  ManagDatePickerVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-1.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ManagDatePickerVC.h"
#import "WTool.h"
#import "SVProgressHUD.h"

#define kHadeSet 1000

@interface ManagDatePickerVC (){
//    UIImage * _imageCheckBox_on;
//    UIImage * _imageCheckBox_off;
//    UIImageView * _checkBoxRememberView;
    BOOL open;
    
    long long onTimeTemp;
    long long offTimeTemp;
    int pickerTage;
}

@end

@implementation ManagDatePickerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"上下班设置";
    }
    return self;
}

- (void)saveAction1{
    pickerTage = kHadeSet;
    GetGitomSingal;
        
    switch (self.setTimeType) {//区分时间段1、2、3
        case 0:
            singal.oneTime1 = onTimeTemp;
            break;
        case 1:
            singal.oneTime2 = onTimeTemp;
            break;
        case 2:
            singal.oneTime3 = onTimeTemp;
            break;
        default:
            break;
    }
    
    NSLog(@"onTimeTemp == %ld",singal.oneTime1);
    UIView *onpicker = [self.view viewWithTag:1001];
    onpicker.hidden = YES;
    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-110, 120, 220, 135)];
    [self.view addSubview:baseView];
    UIView *hideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 115, 135)];
    hideView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_block.png"]];
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake(0, 0, 120, 50);
    [but1 setBackgroundImage:[[UIImage imageNamed:@"01.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [but1 setBackgroundImage:[[UIImage imageNamed:@"02.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [but1 addTarget:self action:@selector(saveAction2) forControlEvents:UIControlEventTouchUpInside];
    but1.center = hideView.center;
    [but1 setTitle:@"更改下班时间" forState:UIControlStateNormal];
    but1.tintColor = [UIColor blackColor];
    [hideView addSubview:but1];
    MWDatePicker *datePicker = [[MWDatePicker alloc] initWithFrame:CGRectMake(0, 0, 220, 135)];
    [datePicker setDelegate:self];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [datePicker setCalendar:calendar];
    [datePicker setFontColor:[UIColor whiteColor]];
    [datePicker update];
    [datePicker setDate:[NSDate date] animated:YES];
    [baseView addSubview:datePicker];
    [datePicker addSubview:hideView];
    
}

- (void)saveAction2{
    
    GetGitomSingal;

    switch (self.setTimeType) {//区分时间段1、2、3
        case 0:
            singal.offTime1 = onTimeTemp;
            break;
        case 1:
            singal.offTime2 = onTimeTemp;
            break;
        case 2:
            singal.offTime3 = onTimeTemp;
            break;
        default:
            break;
    }
    
    NSLog(@"onTimeTemp == %ld",singal.offTime1);
    
}

- (void)saveActionSetting{
    
    GetGitomSingal;
    
    if (open) {//是否开启时间段
        
        if (pickerTage == kHadeSet) {
            
            switch (self.setTimeType) {
                    
                case 0:
                    
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"时间段%d：%@-%@",self.setTimeType+1,[WTool getStrDateTimeWithDateTimeMS:singal.oneTime1 DateTimeStyle:@"HH:mm:ss"],[WTool getStrDateTimeWithDateTimeMS:singal.offTime1 DateTimeStyle:@"HH:mm:ss"]]];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTimes1" object:[NSString stringWithFormat:@"%ld,%ld",singal.oneTime1,singal.offTime1]];
                    
                    break;
                    
                case 1:
                    
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"时间段%d：%@-%@",self.setTimeType+1,[WTool getStrDateTimeWithDateTimeMS:singal.oneTime2 DateTimeStyle:@"HH:mm:ss"],[WTool getStrDateTimeWithDateTimeMS:singal.offTime2 DateTimeStyle:@"HH:mm:ss"]]];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTimes2" object:[NSString stringWithFormat:@"%ld,%ld",singal.oneTime2,singal.offTime2]];
                    break;
                    
                case 2:
                    
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"时间段%d：%@-%@",self.setTimeType+1,[WTool getStrDateTimeWithDateTimeMS:singal.oneTime3 DateTimeStyle:@"HH:mm:ss"],[WTool getStrDateTimeWithDateTimeMS:singal.offTime3 DateTimeStyle:@"HH:mm:ss"]]];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTimes3" object:[NSString stringWithFormat:@"%ld,%ld",singal.oneTime3,singal.offTime3]];
                    break;
                    
                default:
                    
                    break;
                    
            }
            
        }
        
    }else{
        
        switch (self.setTimeType) {//区分时间段1、2、3
            case 0:
//                singal.oneTime1 = kNotSetTime;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTimes1" object:[NSString stringWithFormat:@"%d,%d",kNotSetTime,kNotSetTime]];
                break;
            case 1:
//                singal.oneTime2 = kNotSetTime;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTimes2" object:[NSString stringWithFormat:@"%d,%d",kNotSetTime,kNotSetTime]];
                break;
            case 2:
//                singal.oneTime3 = kNotSetTime;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTimes3" object:[NSString stringWithFormat:@"%d,%d",kNotSetTime,kNotSetTime]];
                break;
            default:
                break;
        }

        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"时间段%d，关闭",self.setTimeType+1] duration:1];
        
    }
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
        
    [self setMyVcTitle:[NSString stringWithFormat:@"更改时间段%d",self.setTimeType+1]];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
 
    
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setTitle:@"确定" forState:UIControlStateNormal];
    [rbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rbtn.frame = CGRectMake(0, 0, 50, 44);
    [rbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    // 高亮
    [rbtn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [rbtn addTarget:self action:@selector(saveActionSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rbtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;

    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-110, 120, 220, 135)];
    baseView.tag = 1001;
    [self.view addSubview:baseView];
    UIView *hideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 115, 135)];
    hideView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_block.png"]];
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake(0, 0, 120, 50);
    [but1 setBackgroundImage:[[UIImage imageNamed:@"01.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [but1 setBackgroundImage:[[UIImage imageNamed:@"02.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [but1 addTarget:self action:@selector(saveAction1) forControlEvents:UIControlEventTouchUpInside];
    but1.center = hideView.center;
    [but1 setTitle:@"更改上班时间" forState:UIControlStateNormal];
    but1.tintColor = [UIColor blackColor];
    [hideView addSubview:but1];
    MWDatePicker *datePicker = [[MWDatePicker alloc] initWithFrame:CGRectMake(0, 0, 220, 135)];
    [datePicker setDelegate:self];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [datePicker setCalendar:calendar];
    [datePicker setFontColor:[UIColor whiteColor]];
    [datePicker update];
    [datePicker setDate:[NSDate date] animated:YES];
    [baseView addSubview:datePicker];
    [datePicker addSubview:hideView];
    
    UIView *openVeiw = [[UIView alloc]initWithFrame:CGRectMake(45, 35, 85, 30)];
    [self.view addSubview:openVeiw];
 
    open = YES;
    UIButton *lfButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lfButton setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
    [lfButton addTarget:self action:@selector(lfButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    lfButton.frame = CGRectMake(0, 0, 30, 30);
    
    UILabel *lfStyleLb = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 60, 20)];
    lfStyleLb.text = @"开启";
    lfStyleLb.backgroundColor = [UIColor clearColor];
    [openVeiw addSubview:lfButton];
    [openVeiw addSubview:lfStyleLb];

}

#pragma mark -- 选择发布公告类型
- (void)lfButtonAction:(UIButton *)sender{
  
    UIButton *rtButton = sender;//(UIButton *)[self.view viewWithTag:2202];
    if (open) {
        
        [rtButton setImage:[UIImage imageNamed:@"checkbox_normal.png"] forState:UIControlStateNormal];
        open = NO;
        
    }else{
        
        [rtButton setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
        open = YES;

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MWPickerDelegate

- (UIColor *) backgroundColorForDatePicker:(MWDatePicker *)picker
{
    return [UIColor blackColor];
}


- (UIColor *) datePicker:(MWDatePicker *)picker backgroundColorForComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [UIColor blackColor];
        case 1:
            return [UIColor blackColor];
        case 2:
            return [UIColor blackColor];
        default:
            return 0; // never
    }
}


- (UIColor *) viewColorForDatePickerSelector:(MWDatePicker *)picker
{
    return [UIColor grayColor];
}

-(void)datePicker:(MWDatePicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"ManagDatePickerVC == %@ row == %d component == %d",[picker getDate],row,component);
    NSString *dateStr= [NSString stringWithFormat:@"%@",[picker getDate]];
    [dateStr componentsSeparatedByString:@" "];
    NSLog(@"%@",[[dateStr componentsSeparatedByString:@" "]objectAtIndex:1]);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    [WTool getTimeMsWithNSDate:[formatter dateFromString:[[dateStr componentsSeparatedByString:@" "]objectAtIndex:1]]];
    NSLog(@"lld time == %lld",[WTool getTimeMsWithNSDate:[formatter dateFromString:[[dateStr componentsSeparatedByString:@" "]objectAtIndex:1]]]);
    onTimeTemp = [WTool getTimeMsWithNSDate:[formatter dateFromString:[[dateStr componentsSeparatedByString:@" "]objectAtIndex:1]]];
}

@end
