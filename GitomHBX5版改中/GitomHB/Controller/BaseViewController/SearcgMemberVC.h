//
//  SearcgMemberVC.h
//  GitomHB
//
//  Created by jiawei on 13-12-26.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "VcWithNavBar.h"

@interface SearcgMemberVC : VcWithNavBar<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *searchTable;
@property (nonatomic, strong) NSArray *searchAr;
@property (nonatomic, strong) UISearchBar *search;
//@property (nonatomic, strong) NSArray *data;
@property (nonatomic,assign) NSInteger seledBtIdx;

@end
