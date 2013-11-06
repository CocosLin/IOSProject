//
//  DetailRecordVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-7-3.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "ReportModel.h"
@interface DetailRecordVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate>
@property(copy,nonatomic)NSString * username;
@property(nonatomic,copy)NSString * realname;
@property(nonatomic,copy)NSString * phone;
@property (nonatomic,retain) UIImage *attenceImge;
@property (nonatomic,retain) UIView *background;
@property(retain,nonatomic)ReportModel * reportModel;

@end
