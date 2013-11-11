//
//  ReportModel.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ReportModel.h"

@implementation ReportModel
//-(id)initForCurrentUserInfoAndWithFlagTypeReport:(NSInteger)flagTypeReport
//                                         Longitude:(double)longitude
//                                          Latitude:(double)latitude
//                                           Address:(NSString *)address
//                                              Note:(NSString *)note
//                                          ImageUrl:(NSString *)imageUrl
//                                          SoundUrl:(NSString *)soundUrl
//{
//    if (self = [super init]) {
//        GetCommonDataModel;
//        self.organizationId = comData.organization.organizationId;
//        self.orgunitId = comData.organization.orgunitId;
//        self.longitude = longitude;
//        self.latitude = latitude;
//        self.address = address;
//        self.note = note;
//        self.imageUrl = imageUrl;
//        self.soundUrl = soundUrl;
//        self.voidFlag = YES;
//    }
//    return self;
//}

-(id)initForAllJsonDataTypeWithDicFromJson:(NSDictionary *)dicFromJson
{
    if (self = [super initForAllJsonDataTypeWithDicFromJson:dicFromJson])
    {
        self.organizationId = [[dicFromJson objectForKey:@"organizationId"] integerValue];
        self.orgunitId = [[dicFromJson objectForKey:@"orgunitId"] integerValue];
        self.reportId = [dicFromJson objectForKey:@"reportId"];
        self.note = [dicFromJson objectForKey:@"note"];
        self.longitude = [[dicFromJson objectForKey:@"longitude"] doubleValue];
        self.latitude = [[dicFromJson objectForKey:@"latitude"] doubleValue];
        self.address = [dicFromJson objectForKey:@"address"];
        self.imageUrl = [dicFromJson objectForKey:@"imageUrl"];
        self.soundUrl = [dicFromJson objectForKey:@"soundUrl"];
        self.reportType = [dicFromJson objectForKey:@"reportType"];
        self.voidFlag = [[dicFromJson objectForKey:@"voidFlag"] integerValue];
//        self.createDate = [[dicFromJson objectForKey:@"createDate"] longLongValue];
//        self.createUserId = [dicFromJson objectForKey:@"createUserId"];
//        self.updateDate = [[dicFromJson objectForKey:@"updateDate"] longLongValue];
//        self.updateUserId = [dicFromJson objectForKey:@"updateUserId"];

    }return self;
}
-(NSDictionary *)getDicJsonForAllJsonDataType
{
    NSMutableDictionary * dicForModel = [NSMutableDictionary dictionaryWithDictionary:[super getDicJsonForAllJsonDataType]];
    [dicForModel setObject:[NSNumber numberWithInteger:self.organizationId]  forKey:@"organizationId"];
    [dicForModel setObject:[NSNumber numberWithInteger:self.orgunitId]  forKey:@"orgunitId"];
    [dicForModel setObject:[NSNumber numberWithLongLong:self.reportId] forKey:@"reportId"];
    if (self.note) [dicForModel setObject:self.note forKey:@"note"];
    [dicForModel setObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    [dicForModel setObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    if (self.address)[dicForModel setObject:self.address forKey:@"address"];
    if (self.imageUrl)[dicForModel setObject:self.imageUrl forKey:@"imageUrl"];
    if (self.soundUrl)[dicForModel setObject:self.soundUrl forKey:@"soundUrl"];
    if (self.reportType)[dicForModel setObject:self.reportType forKey:@"reportType"];
    [dicForModel setObject:[NSNumber numberWithInt:self.voidFlag] forKey:@"voidFlag"];
    return dicForModel;
}
@end
