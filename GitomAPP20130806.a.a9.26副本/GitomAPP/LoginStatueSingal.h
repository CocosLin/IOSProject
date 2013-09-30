//
//  LoginStatueSingal.h
//  GitomAPP
//
//  Created by jiawei on 13-7-15.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <Foundation/Foundation.h>
//-----------------------------------单例
//用于记录用户的登入状态
@interface LoginStatueSingal : NSObject

@property (strong, nonatomic)NSMutableArray *saveCustomIfoAr;//存放对应功能按钮（设计网站、文章管理、应用商店等等）信息的数组
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userNumber;
@property (strong, nonatomic) NSData *userImgData;//用户头像数据
@property (strong, nonatomic) NSString *casUrl;//全局登入网页
@property (strong, nonatomic) NSData *customUrlData;//应用按钮对应的网络数据

//以下属性用来标记是否登入。1表示登入、2表示退出
@property (assign, nonatomic) int logStatu;//判断用户是否登入
@property (assign, nonatomic) int showLogStatu;//切换ChoosView头部的状态
@property (assign, nonatomic) int shiftStatu;//切换用户时候要用到的判断符号
@property (assign, nonatomic) int exitAccountStatu;//切换帐号时候是否退出帐号的标记(全局退出标记 2)
@property (assign, nonatomic) int loginViewFlag;//未登入时候弹出登入界面，登入标记 1

+ (id) shareLogStatu;

@end
