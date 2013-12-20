//
//  SetMapPositionVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-24.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "SetMapPositionVC.h"
#import "SVProgressHUD.h"

@interface SetMapPositionVC (){
    CLLocationCoordinate2D coor;
    BOOL showedOlderPosition;
    BMKPointAnnotation* newAnnotation;
}

@end

@implementation SetMapPositionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"打卡位置";
    }
    return self;
}
#pragma mark -- 确定新的打卡坐标
- (void)setNewPositionAction{
    GetGitomSingal;
    if (coor.longitude||coor.latitude) {
        
        singal.latitude = coor.latitude;
        singal.longitude = coor.longitude;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changePosition" object:[NSString stringWithFormat:@"%f,%f",singal.latitude,singal.longitude]];
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"确定新坐标：%f，%f",coor.latitude,coor.longitude]];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有确定新的坐标，我们将沿用之前的" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [aler show];
  
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    newAnnotation = [[BMKPointAnnotation alloc]init];
    
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"说明" message:@"点击地图，大头针出现的地方将是新的公司坐标！" delegate:nil cancelButtonTitle:@"明白" otherButtonTitles:nil, nil];
    [aler show];
 
    //返回按钮
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
   
    
    //确定保存按钮
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setTitle:@"确定" forState:UIControlStateNormal];
    [rbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rbtn.frame = CGRectMake(0, 0, 50, 44);
    [rbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    [rbtn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [rbtn addTarget:self action:@selector(setNewPositionAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rbtn];
    self.navigationItem.rightBarButtonItem = rbarButtonItem;
   
    
    self.mapVeiw = [[BMKMapView alloc]initWithFrame:CGRectMake(0,45, Screen_Width, Screen_Height)];
    self.mapVeiw.delegate = self;
    GetGitomSingal;
    CLLocationCoordinate2D cllocation = CLLocationCoordinate2DMake(singal.latitude, singal.longitude);
    NSLog(@"mapVeiw.userLocation == %f  %f ",cllocation.latitude,cllocation.longitude);
    self.mapVeiw.centerCoordinate = cllocation;
//    self.mapVeiw.showsUserLocation = YES;
    
    self.mapVeiw.zoomLevel = 19.0;
    self.view = self.mapVeiw;
    
}



- (BMKCoordinateRegion)regionThatFits:(BMKCoordinateRegion)region{
    NSLog(@"---------------");
    return region;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapVeiw viewWillAppear];
    self.mapVeiw.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapVeiw viewWillDisappear];
    //self.mapVeiw.delegate = nil; // 不用时，置nil
//    self.mapVeiw.showsUserLocation = NO;
}

#pragma mark -- BMKMapDelegate 百度地图代理方法
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    //coordinate.longitude;
    //coordinate.latitude;
    NSLog(@"touch cordinate = %f,%f",coordinate.longitude,coordinate.latitude);
    coor.longitude = coordinate.longitude;
    coor.latitude = coordinate.latitude;
    showedOlderPosition = YES;
    [self viewDidAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"确定打卡位置");
    
//    coor.latitude = 24.796942;
//    coor.longitude = 118.588970;
    GetGitomSingal;
    CLLocationCoordinate2D oldCoor;
    oldCoor.latitude = singal.latitude;
    oldCoor.longitude = singal.longitude;
    if (showedOlderPosition) {
        newAnnotation.coordinate = coor;
        
    }else{
        newAnnotation.coordinate = oldCoor;
    }
    
    newAnnotation.title = @"公司位置";
    [self.mapVeiw addAnnotation:newAnnotation];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSLog(@"大头针");
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if (showedOlderPosition) {
            newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        }else{
            newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        }
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        if (annotation != nil) {
            [self.mapVeiw removeAnnotation:annotation];
        }
        return newAnnotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
