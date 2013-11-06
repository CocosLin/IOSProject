//
//  WCommonMacroDefine.h
//  GitomHB
//
//  Created by jiawei on 13-6-17.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#ifndef GitomHB_WCommonMacroDefine_h
#define GitomHB_WCommonMacroDefine_h

#pragma mark -----------------单例-----------------
//实现获得单例方法
#define SINGLETON_FOR_CLASS_Implementation(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}
//声明获得单例方法
#define SINGLETON_FOR_CLASS_Interface(className) \
+ (className *)shared##className;

#pragma mark -----------------屏幕宽高-----------------
#define Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Screen_Width  [[UIScreen mainScreen] bounds].size.width
#define Height_Screen [[UIScreen mainScreen] bounds].size.height
#define Width_Screen  [[UIScreen mainScreen] bounds].size.width

//自定义标记,打印方法、行
#define Mark_Custom NSLog(@"\n+++Custom_Mark: %s, %dLine+++",__PRETTY_FUNCTION__, __LINE__)

#endif
