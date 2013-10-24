//
//  MenuVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "UserRoleModel.h"
@interface MenuVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)RoleId roleId;
@property(nonatomic,copy)NSString * username;
@property(nonatomic,copy)NSString * userRealname;
@property(nonatomic,assign)NSInteger * orgunitId;
@property(nonatomic,assign)NSInteger * organizationId;
@property(nonatomic,copy)NSString * organizationName;
@property(nonatomic,copy)NSString * userPhotoAddress;
-(id)initWithRoleId:(RoleId)roleId
         UsernameID:(NSString *)strUsernameId
       UserRealname:(NSString *)userRealname
   OrganizationName:(NSString *)organizationName;

-(id)initWithRoleId:(RoleId)roleId
          UserModel:(UserModel *)userModel
   OrganizationName:(NSString *)organizationName;
@end
