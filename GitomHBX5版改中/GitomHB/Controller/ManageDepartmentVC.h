//
//  ManageDepartmentVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-10.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "OrganizationsModel.h"

@interface ManageDepartmentVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    int configType;
}

@property (nonatomic, strong) NSArray *arrSet;
@property (nonatomic, strong) OrganizationsModel *orgMod;
@property (nonatomic, assign) BOOL createrUser;//用户是不是创建者

@end
