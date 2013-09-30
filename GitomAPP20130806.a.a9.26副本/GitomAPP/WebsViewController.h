//
//  WebsViewController.h
//  GitomAPP
//
//  Created by jiawei on 13-8-28.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginStatueSingal.h"
#import "AboutGitom.h"
#import "FeedBack.h"
#import "CustomButton.h"
#import <ShareSDK/ShareSDK.h>
#import "Reachability.h"
#import "UserLoginView.h"

@interface WebsViewController : UIViewController<UIWebViewDelegate,feedBackViewPopProtocol,aboutPopToLastViewProtocol,pushLoginView>

@property (strong, nonatomic) UIWebView *firstWeb;
@property (strong, nonatomic) UIBarButtonItem *liftBT;
@property (strong, nonatomic) UIActivityIndicatorView *activity;//加载提示
@property (strong, nonatomic) UIView *navgationView;//定制导航条
@property (strong, nonatomic) UILabel * navgationTitle;//导航条标题
@property (strong, nonatomic) NSString *navtitle;//导航条名字
@property (assign, nonatomic) int imgFlag;//标记页面类型
@property (strong, nonatomic) NSString *anWebUrl;//将要切换到的网页地址
@property (strong, nonatomic) LoginStatueSingal *loginStatueSingale;//登入标记

@end
