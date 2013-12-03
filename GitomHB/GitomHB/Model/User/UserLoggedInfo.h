//
//  UserLoggedInfo.h
//  GitomHB
//
//  Created by linjiawei on 13-6-17.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "WBaseModel.h"
@class UserModel;
#import "UserRoleModel.h"
@interface UserLoggedInfo : WBaseModel
@property(nonatomic,retain)NSArray * organizations;
@property(nonatomic,assign)long long int serverDate;
@property(nonatomic,retain)NSDictionary * user;
@property(nonatomic,copy)NSString * cookie;
@end

@interface Organization : WBaseModel
@property(nonatomic,assign)NSInteger appLevelCode;
@property(nonatomic,copy)NSString * creator;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,assign)NSInteger organizationId;
@property(nonatomic,assign)NSInteger orgunitId;
@property(nonatomic,assign)RoleId roleId;
@property(nonatomic,copy)NSString * operations;//公司主管权限
@property(nonatomic,copy) NSString *checkWay;//加入验证方式
@property(nonatomic,copy) NSString *question;
@property(nonatomic,copy) NSString *answers;
@end

@interface  UserPrivilege  : WBaseModel
@property(nonatomic,copy)NSString * operations;
@property(nonatomic,assign)RoleId roleId;
@end