//
//  GitomSingal.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-28.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "GitomSingal.h"
static GitomSingal *man = nil;
@implementation GitomSingal
+(id) getInstance{
 	    @synchronized(self){
        if (man == nil) {
            man = [[self alloc] init] ;
                }
        }
        return man;
    }

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (man == nil) {
            man = [super allocWithZone:zone];
            return man;
            }
        }
    return nil;
    }
@end
