//
//  AboutGitom.m
//  GitomAPP
//
//  Created by jiawei on 13-7-13.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "AboutGitom.h"

@implementation AboutGitom

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *gitomImg = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 210, 60)];
        gitomImg.image = [UIImage imageNamed:@"logo.png"];
        [self addSubview:gitomImg];
        
        _versions = [[UILabel alloc]initWithFrame:CGRectMake(4, 62, 210, 20)];
        _versions.textColor = [UIColor grayColor];
        _versions.text = @"网即通  0.6.4.6 - [175]";
        _versions.textAlignment = NSTextAlignmentCenter;
        _versions.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_versions];
        
        UIView *link = [[UIView alloc]initWithFrame:CGRectMake(2, 83, 316, 1)];
        link.backgroundColor = [UIColor blueColor];
        [self addSubview:link];
        
        UIImageView *appImg = [[UIImageView alloc]initWithFrame:CGRectMake(60, 95, 200, 200)];
        appImg.image = [UIImage imageNamed:@"GitomAppQR.jpg"];
        //appImg.center = CGPointMake(self.center.x, self.center.y);
        [self addSubview:appImg];
        
        /*
        UIButton *gitDownLoad = [UIButton buttonWithType:UIButtonTypeCustom];
        gitDownLoad.frame = CGRectMake(0, 290, 320, 18);
        [gitDownLoad setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [gitDownLoad setTitle:@"http://www.gitom.com" forState:UIControlStateNormal];
        [gitDownLoad addTarget: self action:@selector(downLoad) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:gitDownLoad];
        */
        UIButton *urlButtont = [UIButton buttonWithType:UIButtonTypeCustom];
        urlButtont.frame = CGRectMake(0, 290, 320, 18);
        [urlButtont addTarget:self action:@selector(conectToUrl) forControlEvents:UIControlEventTouchUpInside];
        [urlButtont setTitle:@"http://59.57.15.168/dev.html" forState:UIControlStateNormal];
        [self addSubview:urlButtont];
        
        
        UILabel *gitUrl = [[UILabel alloc]initWithFrame:CGRectMake(0, 290, 320, 18)];
        gitUrl.textAlignment = NSTextAlignmentCenter;
        gitUrl.text = @"http://www.gitom.com/download/gitomSite";
        gitUrl.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:gitUrl];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToDismissAction)];
        [self addGestureRecognizer:swipe];
        
    }
    return self;
}

- (void)conectToUrl{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://59.57.15.168/dev.html"]];
}

- (void)swipeToDismissAction
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(aboutBackPopToLastView)]) {
        [self.delegate aboutBackPopToLastView];
    }
}

/*
- (void)downLoad
{
    [[UIApplication sharedApplication ]openURL:[NSURL URLWithString:@"http://www.gitom.com/download/gitomSite"]];
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
