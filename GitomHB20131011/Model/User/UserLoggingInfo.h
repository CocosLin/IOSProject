//
//  UserLoggingInfo.h
//  GitomHB
//
//  Created by linjiawei on 13-6-17.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBaseModel.h"
@interface UserLoggingInfo : NSObject<WBaseModelProtocol>
@property(nonatomic,copy)NSString * username;
@property(nonatomic,copy)NSString * password;
@property(nonatomic,assign)BOOL isAutoLogin;
@property(nonatomic,assign)BOOL isRememberPassword;

@end
