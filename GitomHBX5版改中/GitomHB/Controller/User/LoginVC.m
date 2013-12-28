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
#import "registerVC.h"
#import "SVProgressHUD.h"
#import "ApplyForCompany.h"
#import "GitomSingal.h"
#import "ChangePassWordVC.h"


#define Height_Cell_LoginInput 40.0
#define Count_Cell_LoginInput 2
#define Height_Cell_LoginInfoOpera 30.0
#define Count_Cell_LoginInfoOpera 2

#define imageName_btnHistoryAccountNumber @"btnDownList"
#define imageName_btnLoginBackgroundNormal @"btnLoginBackgroundNormal"
#define imageName_btnLoginBackgroundHighlighted @"btnLoginBackgroundHighlight.png"



#define kAutoLog @"autoLog"//用于标记是否自动登入
#define kNoautoLog @"noAutoLog"
#define kRemberAuto @"rember"

#define kPassWord @"PassWord"//用于标记是否记住密码
#define kNoPassWord @"noPassWord"
#define kRemberPassWord @"remberPassWord"

#define kMinZi @"username"
#define kMiMa @"apassword"
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
    UITableView * _tbvUserHistoryIfo;
    UIImage * _imageCheckBox_on;
    UIImage * _imageCheckBox_off;
    UIImageView * _checkBoxRememberView;
    UIImageView * _checkBoxAutoLoginView;
    NSUserDefaults *accountDefaults;
    BOOL hideHistoryUserIfo;
    UIButton *registerButton;
}
@end

@implementation LoginVC
#pragma mark end
#pragma mark - 自定义视图
//用户登录框
-(void)initUserInputView:(CGRect)frame
{
    CGFloat y_start = 0;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>7.0) {
        _tbvUserLoginInput = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, frame.size.width - 10*2,Height_Cell_LoginInput * Count_Cell_LoginInput)];
    }else{
        _tbvUserLoginInput = [[UITableView alloc]initWithFrame:CGRectMake(10, y_start + 30, frame.size.width - 10*2,Height_Cell_LoginInput * Count_Cell_LoginInput)];
    }
    
    
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


#pragma mark -- 历史用户密码
//- (void)getHistoryUserNameAction{
//    NSLog(@"历史用户密码");
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        UIView *historyView = [[UIView alloc]initWithFrame:CGRectMake(10, 80, Screen_Width-20, 0)];
//        [self.view addSubview:historyView];
//        historyView.backgroundColor = BlueColor;
//        historyView.frame = CGRectMake(10, 80, Screen_Width-20, 60);
//        
//    }];
//}

#pragma mark --  生成自动登陆、记住密码界面
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
 
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRememberPasswordAction)];
    [viewPasswordRemember addGestureRecognizer:tap];
    
    
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
 
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAutoLoginAction)];
    [viewAutoLogin addGestureRecognizer:tap2];
    
    self.isRememberPasswordStr = [accountDefaults objectForKey:kRemberPassWord];
    NSLog(@"kRemberPassWord == %@",self.isRememberPasswordStr);
    if (self.isRememberPasswordStr == NULL) {
        self.isRememberPasswordStr = kNoPassWord;
    }
    NSLog(@"kRemberPassWord == %@",self.isRememberPasswordStr);
    if ([self.isRememberPasswordStr isEqualToString:kPassWord]) {
        NSLog(@"记录密码");
        _checkBoxRememberView.image = _imageCheckBox_on;
    }else{
        NSLog(@"未记录密码");
        _checkBoxRememberView.image = _imageCheckBox_off;
    }
    
    
    
    self.isAutoLoginStr = [accountDefaults objectForKey:kRemberAuto];
    NSLog(@"self.isAutoLoginStr == %@",self.isAutoLoginStr);
    if (self.isAutoLoginStr == NULL) {
        self.isAutoLoginStr = kNoautoLog;
    }
    NSLog(@"self.isAutoLoginStr == %@",self.isAutoLoginStr);
    if ([self.isAutoLoginStr isEqualToString:kAutoLog]) {
        NSLog(@"自动登陆");
        _checkBoxAutoLoginView.image = _imageCheckBox_on;
    }else{
        NSLog(@"非自动登陆");
        _checkBoxAutoLoginView.image = _imageCheckBox_off;
    }
    
    //    UITapGestureRecognizer * tapForHideKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForHideKeyboard)];
    //    [self.view addGestureRecognizer:tapForHideKeyboard];
    //    [tapForHideKeyboard release];
    
  
}

#pragma mark - UITableView相关方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == Tag_Tbv_LoginInput) {
        return Count_Cell_LoginInput;
    }else if(tableView.tag==Tag_Tbv_LoginInfoOpera){
        return Count_Cell_LoginInfoOpera;
    }else if (tableView.tag == Tag_Tbv_LoginHistory){
        return _userIfoAr.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == Tag_Tbv_LoginInput) {
        return Height_Cell_LoginInput;
    }else if(tableView.tag == Tag_Tbv_LoginInfoOpera){
        return Height_Cell_LoginInfoOpera;
    }else if(tableView.tag == Tag_Tbv_LoginHistory){
        return 40;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString * cellIdLogin = @"cellIdLogin";
    
    //登入帐号、密码
    if (tableView.tag == Tag_Tbv_LoginInput) {
        
        //UITableViewCell * myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdLogin];
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdLogin];
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:cellIdLogin];
        }
        
        //密码框
        if (indexPath.row == 1)
        {
            
            UILabel * lblPassword = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, 0, 50, Height_Cell_LoginInput)];
            [lblPassword setBackgroundColor:[UIColor clearColor]];
            lblPassword.textColor = [UIColor grayColor];
            lblPassword.text = @"密码";
            [myCell addSubview:lblPassword];

            [_tfPassword setFrame:CGRectMake(50, 10, tableView.frame.size.width - 50, Height_Cell_LoginInput - 5 *2)];
            _tfPassword.borderStyle = UITextBorderStyleNone;
            _tfPassword.placeholder = @"请输入密码";
            _tfPassword.returnKeyType = UIReturnKeyDone;
            _tfPassword.keyboardType = UIKeyboardTypeDefault;
            _tfPassword.secureTextEntry = YES;
            _tfPassword.delegate = self;
            [myCell addSubview:_tfPassword];
            
        }else if(indexPath.row == 0) {
            
            UILabel * lblUsername = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, 0, 50, Height_Cell_LoginInput)];
            [lblUsername setBackgroundColor:[UIColor clearColor]];
            lblUsername.textColor = [UIColor grayColor];
            lblUsername.text = @"账号";
            [myCell addSubview:lblUsername];

            [_tfUsername setFrame:CGRectMake(50, 10, tableView.frame.size.width - 50 - 50, Height_Cell_LoginInput - 5 *2)];
            _tfUsername.borderStyle = UITextBorderStyleNone;
            _tfUsername.returnKeyType = UIReturnKeyDone;
            _tfUsername.keyboardType = UIKeyboardTypeDefault;
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
            [btnHistoryUsername setImage:[UIImage imageNamed:@"btn_list_extra_arrow.png"] forState:UIControlStateNormal];
            
            [btnHistoryUsername addTarget:self action:@selector(showHistoryUserNameAction) forControlEvents:UIControlEventTouchUpInside];
            [myCell addSubview:btnHistoryUsername];
        }
        return myCell;
        
        
    //历史记录
    }else if (tableView.tag == Tag_Tbv_LoginHistory){
        /*
        _userIfo = [_userIfoAr objectAtIndex:indexPath.row];
        NSLog(@"——userIfo =,%@ ,%@",_userIfo.userName,_userIfo.userPassWord);
        myCell.textLabel.text = [NSString stringWithFormat:@"%@",_userIfo.userName];
        UIButton *removeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        removeBut.tag = indexPath.row+100;
        [removeBut setBackgroundImage:[UIImage imageNamed:@"ad_close_icon.png"] forState:UIControlStateNormal];
        [removeBut addTarget:self action:@selector(removeUserHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
        removeBut.frame = CGRectMake(Screen_Width-45, 7, 26, 26);
        [myCell addSubview:removeBut];
        
        
        return myCell;*/
        
        LoginHistoryCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdLogin];
        if (myCell == nil){
            
            myCell = [[LoginHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdLogin];
            myCell.delegate = self;
            myCell.removeBut.tag = indexPath.row;
            
        }
        _userIfo = [_userIfoAr objectAtIndex:indexPath.row];
        myCell.textLabel.text = [NSString stringWithFormat:@"%@",_userIfo.userName];
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
    if (tableView.tag == Tag_Tbv_LoginHistory) {
        _userIfo = [_userIfoAr objectAtIndex:indexPath.row];
        _tfUsername.text = _userIfo.userName;
        _tfPassword.text = _userIfo.userPassWord;
        tableView.hidden = YES;
        UIButton *btnHistoryUsername = (UIButton *)[self.view viewWithTag:Tag_BtnHistoryUsername];
        [btnHistoryUsername setImage:[UIImage imageNamed:@"btn_list_extra_arrow.png"] forState:UIControlStateNormal];
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.isShowHisLoginInfo = NO;
}
#pragma mark - 属性控制
#pragma mark -- 自动登入
//-(void)setIsAutoLogin:(BOOL)isAutoLogin
//{
//    _isAutoLogin = isAutoLogin;
//    if (isAutoLogin)
//    {
//        _checkBoxAutoLoginView.image = _imageCheckBox_on;
//        self.isRememberPassword = YES;
//    }else
//    {
//        _checkBoxAutoLoginView.image = _imageCheckBox_off;
//    }
//}

#pragma mark -- 记住密码
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
    [accountDefaults setObject:kNoautoLog forKey:kRemberAuto];
    [accountDefaults setObject:kNoPassWord forKey:kRemberPassWord];
    [accountDefaults synchronize];
    
    accountDefaults = [NSUserDefaults standardUserDefaults];
    //从user defaults中获取数据:
    if ([[accountDefaults objectForKey:kRemberPassWord] isEqualToString:kPassWord]||[[accountDefaults objectForKey:kRemberAuto] isEqualToString:kAutoLog]) {
        self.tfUsername.text = [accountDefaults objectForKey:kMinZi];
        self.tfPassword.text = [accountDefaults objectForKey:kMiMa];
        if ([[accountDefaults objectForKey:kRemberAuto] isEqualToString:kAutoLog]) {
            NSLog(@"自动登陆");
            [self btnAction:nil];
        }
    }
    NSLog(@"[accountDefaults objectForKey:passWord] ==%@,%@,%@",[accountDefaults objectForKey:kMiMa],[accountDefaults objectForKey:kMinZi],[accountDefaults objectForKey:kRemberPassWord]);
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
    
    
    //注册用户
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.hidden = YES;//AppStor审核用
     [registerButton setBackgroundImage:[[UIImage imageNamed:@"03.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:5]  forState:UIControlStateNormal];
     [registerButton setBackgroundImage:[[UIImage imageNamed:@"04.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateHighlighted];
    
//    registerButton.backgroundColor = [UIColor clearColor];
//    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
//    [registerButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    registerButton.titleLabel.textAlignment = UITextAlignmentRight;
    [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    registerButton.frame = CGRectMake(Screen_Width/2-40, Height_Screen - 180,80, 30);
    [self.view addSubview:registerButton];
    
    //修改密码
    UIButton *changePassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changePassWordButton.backgroundColor = [UIColor clearColor];
    [changePassWordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changePassWordButton setTitle:@"修改密码" forState:UIControlStateNormal];
    [changePassWordButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    changePassWordButton.titleLabel.font = [UIFont systemFontOfSize:13];
    changePassWordButton.titleLabel.textAlignment = UITextAlignmentRight;
    [changePassWordButton addTarget:self action:@selector(changePassWordAction) forControlEvents:UIControlEventTouchUpInside];
    changePassWordButton.frame = CGRectMake(0, Height_Screen - 150, Screen_Width, 20);
    [self.view addSubview:changePassWordButton];
    
    UILabel *lblVersionInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, Height_Screen - 120, Width_Screen - 20, 30)];
    lblVersionInfo.text = @"版本 : v1.0.0";
    lblVersionInfo.font = [UIFont systemFontOfSize:15];
    lblVersionInfo.textColor = [UIColor grayColor];
    lblVersionInfo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblVersionInfo];
    lblVersionInfo.textAlignment = NSTextAlignmentCenter;
 
    
    //成功登入用户查询
    _userIfoAr = [UserInformationsManager findAll];
    _userIfo = [[UserInformationsManager alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 用户事件
#pragma mark -- 注册
- (void) registerAction{
    registerVC *reg = [[registerVC alloc]init];
    [self.navigationController pushViewController:reg animated:YES];
  
}
#pragma mark -- 重置密码
- (void)changePassWordAction{
    ChangePassWordVC *chang = [[ChangePassWordVC alloc]init];
    [self.navigationController pushViewController:chang animated:YES];
  
}

- (void)removeHistoryDelegat:(UIButton *)sender{
    _userIfo = [_userIfoAr objectAtIndex:sender.tag];
    NSLog(@"remove useerid %@",_userIfo.userName);
    [UserInformationsManager deleteWithId:_userIfo.userName];
    _userIfoAr = [UserInformationsManager findAll];
    [_tbvUserHistoryIfo reloadData];
}

#pragma mark -- 删除历史帐号
- (void)removeUserHistoryAction:(id)sender{
    int index = ((UIButton *)sender).tag-100;
    NSLog(@"remove button %d",index);
    _userIfo = [_userIfoAr objectAtIndex:index];
    NSLog(@"remove useerid %@",_userIfo.userName);
    [UserInformationsManager deleteWithId:_userIfo.userName];
    _userIfoAr = [UserInformationsManager findAll];
    [_tbvUserHistoryIfo reloadData];
}
#pragma mark -- 历史记录帐号
- (void)showHistoryUserNameAction{
    NSLog(@"历史记录帐号");
    UIButton *btnHistoryUsername = (UIButton *)[self.view viewWithTag:Tag_BtnHistoryUsername];
    [btnHistoryUsername setImage:[UIImage imageNamed:imageName_btnHistoryAccountNumber] forState:UIControlStateNormal];
    if (hideHistoryUserIfo) {
        [btnHistoryUsername setImage:[UIImage imageNamed:@"btn_list_extra_arrow.png"] forState:UIControlStateNormal];
        _tbvUserHistoryIfo.hidden = YES;
        hideHistoryUserIfo = NO;
    }else{
        if (_userIfoAr.count >4) {
            _tbvUserHistoryIfo = [[UITableView alloc]initWithFrame:CGRectMake(10, 70, Screen_Width-20, 160)];
        }else{
            _tbvUserHistoryIfo = [[UITableView alloc]initWithFrame:CGRectMake(10, 70, Screen_Width-20, _userIfoAr.count *40)];
        }
        
        _tbvUserHistoryIfo.delegate = self;
        _tbvUserHistoryIfo.dataSource = self;
        _tbvUserHistoryIfo.tag = Tag_Tbv_LoginHistory;
        [self.view addSubview:_tbvUserHistoryIfo];
        hideHistoryUserIfo = YES;
    }
}

//处理用户事件
#pragma mark -- 登入
-(void)btnAction:(UIButton *)btn
{
    GetCommonDataModel;
    NSLog(@"开始登入");
    NSString * username = _tfUsername.text;
    NSString * password = _tfPassword.text;
    
    /*AppStore审核用*/
    if ([username isEqualToString:@"注册"]){
        registerButton.hidden = NO;
        [SVProgressHUD showErrorWithStatus:@"通过下方的‘注册’按钮注册"];
        [_tfUsername resignFirstResponder];
        return;
    }
    
    //登录参数
    UserLoggingInfo * loggingInfo = [[UserLoggingInfo alloc]init];
    
    //以下为测试的时候用
    if (![username length] && ![password length]) {
        NSLog(@"空的用户名、密码");
    }else
    {
        //将登入时填写的信息存储进LoggingInfo中
        loggingInfo.username = username;
        loggingInfo.password = password;
    }
        
    //用户业务管理
    UserManager * um = [UserManager sharedUserManager];
    comData.userlogingInfo = loggingInfo;
    //用户登录方法
    [SVProgressHUD showWithStatus:@"正在登录,请稍后..." maskType:4];
    [um loggingWithLoggingInfo:loggingInfo
                    WbLoggedInfo:^( UserLoggedInfo *loggedInfo,BOOL isLoggedOk)
        {
            if (isLoggedOk) {
                
                comData.isLogged = YES;
                comData.serverDate = loggedInfo.serverDate;
                
                /*存储成功登入的用户、密码*/
                [accountDefaults setObject:username forKey:kMinZi];
                [accountDefaults setObject:password forKey:kMiMa];
                NSLog(@"aaccountDefaults objectForKey%@ %@",[accountDefaults objectForKey:kMinZi],[accountDefaults objectForKey:kMiMa]);
                [accountDefaults synchronize];
                
                if ([[accountDefaults objectForKey:kRemberPassWord] isEqualToString:kPassWord]){
                    /*将成功登入的密码存进数据库*/
                    //查询数据库，判断表中是否存在相同的数据
                    //UserInformationsManager *manager = [[UserInformationsManager alloc]init];
                    //[UserInformationsManager insertWithUserName:loggingInfo.username andUserPassWord:loggingInfo.password andUserId:_userIfoAr.count+1];
                    [UserInformationsManager insertWithUserName:loggingInfo.username andUserPassWord:loggingInfo.password];
                    NSLog(@"LoginVC 插入的数据 == %@,%@,%d",loggingInfo.username,loggingInfo.password,_userIfoAr.count+1);
                }

                /*
                 这边要得到用户信息。。。
                 */
                comData.cookie = loggedInfo.cookie;//将登入时候获得的cookie
                UserModel * user = [[UserModel alloc] initForAllJsonDataTypeWithDicFromJson:loggedInfo.user];//传入loggedInfo中的user字典，用过UserModel的initForAllJsonDataTypeWithDicFromJson:方法获得字典中的所有内容。
                comData.userModel = user;//使用单例的userModel属性获得user中转换好的用户信息：头像url、账号等等
                
                Organization * organizationInfo = [[Organization alloc]initForAllJsonDataTypeWithDicFromJson:[loggedInfo.organizations lastObject]];
                comData.organization = organizationInfo;//使用单例的获得解析到的用户信息
          
                
                //成功跳转
                if (organizationInfo.roleId) {
                    _sideViewController = [[JASidePanelController alloc]init];
                    _sideViewController.shouldDelegateAutorotateToVisiblePanel = NO;
                    
                    
                    MobileReportVC * mrVC = [[MobileReportVC alloc]init];
                    MyNavigationController * ncMrvc = [[MyNavigationController alloc]initWithRootViewController:mrVC];
               
                    _sideViewController.centerPanel = ncMrvc;
                    
                    MenuVC * mvc = [[MenuVC alloc]initWithRoleId:organizationInfo.roleId
                                                       UserModel:comData.userModel
                                                OrganizationName:comData.organization.name];
                    MyNavigationController * mnc = [[MyNavigationController alloc]initWithRootViewController:mvc];
            
                    _sideViewController.leftPanel = mnc;
                    _sideViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:_sideViewController animated:YES completion:^{}];
                    [_sideViewController showLeftPanelAnimated:NO];
                    [SVProgressHUD dismissWithIsOk:YES String:@"登入成功！"];
                }else{
                    NSLog(@"还未绑定");
                    [SVProgressHUD dismissWithIsOk:NO String:@"您还未加入公司"];
                    GitomSingal *singal = [GitomSingal getInstance];
                    singal.registerName = self.tfUsername.text;
                    ApplyForCompany *applyVC = [[ApplyForCompany alloc]init];
                    [self.navigationController pushViewController:applyVC animated:NO];
                }
               
            }
        }];
   
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self tapForHideKeyboard];
}
-(void)tapForHideKeyboard
{
    [self.view endEditing:YES];
}
#pragma mark -- 记住用户密码相关
-(void)tapRememberPasswordAction
{
    NSLog(@"mark -- 记住用户密码相关accountDefaults objectForKey:@ %@",[accountDefaults objectForKey:kRemberPassWord]);
    if ([[accountDefaults objectForKey:kRemberPassWord] isEqualToString:kNoPassWord]) {
        NSLog(@"kNoPassWord->kPassWord");
        [accountDefaults setObject:kPassWord forKey:kRemberPassWord];
        _checkBoxRememberView.image = _imageCheckBox_on;
    }else{
        NSLog(@"kPassWord->kNoPassWord");
        [accountDefaults setObject:kNoPassWord forKey:kRemberPassWord];
        _checkBoxRememberView.image = _imageCheckBox_off;
    }
    [accountDefaults synchronize];
    //self.isRememberPassword = !self.isRememberPassword;
}
#pragma mark -- 自动登陆相关
-(void)tapAutoLoginAction
{
    NSLog(@" mark -- 自动登陆相关 accountDefaults objectForKey:@ %@",[accountDefaults objectForKey:kRemberAuto]);
    if ([[accountDefaults objectForKey:kRemberAuto] isEqualToString:kNoautoLog]) {
        NSLog(@"kNoautoLog");
        [accountDefaults setObject:kAutoLog forKey:kRemberAuto];
        _checkBoxAutoLoginView.image = _imageCheckBox_on;
    }else{
        NSLog(@"kAutoLog");
        [accountDefaults setObject:kNoautoLog forKey:kRemberAuto];
        _checkBoxAutoLoginView.image = _imageCheckBox_off;
    }
    [accountDefaults synchronize];
    //self.isAutoLogin = !self.isAutoLogin;
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

#pragma mark -  刷新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _userIfoAr=[UserInformationsManager findAll];
    [_tbvUserHistoryIfo reloadData];
    
}
@end
