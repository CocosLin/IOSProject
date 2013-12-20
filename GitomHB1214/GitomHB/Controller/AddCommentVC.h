//
//  AddCommentVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-8.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
//#import "DLStarRatingControl.h"
#import "ReportModel.h"
#import "RSTapRateView.h"
@interface AddCommentVC : VcWithNavBar<UITextViewDelegate,RSTapRateViewDelegate>//DLStarRatingDelegate>

@property (nonatomic, strong) UILabel *stars;
@property (nonatomic, strong) UITextView *commentView;
@property (nonatomic, strong) ReportModel *reportMod;
@end
