//
//  MyDocumentVC.h
//  GitomNetLjw
//
//  Created by GitomYiwan on 13-7-6.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

@interface MyDocumentVC : VcWithNavBar

@property (retain, nonatomic) UIImageView *headImage;//头像

@property (retain, nonatomic) UITextField *name,*phoneNumber;//可输入文本框
@property (retain, nonatomic) NSString *unitName;//部门名称


@end
