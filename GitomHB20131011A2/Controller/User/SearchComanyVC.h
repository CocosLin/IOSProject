//
//  SearchComanyVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "MLTableAlert.h"

@interface SearchComanyVC : VcWithNavBar<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MLTableAlert *alert;
@property (nonatomic, retain) UITableView *searchTable;
@property (nonatomic, retain) NSArray *searchAr;
//@property (nonatomic, retain) NSArray *orgNameAr;
//@property (nonatomic, retain) NSArray *orgIdAr;
@property (nonatomic, retain) UISearchBar *search;
@property (nonatomic, assign) int uitableIndexPath;
@end
