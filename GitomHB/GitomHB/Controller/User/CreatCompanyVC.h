//
//  CreatCompanyVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-7.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

@interface CreatCompanyVC : VcWithNavBar<UITextViewDelegate>
@property (retain, nonatomic) UIScrollView *baseView;
@property (retain, nonatomic) UITextView *companyNameText;
@property (retain, nonatomic) UITextView *regulationText;
@property (retain, nonatomic) UITextView *realname;
@property (retain, nonatomic) UITextView *cellphone;
@end
