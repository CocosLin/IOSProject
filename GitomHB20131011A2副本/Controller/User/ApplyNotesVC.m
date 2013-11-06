//
//  ApplyNotesVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-6.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ApplyNotesVC.h"
#import "HBServerKit.h"
#import "GitomSingal.h"


@interface ApplyNotesVC ()

@end

@implementation ApplyNotesVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 申请加入公司
- (void)applyAction{
    GitomSingal *singal = [GitomSingal getInstance];
    UITextField *text1 = (UITextField*)[self.view viewWithTag:1001];
    UITextField *text2 = (UITextField*)[self.view viewWithTag:1002];
    UITextField *text3 = (UITextField*)[self.view viewWithTag:1003];
    NSString *noteStr = [NSString stringWithFormat:@"%@%@%@",text1.text,text2.text,text3.text];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit applyJoinToCompanyWithOrganizationId:self.companyId andOrgunitId:self.orgId andNote:noteStr andUseName:singal.registerName andVerifyType:0];
    [hbKit release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rightbtn.frame = CGRectMake(0, 0, 50, 44);
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tpeToDismissAction)];
    [self.view addGestureRecognizer:tap];
    [tap release];
    
    [self creatInfomationsView];
    
    UITableView *registerTableV = [[UITableView alloc]initWithFrame:CGRectMake(10, 85, Screen_Width-20, 130) style:UITableViewStylePlain];
    [registerTableV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    registerTableV.dataSource = self;
    registerTableV.scrollEnabled = NO;
    registerTableV.layer.borderWidth = 0.7;
    registerTableV.layer.cornerRadius = 7;
    [self.view addSubview:registerTableV];

    
}

- (void) creatInfomationsView{
    UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, Screen_Width-20, 25)];
    companyName.backgroundColor =  BlueColor;
    companyName.text = [NSString stringWithFormat:@" 公司:%@",self.companyName];
    [self.view addSubview:companyName];
    
    UILabel *orgName = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, Screen_Width-20, 25)];
    orgName.backgroundColor = BlueColor;
    orgName.text = [NSString stringWithFormat:@" 部门:%@",self.orgName];
    [self.view addSubview:orgName];
    
    UILabel *method = [[UILabel alloc]initWithFrame:CGRectMake(10, 57.5, Screen_Width-20, 25)];
    method.backgroundColor = BlueColor;
    method.text = [NSString stringWithFormat:@" 验证:%@",@"默认"];
    [self.view addSubview:method];
    
    [companyName release];
    [orgName release];
    [method release];
    
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    switch (indexPath.row) {
        case 0:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            leftViewLb.text = @"姓名";
            
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 3, Screen_Width-20, 40)];
            phoneNumber.tag = 1001;
            //phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            //phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            phoneNumber.placeholder = @"输入姓名";
            [cell addSubview:phoneNumber];
            [phoneNumber release];
            [leftViewLb release];
            return cell;
        }
        case 1:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            leftViewLb.text = @"手机";
            
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Screen_Width-20, 40)];
            phoneNumber.secureTextEntry = YES;
            phoneNumber.tag = 1002;
            //phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            //phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            phoneNumber.placeholder = @"输入手机";
            [cell addSubview:phoneNumber];
            [phoneNumber release];
            [leftViewLb release];
            return cell;
        }
            break;
        case 2:{
            UILabel * leftViewLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [leftViewLb setBackgroundColor:[UIColor clearColor]];
            leftViewLb.textColor = [UIColor grayColor];
            leftViewLb.text = @"申请";
            
            UITextField * phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Screen_Width-20, 40)];
            phoneNumber.secureTextEntry = YES;
            phoneNumber.tag = 1003;
            phoneNumber.delegate = self;
            phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
            //phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
            phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            phoneNumber.leftView = leftViewLb;
            phoneNumber.leftViewMode = UITextFieldViewModeAlways;
            phoneNumber.placeholder = @"您申请的理由，如市场部“张三”";
            [cell addSubview:phoneNumber];
            [phoneNumber release];
            [leftViewLb release];
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return 80;
    }
    return 40;
}
#pragma mark - UITextDelegate
//#pragma mark -- UITextFiledDelegate
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    _baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
//    _baseView.contentSize = self.view.frame.size;
//    //self.view.frame = CGRectMake(0, -80, Screen_Width, Screen_Height-70);
//}

#pragma mark -- 点击任意位置收起键盘
- (void)tpeToDismissAction{
    UITextField *textField = (UITextField *)[self.view viewWithTag:2];
    [textField resignFirstResponder];
    [UIView animateWithDuration:1 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y);
    }];
    [textField release];
}
//执行代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//取消第一响应
    return YES;
}
//在用键盘输入内容时候，输入框上移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:1 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-90);
    }];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
