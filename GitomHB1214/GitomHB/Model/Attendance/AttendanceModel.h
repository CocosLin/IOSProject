//
//  AttendanceModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-15.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendanceModel : NSObject

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) int orgunitId;
@property (nonatomic, assign)long long int createTime;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, assign) long long int updateDate;
//@property (nonatomic, copy) NSString *orgunitId;

@end
