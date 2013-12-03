//
//  UserModel.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

#pragma mark --数据库与字典操作--
-(id)initWithDicFromDB:(NSDictionary *)dicFromDB
{
    if (self = [super initWithDicFromDB:dicFromDB])
    {
        if (dicFromDB==nil || dicFromDB.count==0) return self;
        self.username = [dicFromDB objectForKey:@"username"];
        self.password = [dicFromDB objectForKey:@"password"];
        self.realname = [dicFromDB objectForKey:@"realname"];
        self.telephone = [dicFromDB objectForKey:@"telephone"];
        self.cellphone = [dicFromDB objectForKey:@"cellphone"];
        self.address = [dicFromDB objectForKey:@"address"];
        self.photo = [dicFromDB objectForKey:@"photo"];
        self.hobby = [dicFromDB objectForKey:@"hobby"];
    }return self;
}
-(NSDictionary *)getDicDBForModel
{
    NSMutableDictionary * dicDBForModel = [NSMutableDictionary dictionaryWithDictionary:[super getDicDBForModel]];
    if (self.username) [dicDBForModel setObject:self.username forKey:@"username"];
    if (self.password) [dicDBForModel setObject:self.password forKey:@"password"];
    if (self.realname) [dicDBForModel setObject:self.realname forKey:@"realname"];
    if (self.telephone) [dicDBForModel setObject:self.telephone forKey:@"telephone"];
    if (self.cellphone) [dicDBForModel setObject:self.cellphone forKey:@"cellphone"];
    if (self.address) [dicDBForModel setObject:self.address forKey:@"address"];
    if (self.photo) [dicDBForModel setObject:self.photo forKey:@"photo"];
    if (self.hobby) [dicDBForModel setObject:self.hobby forKey:@"hobby"];
    return dicDBForModel;
}
-(NSArray *)getPrimaryKeyNames
{
    return @[@"username"];
}

#pragma mark --json--

-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson]) {
        if (dicFromJson==nil || dicFromJson.count==0) return self;
        self.username = [dicFromJson objectForKey:@"username"];
        self.password = [dicFromJson objectForKey:@"password"];
        self.realname = [dicFromJson objectForKey:@"realname"];
        self.telephone = [dicFromJson objectForKey:@"telephone"];
        self.cellphone = [dicFromJson objectForKey:@"cellphone"];
        self.address = [dicFromJson objectForKey:@"address"];
        self.photo = [dicFromJson objectForKey:@"photo"];
        self.hobby = [dicFromJson objectForKey:@"hobby"];
    }return self;
}

-(NSDictionary *)getDicJsonForAllJsonDataType
{
    return [self getDicDBForModel];
}
@end
