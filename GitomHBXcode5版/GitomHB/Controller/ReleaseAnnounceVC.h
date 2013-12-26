//
//  ReleaseAnnounceVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-23.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

/* 管理功能 》公告发布 */
@interface ReleaseAnnounceVC : VcWithNavBar<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//@property (nonatomic, retain) UIScrollView *announceScrollView;
@property (nonatomic, strong) UIScrollView *baseView;
@property (nonatomic, strong) UITextView *textTitle;
@property (nonatomic, strong) UITextView *announceContent;
@property (nonatomic, copy) NSString *releaseImgUrlStr;
@property (nonatomic, strong) UIImageView *releaseImage;
//@property (retain, nonatomic) UIView *hideKeyBoardView;
@end
