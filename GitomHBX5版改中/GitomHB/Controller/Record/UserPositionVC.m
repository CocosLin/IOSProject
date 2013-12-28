//
//  UserPositionVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-14.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "UserPositionVC.h"

@interface UserPositionVC ()

@end

@implementation UserPositionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"汇报位置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate bMapView].showsUserLocation = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
 
    
    
    self.mapVeiw = [[BMKMapView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height)];
    self.mapVeiw.delegate = self;
    CLLocationCoordinate2D cllocation = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    NSLog(@"mapVeiw.userLocation == %f  %f ",cllocation.latitude,cllocation.longitude);
    self.mapVeiw.centerCoordinate = cllocation;
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
}

#pragma mark -- BMKMapDelegate 百度地图代理方法
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [self viewDidAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.latitude;
    coor.longitude = self.longitude;
    annotation.coordinate = coor;
    annotation.title = [NSString stringWithFormat:@"汇报地点:%@",self.addressStr];
    [self.mapVeiw addAnnotation:annotation];

}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        
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
