//
//  WebsViewController.m
//  GitomAPP
//
//  Created by jiawei on 13-8-28.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "WebsViewController.h"


@interface WebsViewController ()

@end

@implementation WebsViewController

- (void) touchChoose{
    [self chooseBt];
}


- (void)chooseBt
{
    
    NSLog(@"choosBt");
    _loginStatueSingale = [LoginStatueSingal shareLogStatu];
    if (_loginStatueSingale.exitAccountStatu == 2) {
        NSLog(@"退出之前的登入的帐号");
        //NSLog(@"chooseBt");
        //发通知
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"activeView" object:self];
        UIWebView *logWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
        logWebView.delegate = self;
        logWebView.hidden = YES;
        [logWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://login.gitom.com/logout?quit=true&service=http://www.gitom.com/blank.html"]]];
        [self.view addSubview: logWebView];
        NSLog(@"WebsViewController == 退出之前的登入的帐号");
        [self viewDidLoad];
        NSLog(@"WebsViewController == 切换状态为%d时候，退出登入selfviewDidLoad的WebView",_loginStatueSingale.exitAccountStatu);
        self.loginStatueSingale.loginViewFlag = 2;
    }

    CustomButton *but = [[CustomButton alloc]init];
    but.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_3_png.9.png"]];
    NSLog(@"WebsViewController 登入状态标记==%d",_loginStatueSingale.logStatu );
    [self dismissViewControllerAnimated:NO completion:nil];
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
    //[self loadFirstWeb];
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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.anWebUrl = [[NSString alloc]init];
        self.loginStatueSingale = [LoginStatueSingal shareLogStatu];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadNavigatonV];
    [self loadFirstWeb];
    self.activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    self.activity.center = CGPointMake(self.view.center.x, self.view.center.y-60) ;
    [self.firstWeb addSubview:_activity];
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
    chooseBt.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"glyphicons_224_chevron_left.png"]];
    
    
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


#pragma mark -- 加载网页页面
//此处的页面显示不是通过继承来分别显示对应页面的内容，而是通过标记进行区分，以达到
- (void)loadFirstWeb
{
    
    _firstWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 46, Screen_Width, Screen_Height-66)];
    _firstWeb.delegate = self;
    [self.view addSubview:_firstWeb];
    //_firstWeb.backgroundColor = [UIColor clearColor];
    _firstWeb.scalesPageToFit = YES;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToDismissAction)];
    [_firstWeb addGestureRecognizer:swipe];
    
    //根据传参结果判断页面显示效果
    if (self.imgFlag == 1) {//切换网页
        //NSLog(@"下标 1");
        //LoginStatueSingal *singal = [LoginStatueSingal shareLogStatu];
        //LoginStatueSingal *logSingal = [LoginStatueSingal shareLogStatu];
        NSLog(@"self.loginStauteSingale.logstatu = %d",self.loginStatueSingale.loginViewFlag);
        if (self.loginStatueSingale.loginViewFlag == 0) {
            self.imgFlag = 4;
            self.loginStatueSingale.logStatu =1;
            [self loadFirstWeb];
        }else{
            NSString *file = [self.anWebUrl substringWithRange:NSMakeRange(0, 4)];
            if ([file isEqualToString:@"file"]) {//逻辑判断：使用本地html，或服务器
                NSString *fullPath = [NSBundle  pathForResource:@"productList"
                                                         ofType:@"html"
                                                    inDirectory:[[NSBundle mainBundle]bundlePath]];
                [_firstWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:fullPath]]];
                
            }else{
                [_firstWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.anWebUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5]];//网络超时5秒的
            }
        }
        
    }
    else if (_imgFlag == 2){//关于界面
        
        AboutGitom *aboutGitom = [[AboutGitom alloc]initWithFrame:CGRectMake(0, 46, 320, self.view.bounds.size.height-46)];
        aboutGitom.delegate = self;
        [self.view addSubview:aboutGitom];
        
    }
    else if (_imgFlag == 3){//反馈
        FeedBack *feedBack = [[FeedBack alloc]initWithFrame:CGRectMake(0, 46, Screen_Width, Screen_Height-46)];
        feedBack.delegate = self;//代理
        [self.view addSubview:feedBack];
        
    }
    else if (_imgFlag == 4){//用户登入
        _navgationTitle.text = @"用户登录";
        //self.view.backgroundColor = [UIColor blackColor];
        UserLoginView *userlog = [[UserLoginView alloc]initWithFrame:CGRectMake(0, 46, Screen_Width, Screen_Height-46)];
        userlog.tag = 4001;
        [self.view addSubview:userlog];
        
        //设置代理
        userlog.pushDelegate = self;
    }
    
    //使web不漏底
    UIScrollView  *scroller = [_firstWeb.subviews objectAtIndex:0];
    if (scroller)
    {
        scroller.bounces = NO;
        scroller.alwaysBounceVertical = NO;
    }
}

#pragma mark -- 轻扫手势
- (void)swipeToDismissAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -- FeedBack的代理方法:dismiss会上个页面
- (void)feedBackPopToLastView{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark -- AboutGitom的代理方法:dismiss会上个页面
- (void)aboutBackPopToLastView
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

// 网络检查
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
