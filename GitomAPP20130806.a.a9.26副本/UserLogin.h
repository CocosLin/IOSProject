//
//  UserLogin.h
//  GitomAPP
//
//  Created by jiawei on 13-7-17.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLogin : NSObject

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) NSString *success;
@property (assign, nonatomic) NSString *result;

@end
