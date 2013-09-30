//
//  LoginStatueSingal.m
//  GitomAPP
//
//  Created by jiawei on 13-7-15.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "LoginStatueSingal.h"
static LoginStatueSingal *logStatue = nil;
@implementation LoginStatueSingal

+ (id)shareLogStatu
{
    @synchronized(self){
        if(logStatue == nil){
            logStatue = [[self alloc] init] ;
        }
    }
    return logStatue;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (logStatue == nil) {
            logStatue = [super allocWithZone:zone];
            return  logStatue;
        }
    }
    return nil;
}


@end
