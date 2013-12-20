//
//  WDataBaseModelProtocol.h
//  GitomHB
//
//  Created by jiawei on 13-6-21.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WDataBaseModelProtocol <NSObject>
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
