//
//  AppDelegate.m
//  GitomAPP
//
//  Created by jiawei on 13-7-11.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "JASidePanelController.h"
#import "ChooseViewController.h"

#import <ShareSDK/ShareSDK.h>
#import<TencentOpenAPI/QQApiInterface.h>
#import<TencentOpenAPI/TencentOAuth.h>
#import "WBApi.h"
#import"WXApi.h"

#import "LoginStatueSingal.h"
#import "GuideViewController.h"



@implementation AppDelegate{
    BOOL isAlertUpdateShowed;
}
#pragma mark -- 初始化社交平台
- (void)initializePlat
{
    //添加新浪微博应用sinaweibosso.3201194191
    [ShareSDK connectSinaWeiboWithAppKey:@"3201194191"      appSecret:@"0334252914651e8f76bad63337b3b78f"
                             redirectUri:@"http://appgo.cn"];
    
//    //添加QQ空间应用
//    [ShareSDK connectQZoneWithAppKey:@"100371282"
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
    
    //腾讯微博
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WBApi class]];
    
    
    //添加开心网
    //    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
    //                            appSecret:@"da32179d859c016169f66d90b6db2a23"
    //                          redirectUri:@"http://www.sharesdk.cn/"];
    [ShareSDK connectKaiXinWithAppKey:@"5675714382538d1a2f6e98cc7403df0f"
                            appSecret:@"e702245017c19ab1bc80deefc27b2079"
                          redirectUri:@"http://www.sharesdk.cn/"];
    
    //人人网
    [ShareSDK connectRenRenWithAppKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                            appSecret:@"f29df781abdd4f49beca5a2194676ca4"];
    
    //网易微博
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
    
    //添加搜狐微博应用
    [ShareSDK connectSohuWeiboWithConsumerKey:@"SAfmTG1blxZY3HztESWx"
                               consumerSecret:@"yfTZf)!rVwh*3dqQuVJVsUL37!F)!yS9S!Orcsij" redirectUri:@"http://www.sharesdk.cn"];
    
    
    
}

#pragma mark -- 预先加载url
- (void)connectURLandGetData{
    //请求连接
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gapp.gitom.com/api/getAppMenuList.json?packname=com.gitom.app"]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    //获得连接数据
    
    NSError *error = nil;
    NSData *getData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    LoginStatueSingal *loginSingal = [LoginStatueSingal shareLogStatu];
    loginSingal.customUrlData = getData;
    
}

#pragma mark -- 版本更新检测
-(void)checkUpdate
{
    //获得服务器上的版本信息
    NSURL *url = [NSURL URLWithString:@"http://59.57.15.168/GitomIOS.plist"];
    NSDictionary *getXMLdic = [[NSDictionary alloc]initWithContentsOfURL:url];
    NSLog(@"NSDidctionary = %@",getXMLdic);
    NSLog(@"服务器应用版本 = %@",[[[[getXMLdic objectForKey:@"items"]objectAtIndex:0]objectForKey:@"metadata"]objectForKey:@"bundle-version"]);
    
    
    NSString* sLastVersion=[[[[getXMLdic objectForKey:@"items"]objectAtIndex:0]objectForKey:@"metadata"]objectForKey:@"bundle-version"]; //取服务器最新的版本
    NSString* sLastVersionInfo=@"Test Update Check！"; //服务器最新的版本与系统版本进行判断
    
    NSString *versionString = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSLog(@"本应用版本 == %@",versionString);
    if (![sLastVersion isEqualToString:versionString])
    {
        [self alertUpdate:sLastVersionInfo];
        
    }
}

-(void)alertUpdate:(NSString *)strContent
{
    NSLog(@"是否更新");
    if (!isAlertUpdateShowed) {
        isAlertUpdateShowed=YES;
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"升级提示"
                                                     message:strContent
                                                    delegate:self //委托给Self，才会执行上面的调用
                                           cancelButtonTitle:@"以后再说"
                                           otherButtonTitles:@"马上更新",nil] ;
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        NSLog(@"更新");
        NSURL *url = [NSURL URLWithString:APP_DownloadURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark -- 进入程序
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //检测版本更新
    [self checkUpdate];
    
    //社交分享平台
    [ShareSDK registerApp:@"6d05f23afae"];
    [ShareSDK convertUrlEnabled:NO];
    [self initializePlat];
    
    [self connectURLandGetData];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //增加标识，用于判断是否是第一次启动应用...
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        GuideViewController *appStartController = [[GuideViewController alloc] init];
        self.window.rootViewController = appStartController;
        
    }else {
        self.viewController = [[JASidePanelController alloc] init];
        self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
        self.viewController.leftPanel = [[ChooseViewController alloc]init];
        self.viewController.centerPanel = [[ViewController alloc]init];
        self.window.rootViewController = self.viewController;
    }
//    self.viewController = [[JASidePanelController alloc] init];
//    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
//    self.viewController.leftPanel = [[ChooseViewController alloc]init];
//    self.viewController.centerPanel = [[ViewController alloc]init];
//    
//    self.window.rootViewController = self.viewController;
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

@end
