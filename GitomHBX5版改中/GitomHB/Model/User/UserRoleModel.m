//
//  UserRoleModel.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "UserRoleModel.h"

@implementation UserRoleModel


-(id)initWithDicFromDB:(NSDictionary *)dicFromDB
{
    if (self = [super initWithDicFromDB:dicFromDB]) {
        self.organizationId = [[dicFromDB objectForKey:@"organizationId"] integerValue];
        self.roleId = [[dicFromDB objectForKey:@"roleId"] integerValue];
        self.name = [dicFromDB objectForKey:@"name"];
        self.description = [dicFromDB objectForKey:@"description"];
    }return self;
}

-(NSDictionary *)getDicDBForModel
{
    NSMutableDictionary * dicForModel = [NSMutableDictionary dictionaryWithDictionary:[super getDicDBForModel]];
    [dicForModel setObject:[NSNumber numberWithInteger:self.organizationId] forKey:@"organizationId"];
    [dicForModel setObject:[NSNumber numberWithInteger:self.roleId] forKey:@"roleId"];
    if (self.name)
        [dicForModel setObject:self.name forKey:@"name"];
    if (self.description)
        [dicForModel setObject:self.name forKey:@"description"];
    return dicForModel;
}
-(NSArray *)getPrimaryKeyNames
{
    return @[@"organizationId",@"roleId"];
}
@end
