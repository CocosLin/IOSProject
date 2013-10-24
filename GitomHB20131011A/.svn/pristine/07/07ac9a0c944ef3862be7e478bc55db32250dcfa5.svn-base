//
//  ServerBaseModel.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ServerBaseModel.h"

@implementation ServerBaseModel
- (void)dealloc
{
    [_body release];
    [_head release];
    [super dealloc];
}
-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson]) {
        self.body = [dicFromJson objectForKey:@"body"];
        self.head = [dicFromJson objectForKey:@"head"];
    }return self;
}

-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicForJson = [NSMutableDictionary dictionaryWithCapacity:2];
    if (self.body) [dicForJson setObject:self.body forKey:@"body"];        
    if (self.head) [dicForJson setObject:self.head forKey:@"head"];
    return dicForJson;
}
@end

@implementation Body

-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    /*
     @property(retain,nonatomic)NSDictionary * data;
     @property(copy,nonatomic)NSString * note;
     @property(copy,nonatomic)NSString * warning;
     @property(assign,nonatomic)BOOL success;
     */
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson]) {
        self.data = [dicFromJson objectForKey:@"data"];
        self.note = [dicFromJson objectForKey:@"note"];
        self.warning = [dicFromJson objectForKey:@"warning"];
        self.success = [[dicFromJson objectForKey:@"success"] boolValue];
    }return self;
}
-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicForJson = [NSMutableDictionary dictionaryWithCapacity:2];
    if (self.data) [dicForJson setObject:self.data forKey:@"data"];
    if (self.note) [dicForJson setObject:self.note forKey:@"note"];
    if (self.warning) [dicForJson setObject:self.warning forKey:@"warning"];
    [dicForJson setObject:[NSNumber numberWithBool:self.success] forKey:@"success"];
    return dicForJson;
}
- (void)dealloc
{
    [_data release];
    [_note release];
    [_warning release];
    [super dealloc];
}
@end

@implementation Head

-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson]) {
        self.version = [dicFromJson objectForKey:@"version"];
        self.cause = [dicFromJson objectForKey:@"cause"];
        self.success = [[dicFromJson objectForKey:@"success"] boolValue];
    }return self;
}
-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicForJson = [NSMutableDictionary dictionaryWithCapacity:2];
    if (self.version) [dicForJson setObject:self.version forKey:@"version"];
    if (self.cause) [dicForJson setObject:self.cause forKey:@"cause"];
    [dicForJson setObject:[NSNumber numberWithBool:self.success] forKey:@"success"];
    return dicForJson;
}
- (void)dealloc
{
    [_version release];
    [_cause release];
    [super dealloc];
}
@end
