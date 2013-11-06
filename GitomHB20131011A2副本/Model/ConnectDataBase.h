//
//  ConnectDataBase.h
//  GitomAPP
//
//  Created by jiawei on 13-10-19.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ConnectDataBase : NSObject


+ (sqlite3 *)createDB;

@end
