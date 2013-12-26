//
//  UserPositionsViewController.m
//  GitomHB
//
//  Created by jiawei on 13-12-11.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "UserPositionsViewController.h"
#import "HBServerKit.h"
#import "WTool.h"
#import "SVProgressHUD.h"
#import "UserPositionModel.h"

@interface UserPositionsViewController (){
    NSString *titleStr;
}

@end

@implementation UserPositionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        titleStr = [[NSString alloc]init];
        self.title = @"24小时行踪";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleStr = @"24小时行踪";
    //停止定位
    [(AppDelegate *)[UIApplication sharedApplication].delegate bMapView].showsUserLocation = NO;
    [[(AppDelegate *)[UIApplication sharedApplication].delegate timer] invalidate];
    // 后退
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //刷新按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"本月" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 50, 44);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    [btn1  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(locationsAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
	//成员运动轨迹
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    self.mapView.zoomLevel = 19;
    [self.view addSubview:self.mapView];
    
    
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    NSDateComponents * componets = [WTool getDateComponentsWithDate:[NSDate date]];
    [hbKit getPositonsWithUserName:self.username
                      andbeginTime:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]-20000000 - ((long long int)(componets.hour)*110*60*1000)
                        andendTime:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
                          getArray:^(NSArray *arr, WError *myError){
                              if (arr.count<=0) {
                                  [SVProgressHUD showErrorWithStatus:@"暂无该成员24小时内行踪" duration:1.3];
                                  return;
                              }
                              [self.mapView removeOverlays:self.mapView.overlays];
                              // 添加折线覆盖物
                              CLLocationCoordinate2D coors[arr.count];
                              //UserPositionModel *posMod = [[UserPositionModel alloc]init];
                              NSMutableArray *annotationAr = [[NSMutableArray alloc]init];
                              for (int i = 0; i<arr.count; i++) {
                                  UserPositionModel *posMod = [arr objectAtIndex:i];
                                  coors [i] = posMod.loc.coordinate;
                                  
                                  BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
                                  pointAnnotation.coordinate = posMod.loc.coordinate;
//                                  pointAnnotation.title = posMod.createDate;
//                                  pointAnnotation.subtitle = posMod.location;
                                  pointAnnotation.title = posMod.location;
                                  pointAnnotation.subtitle = [WTool getStrDateTimeWithDateTimeMS:[posMod.createDate longLongValue] DateTimeStyle:@"YYYY-MM-dd HH:mm:ss"];
                                  //[self.mapView addAnnotation:pointAnnotation];
                                  [annotationAr addObject:pointAnnotation];
                                
                              }
                              [self.mapView addAnnotations:annotationAr];

                              BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:arr.count];
                              [_mapView addOverlay:polyline];
                              UserPositionModel *posMod = [arr objectAtIndex:0];
                            
                              CLLocation *lastLoc = posMod.loc;
                              self.mapView.centerCoordinate = lastLoc.coordinate;

                          }];
    
}

- (void)btnBack:(id) sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.mapView removeOverlays:self.mapView.overlays];
    self.mapView.delegate = nil;
    [SVProgressHUD dismiss];
    
    
}

#pragma mark -- 本月内行踪
- (void)locationsAction{
    
    titleStr = @"本月行踪";
    [self.mapView removeOverlays:self.mapView.overlays];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    NSDateComponents * componets = [WTool getDateComponentsWithDate:[NSDate date]];
    [hbKit getPositonsWithUserName:self.username
                      andbeginTime:[WTool getEndDateTimeMsWithNSDate:[NSDate date]] - ((long long int)(componets.day-1)*15*60*60*1000)
                        andendTime:[WTool getEndDateTimeMsWithNSDate:[NSDate date]]
                          getArray:^(NSArray *arr, WError *myError){
                              if (arr.count<=0) {
                                  UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"无成员行踪?" message:@"被查询用户需要开启移动汇报才能够记录下行踪" delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil, nil];
                                  [aler show];
                                  return;
                              }
                              
                              // 添加折线覆盖物
                              CLLocationCoordinate2D coors[arr.count];
                              //UserPositionModel *posMod = [[UserPositionModel alloc]init];
                              NSMutableArray *annotationAr = [[NSMutableArray alloc]init];
                              for (int i = 0; i<arr.count; i++) {
                                  UserPositionModel *posMod = [arr objectAtIndex:i];
                                  coors [i] = posMod.loc.coordinate;
                                  
                                  BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
                                  pointAnnotation.coordinate = posMod.loc.coordinate;
                                  pointAnnotation.title = posMod.location;
                                  pointAnnotation.subtitle = [WTool getStrDateTimeWithDateTimeMS:[posMod.createDate longLongValue] DateTimeStyle:@"YYYY-MM-dd HH:mm:ss"];
   
                                  [annotationAr addObject:pointAnnotation];
                                  
                              }
                              [self.mapView addAnnotations:annotationAr];
                              
                              BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:arr.count];
                              [_mapView addOverlay:polyline];
                              UserPositionModel *posMod = [arr objectAtIndex:0];
                              CLLocation *lastLoc = posMod.loc;
                              self.mapView.centerCoordinate = lastLoc.coordinate;
                              
                          }];
}
                           
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = BlueColor;//[[UIColor purpleColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)viewWillUnload{
     NSLog(@"nil delegate");
    self.mapView.delegate = nil;
}
@end
