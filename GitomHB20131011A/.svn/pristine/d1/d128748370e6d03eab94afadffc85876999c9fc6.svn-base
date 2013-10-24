//
//  AttendanceVC.h
//  GitomNetLjw
//
//  Created by linjiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

/*
 考勤
 */

#import "VcWithNavBar.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"


@interface AttendanceVC : VcWithNavBar<BMKMapViewDelegate>{
    BMKUserLocation * _userLocation;
    long getPosDistent;
}

@property(retain, nonatomic) BMKMapView *mapView;
@property(assign,nonatomic)BOOL isAttenWork;//是否上班考勤,不是上班考勤，就是下班考勤
@property(assign,nonatomic)long long int disAtten2Org;//与公司
@property(assign,nonatomic)long long int rangeAtten2Org;//公司的考勤范围
@property(assign,nonatomic)CGFloat companyLongitude;//公司坐标的经度
@property(assign,nonatomic)CGFloat companyLatitude;//公司坐标的纬度
@property(assign,nonatomic)CGFloat longitude;//员工打卡时坐标的经度
@property(assign,nonatomic)CGFloat latitude;//员工打卡时坐标的维度
@property(retain,nonatomic)UIImageView *up,*down;

@end
