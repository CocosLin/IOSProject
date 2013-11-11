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
@interface CommonDataModel : NSObject

@property(assign,nonatomic)BOOL isLogged;//是不是登录了
@property(retain,nonatomic)UserModel * userModel;//用户信息

@property(assign,nonatomic)long long int serverDate;//服务器时间

@property(retain,nonatomic)Organization * organization;
@property(copy,nonatomic)NSString * cookie;


@property(retain,nonatomic)NSArray * arrDicWorkTime;
@property(retain,nonatomic)NSDictionary * dicAttenConfig;


@end