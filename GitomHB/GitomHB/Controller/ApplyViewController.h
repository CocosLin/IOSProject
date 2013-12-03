//
//  ApplyViewController.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-14.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyViewController : VcWithNavBar<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) NSArray *arrData;

@end
