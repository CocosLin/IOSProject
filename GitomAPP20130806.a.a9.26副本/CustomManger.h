//
//  CustomManger.h
//  IOS_Javascript
//
//  Created by jiawei on 13-7-11.
//  Copyright (c) 2013年 GitomYiwan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Custom;

@interface CustomManger : NSObject<NSURLConnectionDataDelegate>

@property (strong, nonatomic) Custom *custom;

//@property (assign, nonatomic) int indx;
//@property (strong, nonatomic) NSMutableData *getData;
@property (strong, nonatomic)NSMutableArray *saveCustomIfo;//存放信息的数组

- (Custom *)connectWithCustomURLgetIndex:(int) aIndex;

@end
