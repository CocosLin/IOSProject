//
//  ManageDepartmentVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-10.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "OrganizationsModel.h"

@interface ManageDepartmentVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    int configType;
}

@property (nonatomic,retain) NSArray *arrSet;
@property (nonatomic,retain) OrganizationsModel *orgMod;
@property (nonatomic,assign) BOOL createrUser;
@end
