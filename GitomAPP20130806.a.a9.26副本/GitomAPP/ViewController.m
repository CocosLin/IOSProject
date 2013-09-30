//
//  ViewController.m
//  GitomAPP
//
//  Created by jiawei on 13-7-11.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "ViewController.h"
#import "ChooseViewController.h"
#import "JASidePanelController.h"
#import "CustomButton.h"

#import <ShareSDK/ShareSDK.h>
#import <QuartzCore/QuartzCore.h>

#import "UIViewController+JASidePanel.h"
//#import "AboutGitom.h"
#import "LoginStatueSingal.h"//存储登入状态的单例
//#import "UserLoginView.h"
//#import "FeedBack.h"
//用户登入
#import "MyMD5.h"
#import "UserLoginView.h"

#import "AppDelegate.h"
#import "CustomManger.h"
//#import "Reachability.h"//网络检测类
#import "Reachability.h"
#import "WebsViewController.h"

@interface ViewController ()

@end

@implementation ViewController


#pragma mark -- 用户验证通过后加载用户首页
- (void)viewWillAppear:(BOOL)animated//成功登录后，首页会变成用户主页
{    
    LoginStatueSingal *logSingal = [LoginStatueSingal shareLogStatu];
    _loginFlag = logSingal.logStatu;//单例传参
    NSLog(@"ViewController单例传参得到的登入状态 = %d ， = %d",_loginFlag,logSingal.logStatu);
    
    if (_loginFlag == 1) {
        //logSingal.logStatu = 11;
        NSLog(@"登入的状态=%d",_loginFlag);
        //NSLog(@"单例存储的状态变化=%d",logSingal.logStatu);
        _navgationTitle.text = logSingal.userName;

        [_firstWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@.3g.gitom.com/",logSingal.userNumber]]]];//http://用户账号.3g.gitom.com/
        [_bottomView removeFromSuperview];
        
        
        //底部的导航栏
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-62, Screen_Width, 42)];
        _bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bg.png"]];
        [self.view addSubview:_bottomView];
        
        //返回
        UIView *backBt = [[UIView alloc]initWithFrame:CGRectMake(2, 2, Screen_Width/2-3, 38)];
        backBt.tag = 2001;
        backBt.layer.cornerRadius = 5;
        backBt.backgroundColor = BackgroundColor_Black;
        [_bottomView addSubview:backBt];
        _backImg = [[UIImageView alloc]initWithFrame:CGRectMake(backBt.frame.size.width/2-15, 6, 30, 30)];
        _backImg.tag = 2001;
        _backImg.image = [UIImage imageNamed:@"webview_goback_btn_enable.png"];
        

        [backBt addSubview:_backImg];
        
        UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gobackAction)];
        [backBt addGestureRecognizer:loginTap];//添加手势
        
        //前进
        UIView *forwardBt = [[UIView alloc]initWithFrame:CGRectMake(161, 2, Screen_Width/2-3, 38)];
        forwardBt.tag = 2002;
        forwardBt.layer.cornerRadius =5;
        forwardBt.backgroundColor = BackgroundColor_Black;
        [_bottomView addSubview:forwardBt];
        
        _forwardImg = [[UIImageView alloc]initWithFrame:CGRectMake(forwardBt.frame.size.width/2-15, 6, 30, 30)];
        _forwardImg.tag = 2002;
        _forwardImg.image = [UIImage imageNamed:@"webview_forward_btn_enable.png"];
        [forwardBt addSubview:_forwardImg];
                
        UITapGestureRecognizer *enrollTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goforwardAction)];
        [forwardBt addGestureRecognizer:enrollTap];//添加手势
    }
    if(logSingal.exitAccountStatu == 2){
        NSLog(@"退出登入selfviewDidLoad");
        [self viewDidLoad];
    }
}

- (void) gobackAction{
    if ([_firstWeb canGoBack]) {
        [UIView animateWithDuration:0.5 animations:^{
            UIView *loginBt = (UIView *)[self.view viewWithTag:2001];
            loginBt.backgroundColor = BackgroundColor_Green;
            loginBt.backgroundColor = BackgroundColor_Black;
        }];
        [_firstWeb goBack];
    }
}

- (void) goforwardAction{
    
    if ([_firstWeb canGoForward]) {
        [UIView animateWithDuration:0.5 animations:^{
            UIView *loginBt = (UIView *)[self.view viewWithTag:2002];
            loginBt.backgroundColor = BackgroundColor_Green;
            loginBt.backgroundColor = BackgroundColor_Black;
        }];
        [_firstWeb goForward];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadNavigatonV];
    [self loadFirstWeb];
    
    _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    _activity.center = CGPointMake(self.view.center.x, self.view.center.y-60) ;
    [_firstWeb addSubview:_activity];
}

#pragma mark -- 加载网页页面、登入页面……
//此处的页面显示不是通过继承来分别显示对应页面的内容，而是通过标记进行区分，以达到
- (void)loadFirstWeb
{
    
    _firstWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 46, Screen_Width, Screen_Height-66)];
    _firstWeb.delegate = self;
    [self.view addSubview:_firstWeb];
    //_firstWeb.backgroundColor = [UIColor clearColor];
    _firstWeb.scalesPageToFit = YES;
    if (_imgFlag == 6){//连接会员中心
        _navgationTitle.text = @"网即通";
        [_firstWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.uc.gitom.com/"]]];
        
    }
    else if (_imgFlag == 7){//注册
        [_firstWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://uc.gitom.com/Register"]]];
    }
    else{
        _navgationTitle.text = @"网即通移动版 欢迎您";
        _firstWeb.frame = CGRectMake(0, 46, Screen_Width, Screen_Height-105);
        //默认、登入后的欢迎页
        NSString *fullPath = [NSBundle  pathForResource:@"cmsDefault"
                                                 ofType:@"html"
                                            inDirectory:[[NSBundle mainBundle]bundlePath]];
        //NSLog(@"fullpath == %@",fullPath);
        [_firstWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:fullPath]]];
        
        //底部的导航栏
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-62, Screen_Width, 42)];
        _bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bg.png"]];
        [self.view addSubview:_bottomView];
        
        //开始体验
        UIView *loginBt = [[UIView alloc]initWithFrame:CGRectMake(2, 2, Screen_Width/2-3, 38)];
        loginBt.tag = 2001;
        loginBt.layer.cornerRadius = 5;
        loginBt.backgroundColor = BackgroundColor_Black;
        [_bottomView addSubview:loginBt];
        UIImageView *loginImg = [[UIImageView alloc]initWithFrame:CGRectMake(68, 2, 18, 20)];
        loginImg.image = [UIImage imageNamed:@"glyphicons_233_direction.png"];
        [loginBt addSubview:loginImg];
        UILabel *loginLb = [[UILabel alloc]initWithFrame:CGRectMake(52, 22, 68, 15)];
        loginLb.backgroundColor = [UIColor clearColor];
        loginLb.text = @"开始体验";
        loginLb.textColor = [UIColor whiteColor];
        loginLb.font = [UIFont systemFontOfSize:12];
        [loginBt addSubview:loginLb];
        
        UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginAction)];
        [loginBt addGestureRecognizer:loginTap];//添加手势
        
        //注册账号
        UIView *enroll = [[UIView alloc]initWithFrame:CGRectMake(161, 2, Screen_Width/2-3, 38)];
        enroll.tag = 2002;
        enroll.layer.cornerRadius =5;
        enroll.backgroundColor = BackgroundColor_Black;
        [_bottomView addSubview:enroll];
        
        UIImageView *enrollImg = [[UIImageView alloc]initWithFrame:CGRectMake(68, 2, 18, 17)];
        enrollImg.image = [UIImage imageNamed:@"glyphicons_006_user_add.png"];
        [enroll addSubview:enrollImg];
        UILabel *enrollLb = [[UILabel alloc]initWithFrame:CGRectMake(52, 22, 68, 15)];
        enrollLb.backgroundColor = [UIColor clearColor];
        enrollLb.text = @"注册账号";
        enrollLb.textColor = [UIColor whiteColor];
        enrollLb.font = [UIFont systemFontOfSize:12];
        [enroll addSubview:enrollLb];
        
        UITapGestureRecognizer *enrollTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enrollAction)];
        [enroll addGestureRecognizer:enrollTap];//添加手势
    }
    
    //使web不漏底
    UIScrollView  *scroller = [_firstWeb.subviews objectAtIndex:0];
    if (scroller)
    {
        scroller.bounces = NO;
        scroller.alwaysBounceVertical = NO;
    }
}

- (void)loginAction
{
    //NSLog(@"体验");
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self.view viewWithTag:2001];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Black;
    }];
    
    WebsViewController *vc = [[WebsViewController alloc]init];
    vc.imgFlag = 4;
    [self presentViewController:vc animated:YES completion:
        nil];
}

- (void)enrollAction
{
    //NSLog(@"注册");
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self.view viewWithTag:2002];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Black;
    }];
    
    LoginStatueSingal *singal = [LoginStatueSingal shareLogStatu];
    singal.logStatu = 2;//只要不是1，就不会重复加载出用户首页
    
    ViewController *vc = [[ViewController alloc]init];
    vc.imgFlag = 7;
    [self presentViewController:vc animated:YES completion:^{
        nil;
    }];
}

#pragma mark -- UserLoginView的代理方法--登录,用户密码正确跳转
- (void)pushToLonginView
{
    NSLog(@"跳转chooseView");
   
    UserLoginView *user = (UserLoginView *)[self.view viewWithTag:4001];
    
    LoginStatueSingal *log = [LoginStatueSingal shareLogStatu];
    log.logStatu = 1;
    
    //判断单例之中是否记录了用户编号，
    if (user.userNumber.text == NULL) {
        nil;
    }else{
        log.userNumber = user.userNumber.text;
    }
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)refreshView{
    [self viewDidLoad];
}

#pragma mark -- UIWebView的代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //NSLog(@"开始加载,滚轮");
    [_activity startAnimating];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[_webTimer invalidate];
    [_activity stopAnimating];
    //countTime = 0;
    
    BOOL netConnect = [self CheckNetworkStatus]; // 网络是否连接
    if (netConnect == YES) {
        // 开始
    } else {
        
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无网络链接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        // 网络链接失败,操作显示
        
    }
}

#pragma mark -- 网络检查
- (BOOL) CheckNetworkStatus {
    NSString *hostName = @"www.mydomain.com";
    Reachability *r = [Reachability reachabilityWithHostName:hostName]; if ([r currentReachabilityStatus]==NotReachable)
    {
        return NO;
    }
    else {
        return YES;
    }
}


#pragma mark -- 加载导航条
- (void)loadNavigatonV
{
    //导航条的定制
    _navgationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 48)];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 46)];
    imgView.image = [UIImage imageNamed:@"title_bg.png"];
    [_navgationView addSubview:imgView];
    [self.view addSubview:_navgationView];
    
    //导航标题
    _navgationTitle = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, 160, 30)];
    _navgationTitle.text = _navtitle;
    _navgationTitle.textColor = [UIColor whiteColor];
    _navgationTitle.backgroundColor = [UIColor clearColor];
    _navgationTitle.center = _navgationView.center;
    _navgationTitle.textAlignment =  NSTextAlignmentCenter;
    _navgationTitle.font = [UIFont systemFontOfSize:15];
    [_navgationView addSubview:_navgationTitle];
    
    //选择栏
    UIButton *chooseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_imgFlag ==1|| _imgFlag==2||_imgFlag==3 ||_imgFlag==4||_imgFlag==6||_imgFlag == 7) {
        chooseBt.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"glyphicons_224_chevron_left.png"]];
    }else{
        chooseBt.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"glyphicons_114_list.png"]];
    }
    
    //添加手势
    UIButton *bigAddBT = [UIButton buttonWithType:UIButtonTypeCustom];
    bigAddBT.frame = CGRectMake(0, 0, 54, 46);
    [bigAddBT setBackgroundImage:[UIImage imageNamed:@"bottom_bg.png"] forState:UIControlStateHighlighted];
    [bigAddBT addTarget:self action:@selector(touchChoose) forControlEvents:UIControlEventTouchUpInside];
    [_navgationView addSubview:bigAddBT];
    
    [chooseBt addTarget:self action:@selector(chooseBt) forControlEvents:UIControlEventTouchUpInside];
    [chooseBt setBackgroundImage:[UIImage imageNamed:@"bottom_bg.png"] forState:UIControlStateHighlighted];
    chooseBt.frame = CGRectMake(15, 11, 24, 21);
    [_navgationView addSubview:chooseBt];
    
    //刷新
    UIButton *bigRefreshBT = [UIButton buttonWithType:UIButtonTypeCustom];
    bigRefreshBT.frame = CGRectMake(220, 0, 54, 46);
    [bigRefreshBT setBackgroundImage:[UIImage imageNamed:@"bottom_bg.png"] forState:UIControlStateHighlighted];
    [bigRefreshBT addTarget:self action:@selector(touchRefresh) forControlEvents:UIControlEventTouchUpInside];
    [_navgationView addSubview:bigRefreshBT];
    
    UIButton *refreshBt = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBt.frame = CGRectMake(235, 10, 22, 22);
    
    [refreshBt addTarget:self action:@selector(refreshBt) forControlEvents:UIControlEventTouchUpInside];
    //[refreshBt setBackgroundImage:[UIImage imageNamed:@"button_style_2_png_on.9.png"] forState:UIControlStateHighlighted];
    refreshBt.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"glyphicons_refresh.png"]];
    [refreshBt setBackgroundImage:[UIImage imageNamed:@"bottom_bg.png"] forState:UIControlStateHighlighted];
    [_navgationView addSubview:refreshBt];
    
    //分享
    UIButton *bigShareBT = [UIButton buttonWithType:UIButtonTypeCustom];
    bigShareBT.frame = CGRectMake(270, 0, 54, 46);
    [bigShareBT setBackgroundImage:[UIImage imageNamed:@"bottom_bg.png"] forState:UIControlStateHighlighted];
    [bigShareBT addTarget:self action:@selector(touchShare) forControlEvents:UIControlEventTouchUpInside];
    [_navgationView addSubview:bigShareBT];
    
    UIButton *shareBt = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBt.frame = CGRectMake(285, 10, 22, 22);
    [shareBt addTarget:self action:@selector(shareSomething) forControlEvents:UIControlEventTouchUpInside];
    [shareBt setBackgroundImage:[UIImage imageNamed:@"bottom_bg.png"] forState:UIControlStateHighlighted];
    shareBt.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"glyphicons_308_share_alt.png"]];
    [_navgationView addSubview:shareBt];
    
    _firstWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, self.view.frame.size.height-44)];
    [self.view addSubview:_firstWeb];
}

#pragma mark -- 导航条右按钮

- (void) touchChoose{
    [self chooseBt];
}

- (void)chooseBt
{
    
    NSLog(@"choosBt");
    //_loginStatueSingale = [LoginStatueSingal shareLogStatu];
    
//    if (_loginStatueSingale.exitAccountStatu == 2) {
//        NSLog(@"退出之前的登入的帐号");
//        //NSLog(@"chooseBt");
//        //发通知
//        //[[NSNotificationCenter defaultCenter]postNotificationName:@"activeView" object:self];
//        UIWebView *logWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
//        logWebView.delegate = self;
//        logWebView.hidden = YES;
//        [logWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://login.gitom.com/logout?quit=true&service=http://www.gitom.com/blank.html"]]];
//        [self.view addSubview: logWebView];
//        NSLog(@"退出之前的登入的帐号");
//        [self viewDidLoad];
//        NSLog(@"切换状态未%d时候，退出登入selfviewDidLoad的WebView",_loginStatueSingale.exitAccountStatu);
//    }
    
    if (_imgFlag==6||_imgFlag ==7) {
       CustomButton *but = [[CustomButton alloc]init];
    but.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_3_png.9.png"]];
    [self dismissViewControllerAnimated:NO completion:nil];
        NSLog(@"ViewController 登入状态标记==%d",_loginStatueSingale.logStatu );
    }else{
        NSLog(@"抽屉效果");
        [self.sidePanelController toggleLeftPanel:nil];//抽屉框架
    }

}

#pragma mark -- 刷新页面
- (void)touchRefresh
{
    [self refreshBt];
}
- (void)refreshBt
{
    //NSLog(@"refreshBt");
    [_firstWeb reload];
}

#pragma mark -- 社交分享功能
- (void)touchShare
{
    [self shareSomething];
}
- (void)shareSomething
{
    //NSLog(@"shareBt");
    
    //创建分享内容
    NSString *imagePath =  [[NSBundle mainBundle] pathForResource:@"logo"
                                                           ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"我正在使用网即通移动版：http://app.gitom.com/MobileApp/detail/7"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:nil//[ShareSDK imageWithPath:imagePath]
                                                title:@"网即通"
                                                  url:@"http://app.gitom.com/MobileApp/detail/7"
                                          description:imagePath
                                            mediaType:SSPublishContentMediaTypeNews];
    
    NSArray *shareList1=[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeSohuWeibo,ShareTypeRenren,ShareType163Weibo,nil];
    
    //选择性的显示分享平台的图标
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil
                                                              oneKeyShareList:shareList1
                                                               qqButtonHidden:NO
                                                        wxSessionButtonHidden:NO
                                                       wxTimelineButtonHidden:NO
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList1
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
    {
        if (state == SSPublishContentStateSuccess)
        {
            NSLog(@"分享成功");
        }
        else if (state == SSPublishContentStateFail)
        {
            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
