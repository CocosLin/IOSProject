//
//  UserLoginView.m
//  GitomAPP
//
//  Created by jiawei on 13-7-15.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "UserLoginView.h"

#import <QuartzCore/QuartzCore.h>
#import "ChooseViewController.h"

#import "UserLonginManger.h"
#import "UserLogin.h"

#import "ViewController.h"
#import "UserInformationsManager.h"

#import "LoginStatueSingal.h"
#import "UserInfomations.h"

#import "JSON.h"

#import "HZActivityIndicatorView.h"

//#import "LoginStatueSingal.h"
#import "GetLabelHightAndBreakLines.h"

@implementation UserLoginView
//@synthesize javascriptBridge = _bridge;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BackgroundColor_Black;
        
        _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-66)];
        _baseView.backgroundColor = BackgroundColor_Black;
        //_baseView.backgroundColor = [UIColor greenColor];
        [self addSubview:_baseView];
        
        [self loadUserLoginStatuView];
        
        //成功登入用户查询
        _userIfoAr = [UserInformationsManager findAll];
        _userIfo = [[UserInformationsManager alloc]init];
       
        [self userInfoRecorded1];
        [self userInfoRecorded2];
        [self userInfoRecorded3];
        
    }
    return self;
}


#pragma mark -- 创建用户登入输入界面
- (void) loadUserLoginStatuView
{
    _yView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, Screen_Width-20, 150)];
    _yView.backgroundColor = [UIColor clearColor];
    [_baseView addSubview:_yView];
    

    
    _logView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, Screen_Width-20, 150)];
    _logView.backgroundColor = [UIColor whiteColor];
    _logView.layer.cornerRadius = 10;
    [_baseView addSubview:_logView];
    
        //用户名
    _userNumber = [[UITextField alloc]initWithFrame:CGRectMake(15, 11, _logView.bounds.size.width-30, 35)];
    //[_userNumber becomeFirstResponder];
    _userNumber.placeholder = @"请输入账号";
    _userNumber.delegate = self;
    _userNumber.keyboardType = UIKeyboardTypeNumberPad;
    _userNumber.borderStyle = UITextBorderStyleRoundedRect;
    _userNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIImageView *imgv=[[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, 23, 22)];
    imgv.image = [UIImage imageNamed:@"glyphicons_003_user_g.png"];//initWithImage:[UIImage imageNamed:@"glyphicons_003_user.png"]];
    _userNumber.leftView = imgv;
    _userNumber.leftViewMode = UITextFieldViewModeAlways;
    [_logView addSubview:_userNumber];
    
    
    //密码
    _password = [[UITextField alloc]initWithFrame:CGRectMake(15, 57, _logView.bounds.size.width-30, 35)];
    _password.placeholder = @"请输入密码";
    _password.secureTextEntry = YES;//隐藏输入密码
    _password.delegate = self;
    _password.keyboardType = UIKeyboardTypeASCIICapable;
    _password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _password .borderStyle = UITextBorderStyleRoundedRect;
    _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIImageView *imgv1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 24)];
    imgv1.image = [UIImage imageNamed:@"glyphicons_203_lock_g.png"];//initWithImage:[UIImage imageNamed:@"glyphicons_003_user.png"]];
    //initWithImage:[UIImage imageNamed:@"glyphicons_203_lock_g.png"]];
    _password.leftView = imgv1;
    _password.leftViewMode = UITextFieldViewModeAlways;
    [_logView addSubview:_password];
    
    
    //登录
    UIButton *loginBT = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBT.backgroundColor = BackgroundColor_Gray;
    loginBT.layer.cornerRadius = 8;
    [loginBT addTarget:self action:@selector(userLog) forControlEvents:UIControlEventTouchUpInside];
    [loginBT setImage:[UIImage imageNamed:@"bottom_bg.png"] forState:UIControlStateHighlighted];
    [loginBT setTintColor:[UIColor whiteColor]];
    [loginBT setTitle:@"登录" forState:UIControlStateNormal];
    loginBT.frame = CGRectMake(15, 103, _logView.bounds.size.width-30, 35);
    [_logView addSubview:loginBT];
    
    
    _loginStatue = [LoginStatueSingal shareLogStatu];
    
    if (_loginStatue.shiftStatu == 1) {//已经有用户输入正确的用户信息
        _logView.hidden = YES;
        
        _userLoginView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 20, Screen_Width-20, 90)];
        [self addSubview:_userLoginView2];
        _userLoginView2.backgroundColor = [UIColor whiteColor];
        _userLoginView2.layer.cornerRadius = 8;
        
        //头像（图片）
        UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 64, 64 )];
        userImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_user_s.png"]];
        userImg.image = [UIImage imageWithData:_loginStatue.userImgData];
        [_userLoginView2 addSubview:userImg];
        
        //用户姓名
        UILabel *userNameLabel = [[UILabel alloc]init ];//WithFrame:CGRectMake(110, 18, 150, 30)];
        GetLabelHightAndBreakLines *getLabelHight = [[GetLabelHightAndBreakLines alloc]init];//根据Label文字量自动调整Label高度的类
        CGFloat labelHight = [getLabelHight highOfLabel:userNameLabel
                                      numberTextOfLabel:_loginStatue.userName
                                            andFontSize:20];
        userNameLabel.frame = CGRectMake(88, 15, 200, labelHight);
        userNameLabel.text = _loginStatue.userName;
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.textColor = [UIColor blackColor];
        userNameLabel.font = [UIFont systemFontOfSize:20];
        [_userLoginView2 addSubview:userNameLabel];
        
        //用户编号
        UILabel *userNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 18+labelHight, 100, 18)];
        userNumberLabel.text = _loginStatue.userNumber;
        userNumberLabel.backgroundColor = [UIColor clearColor];
        userNumberLabel.textColor = [UIColor blackColor];
        userNumberLabel.font = [UIFont systemFontOfSize:12];
        [_userLoginView2 addSubview:userNumberLabel];
        
        //退出当前账号按钮
        UIView *exitUserLogBT = [[UIView alloc]initWithFrame:CGRectMake(205, 60, 80, 25)];
        exitUserLogBT.tag = 1001;
        exitUserLogBT.layer.cornerRadius = 5;
        exitUserLogBT.backgroundColor = BackgroundColor_Gray;
        [_userLoginView2 addSubview:exitUserLogBT];
        UILabel *titleOfBT = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 70, 15)];
        titleOfBT.text = @"退出账号";
        titleOfBT.backgroundColor = [UIColor clearColor];
        titleOfBT.textAlignment = NSTextAlignmentCenter;
        titleOfBT.textColor = [UIColor whiteColor];
        titleOfBT.font = [UIFont systemFontOfSize:12];
        [exitUserLogBT addSubview:titleOfBT];
        
        UITapGestureRecognizer *tapToExit = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitAtion)];//退出手势
        [exitUserLogBT addGestureRecognizer:tapToExit];
        
        
        _yView.frame  = CGRectMake(10, 20, Screen_Width-20, 90);
        
    }
}
static int areYouExite = 1;
#pragma mark -- 退出当前账号
- (void) exitAtion
{
    [UIView animateWithDuration:0.5 animations:^{
        UIView *exitUserLogBT = (UIView *)[self viewWithTag:1001];
        exitUserLogBT.backgroundColor = BackgroundColor_Green;
        exitUserLogBT.backgroundColor = BackgroundColor_Gray;
    }];
    
    [_logView removeFromSuperview];
    [_userLoginView2 removeFromSuperview];
    UIView *recordView1 = [self viewWithTag:3001];
    [recordView1 removeFromSuperview];
    UIView *recordView2 = [self viewWithTag:3002];
    [recordView2 removeFromSuperview];
    UIView *recordView3 = [self viewWithTag:3003];
    [recordView3 removeFromSuperview];
    
    
    LoginStatueSingal *loginStatue = [LoginStatueSingal shareLogStatu];
    loginStatue.logStatu = 2;
    loginStatue.shiftStatu = 2;
    areYouExite = 2;
    loginStatue.exitAccountStatu = areYouExite;
    NSLog(@"exitAccount");
    
    [self loadUserLoginStatuView];
    [self userInfoRecorded1];
    [self userInfoRecorded2];
    [self userInfoRecorded3];
}



#pragma mark -- 记录的已经登入用户的数据（密码、名字等等）
#pragma mark  用户记录1
- (void) userInfoRecorded1{
    _userIfo = [_userIfoAr objectAtIndex:0];
   // NSLog(@"id = %d username = %@",_userIfo.userId,_userIfo.userNumber);
    //_userIfo.userNumber = @"95590";
    //NSLog(@"_userIfoAr == %@",_userIfoAr);
    
    
    UIView *user1 = [[UIView alloc]init];
    user1.tag = 3001;
   // NSLog(@"id = %d username = %@",_userIfo.userId,_userIfo.userNumber);
    
    //对查询结果进行逻辑判断：是否是空的数据，空数据不显示
    if ([_userIfo.userNumber isEqualToString:@" "]) {
        user1.frame = CGRectZero;
        //nil;
    }else{
        user1.frame = CGRectMake(10, _yView.frame.size.height +35, Screen_Width-20, 60);
        user1.backgroundColor = [UIColor clearColor];
        [_baseView addSubview:user1];
    }
    
    //头像
    UIImageView *userImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    userImg.backgroundColor = [UIColor clearColor];
    userImg.image = [UIImage imageNamed:@"info_user.png"];
    [user1 addSubview:userImg];
    
    //用户名
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 80, 25)];
    userName.backgroundColor = [UIColor clearColor];
    userName.textColor = [UIColor whiteColor];
    userName.text = _userIfo.userName;
    [user1 addSubview:userName];
    
    //用户编号
    UILabel *userNumber = [[UILabel alloc]initWithFrame:CGRectMake(65, 35, 80, 20)];
    userNumber.backgroundColor = [UIColor clearColor];
    userNumber.textColor = [UIColor whiteColor];
    userNumber.text = _userIfo.userNumber;
    [user1 addSubview:userNumber];
    
    //移除按钮
    UIView *removeUser = [[UIView alloc]initWithFrame:CGRectMake(150, 20, 70, 30)];
    removeUser.tag = 2001;
    removeUser.backgroundColor = BackgroundColor_Gray;
    UILabel *removeTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    removeTitle.backgroundColor = [UIColor clearColor];
    removeTitle.textColor = [UIColor whiteColor];
    removeTitle.font = [UIFont systemFontOfSize:12];
    removeTitle.textAlignment = NSTextAlignmentCenter;
    removeTitle.text = @"移除记录";
    [removeUser addSubview:removeTitle];
    [user1 addSubview:removeUser];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeRecodAction1)];
    [removeUser addGestureRecognizer:tap];
    
    //使用按钮
    UIView *useTheUser = [[UIView alloc]initWithFrame:CGRectMake(225, 20, 70, 30)];
    useTheUser.tag = 2002;
    useTheUser.backgroundColor = BackgroundColor_Gray;
    UILabel *useTheTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    useTheTitle.backgroundColor = [UIColor clearColor];
    useTheTitle.textAlignment = NSTextAlignmentCenter;
    useTheTitle.textColor = [UIColor whiteColor];
    useTheTitle.font = [UIFont systemFontOfSize:12];
    useTheTitle.text = @"使用该账号";
    [useTheUser addSubview:useTheTitle];
    [user1 addSubview:useTheUser];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useRecodAction1)];
    [useTheUser addGestureRecognizer:tap1];
}

- (void)removeRecodAction1{
    
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self viewWithTag:2001];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Gray;
    }];
    //NSLog(@"1");
    
    [UserInformationsManager upateName:@" " andNumber:@" " andPassWord:@" " andUserImage:nil withId:1];
    
    //调用刷新ViewContrller的代理方法
    if (self.pushDelegate != nil && [self.pushDelegate respondsToSelector:@selector(refreshView)]) {
        [self.pushDelegate refreshView];
    }
    
}

- (void) useRecodAction1{
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self viewWithTag:2002];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Gray;
    }];
    
    _userIfo = [_userIfoAr objectAtIndex:0];
    
    //NSLog(@"使用%@账号",_userIfo.userNumber);
    //NSLog(@"密码%@",_userIfo.passWord);
    /*
     ……连接
     */
    
    LoginStatueSingal *log = [LoginStatueSingal shareLogStatu];
    log.userNumber = _userIfo.userNumber;
    log.logStatu = 1;
    //log.exitAccountStatu = 1;
    _flag = 1;
    if (log.shiftStatu == 1) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请退出当前账号再登入" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [aler show];
    }else{
        [self userLog];//验证并登入 
    }
    
}

#pragma mark  用户记录2
- (void) userInfoRecorded2{
    _userIfo = [_userIfoAr objectAtIndex:1];
   // NSLog(@"id = %d username = %@",_userIfo.userId,_userIfo.userNumber);
   // _userIfo.userNumber = @"95590";
   // NSLog(@"_userIfoAr == %@",_userIfoAr);
    UIView *lastView = [self viewWithTag:3001];
    UIView *user1 = [[UIView alloc]init];
    user1.tag = 3002;
   // NSLog(@"id = %d username = %@",_userIfo.userId,_userIfo.userNumber);
    
    //对查询结果进行逻辑判断：是否是空的数据，空数据不显示
    if ([_userIfo.userNumber isEqualToString:@" "]) {
        user1.frame = CGRectZero;
        //nil;
    }else{
        
        user1.frame = CGRectMake(10, _yView.frame.size.height +45+lastView.frame.size.height, Screen_Width-20, 60);
        user1.backgroundColor = [UIColor clearColor];
        [_baseView addSubview:user1];
    }
    
    //头像
    UIImageView *userImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    userImg.backgroundColor = [UIColor clearColor];
    userImg.image = [UIImage imageNamed:@"info_user.png"];
    [user1 addSubview:userImg];
    
    //用户名
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 80, 25)];
    userName.backgroundColor = [UIColor clearColor];
    userName.textColor = [UIColor whiteColor];
    userName.text = _userIfo.userName;
    [user1 addSubview:userName];
    
    //用户编号
    UILabel *userNumber = [[UILabel alloc]initWithFrame:CGRectMake(65, 35, 80, 20)];
    userNumber.backgroundColor = [UIColor clearColor];
    userNumber.textColor = [UIColor whiteColor];
    userNumber.text = _userIfo.userNumber;
    [user1 addSubview:userNumber];
    
    //移除按钮
    UIView *removeUser = [[UIView alloc]initWithFrame:CGRectMake(150, 20, 70, 30)];
    removeUser.tag = 2003;
    removeUser.backgroundColor = BackgroundColor_Gray;
    UILabel *removeTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    removeTitle.backgroundColor = [UIColor clearColor];
    removeTitle.textColor = [UIColor whiteColor];
    removeTitle.font = [UIFont systemFontOfSize:12];
    removeTitle.textAlignment = NSTextAlignmentCenter;
    removeTitle.text = @"移除记录";
    [removeUser addSubview:removeTitle];
    [user1 addSubview:removeUser];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeRecodAction2)];
    [removeUser addGestureRecognizer:tap];
    
    //使用按钮
    UIView *useTheUser = [[UIView alloc]initWithFrame:CGRectMake(225, 20, 70, 30)];
    useTheUser.tag = 2004;
    useTheUser.backgroundColor = BackgroundColor_Gray;
    UILabel *useTheTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    useTheTitle.backgroundColor = [UIColor clearColor];
    useTheTitle.textAlignment = NSTextAlignmentCenter;
    useTheTitle.textColor = [UIColor whiteColor];
    useTheTitle.font = [UIFont systemFontOfSize:12];
    useTheTitle.text = @"使用该账号";
    [useTheUser addSubview:useTheTitle];
    [user1 addSubview:useTheUser];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useRecodAction2)];
    [useTheUser addGestureRecognizer:tap1];
}

- (void)removeRecodAction2{
    
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self viewWithTag:2003];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Gray;
    }];
    //NSLog(@"2");
    
    [UserInformationsManager upateName:@" " andNumber:@" " andPassWord:@" " andUserImage:nil withId:2];
    
    //调用刷新ViewContrller的代理方法
    if (self.pushDelegate != nil && [self.pushDelegate respondsToSelector:@selector(refreshView)]) {
        [self.pushDelegate refreshView];
    }
}

- (void) useRecodAction2{
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self viewWithTag:2004];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Gray;
    }];
    //NSLog(@"useRecodAction1");
    
    _userIfo = [_userIfoAr objectAtIndex:1];
    
    //NSLog(@"使用%@账号",_userIfo.userNumber);
    //NSLog(@"密码%@",_userIfo.passWord);
    /*
     ……连接
     */
    
    
    LoginStatueSingal *log = [LoginStatueSingal shareLogStatu];
    log.userNumber = _userIfo.userNumber;
    log.logStatu = 1;
    //log.exitAccountStatu = 1;
    _flag = 2;
    
    if (log.shiftStatu == 1) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请退出当前账号再登入" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [aler show];
    }else{
        [self userLog];//验证并登入
    }
    
}

#pragma mark  用户记录3
- (void) userInfoRecorded3{
    _userIfo = [_userIfoAr objectAtIndex:2];
    //NSLog(@"id = %d username = %@",_userIfo.userId,_userIfo.userNumber);
    //_userIfo.userNumber = @"95590";
    //NSLog(@"_userIfoAr == %@",_userIfoAr);
    UIView *lastView1 = [self viewWithTag:3001];
    UIView *lastView2 = [self viewWithTag:3002];
    UIView *user1 = [[UIView alloc]init];
    user1.tag = 3003;
    //NSLog(@"id = %d username = %@",_userIfo.userId,_userIfo.userNumber);
    
    //对查询结果进行逻辑判断：是否是空的数据，空数据不显示
    if ([_userIfo.userNumber isEqualToString:@" "]) {
        user1.frame = CGRectZero;
        nil;
    }else{
        user1.frame = CGRectMake(10, _yView.frame.size.height +55 + lastView2.frame.size.height+lastView1.frame.size.height, Screen_Width-20, 60);
        user1.backgroundColor = [UIColor clearColor];
        [_baseView addSubview:user1];
    }
    
    //头像
    UIImageView *userImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    userImg.backgroundColor = [UIColor clearColor];
    userImg.image = [UIImage imageNamed:@"info_user.png"];
    [user1 addSubview:userImg];
    
    //用户名
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 80, 25)];
    userName.backgroundColor = [UIColor clearColor];
    userName.textColor = [UIColor whiteColor];
    userName.text = _userIfo.userName;
    [user1 addSubview:userName];
    
    //用户编号
    UILabel *userNumber = [[UILabel alloc]initWithFrame:CGRectMake(65, 35, 80, 20)];
    userNumber.backgroundColor = [UIColor clearColor];
    userNumber.textColor = [UIColor whiteColor];
    userNumber.text = _userIfo.userNumber;
    [user1 addSubview:userNumber];
    
    //移除按钮
    UIView *removeUser = [[UIView alloc]initWithFrame:CGRectMake(150, 20, 70, 30)];
    removeUser.tag = 2005;
    removeUser.backgroundColor = BackgroundColor_Gray;
    UILabel *removeTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    removeTitle.backgroundColor = [UIColor clearColor];
    removeTitle.textColor = [UIColor whiteColor];
    removeTitle.font = [UIFont systemFontOfSize:12];
    removeTitle.textAlignment = NSTextAlignmentCenter;
    removeTitle.text = @"移除记录";
    [removeUser addSubview:removeTitle];
    [user1 addSubview:removeUser];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeRecodAction3)];
    [removeUser addGestureRecognizer:tap];
    
    //使用按钮
    UIView *useTheUser = [[UIView alloc]initWithFrame:CGRectMake(225, 20, 70, 30)];
    useTheUser.tag = 2006;
    useTheUser.backgroundColor = BackgroundColor_Gray;
    UILabel *useTheTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    useTheTitle.backgroundColor = [UIColor clearColor];
    useTheTitle.textAlignment = NSTextAlignmentCenter;
    useTheTitle.textColor = [UIColor whiteColor];
    useTheTitle.font = [UIFont systemFontOfSize:12];
    useTheTitle.text = @"使用该账号";
    [useTheUser addSubview:useTheTitle];
    [user1 addSubview:useTheUser];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useRecodAction3)];
    [useTheUser addGestureRecognizer:tap1];
}

- (void)removeRecodAction3{
    
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self viewWithTag:2005];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Gray;
    }];
    //NSLog(@"3");
    
    [UserInformationsManager upateName:@" " andNumber:@" " andPassWord:@" " andUserImage:nil withId:3];
    
    //调用刷新ViewContrller的代理方法
    if (self.pushDelegate != nil && [self.pushDelegate respondsToSelector:@selector(refreshView)]) {
        [self.pushDelegate refreshView];
    }
}

- (void) useRecodAction3{
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self viewWithTag:2006];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Gray;
    }];
    //NSLog(@"useRecodAction2");
    
    _userIfo = [_userIfoAr objectAtIndex:2];
    
    //NSLog(@"使用%@账号",_userIfo.userNumber);
    //NSLog(@"密码%@",_userIfo.passWord);
    /*
     ……连接
     */
        
    LoginStatueSingal *log = [LoginStatueSingal shareLogStatu];
    log.userNumber = _userIfo.userNumber;
    log.logStatu = 1;
    //log.exitAccountStatu = 1;
    _flag = 3;
    if (log.shiftStatu == 1) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请退出当前账号再登入" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [aler show];
    }else{
        [self userLog];//验证并登入
    }
    
}

//http://uc.gitom.com/api/user/validate_user?usernumber=95590&pasw=670b14728ad9902aecba32e22fa4f6bd

#pragma mark -- uitextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-230);
    _baseView.contentSize = self.frame.size;
}

#pragma mark -- 登入验证
static int idx=1;
- (void)userLog
{
    //NSLog(@"用户登录");
    //测试账号
//    _password.text = @"121212";
//    _userNumber.text = @"90261";
    self.loginStatue.exitAccountStatu = 1;//表示已有用户登入
    [_userNumber resignFirstResponder];
    [_password resignFirstResponder];
    if (self.pushDelegate != nil && [self.pushDelegate respondsToSelector:@selector(pushToLonginView)]) {
        
        //对登入框是否为空进行判断
        if (_password.text.length != 0 || _userNumber.text.length != 0 || _flag==1||_flag ==2 ||_flag == 3) {//输入框非空
            NSString *userNameAndPassWord = [[NSString alloc]init];
            //测试账号、密码
            if (_flag==1||_flag ==2||_flag==3) {//已被记录的用户信息
                //_password =
                //NSLog(@"使用已被记录的用户信息");
                _userIfo = [_userIfoAr objectAtIndex:_flag-1];
                _userNumber.text = _userIfo.userNumber;
                _password.text = _userIfo.passWord;
                //NSLog(@"_password.text=%@",_password.text);
                userNameAndPassWord = [NSString stringWithFormat:@"http://uc.gitom.com/api/user/validate_user?usernumber=%@&pasw=%@",_userIfo.userNumber,_userIfo.passWord];
            }else{
                // NSLog(@"使用输入的用户信息");
                _password.text = [MyMD5 md5:_password.text];//MD5编码
                //NSLog(@"_password.text=%@",_password.text);
                userNameAndPassWord = [NSString stringWithFormat:@"http://uc.gitom.com/api/user/validate_user?usernumber=%@&pasw=%@",_userNumber.text,_password.text];
            }
        
           //NSLog(@"验证结果==%@",userNameAndPassWord);
            
            //解析登入用户名、密码
            UserLogin *user = [[UserLonginManger alloc]connectUrl:userNameAndPassWord];
            if (user == nil) {
                nil;
            }else{
            
            //对登入的结果进行逻辑判断
            if ([user.message isEqualToString:@"用户名密码正确！"]) {//登入成功
                //NSLog(@"%@",user.message);
                //http://login.gitom.com/remoteLogin?service=file:///abc.html&loginUrl=http://www.gitom.com&submit=gitom&&username=95590&password=670b14728ad9902aecba32e22fa4f6bd网页全局登入
                //http://res.dev.gitom.com/htmlUserinfo?act=cas用户信息

                NSString *casString = [NSString stringWithFormat:@"http://login.gitom.com/remoteLogin?service=http://res.gitom.com/htmlUserinfo?act=cas&loginUrl=http://www.gitom.com&submit=gitom&&username=%@&password=%@",_userNumber.text,_password.text];
                NSLog(@"cas全局登入 == %@",casString);
                [self addSubview:_loginSuccessWeb];
                
                //不用于显示的用户登入成功的网页
                _loginSuccessWeb = [[UIWebView alloc]initWithFrame:self.frame];
                _loginSuccessWeb.tag = 2001;
                _loginSuccessWeb.backgroundColor = [UIColor greenColor];
                _loginSuccessWeb.hidden = YES;
                _loginSuccessWeb.delegate = self;
                [_loginSuccessWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:casString]]];
                
            }else{//登入失败
                
                //NSLog(@"%@",user.message);
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:user.message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [aler show];
            }
        }
        }else{//输入框为空
            //NSLog(@"输入的用户或密码为空");
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入的用户或密码为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        }        
    }
}



#pragma mark -- UIWebView网络连接的代理方法
#pragma mark 开始连接
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.4];
    [self addSubview:backView];
    
    HZActivityIndicatorView *activityIndicator = [[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(Screen_Width/2-30, Screen_Height/2-80, 40, 40)];
    activityIndicator.tag = 1001;
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.opaque = YES;
    activityIndicator.steps = 8;
    activityIndicator.finSize = CGSizeMake(17, 10);
    activityIndicator.indicatorRadius = 20;
    activityIndicator.stepDuration = 0.150;
    activityIndicator.color = BackgroundColor_Green;
    activityIndicator.cornerRadii = CGSizeMake(0, 0);
    [activityIndicator startAnimating];
    [backView addSubview:activityIndicator];
  
    UILabel *loadLabel = [[UILabel alloc]initWithFrame:CGRectMake(12.5, 25, 60, 15)];
    loadLabel.backgroundColor = [UIColor clearColor];
    loadLabel.textColor = [UIColor whiteColor];
    loadLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    loadLabel.text = @"载入中";
    //loadLabel.font = [UIFont systemFontOfSize:12];
    [activityIndicator addSubview:loadLabel];
}

#pragma mark 结束连接
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loginStatue.loginViewFlag = 1;//判断登入状态的单例
    
//    [_loginSuccessWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://res.dev.gitom.com/htmlUserinfo?act=cas"]]];
    
    NSURL *url = [NSURL URLWithString:@"http://res.gitom.com/htmlUserinfo?act=cas"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSData *getData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    //NSLog(@"%@",getData);
    
    NSString *dataStr = [[NSString alloc]initWithData:getData  encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",dataStr);
    
    NSArray *cutStrAr1 = [dataStr componentsSeparatedByString:@" = "];
    NSString *str1 = [cutStrAr1 objectAtIndex:1];
    //NSLog(@"str1 == %@",str1);
    
    NSArray *cutStrAr2 = [str1 componentsSeparatedByString:@";window"];
    NSString *str2 = [cutStrAr2 objectAtIndex:0];
    //NSLog(@"str2 === %@",str2);
    
    NSDictionary *dataJeson = [str2 JSONValue];
    
    
    //创建网站的用户解析的内容{"name":"72273","nick_name":"晋江市网即通网络科技有限公司","user_photo":"http://img5.gitom.com/logicaldoc/file/2012/10/31/111787_0/1.0+100-100+.png?t=1298","is_dealer":false,"dealer":"22472","fileupload_path":"http://img2.gitom.com/logicaldoc/","fileupload_sid":"88e03cd4-cb5a-4364-a60e-150039bd2de9","key":"c1f7649bbbbbe514761c7a1e9ffb7b64b74b3c9a22eeda633d94d1b16b8b1481c58c7644309383904d26a5ae8a87fbd3679aca16360196a1"}
    
    //未创建网站用户解析的内容：{"name":"95590","nick_name":"cj","is_dealer":false,"dealer":"1","fileupload_path":"http://img2.gitom.com/logicaldoc/","fileupload_sid":"37acc8d2-f713-4980-bcb6-9f4d25d3bc96","key":"2d45d3d273ecc035a29cc93e526e541a64e2076e90066c871795ed6d9960e8d85b7ff3eb8e0320661da34cd739dd248796bb11ef86414212"}
    /*
    NSData *jsData = [str2 dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"参与解析的 data 数据 == %@",jsData);
    NSError *error = nil;
    NSDictionary *dataJeson = [NSJSONSerialization JSONObjectWithData:jsData options:NSJSONReadingMutableLeaves error:&error];
    */
    NSString *name = [dataJeson objectForKey:@"name"];
    //NSLog(@"name == %@",name);
    NSString *nick_name = [dataJeson objectForKey:@"nick_name"];
    //NSLog(@"nick_name == %@",nick_name);
    NSString *is_dealer = [dataJeson objectForKey:@"is_dealer"];
    //NSLog(@"is_dealer == %@",is_dealer);
    NSString *dealer = [dataJeson objectForKey:@"dealer"];
    //NSLog(@"dealer == %@",dealer);
    NSString *fileupload_path = [dataJeson objectForKey:@"fileupload_path"];
    //NSLog(@"fileupload_path == %@",fileupload_path);
    NSString *fileupload_sid = [dataJeson objectForKey:@"fileupload_sid"];
    //NSLog(@"fileupload_sid == %@",fileupload_sid);
    NSString *imgUrl = [dataJeson objectForKey:@"user_photo"];
    //NSLog(@"user_photo == %@",imgUrl);
    
    //先将数据存储进UserInfomations类中
    UserInfomations *userInfo = [[UserInfomations alloc]init];
    userInfo.name = name;
    userInfo.nick_name = nick_name;
    userInfo.is_dealer = is_dealer;
    userInfo.dealer = dealer;
    userInfo.fileupload_path = fileupload_path;
    userInfo.fileupload_sid = fileupload_sid;
    
    LoginStatueSingal *singal = [LoginStatueSingal shareLogStatu];
    singal.userName = userInfo.nick_name;
    
    NSURLRequest *userImgReq = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl]];
    NSData *userImgData = [NSURLConnection sendSynchronousRequest:userImgReq returningResponse:nil error:nil];
    singal.userImgData = userImgData;
    
    //查询数据库，判断表中是否存在相同的数据
    NSArray *allData = [UserInformationsManager findAll];
    UserInformationsManager *userRecord1 = [[UserInformationsManager alloc]init];
    UserInformationsManager *userRecord2 = [[UserInformationsManager alloc]init];
    UserInformationsManager *userRecord3 = [[UserInformationsManager alloc]init];
    userRecord1 = [allData objectAtIndex:0];
    userRecord2 = [allData objectAtIndex:1];
    userRecord3 = [allData objectAtIndex:2];
    if ([_userNumber.text isEqualToString:userRecord1.userNumber] ||[_userNumber.text isEqualToString:userRecord2.userNumber]  || [_userNumber.text isEqualToString:userRecord3.userNumber] ) {
        //NSLog(@"有相同数据记录，不进行记录");
    }else{
        NSString *numberTemp = _userNumber.text;
        NSString *passWordTemp = _password.text;
        NSString *userName = nick_name;
        //用户登入成功，将用户数据存储
        //通过一些判断使数据在id为1-3之间更新
        //NSLog(@"未发现相同数据，进行记录");
        
        //NSLog(@"idx == %d",idx);
        if (idx >= 4) {
            idx = 1;
        }
        int idxId = idx % 4;
        //NSLog(@"idxId == %d",idxId);
        
        //NSString *noStr = [NSString stringWithFormat:@"账号%d",idx];
        if (userName == nil) {
            userName = @"未命名";
        }
        [UserInformationsManager upateName:userName andNumber:numberTemp andPassWord:passWordTemp andUserImage:nil withId:idxId];
        idx ++;
    }
    
    
    //停止提示页面上的滚轮
    HZActivityIndicatorView *act = (HZActivityIndicatorView *)[self viewWithTag:1001];
    [act stopAnimating];
    
    //用户、密码验证成功后，跳转界面
    [self.pushDelegate pushToLonginView];
}
@end
