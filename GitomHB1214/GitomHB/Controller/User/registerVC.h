//
//  registerVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-4.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import <QuartzCore/QuartzCore.h>
@interface registerVC : VcWithNavBar<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *phoneNumber;
@end
