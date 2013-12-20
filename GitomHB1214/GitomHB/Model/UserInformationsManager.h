//
//  UserInformationsManager.h
//  GitomAPP
//
//  Created by jiawei on 13-10-19.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformationsManager : NSObject
//@property (assign, nonatomic) int userId;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString *userPassWord;
//@property (strong, nonatomic) NSString *passWord;
//@property (strong, nonatomic) UIImage *userImg;


+ (NSMutableArray *)findAll;

+(void) upateName:(NSString *)aName andNumber:(NSString *)aNumber andPassWord:(NSString *)aPassWord andUserImage:(UIImage *) aUserImg withId:(int) aId;

+ (void)insertWithUserName:(NSString *)userName andUserPassWord:(NSString *)passWord;
+(void)deleteWithId:(NSString *)userId;

//+(void)deleteACellFromDbWithId:(int)bookId;//按id 删除数据





@end
