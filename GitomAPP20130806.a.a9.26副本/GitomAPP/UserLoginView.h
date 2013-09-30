//
//  UserLoginView.h
//  GitomAPP
//
//  Created by jiawei on 13-7-15.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMD5.h"
#import "LoginStatueSingal.h"

@class UserInformationsManager;

//协议
@protocol pushLoginView <NSObject>
- (void)pushToLonginView;//返回上个页面
//- (void)returnActions;//回车时候调用的方法
- (void)refreshView;//刷新页面
@end

@interface UserLoginView : UIView<UITextFieldDelegate,UIWebViewDelegate>
@property (assign, nonatomic) id <pushLoginView> pushDelegate;

@property (strong, nonatomic) UIScrollView *baseView;//滚动视图
@property (strong, nonatomic) UIView *yView;//此为决定记录用户信息组件的y轴坐标的View
@property (strong, nonatomic) UIView *logView;
@property (strong, nonatomic) UIView *userLoginView2;
@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) UITextField *userNumber;//其实是编号
@property (strong, nonatomic) NSArray *userIfoAr;
@property (strong, nonatomic) UserInformationsManager *userIfo;
@property (strong, nonatomic) UIWebView *loginSuccessWeb;//连接验证网络用的网页
@property (assign, nonatomic) int flag;//标记是填入的还是、历史记录里的用户
//@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;//js与oc交互类库
@property (strong, nonatomic) LoginStatueSingal *loginStatue;//存储各种信息、状态的单例

@end
