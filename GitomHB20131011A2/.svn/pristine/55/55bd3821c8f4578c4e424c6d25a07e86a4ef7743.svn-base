//
//  UserManager.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

/*
 用户相关业务
 */


#import <Foundation/Foundation.h>
#import "WCommonMacroDefine.h"//常用宏
#import "UserLoggedInfo.h"
#import "UserLoggingInfo.h"
#import "UserService.h"
#import "HBServerKit.h"
#import "BaseManager.h"
@interface UserManager : BaseManager


//单例声明
SINGLETON_FOR_CLASS_Interface(UserManager);
#pragma mark - 得到用户头像
-(void)getUserPhotoImageWithStrUserPhotoUrl:(NSString *)strUserPhotoUrl
                                  GotResult:(void(^)(UIImage *imgUserPhoto, BOOL isOK))callback;
#pragma mark - 登录
//用户网络登录
typedef void(^WbLoggedInfo)(UserLoggedInfo * loggedInfo,BOOL isLoggedOk);
-(void)loggingWithLoggingInfo:(UserLoggingInfo *)loggingInfo
           WbLoggedInfo:(WbLoggedInfo)callback;

-(void)loggingWithUsername:(NSString *)username
             Md5PasswordUp:(NSString *)md5PassUp
               GotLoggedOk:(void(^)(BOOL isLoggedOk))callback;

@end
