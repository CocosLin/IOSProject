//
//  NextStepRegisterVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-4.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import <QuartzCore/QuartzCore.h>

@interface NextStepRegisterVC : VcWithNavBar<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIScrollView *baseView;
@property (strong, nonatomic) NSString *phoneNumber;
@end
