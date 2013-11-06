//
//  ServerManager.h
//  GitomNetLjw
//
//  Created by linjiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCommonMacroDefine.h"
@interface ServerManager : NSObject
SINGLETON_FOR_CLASS_Interface(ServerManager);
@property(copy,nonatomic)NSString * strBaseUrl;
@end        
