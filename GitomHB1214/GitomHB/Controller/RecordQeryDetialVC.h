//
//  RecordQeryDetialVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-24.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
/* 管理功能 》记录查询 》部门列表 》员工列表 */
@interface RecordQeryDetialVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *organizationTableView;
@property (nonatomic,strong) NSArray *orgArray;
@property (nonatomic,assign) NSInteger orgNumber;
@property (nonatomic,assign) NSInteger seledBtIdx;
@end
