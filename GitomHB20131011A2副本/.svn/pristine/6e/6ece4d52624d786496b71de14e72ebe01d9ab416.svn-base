//
//  AttendanceManager.h
//  GitomNetLjw
//
//  Created by jiawei on 13-7-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "BaseManager.h"
#import "WCommonMacroDefine.h"
#import "AttendanceConfigModel.h"
#import "AttendanceConfigBean.h"
#import "AttendanceWorktimeModel.h"
@interface AttendanceManager : BaseManager
SINGLETON_FOR_CLASS_Interface(AttendanceManager);
//得到考勤配置(工作时间段，考勤距离，公司坐标等)
-(void)getAttendanceConfigWithOrganizationID:(NSInteger)organizationId
                                   OrgunitID:(NSInteger)orgunitID
                              GotAttenConfig:(void(^)(AttendanceConfigModel * attenConfig))callback;
//考勤

@end
