//
//  ShowStaffInfomationVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-28.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "MemberOrgModel.h"
#import "MLTableAlert.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface ShowStaffInfomationVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSArray *orgNameArr;
@property (strong, nonatomic) NSMutableArray *ifoArray;//存储信息的数组
@property (strong, nonatomic) MemberOrgModel *memberIfo;//获取成员详细资料
@property (strong, nonatomic) UIImageView *headImage;//头像
@property (strong, nonatomic) UITextField *name,*phoneNumber;//可输入文本框
@property (copy, nonatomic) NSString *unitName;//属性传参得到的部门名称
@property (strong, nonatomic) MLTableAlert *alert;

@end
