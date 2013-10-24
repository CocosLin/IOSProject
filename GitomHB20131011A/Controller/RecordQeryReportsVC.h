//
//  RecordQeryReportsVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-9.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

/*管理功能 》记录查询 》部门列表\员工列表 》打卡、汇报列表*/
@interface RecordQeryReportsVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(assign,nonatomic)long long int dtBegin;
@property(assign,nonatomic)long long int dtEnd;
@property(copy,nonatomic)NSString * strTypeRecord;

@property(copy,nonatomic)NSString * username;
@property(copy,nonatomic)NSString * userRealname;
@property(copy,nonatomic)NSString * organizationId;
@property(copy,nonatomic)NSString * orgunitId,* soundUrl,*telephone,*updateDate,*imageUrl,*address,*latitude,*longitude;

@property(nonatomic,assign)NSInteger typeRecord;
@property(nonatomic,retain)NSArray * arrData;
@property (nonatomic,retain) NSArray *reportArrData;

@property (nonatomic,assign) int personalOrOrgRecod;//查询个人或集体标记
@property (nonatomic, assign) BOOL playCard;//是否查询打卡记录

@end
