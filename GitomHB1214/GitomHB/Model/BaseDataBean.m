//
//  BaseDataBean.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "BaseDataBean.h"

@implementation BaseDataBean
- (id)init
{
    self = [super init];
    if (self) {
        self.createDate = 0;
        self.updateDate = 0;
    }
    return self;
}
+(NSArray *)getArrayPrimaryKey
{
    return nil;
}

-(id)initWithDicFromDB:(NSDictionary *)dicFromDB
{
    if (self = [super init]) {
        if (dicFromDB) {
            self.createDate = [[dicFromDB objectForKey:@"createDate"] longLongValue];
            self.createUserId = [dicFromDB objectForKey:@"createUserId"];
            self.updateDate = [[dicFromDB objectForKey:@"updateDate"] longLongValue];
            self.updateUserId = [dicFromDB objectForKey:@"updateUserId"];
        }
    }return self;
}
-(NSDictionary *)getDicDBForModel
{
    NSMutableDictionary * dicForModel = [NSMutableDictionary dictionaryWithCapacity:4];
    [dicForModel setObject:[NSNumber numberWithLongLong:self.createDate] forKey:@"createDate"];
    if (self.createUserId) [dicForModel setObject:self.createUserId forKey:@"createUserId"];
    [dicForModel setObject:[NSNumber numberWithLongLong:self.updateDate] forKey:@"updateDate"];
    if (self.updateUserId) [dicForModel setObject:self.updateUserId forKey:@"updateUserId"];
    return dicForModel;
}
-(NSArray *)getPrimaryKeyNames
{
    return nil;
}
//-(NSDictionary *)getDicDbTypesForModel
//{
//    NSMutableDictionary * dicForModel = [NSMutableDictionary dictionaryWithCapacity:4];
//    [dicForModel setObject:[NSNumber numberWithLongLong:self.createDate] forKey:@"createDate"];
//    if (self.createUserId) [dicForModel setObject:self.createUserId forKey:@"createUserId"];
//    [dicForModel setObject:[NSNumber numberWithLongLong:self.updateDate] forKey:@"updateDate"];
//    if (self.updateUserId) [dicForModel setObject:self.updateUserId forKey:@"updateUserId"];
//    return dicForModel;
//}
#pragma mark --json--
-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    if (self = [super init]) {
        if (dicFromJson) {
            self.createDate = [[dicFromJson objectForKey:@"createDate"] longLongValue];
            self.createUserId = [dicFromJson objectForKey:@"createUserId"];
            self.updateDate = [[dicFromJson objectForKey:@"updateDate"] longLongValue];
            self.updateUserId = [dicFromJson objectForKey:@"updateUserId"];
        }
    }return self;
}
-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicForModel = [NSMutableDictionary dictionaryWithCapacity:4];
    [dicForModel setObject:[NSNumber numberWithLongLong:self.createDate] forKey:@"createDate"];
    if (self.createUserId) [dicForModel setObject:self.createUserId forKey:@"createUserId"];
    [dicForModel setObject:[NSNumber numberWithLongLong:self.updateDate] forKey:@"updateDate"];
    if (self.updateUserId) [dicForModel setObject:self.updateUserId forKey:@"updateUserId"];
    return dicForModel;
}
@end
