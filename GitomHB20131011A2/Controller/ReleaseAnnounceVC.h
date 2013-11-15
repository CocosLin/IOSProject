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
@property (nonatomic, retain) UIScrollView *baseView;
@property (nonatomic, retain) UITextView *textTitle;
@property (nonatomic, retain) UITextView *announceContent;
@property (nonatomic, copy) NSString *releaseImgUrlStr;
@property (nonatomic,retain) UIImageView *releaseImage;
//@property (retain, nonatomic) UIView *hideKeyBoardView;
@end
