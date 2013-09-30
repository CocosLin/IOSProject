//
//  GuideViewController.h
//  GitomAPP
//
//  Created by jiawei on 13-9-13.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "JASidePanelController.h"
#import "ChooseViewController.h"
@interface GuideViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *pageScroll;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) JASidePanelController *viewController;
@end
