//
//  DetailQeryViewController.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-11.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "ReportModel.h"
#import <AVFoundation/AVFoundation.h>

/*管理功能 》记录查询 》部门\员工列表 》汇报列表 》汇报的详情 */
@interface DetailQeryViewController : VcWithNavBar<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,UIScrollViewDelegate>

@property (copy,nonatomic) NSString * username;
@property (nonatomic,copy) NSString * realname;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,strong) UIImage *attenceImge;//汇报时上传的图片
//@property (nonatomic,strong) NSData * soundData;//汇报时上传的声音
@property (nonatomic,strong) UIView * background;
@property (nonatomic,strong) ReportModel * reportModel;
@property (nonatomic,strong) NSArray *soundStirngAr;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSTimer *timer;

@end
