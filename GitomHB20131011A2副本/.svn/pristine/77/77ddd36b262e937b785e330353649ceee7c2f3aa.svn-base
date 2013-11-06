//
//  AttendanceManager.m
//  GitomNetLjw
//
//  Created by jiawei on 13-7-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "AttendanceManager.h"

@implementation AttendanceManager
SINGLETON_FOR_CLASS_Implementation(AttendanceManager)
//得到考勤配置(工作时间段，考勤距离，公司坐标等)
-(void)getAttendanceConfigWithOrganizationID:(NSInteger)organizationId
                                   OrgunitID:(NSInteger)orgunitID
                              GotAttenConfig:(void(^)(AttendanceConfigModel * attenConfig))callback
{
    
    [_serverKit getAttendanceConfigWithOrganizationID:organizationId
                                            OrgunitID:orgunitID
                                       GotAttenConfig:^(NSDictionary *dicAttenConfig)
    {
        if (dicAttenConfig&& dicAttenConfig.count!=0)
        {
            AttendanceConfigModel * attenConfigM = [[[AttendanceConfigModel alloc]initForAllJsonDataTypeWithDicFromJson:dicAttenConfig]autorelease];
            callback(attenConfigM);
        }else
        {
            //查不到数据
            callback(nil);
        }
        
    }];
}
@end
