//
//  VcWithNavBar.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <UIKit/UIKit.h>
//背景颜色
#define Color_Background [UIColor colorWithRed:230/255.0 green:235/255.0 blue:246/255.0 alpha:1.0]

@interface VcWithNavBar : UIViewController
//导航条图片名称
@property(copy,nonatomic)NSString * imgNameNavBar;
//自定义导航条标题
@property(copy,nonatomic)NSString * myVcTitle;
-(void)btnBack:(UIButton *)btn;
@end
