//
//  LoginVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "LoginVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UserManager.h"
#import "UserModel.h"
#import "MenuVC.h"
#import "JASidePanelController.h"
#import "MyNavigationController.h"
#import "MobileReportVC.h"



#define Height_Cell_LoginInput 40.0
#define Count_Cell_LoginInput 2
#define Height_Cell_LoginInfoOpera 30.0
#define Count_Cell_LoginInfoOpera 2

#define imageName_btnHistoryAccountNumber @"btnDownList"
#define imageName_btnLoginBackgroundNormal @"btnLoginBackgroundNormal"
#define imageName_btnLoginBackgroundHighlighted @"btnLoginBackgroundHighlight.png"

#define imageName_checkBox_off @"checkbox_normal"
#define imageName_checkBox_on @"checkbox_checked"

typedef NS_ENUM(NSInteger, TagValue)//标记不同视图主键要用的标记
{
    Tag_Tbv_LoginInput = 101,
    Tag_Tbv_LoginHistory = 102,
    Tag_Tbv_LoginInfoOpera = 103,
    Tag_BtnHistoryUsername = 200,
    Tag_BtnLogin = 201,
    Tag_BtnRegister = 202,
    Tag_BtnUpdatePassword = 203,
    Tag_CellRememberPassword = 51,
    Tag_CellAutoLogin = 52
};

@interface LoginVC ()
{
    UITableView * _tbvUserLoginInput;
    UITableView * _tbvUserLoginInfoOpera;
    UIImage * _imageCheckBox_on;
    UIImage * _imageCheckBox_off;
    UIImageView * _checkBoxRememberView;
    UIImageView * _checkBoxAutoLoginView;
}
@end

@implementation LoginVC
#pragma mark end
#pragma mark - 自定义视图
//用户登录框
-(void)initUserInputView:(CGRect)frame
{
    CGFloat y_start = 0;
    _tbvUserLoginInput = [[UITableView alloc]initWithFrame:CGRectMake(10, y_start + 30, frame.size.width - 10*2,Height_Cell_LoginInput * Count_Cell_LoginInput)];
    _tbvUserLoginInput.tag = Tag_Tbv_LoginInput;
    [self.view addSubview:_tbvUserLoginInput];
    _tbvUserLoginInput.scrollEnabled = NO;
    _tbvUserLoginInput.delegate = self;
    _tbvUserLoginInput.dataSource = self;
    _tbvUserLoginInput.layer.borderWidth = 0.7;
    _tbvUserLoginInput.layer.cornerRadius = 7;
}

-(void)initUserLoginOpera
{
    CGFloat y_start = 200;
    _tbvUserLoginInfoOpera = [[UITableView alloc]initWithFrame:CGRectMake(10, y_start, 120,Height_Cell_LoginInfoOpera * Count_Cell_LoginInfoOpera)];
    _tbvUserLoginInfoOpera.tag = Tag_Tbv_LoginInfoOpera;
    [self.view addSubview:_tbvUserLoginInfoOpera];
    _tbvUserLoginInfoOpera.scrollEnabled = NO;
//    _tbvUserLoginInfoOpera.delegate = self;
//    _tbvUserLoginInfoOpera.dataSource = self;
    _tbvUserLoginInfoOpera.layer.borderWidth = 0.2;
//    _tbvUserLoginInfoOpera.layer.cornerRadius = 7;
}
-(void)addViewForMoreLoginOperaWithBtnLoginFrame:(CGRect)frameBtnLogin
{
    //设置两个图标
    _imageCheckBox_on = [UIImage imageNamed:imageName_checkBox_on];
    _imageCheckBox_off = [UIImage imageNamed:imageName_checkBox_off];
    
    //登录操作
    UIView * viewMoreLoginOpera = [[UIView alloc]initWithFrame:CGRectMake(frameBtnLogin.origin.x, frameBtnLogin.origin.y + frameBtnLogin.size.height + 30, 120, 70)];
    [viewMoreLoginOpera setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewMoreLoginOpera];
    
    CGRect frameViewMoreLoginOpera = viewMoreLoginOpera.frame;
    UIView * viewPasswordRemember = [[UIView alloc]initWithFrame:CGRectMake(5, 0, frameViewMoreLoginOpera.size.width-5, frameViewMoreLoginOpera.size.height / 2)];
    CGRect frameViewPasswordRemember = viewPasswordRemember.frame;
    [viewPasswordRemember setBackgroundColor:[UIColor clearColor]];
    [viewMoreLoginOpera addSubview:viewPasswordRemember];
    _checkBoxRememberView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10/2, frameViewPasswordRemember.size.height-10, frameViewPasswordRemember.size.height-10)];
    _checkBoxRememberView.image = _imageCheckBox_off;
    [viewPasswordRemember addSubview:_checkBoxRememberView];
    UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(_checkBoxRememberView.frame.size.width + _checkBoxRememberView.frame.origin.x + 5, 0, frameViewPasswordRemember.size.width - _checkBoxRememberView.frame.size.width, frameViewPasswordRemember.size.height)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:@"记住密码"];
    [lbl setTextColor:[UIColor grayColor]];
    [lbl setFont:[UIFont systemFontOfSize:15]];
    [viewPasswordRemember addSubview:lbl];
    [lbl release];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRememberPasswordAction)];
    [viewPasswordRemember addGestureRecognizer:tap];
    [tap release];
    [viewPasswordRemember release];
    
    
    UIView * viewAutoLogin = [[UIView alloc]initWithFrame:CGRectMake(5, frameViewMoreLoginOpera.size.height / 2, frameViewMoreLoginOpera.size.width-5, frameViewMoreLoginOpera.size.height / 2)];
    CGRect frameViewAutoLogin = viewAutoLogin.frame;
    [viewAutoLogin setBackgroundColor:[UIColor clearColor]];
    [viewMoreLoginOpera addSubview:viewAutoLogin];
    
    _checkBoxAutoLoginView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10/2, frameViewAutoLogin.size.height-10, frameViewAutoLogin.size.height-10)];
    _checkBoxAutoLoginView.image = _imageCheckBox_off;
    [viewAutoLogin addSubview:_checkBoxAutoLoginView];
    UILabel * lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(_checkBoxAutoLoginView.frame.size.width + _checkBoxAutoLoginView.frame.origin.x + 5, 0, frameViewAutoLogin.size.width - _checkBoxAutoLoginView.frame.size.width, frameViewAutoLogin.size.height)];
    [lbl2 setBackgroundColor:[UIColor clearColor]];
    [lbl2 setText:@"自动登录"];
    [lbl2 setTextColor:[UIColor grayColor]];
    [lbl2 setFont:[UIFont systemFontOfSize:15]];
    [viewAutoLogin addSubview:lbl2];
    [lbl2 release];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAutoLoginAction)];
    [viewAutoLogin addGestureRecognizer:tap2];
    [tap2 release];
    [viewAutoLogin release];
    
    //    UITapGestureRecognizer * tapForHideKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForHideKeyboard)];
    //    [self.view addGestureRecognizer:tapForHideKeyboard];
    //    [tapForHideKeyboard release];
    
    [viewMoreLoginOpera release];
}

#pragma mark - UITableView相关方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == Tag_Tbv_LoginInput) {
        return Count_Cell_LoginInput;
    }else if(tableView.tag==Tag_Tbv_LoginInfoOpera){
        return Count_Cell_LoginInfoOpera;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == Tag_Tbv_LoginInput) {
        return Height_Cell_LoginInput;
    }else if(tableView.tag == Tag_Tbv_LoginInfoOpera){
        return Height_Cell_LoginInfoOpera;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == Tag_Tbv_LoginInput) {
        static  NSString * cellIdLogin = @"cellIdLogin";
        //UITableViewCell * myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdLogin];
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdLogin];
        if (!myCell) {
            myCell = [[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:cellIdLogin]autorelease];
        }
        //密码框
        if (indexPath.row == 1)
        {
            UILabel * lblPassword = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, 0, 50, Height_Cell_LoginInput)];
            [lblPassword setBackgroundColor:[UIColor clearColor]];
            lblPassword.textColor = [UIColor grayColor];
            lblPassword.text = @"密码";
            [myCell addSubview:lblPassword];
            [lblPassword release];
            //            _tfPassword = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, tableView.frame.size.width - 50, Height_LoginInputCell - 5 *2)];
            [_tfPassword setFrame:CGRectMake(50, 10, tableView.frame.size.width - 50, Height_Cell_LoginInput - 5 *2)];
            _tfPassword.borderStyle = UITextBorderStyleNone;
            _tfPassword.placeholder = @"请输入密码";
            _tfPassword.returnKeyType = UIReturnKeyDone;
            _tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
            _tfPassword.secureTextEntry = YES;
            _tfPassword.delegate = self;
            [myCell addSubview:_tfPassword];
        }else if(indexPath.row == 0)
        {
            UILabel * lblUsername = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, 0, 50, Height_Cell_LoginInput)];
            [lblUsername setBackgroundColor:[UIColor clearColor]];
            lblUsername.textColor = [UIColor grayColor];
            lblUsername.text = @"账号";
            [myCell addSubview:lblUsername];
            [lblUsername release];
            //            _tfUsername = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, tableView.frame.size.width - 50 - 50, Height_LoginInputCell - 5 *2)];
            [_tfUsername setFrame:CGRectMake(50, 10, tableView.frame.size.width - 50 - 50, Height_Cell_LoginInput - 5 *2)];
            _tfUsername.borderStyle = UITextBorderStyleNone;
            _tfUsername.returnKeyType = UIReturnKeyDone;
            _tfUsername.keyboardType = UIKeyboardTypeNumberPad;
            _tfUsername.placeholder = @"请输入网即通通行证";
            _tfUsername.delegate = self;
            [myCell addSubview:_tfUsername];
            //历史账号按钮
            UIButton * btnHistoryUsername = [UIButton buttonWithType:UIButtonTypeCustom];
            btnHistoryUsername.tag = Tag_BtnHistoryUsername;
            [btnHistoryUsername setFrame:CGRectMake(tableView.frame.size.width - 50,
                                                    2,
                                                    Height_Cell_LoginInput,
                                                    Height_Cell_LoginInput)];
            [btnHistoryUsername setImage:[UIImage imageNamed:imageName_btnHistoryAccountNumber] forState:UIControlStateNormal];
            [btnHistoryUsername addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [myCell addSubview:btnHistoryUsername];
        }
        return myCell;
    }
    return nil;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == Tag_Tbv_LoginInput || tableView.tag == Tag_Tbv_LoginInfoOpera) {
        return NO;
    }
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.isShowHisLoginInfo = NO;
}
#pragma mark - 属性控制
-(void)setIsAutoLogin:(BOOL)isAutoLogin
{
    _isAutoLogin = isAutoLogin;
    if (isAutoLogin)
    {
        _checkBoxAutoLoginView.image = _imageCheckBox_on;
        self.isRememberPassword = YES;
    }else
    {
        _checkBoxAutoLoginView.image = _imageCheckBox_off;
    }
}
-(void)setIsRememberPassword:(BOOL)isRememberPassword
{
    _isRememberPassword = isRememberPassword;
    if (_isRememberPassword)
    {
        _checkBoxRememberView.image = _imageCheckBox_on;
    }
    else
    {
        _checkBoxRememberView.image = _imageCheckBox_off;
        self.isAutoLogin = NO;
    }
}
#pragma mark - UItextField
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.isShowHisLoginInfo = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    self.isShowHisLoginInfo = NO;
    return YES;
}
#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"移动汇报登录";
    }return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = Color_Background;
    _tfPassword = [[UITextField alloc]init];
    _tfUsername = [[UITextField alloc]init];
    [self initUserInputView:self.view.bounds];
//    [self initUserLoginOpera];
    
    CGRect frameTableViewLoginInput = _tbvUserLoginInput.frame;//登录输入位置

    //登录按钮
    UIButton * btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.tag = Tag_BtnLogin;
    // 登录事件
    [btnLogin addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLogin setBackgroundImage:[[UIImage imageNamed:imageName_btnLoginBackgroundHighlighted] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 25, 25)] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[[UIImage imageNamed:imageName_btnLoginBackgroundHighlighted] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 25, 25)] forState:UIControlStateHighlighted];
    [self setButtonTitleWithButton:btnLogin
                andTitleNormalText:@"登录"
               andTitleNormalColor:[UIColor blackColor]
               andTitleHighlighted:@"登录中...."
      andTitleHighlightedColorText:[UIColor blackColor]];
    btnLogin.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnLogin setFrame:CGRectMake(frameTableViewLoginInput.origin.x, frameTableViewLoginInput.origin.y + frameTableViewLoginInput.size.height + 20,
                                  frameTableViewLoginInput.size.width, 40)];
    CGRect frameBtnLogin = btnLogin.frame;
    // 登录事件
    [btnLogin addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    //更多操作，自动登录，记住密码等
    [self addViewForMoreLoginOperaWithBtnLoginFrame:frameBtnLogin];
    
    UILabel *lblVersionInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, Height_Screen - 120, Width_Screen - 20, 30)];
    lblVersionInfo.text = @"正式版 : v1.0.0";
    lblVersionInfo.textColor = [UIColor grayColor];
    lblVersionInfo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblVersionInfo];
    lblVersionInfo.textAlignment = NSTextAlignmentCenter;
    [lblVersionInfo release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_checkBoxAutoLoginView release];
    [_checkBoxRememberView release];
    [_tbvUserLoginInput release];
    [_arrLoggingInfos release];
    [_tfPassword release];
    [_tfUsername release];
    [super dealloc];
}
#pragma mark - 用户事件
//处理用户事件
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == Tag_BtnLogin){
        NSString * username = _tfUsername.text;
        NSString * password = _tfPassword.text;
        //登录参数
        UserLoggingInfo * loggingInfo = [[UserLoggingInfo alloc]init];
        //以下为测试的时候用
        if (![username length] && ![password length]) {
            loggingInfo.username = @"90261";
            loggingInfo.password = @"121212";//HBSserverKit == 获取数据 http://59.57.15.168:6363/report/findReports
            //loggingInfo.username = @"1073";
            //loggingInfo.password = @"gitom.com2012";//HBSserverKit == 获取数据 http://59.57.15.168:6363/report/findReports
        }else
        {
            //将登入时填写的信息存储进LoggingInfo中
            loggingInfo.username = username;
            loggingInfo.password = password;
        }
        
        //用户业务管理
        UserManager * um = [UserManager sharedUserManager];
        //用户登录方法
        [um loggingWithLoggingInfo:loggingInfo
                      WbLoggedInfo:^( UserLoggedInfo *loggedInfo,BOOL isLoggedOk)
        {
            if (isLoggedOk) {
                GetCommonDataModel;
                comData.isLogged = YES;
                comData.serverDate = loggedInfo.serverDate;
                /*
                 这边要得到用户信息。。。
                 */
                comData.cookie = loggedInfo.cookie;//将登入时候获得的cookie
                UserModel * user = [[UserModel alloc] initForAllJsonDataTypeWithDicFromJson:loggedInfo.user];//传入loggedInfo中的user字典，用过UserModel的initForAllJsonDataTypeWithDicFromJson:方法获得字典中的所有内容。
                comData.userModel = user;//使用单例的userModel属性获得user中转换好的用户信息：头像url、账号等等
                
                Organization * organizationInfo = [[[Organization alloc]initForAllJsonDataTypeWithDicFromJson:[loggedInfo.organizations lastObject]]autorelease];
                comData.organization = organizationInfo;//使用单例的获得解析到的用户信息
                [user release];
                
                //跳转
                _sideViewController = [[[JASidePanelController alloc]init]autorelease];
                _sideViewController.shouldDelegateAutorotateToVisiblePanel = NO;
                
                
                MobileReportVC * mrVC = [[MobileReportVC alloc]init];
                MyNavigationController * ncMrvc = [[[MyNavigationController alloc]initWithRootViewController:mrVC]autorelease];
                [mrVC release];
                _sideViewController.centerPanel = ncMrvc;
                
                MenuVC * mvc = [[MenuVC alloc]initWithRoleId:organizationInfo.roleId
                                                  UserModel:comData.userModel
                                            OrganizationName:comData.organization.name];
                MyNavigationController * mnc = [[[MyNavigationController alloc]initWithRootViewController:mvc]autorelease];
                [mvc release];
                _sideViewController.leftPanel = mnc;
                _sideViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:_sideViewController animated:YES completion:^{}];
                [_sideViewController showLeftPanelAnimated:NO];
            }
        }];
        [loggingInfo release];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self tapForHideKeyboard];
}
-(void)tapForHideKeyboard
{
    [self.view endEditing:YES];
}
-(void)tapRememberPasswordAction
{
    self.isRememberPassword = !self.isRememberPassword;
}
-(void)tapAutoLoginAction
{
    self.isAutoLogin = !self.isAutoLogin;
}
#pragma - 自定义方法
//设置按钮文字还有颜色
-(void)setButtonTitleWithButton:(UIButton *)btn
             andTitleNormalText:(NSString *)titleNormalText
            andTitleNormalColor:(UIColor *)titleNormalColor
            andTitleHighlighted:(NSString *)titleHighlightedText
   andTitleHighlightedColorText:(UIColor *)titleHighlightedColor
{
    [btn setTitle:titleNormalText forState:UIControlStateNormal];
    [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [btn setTitle:titleHighlightedText forState:UIControlStateHighlighted];
    [btn setTitleColor:titleHighlightedColor forState:UIControlStateHighlighted];
}
@end
