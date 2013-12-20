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

@property (nonatomic, strong) UIScrollView *baseView;
@property (nonatomic, strong) NSString *appindStr;

@end
