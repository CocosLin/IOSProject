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

@interface AttendanceVC : VcWithNavBar

@property(assign,nonatomic)BOOL isAttenWork;//是否上班考勤,不是上班考勤，就是下班考勤
@property(assign,nonatomic)long long int disAtten2Org;//与公司
@property(assign,nonatomic)long long int rangeAtten2Org;//公司的考勤范围

@end
