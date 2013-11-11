//
//  AddCommentVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-8.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "DLStarRatingControl.h"
#import "ReportModel.h"

@interface AddCommentVC : VcWithNavBar<UITextViewDelegate,DLStarRatingDelegate>

@property (nonatomic, retain) UILabel *stars;
@property (nonatomic, retain) UITextView *commentView;
@property (nonatomic, retain) ReportModel *reportMod;
@end
