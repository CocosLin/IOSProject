//
//  RolePrivilegeVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
/*编辑主管权限*/
@interface RolePrivilegeVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) UITableView *configTableView;
@property (nonatomic, retain) NSMutableString *appindStr;

@end
