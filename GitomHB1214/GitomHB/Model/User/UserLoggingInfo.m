//
//  UserLoggingInfo.m
//  GitomHB
//
//  Created by linjiawei on 13-6-17.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "UserLoggingInfo.h"

@implementation UserLoggingInfo


-(id)initWithDicFromDB:(NSDictionary *)dicFromDB
{
    if (self = [super init]) {
        self.isAutoLogin = NO;
        self.isRememberPassword = NO;
        self.username = [dicFromDB objectForKey:@"username"];
        self.password = [dicFromDB objectForKey:@"password"];
        self.isAutoLogin = [[dicFromDB objectForKey:@"isAutoLogin"] boolValue];
        self.isRememberPassword = [[dicFromDB objectForKey:@"isRememberPassword"] boolValue];
    }return self;
}
-(NSDictionary *)getDicDBForModel
{
    NSMutableDictionary * dicForDB = [NSMutableDictionary dictionaryWithCapacity:4];
    if (self.username) [dicForDB setObject:self.username forKey:@"username"];
     if (self.password) [dicForDB setObject:self.password forKey:@"password"];
    [dicForDB setObject:[NSNumber numberWithBool:self.isAutoLogin] forKey:@"isAutoLogin"];
    [dicForDB setObject:[NSNumber numberWithBool:self.isRememberPassword] forKey:@"isRememberPassword"];
    return dicForDB;
}

-(NSArray *)getPrimaryKeyNames
{
    return @[@"username"];
}

@end
