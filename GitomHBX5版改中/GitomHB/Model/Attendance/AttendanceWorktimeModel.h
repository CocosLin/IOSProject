//
//  AttendanceWorktimeModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-7-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "WBaseModel.h"

@interface AttendanceWorktimeModel : WBaseModel



@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;

@property (nonatomic,assign) long offTime1;
@property (nonatomic,assign) long oneTime1;
@property (nonatomic,assign) long offTime2;
@property (nonatomic,assign) long oneTime2;
@property (nonatomic,assign) long offTime3;
@property (nonatomic,assign) long oneTime3;

@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *outMinute;
@property (nonatomic,copy) NSString *inMinute;
/*
 createDate = 1373074845000;
 createUserId = 56555;
 offTime = 14400000;
 onTime = 1800000;
 ordinal = 1;
 organizationId = 114;
 orgunitId = 1;
 updateDate = 1373074845000;
 updateUserId = 56555;
 voidFlag = 0;
 */
@property(nonatomic,assign)NSInteger ordinal;
@property(nonatomic,assign)NSInteger organizationId;
@property(nonatomic,assign)NSInteger orgunitId;
@property(nonatomic,assign)long offTime;
@property(nonatomic,assign)long onTime;
@property(nonatomic,assign)BOOL voidFlag;



@end
