//
//  GuideViewController.m
//  GitomAPP
//
//  Created by jiawei on 13-9-13.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController
@synthesize pageScroll;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
    
    pageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    pageScroll.delegate = self;
    pageScroll.pagingEnabled = YES;
    UIButton *aBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBt setTitle:@"点击此处开始" forState:UIControlStateNormal];
    aBt.frame = CGRectMake(Screen_Width *4 + Screen_Width/2-60, Screen_Height/2-50, 120, 40);
    [aBt addTarget:self action:@selector(abtAction) forControlEvents:UIControlEventTouchUpInside];
    for (int i=0; i<5; i++) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0+Screen_Width*i, 0, Screen_Width, Screen_Height)];
        imgV.contentMode = UIViewContentModeScaleToFill;
        imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        [pageScroll addSubview:imgV];//每个
        
    }
    pageScroll.backgroundColor = [UIColor blackColor];
    pageScroll.contentSize = CGSizeMake(Screen_Width * 5, Screen_Height);
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(Screen_Width/2-65, Screen_Height-80, 130, 30)];
    pageControl.numberOfPages = 5;
    
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct)];
    [pageScroll addGestureRecognizer:tapAction];
    
    [self.view addSubview:pageScroll];
    [self.view addSubview:pageControl];
    [pageScroll addSubview:aBt];
}
#pragma mark -- 进入应用
- (void)abtAction{
    
    //使用NSUserDefult记录已经登入的结果，下次登入是不再出现教程
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.viewController.leftPanel = [[ChooseViewController alloc]init];
    self.viewController.centerPanel = [[ViewController alloc]init];
    //ViewController *vi = [[ViewController alloc]init];
    self.viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:self.viewController animated:YES completion:nil];
    NSLog(@"结束教程，进入应用");
}

#pragma mark -- 点击浏览教程
- (void)tapAct{
    pageControl.currentPage ++;
    NSLog(@"点击时候显示的页码 == %d",pageControl.currentPage);
    [UIView animateWithDuration:0.5 animations:^{
        pageScroll.contentOffset = CGPointMake(Screen_Width*pageControl.currentPage, 0);
    }];
    if (pageControl.currentPage == 4) {
        [self abtAction];
    }
}

#pragma mark -- 拖动浏览教程
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    pageControl.currentPage = index;
    NSLog(@"拖动时候点显示的页码 == %d",index);
    if (index == 4) {
        [self abtAction];
    }
    NSLog(@"ssssssss`");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
