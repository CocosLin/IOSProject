//
//  ChooseViewController.h
//  IOS_Javascript
//
//  Created by GitomYiwan on 13-7-8.
//  Copyright (c) 2013年 GitomYiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "UserStatue.h"
#import "WebsViewController.h"

@class Custom;

@interface ChooseViewController : UIViewController<tapConnectProtocol,UserStatueProtocol>

@property (strong, nonatomic) UIView *buttomBt1;
@property (strong, nonatomic) UIView *buttomBt2;
@property (strong, nonatomic) UIView *buttomBt3;

@property (strong, nonatomic) UIView *aboutView;
@property (strong, nonatomic) UIView *appView;
@property (strong, nonatomic) UIView *headView;

@property (strong, nonatomic) Custom *custom;

@property (assign, nonatomic) int loginFlag;//登入状态标记
@property (strong, nonatomic) NSString *buttonTitle;
//@property (strong, nonatomic) UIView *refreshButton;
@property (strong, nonatomic) UIButton *refreshButton;

@property (strong, nonatomic) CustomButton *cusBT;

@end