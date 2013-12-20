//
//  BaseDataBean.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "WBaseModel.h"

@interface BaseDataBean : WBaseModel
@property(assign,nonatomic)long long int createDate;//创建时间
@property(nonatomic,copy)NSString * createUserId;//创建者
@property(assign,nonatomic)long long int updateDate;//更新时间
@property(nonatomic,copy)NSString * updateUserId;//更新者
@end
