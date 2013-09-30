//
//  CustomButton.h
//  IOS_Javascript
//
//  Created by jiawei on 13-7-11.
//  Copyright (c) 2013年 GitomYiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
//连接相对应的网络
@protocol tapConnectProtocol <NSObject>

- (void)pushToWeb:(int)tag;

@end

@interface CustomButton : UIView

@property (strong, nonatomic) UIImageView *imgIcon;
@property (strong, nonatomic) UILabel *titleLB;
//@property (strong, nonatomic) NSString *webUrl;
@property (assign, nonatomic) int btTag;

@property (assign, nonatomic)id<tapConnectProtocol> connectDL;//协议代理

@end
