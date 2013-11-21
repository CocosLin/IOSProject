//
//  QueryMessageModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-21.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>
/*消息通知实体类
 createDate = 1377139058000;
 dtx = report;
 extend = 1377139058783;
 messageId = 1377139058808;
 organizationId = 204;
 orgunitId = 1;
 readUser = "";
 sender = 78088;
 senderReadname = "\U67ef\U603b";
 username = "";
 voidFlag = 0;
 */
@interface QueryMessageModel : NSObject

@property (nonatomic, copy) NSString *createDate;
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
