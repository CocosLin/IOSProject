//
//  CustomButton.m
//  IOS_Javascript
//
//  Created by jiawei on 13-7-11.
//  Copyright (c) 2013年 GitomYiwan. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.webUrl = [[NSString alloc]init];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_style_3.png"]];
        
        _imgIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 34, 28)];
        [self addSubview:_imgIcon];
        
        _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 66, 15)];
        
        _titleLB.backgroundColor = [UIColor clearColor];
        _titleLB.textColor = [UIColor whiteColor];
        _titleLB.font = [UIFont systemFontOfSize:11];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLB];
    
        //手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(connectWeb)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)connectWeb
{
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    }];
        
    if (self.connectDL !=nil && [self.connectDL respondsToSelector:@selector(pushToWeb:)]) {
        [self.connectDL pushToWeb:self.tag];
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
