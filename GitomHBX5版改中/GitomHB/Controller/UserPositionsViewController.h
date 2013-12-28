//
//  UserPositionsViewController.h
//  GitomHB
//
//  Created by jiawei on 13-12-11.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "VcWithNavBar.h"
#import "BMapKit.h"
#import "BMKPolyline.h"

@interface UserPositionsViewController : VcWithNavBar<BMKMapViewDelegate,BMKSearchDelegate>{
    
    BMKMapRect routeRect;
    NSArray* routes;
    NSMutableArray * allCoordinateArr;
    BMKPointAnnotation* annotation;
    NSString *addressStr;
}

@property (strong, nonatomic) NSString *username;

@property (nonatomic, strong) BMKPolyline * routeLine;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong)BMKPolylineView * routeLineView;

@end
