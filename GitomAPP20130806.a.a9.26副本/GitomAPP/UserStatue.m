//
//  UserStatue.m
//  GitomAPP
//
//  Created by jiawei on 13-7-19.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "UserStatue.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginStatueSingal.h"

@implementation UserStatue

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        LoginStatueSingal *singal = [[LoginStatueSingal alloc]init];
        //NSLog(@"UserStatue == %@",singal.userNumber);
        _userNumber = singal.userNumber;
        //默认头像
        _userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 18, 64, 64 )];
        _userImg.image = [UIImage imageNamed:@"info_user.png"];
        [self addSubview:_userImg];
        
        //用户名
        UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 18, 100, 30)];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.text = _userName;
        userNameLabel.textColor = [UIColor whiteColor];
        userNameLabel.font = [UIFont systemFontOfSize:28];
        //userNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:userNameLabel];
        
        //编号
        UILabel *userNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 49, 100, 18)];
        userNumberLabel.text = _userNumber;
        userNumberLabel.backgroundColor = [UIColor clearColor];
        //userNumberLabel.text = @"95590";
        userNumberLabel.textColor = [UIColor whiteColor];
        userNumberLabel.font = [UIFont systemFontOfSize:12];
        //userNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:userNumberLabel];
        
        //切换账号按钮
        UIView *shiftBt = [[UIView alloc]initWithFrame:CGRectMake(92, 69, 70, 25)];
        shiftBt.tag = 2001;
        shiftBt.layer.cornerRadius = 2;
        shiftBt.backgroundColor = BackgroundColor_Black;
        [self addSubview:shiftBt];
        UILabel *loginLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 2.5, 60, 20)];
        loginLb.backgroundColor = [UIColor clearColor];
        loginLb.text = @"切换账号";
        loginLb.textColor = [UIColor whiteColor];
        loginLb.font = [UIFont systemFontOfSize:12];
        loginLb.textAlignment = NSTextAlignmentCenter;
        [shiftBt addSubview:loginLb];
        
        UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shiftAction)];
        [shiftBt addGestureRecognizer:loginTap];//添加手势
        
        //会员中心
        UIView *vipBt = [[UIView alloc]initWithFrame:CGRectMake(165, 69, 70, 25)];
        vipBt.tag = 2002;
        vipBt.layer.cornerRadius = 2;
        vipBt.backgroundColor = BackgroundColor_Black;
        [self addSubview:vipBt];
        UILabel *vipLB = [[UILabel alloc]initWithFrame:CGRectMake(5, 2.5, 60, 20)];
        vipLB.backgroundColor = [UIColor clearColor];
        vipLB.text = @"会员中心";
        vipLB.textColor = [UIColor whiteColor];
        vipLB.font = [UIFont systemFontOfSize:12];
        vipLB.textAlignment = NSTextAlignmentCenter;
        [vipBt addSubview:vipLB];
        
        UITapGestureRecognizer *vipTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipAction)];
        [vipBt addGestureRecognizer:vipTap];//添加手势
        
        
    }
    return self;
}

#pragma mark -- 切换账号
- (void)shiftAction
{
    //NSLog(@"切换账号");
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self viewWithTag:2001];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Black;
    }];
    
    if (self.userStatueDelegat != nil && [self.userStatueDelegat respondsToSelector:@selector(presentToShiftView)]) {
        [self.userStatueDelegat presentToShiftView];
    }
    
    
}

#pragma mark -- 会员中心
- (void)vipAction
{
    //NSLog(@"会员中心");
    [UIView animateWithDuration:0.5 animations:^{
        UIView *loginBt = (UIView *)[self viewWithTag:2002];
        loginBt.backgroundColor = BackgroundColor_Green;
        loginBt.backgroundColor = BackgroundColor_Black;
    }];
    
    LoginStatueSingal *singal = [LoginStatueSingal shareLogStatu];
    singal.logStatu = 2;
    
    if (self.userStatueDelegat !=nil && [self.userStatueDelegat respondsToSelector:@selector(presentToVipView)]) {
        [self.userStatueDelegat presentToVipView];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
