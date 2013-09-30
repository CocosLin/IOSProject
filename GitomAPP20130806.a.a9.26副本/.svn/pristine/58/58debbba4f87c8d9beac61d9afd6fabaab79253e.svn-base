//
//  UserInformationsManager.m
//  GitomAPP
//
//  Created by jiawei on 13-7-19.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//
//
#import "UserInformationsManager.h"
#import "ConnectDataBase.h"

@implementation UserInformationsManager

+(NSMutableArray *)findAll{
    NSMutableArray *userIfomationArray=nil;//返回的查询结果
    
    sqlite3 *sql3=[ConnectDataBase createDB];//返回一个指针类型
    
    //声明sql语句对象
    sqlite3_stmt *st;
    
    //给sql语句对象赋值
    //第三项 -1，指取第二项字符串的全部长度。第四项 可以写回调函数
    int p= sqlite3_prepare_v2(sql3, "select *from userinformation", -1, &st , nil);
    
    if (p==SQLITE_OK) {//判断sql语法正确性
        userIfomationArray=[[NSMutableArray alloc]init];
        
        while (sqlite3_step(st)==SQLITE_ROW) {//是否查询到记录
            UserInformationsManager *userInfo=[[UserInformationsManager alloc]init];
            userInfo.userId=sqlite3_column_int(st, 0);
            
            userInfo.userName =[NSString stringWithCString:(char *)sqlite3_column_text(st, 1) encoding:NSUTF8StringEncoding];
            userInfo.userNumber =[NSString stringWithCString:(char *)sqlite3_column_text(st, 2) encoding:NSUTF8StringEncoding];
            userInfo.passWord = [NSString stringWithCString:(char *)sqlite3_column_text(st, 3) encoding:NSUTF8StringEncoding];
            int length=sqlite3_column_bytes(st, 4);
            Byte *imageByte=(Byte *)sqlite3_column_blob(st, 4);
            NSData *imageData=[NSData dataWithBytes:imageByte length:length];
            userInfo.userImg = [[UIImage alloc]initWithData:imageData];
            
            [userIfomationArray addObject:userInfo];
        }
    }
    
    sqlite3_finalize(st);
    return userIfomationArray;
    
}

//更新
+ (void) upateName:(NSString *)aName andNumber:(NSString *)aNumber andPassWord:(NSString *)aPassWord andUserImage:(UIImage *)aUserImg withId:(int) aId
{
    NSData *data=UIImagePNGRepresentation(aUserImg);
    sqlite3 *sql3=[ConnectDataBase createDB];
    NSString *sql=[NSString stringWithFormat:@"update userinformation set userName=?,userNumber=?,passWord=?,userImage=? where userId=?"];
    sqlite3_stmt *st;
    
    if(sqlite3_prepare_v2(sql3, [sql UTF8String], -1, &st, nil)==SQLITE_OK){
        
        sqlite3_bind_text(st, 1, [aName UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(st, 2, [aNumber UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(st, 3, [aPassWord UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_blob(st, 4, [data bytes], [data length], nil);//插入用户头像
        sqlite3_bind_int(st, 5, aId);
        
        if (sqlite3_step(st)==SQLITE_ERROR) {//绑定好参数之后 再执行sql
            
            NSLog(@"error:failed in kit updata database");
        }else{
            NSLog(@"更新正确执行了");
        }
    }else{
        NSLog(@"sql语法错误");
    }
    sqlite3_finalize(st);

}
/*
//删除
+(void)deleteACellFromDbWithId:(int)bookId{
    
    sqlite3 *sql3=[NSConnection createDB];//类似单例 的指针型
    
    NSString *sql=[NSString stringWithFormat:@"delete from book where bookid=%d",bookId ];
    
    sqlite3_stmt *st;
    if (sqlite3_prepare_v2(sql3, [sql UTF8String], -1, &st, nil)==SQLITE_OK) {
        if (sqlite3_step(st)==SQLITE_ERROR) {
            NSLog(@"error:failed in kit delete database");
        }
        
    }else{
        
        NSLog(@"sql语法错误");
    }
    sqlite3_finalize(st);
    
}
*/

@end
