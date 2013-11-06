//
//  ServerBaseModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//


//服务器返回的默认数据
#import "WBaseModel.h"

@interface ServerBaseModel : WBaseModel
@property(retain,nonatomic)NSDictionary * body;
@property(retain,nonatomic)NSDictionary * head;
@end

@interface Body : WBaseModel
@property(copy,nonatomic)NSString * data;
@property(copy,nonatomic)NSString * note;
@property(copy,nonatomic)NSString * warning;
@property(assign,nonatomic)BOOL success;
@end

@interface Head : WBaseModel
@property(copy,nonatomic)NSString * cause;
@property(copy,nonatomic)NSString * version;
@property(assign,nonatomic)BOOL success;
@end

