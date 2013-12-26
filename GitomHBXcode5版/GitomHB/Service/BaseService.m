//
//  BaseService.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService
- (id)init
{
    self = [super init];
    if (self) {
//        _strBaseUrl = @"http://59.57.15.168:6363";
    }
    return self;
}
-(NSString *)strBaseUrl
{
//    return @"http://59.57.15.168:6363";
    return @"http://hb.m.gitom.com/3.0";
//    return @"http://192.168.100.115:9292";
}
@end
