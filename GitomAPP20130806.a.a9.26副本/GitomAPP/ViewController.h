//
//  ViewController.h
//  GitomAPP
//
//  Created by jiawei on 13-7-11.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLoginView.h"//含有协议
#import "FeedBack.h"//含有协议
#import "AboutGitom.h"//含有协议
#import "LoginStatueSingal.h"

@interface ViewController : UIViewController<UIWebViewDelegate>//,pushLoginView,feedBackViewPopProtocol,aboutPopToLastViewProtocol>

@property (strong, nonatomic) UIWebView *firstWeb;
@property (strong, nonatomic) UIBarButtonItem *liftBT;
@property (strong, nonatomic) UIActivityIndicatorView *activity;//加载提示
@property (strong, nonatomic) UIView *navgationView;//定制导航条
@property (strong, nonatomic) UILabel * navgationTitle;//导航条标题
@property (strong, nonatomic) NSString *navtitle;//导航条名字
@property (strong, nonatomic) UIView *bottomView;//底部的导航栏

@property (assign, nonatomic) int loginFlag;//用户登入状态
@property (assign, nonatomic) int imgFlag;//标记页面类型
@property (strong, nonatomic) NSString *webUrl;//将要切换到的网页地址

@property (strong, nonatomic) NSTimer *webTimer;

@property (strong, nonatomic) UIImageView *forwardImg;
@property (strong, nonatomic) UIImageView *backImg;
@property (strong, nonatomic) LoginStatueSingal *loginStatueSingale;//登入标记
@end
