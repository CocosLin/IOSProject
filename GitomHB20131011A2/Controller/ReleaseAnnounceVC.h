//
//  ReleaseAnnounceVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-23.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
/* 管理功能 》公告发布 */
@interface ReleaseAnnounceVC : VcWithNavBar<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>

//@property (nonatomic, retain) UIScrollView *announceScrollView;
@property (retain, nonatomic) UIScrollView *baseView;
@property (retain, nonatomic) UITextView *textTitle;
@property (retain, nonatomic) UITextView *announceContent;
@property (retain, nonatomic) UIView *hideKeyBoardView;
@end
