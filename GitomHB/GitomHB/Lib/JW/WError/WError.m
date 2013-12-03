//
//  WError.m
//  HbGitom_Ljw
//
//  Created by jiawei on 13-6-15.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//

#import "WError.h"

@implementation WError


#pragma mark --初始化方法--
- (id)initWithWErrorType:(WErrorType)wErrorType
       wErrorDescription:(NSString *)wErrorDescription
{
    if (self=[super init])
    {
        self.wErrorType = wErrorType;
        self.wErrorDescription = wErrorDescription;
    }
    return self;
}
- (id)initWithWErrorType:(WErrorType)wErrorType
{
    if (self=[super init])
    {
        self.wErrorType = wErrorType;
        switch (wErrorType)
        {
            case WErrorType_NetworkRequests:
            {
                self.wErrorDescription = @"网络请求出错,请检查网络后重试!";
                break;
            }
            case WErrorType_Parse:
            {
                self.wErrorDescription = @"解析出错,请检查解析信息!";
                break;
            }
            case WErrorType_Logic:
            {
                self.wErrorDescription = @"程序出错,请联系管理员!";
                break;
            }
            default:
                break;
        }
    }
    return self;
}
- (id)initWithWErrorDescription:(NSString *)wErrorDescription
{
    if (self=[super init])
    {
        self.wErrorDescription = wErrorDescription;
    }
    return self;
}
@end
