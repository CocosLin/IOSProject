//
//  UserPositionVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-14.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"
@interface UserPositionVC : VcWithNavBar<BMKMapViewDelegate>
@property (nonatomic,strong) BMKMapView *mapVeiw;
@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;
@end
