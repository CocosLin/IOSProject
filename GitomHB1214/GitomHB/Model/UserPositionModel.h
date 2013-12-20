//
//  UserPositionModel.h
//  GitomHB
//
//  Created by jiawei on 13-12-9.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPositionModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) CLLocation *loc;

@end
