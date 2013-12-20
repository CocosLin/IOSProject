//
//  QueryMessageModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-21.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>
/*消息通知实体类*/
@interface QueryMessageModel : NSObject
@property (nonatomic, assign) long long int updateDate;
@property (nonatomic, assign) long long int createDate;
@property (nonatomic, copy) NSString *dtx;
@property (nonatomic, copy) NSString *extend;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *organizationId;
@property (nonatomic, copy) NSString *orgunitId;
@property (nonatomic, copy) NSString *readUser;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *senderReadname;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) int voidFlag;

@end
