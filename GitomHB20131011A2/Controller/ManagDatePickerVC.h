//
//  ManagDatePickerVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-1.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "MWDatePicker.h"

@interface ManagDatePickerVC : VcWithNavBar< MWPickerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) int setTimeType;
@property (nonatomic,retain) UITableView *dateTableView;

@end
