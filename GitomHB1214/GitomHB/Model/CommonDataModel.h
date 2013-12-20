//
//  CommonDataModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "UserLoggedInfo.h"
#import "UserLoggingInfo.h"

@interface CommonDataModel : NSObject

@property (assign, nonatomic) BOOL isLogged;//是不是登录了
@property (strong, nonatomic) UserModel * userModel;//用户信息
@property (nonatomic, strong) UserLoggingInfo *userlogingInfo;//记录用户密码、名称
@property (assign, nonatomic) long long int serverDate;//服务器时间
@property (nonatomic, strong) NSArray *verifyMethodArr;//验证方式的

@property (strong, nonatomic) Organization * organization;
@property (copy, nonatomic) NSString * cookie;


@property (strong, nonatomic) NSArray * arrDicWorkTime;
@property (strong, nonatomic) NSDictionary * dicAttenConfig;

@end
