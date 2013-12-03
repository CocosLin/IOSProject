//
//  UserLoggedInfo.m
//  GitomHB
//
//  Created by linjiawei on 13-6-17.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "UserLoggedInfo.h"


@implementation UserLoggedInfo
-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    /*@property(nonatomic,retain)NSArray * organizations;
     @property(nonatomic,assign)long long int serverDate;
     @property(nonatomic,retain)NSDictionary * user;
     */
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson]) {
        self.organizations = [dicFromJson objectForKey:@"organizations"];
        self.serverDate = [[dicFromJson objectForKey:@"serverDate"] longLongValue];
        self.user = [dicFromJson objectForKey:@"user"];//获得json接口中关键字为“user”的信息：包括用户的id、密码、头像的url、真实姓名、
         self.cookie = [dicFromJson objectForKey:@"cookie"];
    }return self;
}
-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicJsonForModel = [NSMutableDictionary dictionaryWithDictionary:[super getDicJsonForAllJsonDataType]];
    if (self.organizations) [dicJsonForModel setObject:self.organizations forKey:@"organizations"];
    if (self.user) [dicJsonForModel setObject:self.user forKey:@"user"];
    if (self.cookie) [dicJsonForModel setObject:self.cookie forKey:@"cookie"];
    [dicJsonForModel setObject:[NSNumber numberWithLongLong:self.serverDate] forKey:@"serverDate"];
    return dicJsonForModel;
}
- (void)dealloc
{
    [_organizations release];
    [_user release];
    [super dealloc];
}
@end


@implementation Organization
-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    /*
     @property(nonatomic,assign)NSInteger appLevelCode;
     @property(nonatomic,copy)NSString * creator;
     @property(nonatomic,copy)NSString * name;
     @property(nonatomic,assign)NSInteger organizationId;
     @property(nonatomic,assign)NSInteger orgunitId;
     @property(nonatomic,assign)RoleId roleId;
     @property(nonatomic,retain)NSArray * userPrivileges;
     */
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson]) {
        self.appLevelCode = [[dicFromJson objectForKey:@"appLevelCode"] integerValue];
        self.creator = [dicFromJson objectForKey:@"creator"];
        self.name = [dicFromJson objectForKey:@"name"];
        self.organizationId = [[dicFromJson objectForKey:@"organizationId"] integerValue];
        self.orgunitId = [[dicFromJson objectForKey:@"orgunitId"] integerValue];
        self.roleId = [[dicFromJson objectForKey:@"roleId"] integerValue];
        self.operations = [[[dicFromJson objectForKey:@"userPrivileges"]objectAtIndex:1]objectForKey:@"operations"];
    }return self;
}
-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicJsonForModel = [NSMutableDictionary dictionaryWithDictionary:[super getDicJsonForAllJsonDataType]];
   [dicJsonForModel setObject:[NSNumber numberWithInteger:self.appLevelCode] forKey:@"appLevelCode"];
     [dicJsonForModel setObject:[NSNumber numberWithInteger:self.organizationId] forKey:@"organizationId"];
     [dicJsonForModel setObject:[NSNumber numberWithInteger:self.orgunitId] forKey:@"orgunitId"];
     [dicJsonForModel setObject:[NSNumber numberWithInteger:self.roleId] forKey:@"roleId"];
    if (self.creator) [dicJsonForModel setObject:self.creator forKey:@"creator"];
    if (self.name) [dicJsonForModel setObject:self.name forKey:@"name"];

    return dicJsonForModel;
}
- (void)dealloc
{
    [_creator release];
    [_name release];
    //[_userPrivileges release];
    [super dealloc];
}
@end


@implementation UserPrivilege
-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    /*
     @property(nonatomic,copy)NSString * operations;
     @property(nonatomic,assign)NSInteger * roleId;
     */
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson]) {
        self.operations = [dicFromJson objectForKey:@"operations"];
        self.roleId = [[dicFromJson objectForKey:@"roleId"] integerValue];
    }return self;
}
-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicJsonForModel = [NSMutableDictionary dictionaryWithDictionary:[super getDicJsonForAllJsonDataType]];
    [dicJsonForModel setObject:[NSNumber numberWithInteger:self.roleId] forKey:@"roleId"];
    if (self.operations) [dicJsonForModel setObject:self.operations forKey:@"operations"];
    return dicJsonForModel;
}
- (void)dealloc
{
    [_operations release];
    [super dealloc];
}
@end
