//
//  MobileReportVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

@interface MobileReportVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic)long long int serverTimeMS;
@property(strong,nonatomic)NSArray * arrStrWorkTime;
@end