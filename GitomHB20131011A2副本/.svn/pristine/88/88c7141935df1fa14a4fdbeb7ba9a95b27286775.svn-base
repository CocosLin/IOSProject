//
//  WError.h
//  HbGitom_Ljw
//
//  Created by jiawei on 13-6-15.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//

#import <Foundation/Foundation.h>
//错误类型枚举
typedef NS_ENUM(NSInteger, WErrorType)
{
    WErrorType_NetworkRequests = -1,//网络请求错误
    WErrorType_Parse = -2,//解析错误
    WErrorType_Logic = -3,//逻辑错误
     WErrorType_Database = -4,//数据库错误
};

@interface WError : NSObject

#pragma mark ---错误类型---

@property(nonatomic,assign)WErrorType wErrorType;//错误类型
@property(nonatomic,copy)NSString * wErrorCode;//错误代码
@property(nonatomic,copy)NSString * wErrorDescription;//错误描述与建议
@property(nonatomic,retain)NSError * wErrorIOS;//IOS自带错误NSError

#pragma mark --初始化方法--
- (id)initWithWErrorType:(WErrorType)wErrorType
       wErrorDescription:(NSString *)wErrorDescription;

- (id)initWithWErrorType:(WErrorType)wErrorType;

- (id)initWithWErrorDescription:(NSString *)wErrorDescription;
@end

