//
//  AttendanceConfigBean.m
//  GitomNetLjw
//
//  Created by jiawei on 13-7-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "AttendanceConfigBean.h"

@implementation AttendanceConfigBean


-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson]) {
        self.organizationId = [[dicFromJson objectForKey:@"organizationId"] integerValue];
        self.orgunitId = [[dicFromJson objectForKey:@"orgunitId"] integerValue];
        self.inMinute = [[dicFromJson objectForKey:@"inMinute"] integerValue];
        self.outMinute = [[dicFromJson objectForKey:@"outMinute"] integerValue];
        self.distance = [[dicFromJson objectForKey:@"distance"] integerValue];
        self.longitude = [[dicFromJson objectForKey:@"longitude"] doubleValue];
        self.latitude = [[dicFromJson objectForKey:@"latitude"] doubleValue];
    }return self;
}

-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicForJson = [NSMutableDictionary dictionaryWithDictionary:[super getDicJsonForAllJsonDataType]];
    [dicForJson setObject:[NSNumber numberWithInteger:self.organizationId] forKey:@"organizationId"];
    [dicForJson setObject:[NSNumber numberWithInteger:self.orgunitId] forKey:@"orgunitId"];
    [dicForJson setObject:[NSNumber numberWithInteger:self.inMinute] forKey:@"inMinute"];
    [dicForJson setObject:[NSNumber numberWithInteger:self.outMinute] forKey:@"outMinute"];
    [dicForJson setObject:[NSNumber numberWithInteger:self.distance] forKey:@"distance"];
    [dicForJson setObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    [dicForJson setObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    return dicForJson;
}

@end
