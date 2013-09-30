//
//  UserStatue.h
//  GitomAPP
//
//  Created by jiawei on 13-7-19.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol UserStatueProtocol <NSObject>

- (void) presentToShiftView;//切换账号代理方法
- (void) presentToVipView;//切换会员中心代理方法

@end

@interface UserStatue : UIView

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userNumber;
@property (strong, nonatomic) UIImageView *userImg;
@property (strong, nonatomic) UIButton *shiftButton;
@property (strong, nonatomic) UIButton *vipButton;

@property (assign, nonatomic) id<UserStatueProtocol> userStatueDelegat;




@end
