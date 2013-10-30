//
//  ChooseViewController.m
//  IOS_Javascript
//
//  Created by GitomYiwan on 13-7-8.
//  Copyright (c) 2013年 GitomYiwan. All rights reserved.
//

#import "ChooseViewController.h"
#import "JASidePanelController.h"//抽屉效果
#import "UIViewController+JASidePanel.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomManger.h"//
//#import "CustomButton.h"
#import "Custom.h"
//#import "WebViewController.h"
#import "ViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "UIImageView+Dcgimage.h"
#import "LoginStatueSingal.h"//存储登入状态的单例
#import "GetLabelHightAndBreakLines.h"//实现UILabel自动换行的类

//#import "UserStatue.h"//用户状态视图

@interface ChooseViewController ()

@end

@implementation ChooseViewController{
    NSMutableArray *urlArray;
    BOOL isAlertUpdateShowed;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        urlArray = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark -- 用户验证好重新加载界面
- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%s",__FUNCTION__);
    NSLog(@"载入ChoosevIEWController……");
    
    LoginStatueSingal *logSingal = [LoginStatueSingal shareLogStatu];
    _loginFlag = logSingal.exitAccountStatu;//单例传参
    NSLog(@"选择（choos）页面的单例传参结果logsingel.logstaut= %d",_loginFlag);
    if (_loginFlag == 1) {
        //[self viewDidLoad];
        NSLog(@"ChoosViewController.m登入的状态==================");
        
        [_headView removeFromSuperview];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UserStatue *userStatue = [[UserStatue alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 100)];
        //NSLog(@"用户编号=== %@",logSingal.userNumber);
        userStatue.userNumber = logSingal.userNumber;//通单例获得编号
        //NSLog(@"用户编号=== %@",userStatue.userNumber);
        userStatue.userStatueDelegat = self;//设置代理
        [self.view addSubview:userStatue];
        
        //用户头像
        UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 64, 64 )];
        userImg.backgroundColor = [UIColor clearColor];
        userImg.image = [UIImage imageWithData:logSingal.userImgData];
        [userStatue addSubview:userImg];
        
        //用户编号
        UILabel *userNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 44, 100, 18)];
        userNumberLabel.text = logSingal.userNumber;
        userNumberLabel.backgroundColor = [UIColor clearColor];
        userNumberLabel.textColor = [UIColor whiteColor];
        userNumberLabel.font = [UIFont systemFontOfSize:12];
        [userStatue addSubview:userNumberLabel];
        
        //用户姓名
        UILabel *userNameLabel = [[UILabel alloc]init ];//WithFrame:CGRectMake(110, 18, 150, 30)];
        GetLabelHightAndBreakLines *getLabelHight = [[GetLabelHightAndBreakLines alloc]init];
        CGFloat labelHight = [getLabelHight highOfLabel:userNameLabel
                                      numberTextOfLabel:logSingal.userName
                                            andFontSize:20];
        userNameLabel.frame = CGRectMake(88, 18, 165, labelHight);
        
        userNameLabel.text = logSingal.userName;
        userNameLabel.backgroundColor = [UIColor blackColor];
        userNameLabel.textColor = [UIColor whiteColor];
        userNameLabel.font = [UIFont systemFontOfSize:20];
        [userStatue addSubview:userNameLabel];
        
        _headView.frame = CGRectMake(0, 0, Screen_Width, 100);
        _appView.frame  = CGRectMake(0, _headView.bounds.size.height, 320, 320);
        _aboutView.frame = CGRectMake(0, _headView.bounds.size.height, 320, 320);
    }
    if(logSingal.exitAccountStatu == 2){
        NSLog(@"ChooseViewController.m退出状态=======================");
        [self viewDidLoad];
        //logSingal.exitAccountStatu =103;
    }
    
}

#pragma mark -- UserStatue的代理方法
#pragma mark 切换账号
- (void)presentToShiftView
{
    LoginStatueSingal *logSingal = [LoginStatueSingal shareLogStatu];
    logSingal.shiftStatu = 1;//登入界面 已经有账号登入的标记
    logSingal.logStatu = 2;//标记非1时候界面ViewController不刷新

    WebsViewController *vc = [[WebsViewController alloc]init];
    vc.imgFlag = 4;
    [self presentViewController:vc animated:YES completion:^{
        nil;
    }];
}
#pragma mark 会员中心
- (void)presentToVipView
{
    ViewController *vc = [[ViewController alloc]init];
    vc.imgFlag = 6;
    //NSLog(@"进入会员中心");
    [self presentViewController:vc animated:YES completion:^{
        nil;
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BackgroundColor_DarkBlack;//colorWithRed:59/255.0 green:66/255.0 blue:74/255.0 alpha:1];
    
    _headView = [[UIView alloc]initWithFrame:CGRectZero];
    _headView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_headView];
    
    NSLog(@"未登入");
    _buttonTitle = @"登入";
    _headView.frame = CGRectMake(0, 0, 320, 50);
        
    UIButton *loginBT = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBT.backgroundColor = [UIColor colorWithRed:59/255.0 green:66/255.0 blue:74/255.0 alpha:1];
        
    [loginBT addTarget:self action:@selector(userLog) forControlEvents:UIControlEventTouchUpInside];
    [loginBT setImage:[UIImage imageNamed:@"bottom_bg.png"] forState:UIControlStateHighlighted];
    [loginBT setTintColor:[UIColor whiteColor]];
    [loginBT setTitle:_buttonTitle forState:UIControlStateNormal];
    loginBT.frame = CGRectMake(8, 5, Screen_Width - 80, 40);
    [_headView addSubview:loginBT];

    //NSLog(@"企业定制应用");
    //企业定制应用
    _appView = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bounds.size.height, 320, 366)];
    _appView.backgroundColor = BackgroundColor_DarkBlack;
    [self.view addSubview:_appView];
    
        //遍历出按钮
        _custom = [[CustomManger alloc]connectWithCustomURLgetIndex:0];//解析json
        NSLog(@"数组的数量%d",_custom.customAr.count);
        if (_custom.customAr.count == 1) {
            
            _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_refreshButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"myRefresh.png"]]];
            [_refreshButton setBackgroundImage:[UIImage imageNamed:@"myRefresh_press.png"] forState:UIControlStateHighlighted];
            [_refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
            _refreshButton.frame = CGRectMake(10, 10, 64, 58);
            [_appView addSubview:_refreshButton];
            
            
        }else{
            for (int i=0;i<_custom.customAr.count ; i++) {
                
                //NSLog(@"遍历按钮");
                _custom = [[CustomManger alloc]connectWithCustomURLgetIndex:i ];//解析json
                CustomButton *customButton = [[CustomButton alloc]initWithFrame:CGRectMake(10+76*(i%3), 10+70*(i/3), 64, 58)];
                self.cusBT = customButton;
                //_cusBT = [[CustomButton alloc]initWithFrame:CGRectMake(10+76*(i%3), 10+70*(i/3), 64, 58)];
                customButton.connectDL = self;//设置“按钮”的代理
                customButton.titleLB.text = _custom.title;
                //cusBT.imgIcon.image = _custom.img;
                NSString *http = [_custom.imgUrl substringWithRange:NSMakeRange(0, 4)];
                if ([http isEqualToString:@"http"]) {//对解析的到的图片地址进行逻辑判断：本地、服务器
                    //[customButton.imgIcon setImageFronUrl:_custom.imgUrl];
                }else{
                    customButton.imgIcon.image = [UIImage imageNamed:_custom.imgUrl];
                }
                
                //NSLog(@"图片链接%@",_custom.imgUrl);
                //self.cusBT.webUrl = _custom.paramer;
                [urlArray addObject:_custom.paramer];
                customButton.tag = 2000+i;
                //self.cusBT.btTag = 0+i;
                [_appView addSubview:customButton];
            }
        }

        
    
       [self loadButtons];
    
}


#pragma mark -- CustomButton的代理方法
//static int pushToWebFlag = 1;
- (void)pushToWeb:(int)tag
{    
    CustomButton *cusBT = (CustomButton *)[self.view viewWithTag:tag];
//    NSLog(@"uiview weburl tag = %d",tag);
//    NSLog(@"ChooseViewController _cusBT.webUrl == %@",cusBT.webUrl);
//    if (!cusBT.webUrl) {
//        cusBT.webUrl = [urlArray objectAtIndex:tag-2000];
//        NSLog(@"ChooseViewController = %@",cusBT.webUrl);
//    }
    //vi.webUrl = cusBT.webUrl;
    LoginStatueSingal *singal = [LoginStatueSingal shareLogStatu];
    singal.logStatu = 2;//只要不是1，就不会重复加载出用户首页
//    if (cusBT.webUrl) {
    WebsViewController *vi = [[WebsViewController alloc]init];
    vi.imgFlag =1;
    vi.anWebUrl = [urlArray objectAtIndex:tag-2000];
    NSLog(@"[urlArray objectAtIndex:tag-2000] == %@",[urlArray objectAtIndex:tag-2000]);
    vi.navtitle = cusBT.titleLB.text;
    //*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[UIView webUrl]: unrecognized selector sent to instance 0x164c6100'
    if (singal.loginViewFlag == 2) {
            vi.imgFlag = 4;
    }
    [self presentViewController:vi animated:NO completion:nil];
//    }else{
//        nil;
//    }
}

#pragma mark -- 底部操作按钮
- (void)loadButtons
{
    _buttomBt2 = [[UIView alloc]initWithFrame:CGRectMake(3, Screen_Height-62, 120, 39)];
    _buttomBt2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_1_png_press.png"]];
    _buttomBt2.layer.cornerRadius = 5;
    //buttomBt2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_buttomBt2];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(app)];
    [_buttomBt2 addGestureRecognizer:tap2];
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(_buttomBt2.frame.size.width/2-20, _buttomBt2.frame.size.height/2-8, 40, 16)];
    title2.textColor = [UIColor whiteColor];
    title2.backgroundColor = [UIColor clearColor];
    title2.text = @"应用";
    [_buttomBt2 addSubview:title2];
    
    _buttomBt3 = [[UIView alloc]initWithFrame:CGRectMake(_buttomBt2.frame.size.width+5, Screen_Height-62, 120, 39)];
    _buttomBt3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_1.png"]];
    _buttomBt3.layer.cornerRadius = 5;
    //    buttomBt3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_buttomBt3];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(about)];
    [_buttomBt3 addGestureRecognizer:tap3];
    UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(_buttomBt3.frame.size.width/2-20, _buttomBt3.frame.size.height/2-8, 40, 16)];
    title3.textColor = [UIColor whiteColor];
    title3.backgroundColor = [UIColor clearColor];
    title3.text = @"关于";
    [_buttomBt3 addSubview:title3];
}

- (void)app
{
    [_aboutView removeFromSuperview];
    [self.view addSubview:_appView];
    
    _buttomBt2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_1_png_press.png"]];
    //_buttomBt1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_1_png.9.png"]];
    _buttomBt3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_1.png"]];
    
}

- (void)about
{
    [_appView removeFromSuperview];
    
    //_buttomBt1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_1_png.9.png"]];
    _buttomBt2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_1.png"]];
    //_buttomBt1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_1_png.9.png"]];
    _buttomBt3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_1_png_press.png"]];
    
    //关于页面
    _aboutView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 366)];
    _aboutView.frame = CGRectMake(0, _headView.bounds.size.height, 320, 320);
    [self.view addSubview:_aboutView];
    _aboutView.backgroundColor = BackgroundColor_DarkBlack;
    
    UIView *shareV = [self creatAboutViewsSetTitle:@"分享应用" andImg:@"glyphicons_308_share_alt.png" andFrame:CGRectMake(10, 5, 230, 40) andSelect:@selector(shareSL)];
    shareV.tag = 3001;
    [_aboutView addSubview:shareV];
    
    UIView *updataV = [self creatAboutViewsSetTitle:@"检查更新" andImg:@"glyphicons_365_restart.png" andFrame:CGRectMake(10, 50, 230, 40) andSelect:@selector(checkUpdate)];
    updataV.tag = 3002;
    [_aboutView addSubview:updataV];
    
    UIView *feedV = [self creatAboutViewsSetTitle:@"意见反馈" andImg:@"glyphicons_234_brush.png" andFrame:CGRectMake(10, 95, 230, 40) andSelect:@selector(feedBackSL)];
    feedV.tag = 3003;
    [_aboutView addSubview:feedV];
    
    
    UIView *aboutV = [self creatAboutViewsSetTitle:@"关于" andImg:@"glyphicons_258_qrcode.png" andFrame:CGRectMake(10, 140, 230, 40) andSelect:@selector(aboutSL)];
    aboutV.tag = 3004;
    [_aboutView addSubview:aboutV];
    
}

//创建关于内条形按钮
- (UIView *)creatAboutViewsSetTitle:(NSString *)aTitle
                         andImg:(NSString *)imgName
                       andFrame:(CGRect)aFrame
                      andSelect:(SEL)select
{
    UIView *about = [[UIView alloc]initWithFrame:aFrame];
    about.layer.shadowColor = [UIColor blackColor].CGColor;
    about.layer.shadowOffset = CGSizeMake(4, 4);
    about.layer.shadowOpacity = .5;
    
    about.backgroundColor = [UIColor colorWithRed:61/255.0 green:71/255.0 blue:82/255.0 alpha:1];
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(75, 12.5, 80, 15)];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = [UIColor whiteColor];
    titleLB.backgroundColor = [UIColor clearColor];
    titleLB.text = aTitle;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 9, 22, 22)];
    imgView.image = [UIImage imageNamed:imgName];
    [about addSubview:imgView];
    [about addSubview:titleLB];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:select];
    [about addGestureRecognizer:tap];
    
    return about;
}


- (void)shareSL
{
    //NSLog(@"分享");
    UIView *share = (UIView *)[self.view viewWithTag:3001];
    [UIView animateWithDuration:0.3 animations:^{
        //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:share cache:YES];
        share.backgroundColor = BackgroundColor_Green;
        share.backgroundColor = BackgroundColor_Black;
    }];
    
    
    //创建分享内容
    NSString *imagePath =  [[NSBundle mainBundle] pathForResource:@"logo"
                                                           ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"真机测试 网即通移动版:http://app.gitom.com/MobileApp/detail/7"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:nil//[ShareSDK imageWithPath:imagePath]
                                                title:@"网即通"
                                                  url:@"http://app.gitom.com/MobileApp/detail/7"
                                          description:imagePath
                                            mediaType:SSPublishContentMediaTypeNews];
    
    NSArray *shareList1=[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeSohuWeibo,ShareTypeRenren,ShareType163Weibo,nil];
    
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

#pragma mark -- 版本更新
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
        
    }else{
        UIAlertView *alr = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alr show];
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




- (void)restartSL
{
    //NSLog(@"更新");
    UIView *restart = (UIView *)[self.view viewWithTag:3002];
    [UIView animateWithDuration:0.4 animations:^{
        //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:restart cache:YES];
        restart.backgroundColor = BackgroundColor_Green;
        restart.backgroundColor = BackgroundColor_Black;
    }];
    //http://59.57.15.168/dev.html
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://59.57.15.168/dev1.html"]];
//    UIAlertView *alr = [[UIAlertView alloc]initWithTitle:@"提示" message:@"还未出新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alr show];
    
}

- (void)feedBackSL
{
    //NSLog(@"意见反馈");
    UIView *restart = (UIView *)[self.view viewWithTag:3003];
    [UIView animateWithDuration:0.3 animations:^{
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:restart cache:YES];
        restart.backgroundColor = BackgroundColor_Green;
        restart.backgroundColor = BackgroundColor_Black;
    }];
    
    //http://app.gitom.com/app/detail/125
    WebsViewController *vc = [[WebsViewController alloc]init];
    vc.imgFlag = 3;
    vc.navtitle = @"反馈";
    vc.anWebUrl = @"http://app.gitom.com/app/detail/125";
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)aboutSL
{
    UIView *about = (UIView *)[self.view viewWithTag:3004];
    
    [UIView animateWithDuration:0.3 animations:^{
        about.backgroundColor = BackgroundColor_Green;
        about.backgroundColor = BackgroundColor_Black;
    }];
    
    WebsViewController *vc = [[WebsViewController alloc]init];
    vc.imgFlag = 2;
    vc.navtitle = @"关于";
    //vc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //vc.webUrl = @"http://app.gitom.com/app/detail/125";
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark -- 登入
- (void)userLog
{
    //NSLog(@"用户登入");
    WebsViewController *vc = [[WebsViewController alloc]init];
    vc.imgFlag = 4;
    vc.navtitle = @"用户登入";
    [self presentViewController:vc animated:YES completion:nil];
}

//刷新
- (void)refreshAction
{
    //NSLog(@"刷新");
//    [_refreshButton setBackgroundColor:BackgroundColor_Green];
//    [UIView animateWithDuration:0.5 animations:^{
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_refreshButton cache:YES];
//    }];
    //重新请求连接
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gapp.gitom.com/api/getAppMenuList.json?packname=com.gitom.app"]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    //获得连接数据
    NSError *error = nil;
    NSData *getData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    LoginStatueSingal *loginSingal = [LoginStatueSingal shareLogStatu];
    loginSingal.customUrlData = getData;
    [self viewDidLoad];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
