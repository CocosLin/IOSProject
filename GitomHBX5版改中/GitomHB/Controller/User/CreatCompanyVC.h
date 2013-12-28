//
//  CreatCompanyVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-7.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

@interface CreatCompanyVC : VcWithNavBar<UITextViewDelegate>
@property (strong, nonatomic) UIScrollView *baseView;
@property (strong, nonatomic) UITextView *companyNameText;
@property (strong, nonatomic) UITextView *regulationText;
@property (strong, nonatomic) UITextView *realname;
@property (strong, nonatomic) UITextView *cellphone;
@end
