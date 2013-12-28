//
//  MyDocumentVC.h
//  GitomNetLjw
//
//  Created by GitomYiwan on 13-7-6.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

@interface MyDocumentVC : VcWithNavBar<UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (retain, nonatomic) UIImageView *headImage;//头像

@property (strong, nonatomic) UITextField *name,*phoneNumber;//可输入文本框
@property (strong, nonatomic) NSString *unitName;//部门名称
@property (copy, nonatomic) NSString *headImgUrlStr;//服务器图片路径
@property (nonatomic, strong) UIImage *imgdata;

@end
