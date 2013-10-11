//
//  AttendanceWorktimeModel.m
//  GitomNetLjw
//
//  Created by jiawei on 13-7-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "AttendanceWorktimeModel.h"

@implementation AttendanceWorktimeModel
-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson])
    {
        
        self.ordinal = [[dicFromJson objectForKey:@"ordinal"] integerValue];
        self.organizationId = [[dicFromJson objectForKey:@"organizationId"] integerValue];
        self.orgunitId = [[dicFromJson objectForKey:@"orgunitId"] integerValue];
        self.offTime = [[dicFromJson objectForKey:@"offTime"] longValue];
        self.onTime = [[dicFromJson objectForKey:@"onTime"] longValue];
        self.voidFlag = [[dicFromJson objectForKey:@"voidFlag"] boolValue];
    }return self;
}

-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicForJson = [NSMutableDictionary dictionaryWithDictionary:[super getDicJsonForAllJsonDataType]];
    [dicForJson setObject:[NSNumber numberWithInteger:self.ordinal] forKey:@"ordinal"];
    [dicForJson setObject:[NSNumber numberWithInteger:self.organizationId] forKey:@"organizationId"];
    [dicForJson setObject:[NSNumber numberWithInteger:self.orgunitId] forKey:@"orgunitId"];
    [dicForJson setObject:[NSNumber numberWithLong:self.offTime] forKey:@"offTime"];
    [dicForJson setObject:[NSNumber numberWithLong:self.onTime] forKey:@"onTime"];
    [dicForJson setObject:[NSNumber numberWithBool:self.voidFlag] forKey:@"voidFlag"];
    return dicForJson;
}


@end
