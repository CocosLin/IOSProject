//
//  AttendanceConfigModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-7-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "WBaseModel.h"

@interface AttendanceConfigModel : WBaseModel  

@property(nonatomic,retain)NSDictionary * attenConfig;
@property(nonatomic,retain)NSArray * attenWorktimes;
@end
