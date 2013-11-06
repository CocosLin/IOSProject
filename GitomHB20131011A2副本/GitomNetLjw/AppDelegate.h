//
//  AppDelegate.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWMotionRecognizingWindow.h"//可以发送摇动手机通知的window
#import "LoginVC.h"//登录页面
#import "CommonDataModel.h"
#import "UIViewController+JASidePanel.h"
#import "BMapKit.h"
#import "ASIDownloadCache.h"
@class JASidePanelController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
    ASIDownloadCache *myCache;
}
@property (strong, nonatomic) JWMotionRecognizingWindow * window;
@property(retain,nonatomic)CommonDataModel * comData;
@property (nonatomic,retain) ASIDownloadCache *myCache;
@end
