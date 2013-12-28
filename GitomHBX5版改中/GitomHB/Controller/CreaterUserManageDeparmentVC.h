//
//  CreaterUserManageDeparmentVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-15.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ManageStaffVC.h"

@interface CreaterUserManageDeparmentVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *manageTableView;
@property (nonatomic,strong) NSArray *orgArray;
@property (nonatomic, copy) NSString *allOrgUnitNames;

@end
