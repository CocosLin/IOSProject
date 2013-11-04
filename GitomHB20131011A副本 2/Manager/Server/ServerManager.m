//
//  ServerManager.m
//  GitomNetLjw
//
//  Created by linjiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ServerManager.h"

@implementation ServerManager
SINGLETON_FOR_CLASS_Implementation(ServerManager)
- (id)init
{
    self = [super init];
    if (self) {
        self.strBaseUrl = @"http://59.57.15.168:6363";
        
        
    }
    return self;
}
@end
