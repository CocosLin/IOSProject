//
//  WJsonModelProtocol.h
//  GitomHB
//
//  Created by jiawei on 13-6-21.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WJsonModelProtocol <NSObject>
@optional//选择实现的方法
//用dicJson生成model
- (id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson;
//得到dicJson
- (NSDictionary *)getDicJsonForAllJsonDataType;

//- (id)initForIncludeModelTypeWithDicFromJson:(NSDictionary *)dicFromJson;
//- (NSDictionary *)getDicJsonForIncludeModelType;
@end
