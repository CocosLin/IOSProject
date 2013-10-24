//
//  UserManager.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "UserManager.h"
#import "SVProgressHUD.h"
@implementation UserManager
//单例实现
SINGLETON_FOR_CLASS_Implementation(UserManager)
- (id)init
{
    if (self = [super init])
    {
        //保留这个对象,不然如果在回调方法后释放了，回调方法就不可用!!!
//        _service = [[UserService alloc]init];
        _serverKit = [[HBServerKit alloc]init];

    } return self;
}
#pragma mark - 得到用户头像
-(void)getUserPhotoImageWithStrUserPhotoUrl:(NSString *)strUserPhotoUrl
                                  GotResult:(void(^)(UIImage *imgUserPhoto, BOOL isOK))callback
{
    strUserPhotoUrl = [strUserPhotoUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    [_serverKit getUserPhotoImageWithStrUserPhotoUrl:strUserPhotoUrl GotResult:^(UIImage *imgUserPhoto, WError *myError)
     {
         if (!myError) {
             callback(imgUserPhoto,YES);
         }else
         {
             Mark_Custom;
             NSLog(@"errorIOS:%@",myError.wErrorIOS.description);
             NSLog(@"error:%@",myError.wErrorDescription);
             callback(nil,NO);
         }
     }];
}
#pragma mark - 登录
/*登录逻辑:
 1.先检查用户名和密码输入问题
 2.网络请求数据
 */
-(void)loggingWithLoggingInfo:(UserLoggingInfo *)loggingInfo
                 WbLoggedInfo:(WbLoggedInfo)callback
{
    UserLoggingInfo * userLoggingInfo = [loggingInfo retain];//保存一份loggingInfo
    [SVProgressHUD showWithStatus:@"正在登录,请稍后..." maskType:4];
    //验证用户名和密码输入是否有问题
    NSString * strError = [self getStrErrorJudgeUsername:userLoggingInfo.username Password:userLoggingInfo.password];
    if (!strError) {
        WDataParse * wdp = [WDataParse sharedWDataParse];
        [_serverKit loggingWithUsername:userLoggingInfo.username
                        Md5PasswordUp:[[wdp wMd5HexDigest:userLoggingInfo.password] uppercaseString]
                          VersionCode:@"9999"
                           GotJsonDic:^(NSDictionary * dicUserLogged, WError *myError)
         {
             if (myError) {
                 callback(nil,NO);
                 [SVProgressHUD dismissWithIsOk:NO String:myError.wErrorDescription];//显示出结果
             }else
             {
                 UserLoggedInfo * loggedInfo = [[UserLoggedInfo alloc]initForAllJsonDataTypeWithDicFromJson:dicUserLogged];//获得cookie 、organizations、serverDate、user
                 [SVProgressHUD dismissWithIsOk:YES String:@"登录成功"];//显示出结果
                 callback(loggedInfo,YES);
                 [loggedInfo release];
             }
        }];
    }else//用户名和密码验证有错误信息
    {
        [SVProgressHUD dismissWithIsOk:!!strError String:strError];//显示出结果
        callback(nil,NO);
    }
    [userLoggingInfo release];//释放刚刚保存的loggingInfo
}

-(void)loggingWithUsername:(NSString *)username
             Md5PasswordUp:(NSString *)md5PassUp
               GotLoggedOk:(void(^)(BOOL isLoggedOk))callback
{
        [_serverKit loggingWithUsername:username
                          Md5PasswordUp:md5PassUp
                            VersionCode:@"9999"
                             GotJsonDic:^(NSDictionary * dicUserLogged, WError *myError)
         {
            if (myError)
            {
                 callback(NO);
            }else
             {
                 UserLoggedInfo * loggedInfo = [[UserLoggedInfo alloc] initForAllJsonDataTypeWithDicFromJson:dicUserLogged];
                 /*
                  这边要得到用户信息。。。
                  */
                 GetCommonDataModel;
                 comData.cookie = loggedInfo.cookie;
                 comData.isLogged = YES;
                 comData.serverDate = loggedInfo.serverDate;
                 UserModel * user = [[UserModel alloc] initForAllJsonDataTypeWithDicFromJson:loggedInfo.user];
                 comData.userModel = user;
                 
                 Organization * organizationInfo = [[[Organization alloc]initForAllJsonDataTypeWithDicFromJson:[loggedInfo.organizations lastObject]]autorelease];
                 comData.organization = organizationInfo;
                 [user release];

                 callback(YES);
                 [loggedInfo release];
             }
         }];
}

#pragma mark -判断用户名和密码
-(NSString *)getStrErrorJudgeUsername:(NSString *)username Password:(NSString *)password
{
    if (!username||!password) {
        return @"用户名和密码不能为空!";
    }
    NSString * usernameR = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * passwordR = [password stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([usernameR length]==0 || [passwordR length]==0) {
        return @"用户名和密码不能为空\n且不能为全空格!";
    }
    return nil;
}
@end
