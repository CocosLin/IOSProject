//
//  UserRoleModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "WBaseModel.h"
//用户权限
typedef NS_ENUM(NSInteger, RoleId)
{
    RoleId_Creator = 1,
    RoleId_Administrator = 2,
    RoleId_Common = 4
};
@interface UserRoleModel : WBaseModel
@property()NSInteger organizationId;//公司ID
@property()RoleId roleId;//权限ID
@property(copy)NSString * name;
@property(copy)NSString * description;

@end
