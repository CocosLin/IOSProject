

#import "AppDelegate.h"
#import "MyNavigationController.h"
#import "UMSocial.h"
#define UmengAppkey @"52ac1e8556240b08a00c42bc"
#import "Reachability.h"
#import "HBServerKit.h"
#import "WTool.h"
#include <sys/xattr.h>//导入该框架用于防止相应文件的云储存iCloud

//百度地图-移动汇报Key
#define Key_BaiduMap @"6C5DEAD96FFFEEAAF3F0F2289BC52F9E078ADA72"
#define APP_DownloadURL @"http://59.57.15.168/HB.html"
#import "NewsManager.h"


@implementation AppDelegate{
    BOOL isAlertUpdateShowed;
    CLGeocoder *myGeocoder;
    NSString *addresStr;
    BMKUserLocation * _userLocation;
    BMKSearch * _bMapSearch;
}




#pragma mark -- 初始化社交平台
- (void)initializePlat
{
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //设置微信AppId
    [UMSocialConfig setWXAppId:@"wxd9a39c7122aa6516" url:nil];
    ;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    [UMSocialData defaultData].extConfig.title = @"朋友圈分享内容";
    
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES];
    
    //设置手机QQ的AppId，url传自己的网址，若传nil将使用友盟的网址
    [UMSocialConfig setQQAppId:@"100424468" url:[NSURL URLWithString:@"http://app.gitom.com/mobileapp/list/12"] importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    
    //使用友盟统计
    //[MobClick startWithAppkey:UmengAppkey];
    
    [UMSocialConfig setSupportTencentSSO:YES importClass:[WBApi class]];
    
    
    
}
/*
#pragma mark -- 版本更新检测
-(void)checkUpdate
{
    //获得服务器上的版本信息
    NSURL *url = [NSURL URLWithString:@"http://59.57.15.168/GitomHB.plist"];
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
    
    
}*/

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

- (void)myLocationManage{
    // 定位管理
    NSLog(@"appdelegate loc");
    self.bMapView = [[BMKMapView alloc]init];
    self.bMapView.showsUserLocation = YES;
    self.bMapView.delegate = self;
    _bMapSearch = [[BMKSearch alloc]init];
    
    //为Document文件设置不iCloud存储属性，防止AppStore审核无法通过2.23条款
    NSString *notBackUpPathDoc = nil;
    notBackUpPathDoc = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
    [self addSkipBackupAttributeToPath:notBackUpPathDoc];
    
    NSString *notBackUpPathCach = nil;
    notBackUpPathCach = [NSString stringWithFormat:@"%@/Library/Caches/",NSHomeDirectory()];
    [self addSkipBackupAttributeToPath:notBackUpPathCach];
}


- (void)addSkipBackupAttributeToPath:(NSString*)path {
    u_int8_t b = 1;
    setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
} 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //更新检测
//    [self checkUpdate];
    
    //社交分享平台
    [self initializePlat];
    
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
    
    if (!isExistenceNetwork) {
        UIAlertView *myalert = [[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@"提示", @"Network error")
                                message:NSLocalizedString(@"您未连接网络", nil)
                                delegate:self
                                cancelButtonTitle:NSLocalizedString(@"知道了", @"Cancel")
                                otherButtonTitles:nil];
        [myalert show];
        
    }
    
    //百度地图管理器启动
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:Key_BaiduMap
                  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window = [[JWMotionRecognizingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    _comData = [[CommonDataModel alloc]init];
    LoginVC * lvc = [[LoginVC alloc]init];
    MyNavigationController * ncLvc = [[MyNavigationController alloc]initWithRootViewController:lvc];//将登录界面作为导航栏的根视图
    
    
    self.window.rootViewController = ncLvc;
    [self myLocationManage];
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
    
    // 当程序退到后台时，进行定位的重新计算
    self.executingInBackground = YES;

    // 定位管理
    if (!self.bMapView.showsUserLocation) {
        self.bMapView.showsUserLocation = YES;
    }
    
    GetCommonDataModel;
    NSLog(@"上传用户坐标时间间隔 == %@",comData.organization.updatePosition);
    
    //如果用户已经登入
    
    if (comData.cookie) {
        
        //按照部门设定的时间间隔上传位置
        self.timer = [NSTimer scheduledTimerWithTimeInterval:[comData.organization.updatePosition floatValue]/1000 target:self selector:@selector(upTime) userInfo:nil repeats:YES];
    }
    
}



static int intTime = 0;
- (void)upTime{
    intTime++;
    
    [_bMapSearch reverseGeocode:_userLocation.coordinate];
    _bMapSearch.delegate = self;
    
    
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{/*
    // 程序进入前台，
    // 定位管理
    if (!self.bMapView) {
        NSLog(@"开启定位管理");
        [self myLocationManage];
    }
    
    self.executingInBackground = NO;
    */
    [self.timer invalidate];
}



#pragma mark - 判断是否在后台


// 判断是否在后台

- (BOOL) isExecutingInBackground{
    
    return _executingInBackground;
    
}

#pragma mark -- 百度地图代理
#pragma mark -百度地图服务
-(void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error
{
    
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    NSLog(@"self.myAddress == %@",result.strAddr);
    [hbKit sendUserPositionWithaccuracy:0 andlatitude:_userLocation.coordinate.latitude andlocation:result.strAddr andlongitude:_userLocation.coordinate.longitude andusername:comData.userModel.username];
    
}

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //定位
    NSLog(@"AppDelegate mapView %f ,%f",_userLocation.coordinate.longitude,userLocation.coordinate.latitude);
    _userLocation = userLocation;

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
