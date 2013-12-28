//
//  ManageStaffDetialVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-24.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

@interface ManageStaffDetialVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *organizationTableView;
@property (nonatomic, strong) NSArray *orgArray;
@property (nonatomic, copy) NSString *unitName;
@property (nonatomic, assign) int orgNumber;
@end
