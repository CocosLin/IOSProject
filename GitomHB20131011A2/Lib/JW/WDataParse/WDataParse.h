//
//  WDataParse.h
//  HbGitom_Ljw
//
//  Created by jiawei on 13-6-15.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "WCommonMacroDefine.h"
//解析类型枚举
typedef NS_ENUM(NSInteger, WDataParseType)
{
    WDataParseType_NSDictionary = 0,
    WDataParseType_NSArray= 1,
};
@interface WDataParse : NSObject
SINGLETON_FOR_CLASS_Interface(WDataParse);

#pragma mark --MD5加密--
-(NSString *) wMd5HexDigest:(NSString *)strData;
#pragma mark --JSON序列化--

/*
   把json对象(dic/arr)转化为json
 */
-(NSString *)wGetStrJsonWithJsonObj:(id)jsonObj;
#pragma mark --JSON解析--
/*
 *Json解析工厂
 *return:可能类型:NSDictionary、NSArray *strJson:要解析的json对象
 *wDataParseType:要解析的类型
 */
-(id)wGetJsonObjWithWDataParseType:(WDataParseType)wDataParseType
                      StringJson:(NSString *)strJson;

//解析json为dic
-(NSDictionary *)wGetDicJsonWithStringJson:(NSString *)strJson;

//解析json为arr
-(NSArray *)wGetArrJsonWithStringJson:(NSString *)strJson;

@end
