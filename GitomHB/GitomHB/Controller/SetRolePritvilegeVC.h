//
//  SetRolePritvilegeVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-28.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "QCheckBox.h"

@interface SetRolePritvilegeVC : VcWithNavBar<UIScrollViewDelegate,QCheckBoxDelegate>

@property (nonatomic, retain) UIScrollView *baseView;
@property (nonatomic, retain) NSString *appindStr;

@end
