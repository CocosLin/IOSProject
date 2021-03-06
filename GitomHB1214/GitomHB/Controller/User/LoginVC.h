//
//  LoginVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "UserInformationsManager.h"
#import "LoginHistoryCell.h"

@class JASidePanelController;


@interface LoginVC : VcWithNavBar<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LoginHistorCellDelegate>
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
@property (nonatomic, copy) NSString *isRememberPasswordStr;
//是否自动登录
@property(nonatomic,assign)BOOL isAutoLogin;
@property (nonatomic, copy) NSString *isAutoLoginStr;
//是否显示历史账号记录
@property(nonatomic,assign)BOOL isShowHisLoginInfo;

//历史账号信息
@property(strong,nonatomic)NSMutableArray * arrLoggingInfos;

@property (strong, nonatomic) NSArray *userIfoAr;
@property (strong, nonatomic) UserInformationsManager *userIfo;

@end
