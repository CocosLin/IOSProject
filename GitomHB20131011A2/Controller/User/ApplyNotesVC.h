//
//  ApplyNotesVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-6.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "OrganizationsModel.h"
#import <QuartzCore/QuartzCore.h>

@interface ApplyNotesVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSString *checkWay;
}
//@property (nonatomic,retain) OrganizationsModel *orgMod;
@property (nonatomic,copy) NSString *orgName;
@property (nonatomic,copy) NSString *orgId;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,retain) NSArray *orgPropsArray;
@end
