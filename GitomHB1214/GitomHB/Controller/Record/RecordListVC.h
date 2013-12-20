//
//  RecordListVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//



/*
 汇报记录列表
 */


#import "VcWithNavBar.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"


@interface RecordListVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,EGORefreshTableFooterDelegate,EGORefreshTableHeaderDelegate>{
    EGORefreshTableFooterView *refreshView;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL reloading;
    BOOL reloading1;
}

@property(assign,nonatomic)long long int dtBegin;
@property(assign,nonatomic)long long int dtEnd;
@property(copy,nonatomic)NSString * strTypeRecord;

@property(copy,nonatomic)NSString * username;
@property(copy,nonatomic)NSString * userRealname;

@property(nonatomic,assign)NSInteger typeRecord;
@property(nonatomic,strong)NSArray * arrData;


-(id)initWithRecordType:(NSInteger)typeRecord
               Username:(NSString *)username
           UserRealname:(NSString *)userRealname;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
