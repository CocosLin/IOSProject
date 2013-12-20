//
//  ManageAttendanceConfigVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-15.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "AttendanceWorktimeModel.h"


@interface ManageAttendanceConfigVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>{
    int configType;
}
@property (strong, nonatomic) UITableView *configTableView;
@property (nonatomic, strong) NSArray *orgArray;
@property (nonatomic, copy) NSString *location,*outMinute,*inMinute,*distance,*time1,*time2,*time3;
@property (nonatomic, copy) NSString *orgunitId;
@property (nonatomic, strong) AttendanceWorktimeModel *attendModle;//考勤配置
@end
