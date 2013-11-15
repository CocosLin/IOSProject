//
//  ManageStaffVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-10.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"


@interface ManageStaffVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) UITableView *manageTableView;
@property (nonatomic,strong) NSArray *orgArray;
- (void)refreshAction;
@end
