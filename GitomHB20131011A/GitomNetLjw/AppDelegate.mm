//
//  AppDelegate.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "AppDelegate.h"
#import "MyNavigationController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WBApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "Reachability.h"

//百度地图-移动汇报Key
#define Key_BaiduMap @"6C5DEAD96FFFEEAAF3F0F2289BC52F9E078ADA72"
#import "NewsManager.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NewsManager *manger = [[NewsManager alloc]init];
    [manger getNewsOforganizationId:114 andOrgunitId:1 andCookie:@"5533098A-43F1-4AFC-8641-E64875461345"];
    
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
        {
            isExistenceNetwork=NO;
            NSLog(@"没有网络");
            break;
        }case ReachableViaWWAN:
        {
            isExistenceNetwork=YES;
            NSLog(@"正在使用3G网络");
            break;
        }case ReachableViaWiFi:
        {
            isExistenceNetwork=YES;
            NSLog(@"正在使用wifi网络");
            break;
        }
    }
    //self.loginFlag = LoginFlag_NoLogin;
    if (!isExistenceNetwork) {
        UIAlertView *myalert = [[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@"提示", @"Network error")
                                message:NSLocalizedString(@"您未连接网络", nil)
                                delegate:self
                                cancelButtonTitle:NSLocalizedString(@"知道了", @"Cancel")
                                otherButtonTitles:nil];
        [myalert show];
        [myalert release];
    }
    
    
    //社交分享功能
    [ShareSDK registerApp:@"520520test"];
    [self initializePlat];
    [ShareSDK connectWeChatWithAppId:@"wx6dd7a9b94f3dd72a"
                           wechatCls:[WXApi class]];
    //添加QQ应用
    [ShareSDK connectQQWithAppId:@"QQ0F0A941E" qqApiCls:[QQApi class]];
    
    
    //百度地图管理器启动
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:Key_BaiduMap
                  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window = [[[JWMotionRecognizingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    _comData = [[CommonDataModel alloc]init];
    LoginVC * lvc = [[LoginVC alloc]init];
    MyNavigationController * ncLvc = [[MyNavigationController alloc]initWithRootViewController:lvc];//将登录界面作为导航栏的根视图
    
    [lvc release];
    self.window.rootViewController = ncLvc;
    [ncLvc release];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark --分享--
- (void)initializePlat
{
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"3201194191" appSecret:@"0334252914651e8f76bad63337b3b78f"
                             redirectUri:@"http://appgo.cn"];
    [ShareSDK connectWeChatWithAppId:@"wx6dd7a9b94f3dd72a" wechatCls:[WXApi class]];
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WBApi class]];
    //添加QQ空间应用    ￼
    [ShareSDK connectQZoneWithAppKey:@"100371282" appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加网易微博应用
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy" appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
    //添加搜狐微博应用
    [ShareSDK connectSohuWeiboWithConsumerKey:@"SAfm TG1blxZY3HztESWx"
                               consumerSecret:@"yfTZf)!rVwh*3dqQuVJVs UL37!F)!yS9S!Orcs ij" redirectUri:@"http://www.sharesdk.cn"];
    //添加豆瓣应用
    [ShareSDK connectDoubanWithAppKey:@"07d08fbfc1210e931771af3f43632bb9" appSecret:@"e32896161e72be91"
                          redirectUri:@"http://dev.kumoway.com/braininference/infos.php"]; //添加人人网应用
    [ShareSDK connectRenRenWithAppKey:@"fc5b8aed373c4c27a05b712acba0f8c3" appSecret:@"f29df781abdd4f49beca5a2194676ca4"];
    //添加开心网应用
    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c" appSecret:@"da32179d859c016169f66d90b6db2a23"
                          redirectUri:@"http://www.sharesdk.cn/"];
    //添加Ins tapaper应用
    [ShareSDK connectInstapaperWithAppKey:@"4rDJORm cOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
    //添加有道云笔记应用
    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
                                consumerSecret:@"d98217b4020e7f1874263795f44838fe" redirectUri:@"http://www.sharesdk.cn/"];
    
    //添加Facebook应用
    [ShareSDK connectFacebookWithAppKey:@"107704292745179" appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    //添加Twitter应用
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg" consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc" redirectUri:@"http://www.sharesdk.cn"];
    //添加搜狐随身看应用
    [ShareSDK connectSohuKanWithAppKey:@"e16680a815134504b746c86e08a19db0"
                             appSecret:@"b8eec53707c3976efc91614dd16ef81c" redirectUri:@"http://sharesdk.cn"];
    //添加Pocket应用
    [ShareSDK connectPocketWithConsumerKey:@"11496-de7c8c5eb25b2c9fcdc2b627"
                               redirectUri:@"pocketapp1234"];
    //添加印象笔记应用
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
                          consumerKey:@"sharesdk-7807" consumerSecret:@"d05bf86993836004"];
}

- (void)initializePlatForTrusteeship
{
    //    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    //    [ShareSDK importQQClass:[QQApiInterface class]
    //            tencentOAuthCls:[TencentOAuth class]];
    //
    //    //导入人人网需要的外部库类型,如果不需要人人网SSO可以不调用此方法
    //    [ShareSDK importRenRenClass:[RennClient class]];
    //
    //    //导入腾讯微博需要的外部库类型，如果不需要腾讯微博SSO可以不调用此方法
    //    [ShareSDK importTencentWeiboClass:[WBApi class]];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
}
@end