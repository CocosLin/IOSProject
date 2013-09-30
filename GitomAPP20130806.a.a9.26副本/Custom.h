//
//  Custom.h
//  IOS_Javascript
//
//  Created by jiawei on 13-7-11.
//  Copyright (c) 2013年 GitomYiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Custom : NSObject
@property (strong, nonatomic)NSString *imgUrl;//图片地址
@property (strong, nonatomic)UIImage *img;//tu
@property (strong, nonatomic)UIImageView *imgIcon;//图片
@property (strong, nonatomic)NSString *title;//标题
@property (strong, nonatomic)NSString *paramer;//网站地址
@property (strong, nonatomic)NSArray *customAr;//按钮数

@property (strong, nonatomic)NSMutableArray *saveCustomIfo;//存放信息的数组

//+ (id) shareCustom;

@end
