//
//  ManageAttendanceConfigVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-15.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

@interface ManageAttendanceConfigVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) UITableView *configTableView;
@property (nonatomic,retain) NSArray *orgArray;
@property (nonatomic, copy) NSString *location,*outMinute,*inMinute,*distance,*time1,*time2,*time3;
@end
