//
//  DetailRecordVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-7-3.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "ReportModel.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailRecordVC : VcWithNavBar<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,UIScrollViewDelegate>{
    UITextView *contentText;

}

@property (copy,nonatomic) NSString * username;
@property (nonatomic,copy) NSString * realname;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,strong) UIImage *attenceImge;
@property (nonatomic,strong) UIView *background;
@property (nonatomic,strong) ReportModel * reportModel;
@property (nonatomic,strong) NSArray *soundStirngAr;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSTimer *timer;

@end
