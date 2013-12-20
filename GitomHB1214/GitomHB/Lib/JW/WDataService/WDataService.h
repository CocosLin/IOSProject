//
//  WDataService.h
//  HbGitom_Ljw
//
//  Created by linjiawei on 13-6-16.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import "WCommonMacroDefine.h"
@interface WDataService : NSObject
SINGLETON_FOR_CLASS_Interface(WDataService);
@property (assign) NSTimeInterval timeOutSeconds;//超时时间
@property (assign) NSTimeInterval persistentConnectionTimeoutSeconds;//持续连接时间

#pragma mark --网络类型判断--
/*
 NotReachable:没有网络
 ReachableViaWWAN:城域网
 ReachableViaWiFi:wifi网络
 */
-(NetworkStatus)wGetNetworkStatusType;


#pragma mark --POST提交请求数据--
/*
 isAsynchronous是否异步
 url请求的url地址
 dicPostParam请求的参数字典
 dataRespose请求得到的数据
 myError请求可能出现的错误
 注:如果myError!=nil,那么就有strRespose数据。
 */
typedef void(^ WblockRequestResultWithStrResposeAndError)(NSString * strRespose,NSError * errorRequest);
-(void)wPostRequestWithIsAsynchronous:(BOOL)isAsynchronous
                                  Url:(NSURL *)url
                         DicPostDatas:(NSDictionary *)dicPostDatas
                            GotResult:(WblockRequestResultWithStrResposeAndError)callBack;
/*
 isAsynchronous是否异步
 url请求的url地址
 dicPostParam请求的参数字典
 dataRespose请求得到的数据
 myError请求可能出现的错误
 注:如果myError!=nil,那么就有dataRespose数据。
 */
-(void)wPostRequestWithIsAsynchronous:(BOOL)isAsynchronous
                                  Url:(NSURL *)url
                         DicPostDatas:(NSDictionary *)dicPostDatas
                            GetResult:(void(^)(NSData * dataResponse,NSError * errorRequest))callBack;
#pragma mark --带解析的请求--

@end
