//
//  AppDelegate.h
//  GitomHB
//
//  Created by jiawei on 13-11-29.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWMotionRecognizingWindow.h"//可以发送摇动手机通知的window
#import "LoginVC.h"//登录页面
#import "CommonDataModel.h"
#import "UIViewController+JASidePanel.h"
#import "BMapKit.h"
#import <CoreLocation/CoreLocation.h>
//#import "ASIDownloadCache.h"
//#import "ASINetworkQueue.h"
//#import <MapKit/MapKit.h>
#import "BMKMapView.h"

@class JASidePanelController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,BMKMapViewDelegate,BMKSearchDelegate>
{
    BMKMapManager* _mapManager;
    //ASIDownloadCache *myCache;
//    NSTimer *timer;
    CLLocation * loc2d;
    //BMKMapView * bMapView;
}
@property (strong, nonatomic) JWMotionRecognizingWindow * window;
@property(retain,nonatomic)CommonDataModel * comData;
@property (nonatomic, unsafe_unretained, getter=isExecutingInBackground) BOOL
executingInBackground;// 判断程序是否在后台
//@property (strong, nonatomic) CLLocationManager *myLocationManager;

@property (retain, nonatomic) BMKMapView * bMapView;
@property (nonatomic, copy) NSString * myAddress;
@property (nonatomic, strong) NSTimer *timer;


@end
