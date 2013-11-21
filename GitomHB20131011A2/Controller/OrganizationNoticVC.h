//
//  OrganizationNoticVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-18.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
@class ShowNoticView;
@interface OrganizationNoticVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>{
    ShowNoticView *showIfoView;
    UITableView *massageTableView;
}
@property (nonatomic,strong) NSString *textTitle;
@property (nonatomic,strong) NSString *realName;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *creatDate;
@property (nonatomic,assign) BOOL querMessage;
@end
