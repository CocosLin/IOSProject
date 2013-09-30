//
//  UIImageView+Dcgimage.m
//  GitomAPP
//
//  Created by jiawei on 13-7-12.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "UIImageView+Dcgimage.h"

@implementation UIImageView (Dcgimage)

-(void)setImageFronUrl:(NSString * )str
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),
                   ^{
                       //子线程负责获取相关数据
                       NSURL * url = [NSURL URLWithString:str];
                       NSData * data = [NSData dataWithContentsOfURL:url];
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          //主线程负责UI界面的更新
                                          self.image = [UIImage imageWithData:data];
                                      });
                   });
}


@end
