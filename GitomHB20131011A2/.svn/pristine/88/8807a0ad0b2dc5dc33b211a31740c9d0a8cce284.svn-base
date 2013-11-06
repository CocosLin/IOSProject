//
//  LoginVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"


@class JASidePanelController;

@interface LoginVC : VcWithNavBar<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    JASidePanelController * _sideViewController;
}
#pragma mark - 用户登录输入
//用户名和密码输入框
@property(nonatomic,retain)UITextField * tfUsername;
@property(nonatomic,retain)UITextField * tfPassword;


#pragma mark - 用户登录其他操作
//是否记住密码
@property(nonatomic,assign)BOOL isRememberPassword;
//是否自动登录
@property(nonatomic,assign)BOOL isAutoLogin;
//是否显示历史账号记录
@property(nonatomic,assign)BOOL isShowHisLoginInfo;

//历史账号信息
@property(retain,nonatomic)NSMutableArray * arrLoggingInfos;

@end
