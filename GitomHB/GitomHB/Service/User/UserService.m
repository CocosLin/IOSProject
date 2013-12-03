//
//  UserService.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "UserService.h"
#import "ServerManager.h"
#import "ServerBaseModel.h"
#define StrPortLogin @"http://hb.m.gitom.com/Login"
@implementation UserService
- (id)init
{
    self = [super init];
    if (self) {
                _strLoginPort = @"/util/login";
    }
    return self;
}
// http://hb.m.gitom.com/Login?username=1029&password=E10ADC3949BA59ABBE56E057F20F883E&version=400
@end
