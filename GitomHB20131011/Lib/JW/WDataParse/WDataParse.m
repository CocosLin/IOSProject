//
//  WDataParse.m
//  HbGitom_Ljw
//
//  Created by jiawei on 13-6-15.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//

#import "WDataParse.h"

@interface WDataParse ()

@end

@implementation WDataParse

SINGLETON_FOR_CLASS_Implementation(WDataParse)

#pragma mark --MD5加密--
-(NSString *)wMd5HexDigest:(NSString *)strData
{
    const char * original_str = [strData UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
#pragma mark --JSON序列化--
-(NSString *)jsonSerializationToStringWithJsonObject:(id)jsonObject
{
    if (![NSJSONSerialization  isValidJSONObject:jsonObject])
    {
        NSLog(@"\n+++Custom_Mark: %s, %dLine+++",__PRETTY_FUNCTION__, __LINE__);
        NSLog(@"\nJson格式不对,不能被解析:\n%@",jsonObject);
        return nil;
    }
    NSError * error = nil;
    NSData * dataFromDicJson = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                               options:kNilOptions
                                                                 error:&error];
    if (error)
    {
        NSLog(@"\n+++Custom_Mark: %s, %dLine+++",__PRETTY_FUNCTION__, __LINE__);
        NSLog(@"\nJson序列化出错:\n%@",jsonObject);
        return nil;
    }
    NSString * strJson = [[[NSString alloc]initWithData:dataFromDicJson
                                               encoding:NSUTF8StringEncoding] autorelease];
    return strJson;
}
/*
 把json对象(dic/arr)转化为json
 */
-(NSString *)wGetStrJsonWithJsonObj:(id)jsonObj
{
    
    if (![NSJSONSerialization  isValidJSONObject:jsonObj])
    {
        NSLog(@"\n+++Custom_Mark: %s, %dLine+++",__PRETTY_FUNCTION__, __LINE__);
        NSLog(@"\nJson格式不对,不能被解析:\n%@",jsonObj);
        return nil;
    } 
    NSError * error = nil;
    NSData * dataFromDicJson = [NSJSONSerialization dataWithJSONObject:jsonObj
                                                               options:kNilOptions
                                                                 error:&error];
    if (error)
    {
        NSLog(@"\n+++Custom_Mark: %s, %dLine+++",__PRETTY_FUNCTION__, __LINE__);
        NSLog(@"\nJson序列化出错:\n%@",jsonObj);
        return nil;
    }
    NSString * strJson = [[[NSString alloc]initWithData:dataFromDicJson
                                               encoding:NSUTF8StringEncoding] autorelease];
    return strJson;
}
#pragma mark --JSON解析--
/*
 *Json解析工厂
 *return:可能类型:NSDictionary、NSArray *strJson:要解析的json对象
 *wDataParseType:要解析的类型
 */
-(id)wGetJsonObjWithWDataParseType:(WDataParseType)wDataParseType
                        StringJson:(NSString *)strJson
{
    switch (wDataParseType)
    {
        case WDataParseType_NSDictionary:
        {
            return [self wGetDicJsonWithStringJson:strJson];
            break;
        }
        case WDataParseType_NSArray:
        {
            return [self wGetArrJsonWithStringJson:strJson];
            break;
        }
        default:
        {
            return [self wGetDicJsonWithStringJson:strJson];
            break;
        }
    }
    return nil;
}


//解析json为dic
-(NSDictionary *)wGetDicJsonWithStringJson:(NSString *)strJson
{
    NSError * error = nil;
    NSData * dataJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];//转成nsdata
    NSDictionary  * dicFromParseJson = [NSJSONSerialization JSONObjectWithData:dataJson
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&error];
    if (error)
    {
        NSLog(@"\n+++Custom_Mark: %s, %dLine+++",__PRETTY_FUNCTION__, __LINE__);
        NSLog(@"\n%@",[error localizedDescription]);
    }
    return dicFromParseJson;
}
//解析json为arr
-(NSArray *)wGetArrJsonWithStringJson:(NSString *)strJson
{
    NSError * error = nil;
    NSData * dataJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];//转成nsdata
    NSArray  * arrFromParseJson = [NSJSONSerialization JSONObjectWithData:dataJson
                                                                  options:NSJSONReadingMutableLeaves
                                                                    error:&error];
    if (error)
    {
        NSLog(@"\n+++Custom_Mark: %s, %dLine+++",__PRETTY_FUNCTION__, __LINE__);
        NSLog(@"\n%@",[error localizedDescription]);
    }
    return arrFromParseJson;
}

////解析json数据到字典
//-(void)JsonParseToDicWithStrJson:(NSString *)strJson
//                       GotResult:(void(^)(NSDictionary * dicFromStrJson,NSError * error))callback;
//{
//    NSLog(@"strJson:\n%@",strJson);
//    NSError * error = nil;
//    NSData * dataJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary  * dicForParseJson = [NSJSONSerialization JSONObjectWithData:dataJson
//                                                                      options:kNilOptions
//                                                                        error:&error];
//    callback(dicForParseJson,error);
//}
////解析json数据到字典
//-(NSDictionary *)JsonParseToDicWithStrJson:(NSString *)strJson
//{
//    NSLog(@"strJson:\n%@",strJson);
//    NSError * error = nil;
//    //转成nsdata
//    NSData * dataJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];
//    //解析最外层为dic
//    NSDictionary  * dicForParseJsonTemp = [NSJSONSerialization JSONObjectWithData:dataJson
//                                                                      options:kNilOptions
//                                                                        error:&error];
//    /*理解错了，json解析不止解析最外层的，里面的也解析了！！！！！
//    //保存最外层dic
//    NSMutableDictionary * dicForParseJson = [NSMutableDictionary dictionaryWithDictionary:dicForParseJsonTemp];
//    //得到最外层所有的key
//    NSArray * arrStrAllkeys = [dicForParseJson allKeys];
//    for (NSString * strKey in arrStrAllkeys)
//    {
//        id valueForKey = [dicForParseJson objectForKey:strKey];
//        //找到里层数组
//        if ([valueForKey isKindOfClass:[NSArray class]])
//        {
//            NSArray * arrValue = (NSArray *)valueForKey;
//            //定义改变后要保存的数组
//            NSMutableArray * arrForParseJsonFormSecondLevel = [NSMutableArray arrayWithCapacity:arrValue.count];
//            for (int i = 0; i<[arrValue count]; i++)
//            {
//                //把数组里面的元素解析成dic,保存到新数组里面
//                NSDictionary * dicFromArrValue = [self JsonParseToDicWithStrJson:[arrValue objectAtIndex:i]];
//                [arrForParseJsonFormSecondLevel addObject:dicFromArrValue];
//            }
//            //设置新数组
//            [dicForParseJson setObject:arrForParseJsonFormSecondLevel forKey:strKey];
//        }
//    }
//    if (error) return nil;
//    return dicForParseJson;
//     */
//    return dicForParseJsonTemp;
//}







@end
