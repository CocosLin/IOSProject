//
//  AttendanceConfigModel.m
//  GitomNetLjw
//
//  Created by jiawei on 13-7-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "AttendanceConfigModel.h"

@implementation AttendanceConfigModel
-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson]) {
        self.attenConfig = [dicFromJson objectForKey:@"attenConfig"];
        self.attenWorktimes = [dicFromJson objectForKey:@"attenWorktime"];
    }return self;
}
-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicForJson = [NSMutableDictionary dictionaryWithDictionary:[super getDicJsonForAllJsonDataType]];
    if (self.attenConfig) {
        [dicForJson setObject:self.attenConfig forKey:@"attenConfig"];
    }
    if (self.attenWorktimes) {
        [dicForJson setObject:self.attenWorktimes forKey:@"attenWorktime"];
    }
    return dicForJson;
}
@end
