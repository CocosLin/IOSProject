
//  Created by Yang Meyer on 03.02.12.
//  Copyright (c) 2012 compeople. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIResponder (MotionRecognizers)

//注册摇动通知
- (void) addMotionRecognizerWithAction:(SEL)action;
//取消摇动通知
- (void) removeMotionRecognizer;

@end
