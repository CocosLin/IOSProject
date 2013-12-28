//
//  ApplyModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-14.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyModel : NSObject
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *orgunitName;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *createUserId;//申请者id
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *orgunitId;
@end
