//
//  VcWithNavBar.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"

@interface VcWithNavBar ()
{
    UILabel * _lblNavBarTitle;
}
@end

@implementation VcWithNavBar


#pragma mark - 属性控制
-(void)setMyVcTitle:(NSString *)myVcTitle
{
    //调用setMyVcTitle:方法的时候，设置标题
    _lblNavBarTitle.text = myVcTitle;
    _lblNavBarTitle.text = self.title;
    if (_myVcTitle == myVcTitle) {
        return;
    }
    [_myVcTitle release];
    _myVcTitle = [myVcTitle copy];
}
#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.imgNameNavBar = @"navigationBarBackground";
    }return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //通用的导航条背景图片
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:self.imgNameNavBar]]];
    _lblNavBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    _lblNavBarTitle.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    _lblNavBarTitle.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
    _lblNavBarTitle.textColor = [UIColor blackColor];  //设置文本颜色
    _lblNavBarTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _lblNavBarTitle;
    self.myVcTitle = self.title;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_block.png"]]];
    
   
}



-(void)btnBack:(UIButton *)btn
{
    NSLog(@"VcWithNavBar popViewControllerAnimated");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_imgNameNavBar release];
    [_lblNavBarTitle release];
    [_myVcTitle release];
    [super dealloc];
}



@end
