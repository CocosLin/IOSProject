//
//  SetMapPositionVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-24.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"

@interface SetMapPositionVC : VcWithNavBar<BMKMapViewDelegate>
@property (nonatomic,strong) BMKMapView *mapVeiw;
@property (nonatomic,copy) NSString *locStr;
@end