//
//  WDataService.m
//  HbGitom_Ljw
//
//  Created by linjiawei on 13-6-16.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//

#import "WDataService.h"
#import "ASIFormDataRequest.h"

@implementation WDataService
SINGLETON_FOR_CLASS_Implementation(WDataService)
#pragma mark ----
- (id)init
{
    if (self = [super init]) {
        _timeOutSeconds = 10;
        _persistentConnectionTimeoutSeconds = 30;
    }
    return self;
}

#pragma mark --网络类型判断--
/*
 NotReachable:没有网络
 ReachableViaWWAN:城域网
 ReachableViaWiFi:wifi网络
 */
-(NetworkStatus)wGetNetworkStatusType
{
    NetworkStatus netStatus = NotReachable;
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    netStatus = [reachability currentReachabilityStatus];
    return netStatus;
}
#pragma mark --POST提交请求数据--
#pragma mark post返回NSString
-(void)wPostRequestWithIsAsynchronous:(BOOL)isAsynchronous
                                  Url:(NSURL *)url
                         DicPostDatas:(NSDictionary *)dicPostDatas
                            GotResult:(void(^)(NSString * strRespose,NSError * errorRequest))callBack
{
    NSLog(@"WDataService 使用 POST 进行数据请求 ，返回NSData!!");
    __weak ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];//设置请求方法为POST
    
    if (self.timeOutSeconds!=0)
        [request setTimeOutSeconds:self.timeOutSeconds];//设置超时时间
    [request setShouldAttemptPersistentConnection:YES];//设置持久连接
    if (self.persistentConnectionTimeoutSeconds !=0)
        [request setPersistentConnectionTimeoutSeconds:self.persistentConnectionTimeoutSeconds];//设置持久连接超时时间
    //设置参数
    for (NSString * postParam in [dicPostDatas allKeys])
    {
        NSString * postValue = [dicPostDatas objectForKey:postParam];
        [request setPostValue:postValue forKey:postParam];
    }
    //设置请求完成或者失败
    [request setCompletionBlock:^{
        callBack([request responseString],Nil);
    }];
    [request setFailedBlock:^{
        callBack(Nil,[request error]);
    }];
    NSLog(@"tototototototo");
    //同步或者异步请求
    if (isAsynchronous)
        [request startAsynchronous];
    else
        [request startSynchronous];
    NSLog(@"WDataService request == %@",request);
}
/*
 isAsynchronous是否异步
 url请求的url地址
 dicPostParam请求的参数字典
 dataRespose请求得到的数据
 myError请求可能出现的错误
 注:如果myError!=nil,那么就有dataRespose数据。
 */
#pragma mark post返回NSData
-(void)wPostRequestWithIsAsynchronous:(BOOL)isAsynchronous
                                  Url:(NSURL *)url
                         DicPostDatas:(NSDictionary *)dicPostDatas
                            GetResult:(void(^)(NSData * dataResponse,NSError * errorRequest))callBack
{
    //NSLog(@"WDataService 使用 POST 进行数据请求 返回NSData!!");
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];//设置请求方法为POST
    
    if (self.timeOutSeconds!=0)
        [request setTimeOutSeconds:self.timeOutSeconds];//设置超时时间
    [request setShouldAttemptPersistentConnection:YES];//设置持久连接
    if (self.persistentConnectionTimeoutSeconds !=0)
        [request setPersistentConnectionTimeoutSeconds:self.persistentConnectionTimeoutSeconds];//设置持久连接超时时间
    //设置参数
    for (NSString * postParam in [dicPostDatas allKeys])
    {
        NSString * postValue = [dicPostDatas objectForKey:postParam];
        [request setPostValue:postValue forKey:postParam];
    }
    //设置请求完成或者失败
    [request setCompletionBlock:^{
        callBack([request responseData],Nil);
    }];
    [request setFailedBlock:^{
        callBack(Nil,[request error]);
    }];
    //同步或者异步请求
    if (isAsynchronous)
        [request startAsynchronous];
    else
        [request startSynchronous];
    NSLog(@"WDataService  通过POST获得的数据内容 == %@ NSData ",request);
}


@end
