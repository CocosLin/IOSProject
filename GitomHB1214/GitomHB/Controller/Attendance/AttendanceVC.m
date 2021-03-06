#import "AttendanceVC.h"
#import "WCommonMacroDefine.h"
#import "HBServerKit.h"

@interface AttendanceVC ()
{
    UILabel * _lblDistanceClock;
    UILabel * _lblDistanceRange;
    UIImageView * _imageViewShakeUp;
    UIImageView * _imageViewShakeDown;
    NSString *myAddress;
}
@end

@implementation AttendanceVC
@synthesize up,down;
#pragma mark - 属性控制
-(void)setIsAttenWork:(BOOL)isAttenWork
{
    _isAttenWork = isAttenWork;
    if (isAttenWork) {
        self.title = @"上班考勤";
    }else
    {
        self.title = @"下班考勤";
    }
}

-(void)setDisAtten2Org:(long long)disAtten2Org
{
    _disAtten2Org = disAtten2Org;
    if (disAtten2Org == -1) {
        _lblDistanceClock.text = [NSString stringWithFormat:@"正在计算当前位置与公司的距离..."];
        return;
    }
     _lblDistanceClock.text = [NSString stringWithFormat:@"位置距离：%lli米",disAtten2Org];
}

-(void)setRangeAtten2Org:(long long)rangeAtten2Org
{
    _rangeAtten2Org = rangeAtten2Org;
    if (_rangeAtten2Org == -1) {
        _lblDistanceRange.text = [NSString stringWithFormat:@"正在读取公司所设定的有效考勤范围..."];
        return;
    }
    _lblDistanceRange.text = [NSString stringWithFormat:@"有效范围：%lli米",rangeAtten2Org];
}

#pragma mark -- 测算两点之间距离
-(long)getDistanceWithLongitude1:(double)lng1 andLatitude1:(double)lat1 andLongitude2:(double)lng2 andLatitude1:(double)lat2
{
    CLLocation * lo1 = [[CLLocation alloc]initWithLatitude:lat1 longitude:lng1];
    CLLocation * lo2 = [[CLLocation alloc]initWithLatitude:lat2 longitude:lng2];
    double distance = [lo2 distanceFromLocation:lo1];
 

    return (long)distance;
}
#pragma mark --BMKMapViewDelegate--
/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"AttendanceVC BMKMapViewDelegate location %@",userLocation);
    _userLocation = userLocation;

    //保存用户当前位置
    self.latitude = _userLocation.coordinate.latitude;
    self.longitude = _userLocation.coordinate.longitude;
    NSLog(@"AttendanceVC BMKMapViewDelegate location %f %f",self.longitude,self.latitude);
    getPosDistent = [self getDistanceWithLongitude1:self.companyLongitude andLatitude1:self.companyLatitude andLongitude2:self.longitude andLatitude1:self.latitude];
    NSLog(@"两点之间的距离 == %ld",getPosDistent);
    [self setDisAtten2Org:getPosDistent];
    [self setRangeAtten2Org:self.rangeAtten2Org];
}
/**
 *在地图View停止定位时，会调用此函数
 *@param mapView 地图View
 */
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"map position stop");
    
    [_bMksearch reverseGeocode:_userLocation.coordinate];
    _bMksearch.delegate = self;
    
}

#pragma mark -百度地图服务
-(void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error
{
    //地址
    
    //myAddress = result.strAddr;
    NSLog(@"self.myAddress == %@",result.strAddr);
    //self.bMapView.showsUserLocation = NO;
    NSLog(@"AttedanceVC myAddress == %@",myAddress);
    /*
    //如果是高级版上传用户坐标
    GetCommonDataModel;
    if ([comData.organization.appLevelCode isEqualToString:kBase]) {
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        float accuracy = arc4random()/1000.99;
        NSLog(@"accuracy == %f",accuracy);
        
        [hbKit sendUserPositionWithaccuracy:accuracy
                                andlatitude:_userLocation.coordinate.latitude
                                andlocation:result.strAddr
                               andlongitude:_userLocation.coordinate.longitude
                                andusername:comData.userModel.username];
    }
    */
}

#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"考勤";
        BMKMapView *mapView = [[BMKMapView alloc]init];
        self.mapView = mapView;
        self.mapView.showsUserLocation = YES;
        self.mapView.delegate = self;
        myAddress = [[NSString alloc]init];
        _bMksearch = [[BMKSearch alloc]init];
        
  
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GetGitomSingal;
    self.rangeAtten2Org = [singal.distance longLongValue];
    self.companyLatitude = singal.latitude;
    self.companyLongitude = singal.longitude;
    
    //上视图320/3=106.3  480/6=80
    up=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width/3,Screen_Height/6, Screen_Width/3, Screen_Height/6-20)];
    up.image=[UIImage imageNamed:@"shake_logo_up.png"];
    [self.view addSubview:up];
    
    //下视图
    down=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width/3, Screen_Height/3-10, Screen_Width/3, Screen_Height/6-20)];
    down.image=[UIImage imageNamed:@"shake_logo_down.png"];
    [self.view addSubview:down];
    up.center=CGPointMake(Screen_Width/2, Screen_Height/2-Screen_Height/16);
    down.center=CGPointMake(Screen_Width/2, Screen_Height/2+Screen_Height/16);
    
    //----------------------------------------设置导航条----------------------------------------
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
  

    //---------------------------------视图----------------------------------------
    self.view.backgroundColor=[UIColor colorWithRed:(50/255.0) green:(56/255.0) blue:(61/255.0) alpha:1];
    //视图开始的y坐标值
    CGFloat y_top = 0;
    //位置信息视图
    UIView *  viewDistance = [[UIView alloc]initWithFrame:CGRectMake(10, y_top + 10, Width_Screen - 10 * 2, 60)];
    [viewDistance setBackgroundColor:[UIColor clearColor]];
    CGRect boundsViewDistance = viewDistance.bounds;
    //当前打卡位置信息
    UIView * viewDistanceClock = [[UIView alloc]initWithFrame:CGRectMake(boundsViewDistance.origin.x, boundsViewDistance.origin.y, boundsViewDistance.size.width, 30)];
    [viewDistanceClock setBackgroundColor:[UIColor clearColor]];
    CGRect boundsViewDistanceClock = viewDistanceClock.bounds;
    
    //图片
    UIImageView * imageViewClock = [[UIImageView alloc]initWithFrame:CGRectMake(boundsViewDistanceClock.origin.x, boundsViewDistanceClock.origin.y, 20, 20)];
    imageViewClock.image = [UIImage imageNamed:@"positioning.png"];
    [imageViewClock setBackgroundColor:[UIColor clearColor]];
    [viewDistanceClock addSubview:imageViewClock];
  
    CGRect frameImageViewClock = imageViewClock.bounds;
    //位置距离
    _lblDistanceClock = [[UILabel alloc]initWithFrame:CGRectMake(frameImageViewClock.size.width, frameImageViewClock.origin.y - 5, boundsViewDistanceClock.size.width - frameImageViewClock.size.width, 30)];
    
    [_lblDistanceClock setBackgroundColor:[UIColor clearColor]];
    [_lblDistanceClock setFont:[UIFont systemFontOfSize:14]];
    self.disAtten2Org = -1;//初始化提示文字
    [_lblDistanceClock setTextColor:[UIColor whiteColor]];
    [viewDistanceClock addSubview:_lblDistanceClock];
    
    [viewDistance addSubview:viewDistanceClock];
  
    
    //有效打卡位置
    UIView * viewDistanceRange = [[UIView alloc]initWithFrame:CGRectMake(boundsViewDistance.origin.x, boundsViewDistance.origin.y + boundsViewDistanceClock.size.height, boundsViewDistance.size.width, 30)];
    [viewDistanceClock setBackgroundColor:[UIColor clearColor]];
    UIImageView * imageViewRange= [[UIImageView alloc]initWithFrame:CGRectMake(boundsViewDistanceClock.origin.x, boundsViewDistanceClock.origin.y, 20, 20)];
    imageViewRange.image = [UIImage imageNamed:@"Scope.png"];
    [imageViewRange setBackgroundColor:[UIColor clearColor]];
    [viewDistanceRange addSubview:imageViewRange];
  
    CGRect frameImageViewRange = imageViewRange.bounds;
    //位置距离
    _lblDistanceRange = [[UILabel alloc]initWithFrame:CGRectMake(frameImageViewRange.size.width, frameImageViewRange.origin.y - 5, boundsViewDistanceClock.size.width - frameImageViewRange.size.width, 30)];
   
    [_lblDistanceRange setBackgroundColor:[UIColor clearColor]];
    [_lblDistanceRange setFont:[UIFont systemFontOfSize:14]];
    [_lblDistanceRange setTextColor:[UIColor whiteColor]];
    [viewDistanceRange addSubview:_lblDistanceRange];
   
    [viewDistance addSubview:viewDistanceRange];
   
    
    [self.view addSubview:viewDistance];
  
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [but1 setTitle:@"打卡" forState:UIControlStateNormal];
    but1.frame = CGRectMake(10, Screen_Height-110, Screen_Width-20, 42);
    [but1 setBackgroundImage:[[UIImage imageNamed:@"03.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [but1 setBackgroundImage:[[UIImage imageNamed:@"04.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [but1 addTarget: self action:@selector(motionEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
}


//成为第一响应者
- (BOOL) canBecomeFirstResponder
{
    return YES;
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    [self becomeFirstResponder];
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.showsUserLocation = NO;
}

#pragma mark -- 摇晃手势
static SystemSoundID shake_sound_male_id = 0;
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    //检测到摇动
    NSLog(@"检测摇动");
    //类似微信摇一摇的动画
    [UIView animateWithDuration:0.8 animations:^{
        up.center=CGPointMake(Screen_Width/2, Screen_Height/2-Screen_Height/12-30);
        down.center=CGPointMake(Screen_Width/2, Screen_Height/2+Screen_Height/12+30);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{
            up.center=CGPointMake(Screen_Width/2, Screen_Height/2-Screen_Height/16);
            down.center=CGPointMake(Screen_Width/2, Screen_Height/2+Screen_Height/16);
        }];
    }];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"shaking" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);
    
    //更新定位
    //[self updateLocation:nil];
    
}


//摇动取消
- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    //摇动取消
    NSLog(@"摇动取消");
    
}

//摇动结束
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shaken" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    AudioServicesPlaySystemSound(shake_sound_male_id);

    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    if (self.isAttenWork == YES) {
        [hbKit savePlayCardWithOrganizationId:comData.organization.organizationId OrgunitId:comData.organization.orgunitId Username:comData.userModel.username PunchType:kOnPunch Longitude:self.longitude Latitude:self.latitude GotArrReports:^(NSArray *arrDicReports, WError *myError) {
            NSLog(@"获得打卡返回数据");
        }];
    }else{
        [hbKit savePlayCardWithOrganizationId:comData.organization.organizationId OrgunitId:comData.organization.orgunitId Username:comData.userModel.username PunchType:kOffPunch Longitude:self.longitude Latitude:self.latitude GotArrReports:^(NSArray *arrDicReports, WError *myError) {
            NSLog(@"获得打卡返回数据");
        }];
    }
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
