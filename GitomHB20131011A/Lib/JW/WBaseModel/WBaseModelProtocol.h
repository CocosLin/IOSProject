//
//  WBaseModelProtocol.h
//  HbGitom_Ljw
//
//  Created by jiawei on 13-6-17.
//  Copyright (c) 2013年 linjiawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJsonModelProtocol.h"
#import "WDataBaseModelProtocol.h"

@protocol WJsonModelProtocol;
@protocol WDataBaseModelProtocol;
@protocol WBaseModelProtocol <NSObject,WJsonModelProtocol,WDataBaseModelProtocol>
#pragma mark --得到model的属性字符串列表--
@optional//选择实现的方法
-(NSArray *)getArrStrPropertyList;
#pragma mark --dicFromJson与model--
@optional//选择实现的方法
//用dicJson生成model
- (id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson;
//得到dicJson
- (NSDictionary *)getDicJsonForAllJsonDataType;

#pragma mark --dicFromDB与model--
@optional//选择实现的方法
//把对象转为dicDB
- (NSDictionary *)getDicDBForModel;
//用dicDB生成对象
- (id)initWithDicFromDB:(NSDictionary *)dicFromDB;
//得到主键
-(NSArray *)getPrimaryKeyNames;
//得到属性对应的数据库类型
-(NSDictionary *)getDicDbTypesForModel;


@end
