//
//  SetMapPositionVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-24.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "SetMapPositionVC.h"

@interface SetMapPositionVC ()

@end

@implementation SetMapPositionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_On"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    //    - (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate;
        BMKMapView *mapVeiw = [[BMKMapView alloc]initWithFrame:CGRectMake(0,45, Screen_Width, Screen_Height)];
    //mapVeiw.zoomLevel = 10.0;
        mapVeiw.delegate = self;
        mapVeiw.showsUserLocation = YES;
        self.view = mapVeiw;
    CLLocationCoordinate2D cllocation = CLLocationCoordinate2DMake(24.797424, 118.579995);
    NSLog(@"mapVeiw.userLocation == %f  %f ",cllocation.latitude,cllocation.longitude);
    [mapVeiw setCenterCoordinate:cllocation animated:YES];
    BMKCoordinateSpan span = BMKCoordinateSpanMake(200, 200);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(cllocation, span);
    [mapVeiw setRegion:region];
    [mapVeiw release];
}

#pragma mark -- BMKMapDelegate
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    //coordinate.longitude;
    //coordinate.latitude;
    NSLog(@"%f,%f",coordinate.longitude,coordinate.latitude);
}

- (BMKCoordinateRegion)regionThatFits:(BMKCoordinateRegion)region{
    NSLog(@"---------------");
    return region;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
