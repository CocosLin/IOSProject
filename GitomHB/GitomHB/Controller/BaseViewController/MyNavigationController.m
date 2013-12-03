//
//  MyNavigationController.m
//  GitomHB
//
//  Created by jiawei on 13-5-16.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()
{
    UILabel * _titleLabel;
}
@end

@implementation MyNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //自定义标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        _titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //self.navigationBar.backgroundColor = [UIColor whiteColor];
        self.navigationItem.titleView = _titleLabel;
        self.myControllerTitle = self.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]<6.0) {
        //[self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    }else{
        //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground"] forBarMetrics:0];
    }
   
}

-(void)setMyControllerTitle:(NSString *)myControllerTitle
{
    _titleLabel.text = myControllerTitle;
    if (_myControllerTitle == myControllerTitle) {
        return;
    }
    _myControllerTitle = [myControllerTitle copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
