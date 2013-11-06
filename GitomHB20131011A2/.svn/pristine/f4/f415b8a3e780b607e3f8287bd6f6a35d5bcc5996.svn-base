
//  Created by Yang Meyer on 03.02.12.
//  Copyright (c) 2012 compeople. All rights reserved.

#import "JWMotionRecognizingWindow.h"

@implementation JWMotionRecognizingWindow

//重写运动结束调用方法
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event {
//    typedef NS_ENUM(NSInteger, UIEventType) {
//        UIEventTypeTouches,
//        UIEventTypeMotion,
//        UIEventTypeRemoteControl,
//    };
    //判断是不是摇动
	if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"JWDeviceShaken" object:self];
	}
}

@end
