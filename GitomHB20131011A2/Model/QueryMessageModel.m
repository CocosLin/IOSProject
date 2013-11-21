//
//  QueryMessageModel.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-21.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "QueryMessageModel.h"

@implementation QueryMessageModel

- (void)dealloc{
    [_dtx release];
    [_readUser release];
    [_senderReadname release];
    [_username release];
    [super dealloc];
}

@end
