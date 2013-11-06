//
//  HBServerKit.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "HBServerKit.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"

//typedef NS_ENUM(NSInteger, ETypeReport)
//{
//    ETypeReport
//};

#define REPORT_ID @"reportId"
#define BEGIN_DATE @"beginDate"
#define END_DATE @"endDate"
#define FIRST @"first"
#define MAX_RecordCount @"max"
#define REPORT_TYPE @"reportType"

#define USERNAME @"username"
#define ORGANIZATION_ID @"organizationId"
#define ORGUNIT_ID @"orgunitId"
#define INVALID_COOKIE @"invalidCookie"

@interface HBServerKit ()
{
    NSString * _cookie;
}
@end

@implementation HBServerKit
- (id)init
{
    if (self = [super init]) {
        GetCommonDataModel;
        _cookie = [comData.cookie copy];
    }return self;
}
#pragma mark - 得到用户头像
-(void)getUserPhotoImageWithStrUserPhotoUrl:(NSString *)strUserPhotoUrl
                                  GotResult:(void(^)(UIImage *imgUserPhoto, WError * myError))callback
{
    WDataService * wds = [WDataService sharedWDataService];
    [wds wPostRequestWithIsAsynchronous:YES
                                    Url:[NSURL URLWithString:strUserPhotoUrl]
                           DicPostDatas:nil
                              GetResult:^(NSData * dataRespose, NSError * errorRequest)
     {
         if (!errorRequest)
         {
             UIImage *imgPhoto = [UIImage imageWithData:dataRespose];
             callback(imgPhoto,nil);
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests wErrorDescription:@"加载图片出错,检查网络后重试!"];
             error.wErrorIOS = errorRequest;
             callback(nil,error);
             [error release];
         }
     }];
}

#pragma mark -- 获得汇报图片
- (NSString *) getImgStringWith:(NSString *)jsonStr{
    WDataParse *wdParse = [WDataParse sharedWDataParse];
    NSDictionary *dic = [wdParse wGetDicJsonWithStringJson:jsonStr];
    NSLog(@"汇报图片字典 == %@ ",dic);
    NSArray *getArr = [dic objectForKey:@"imageUrl"];
    if (getArr.count) {
        NSDictionary *dic2 = [getArr objectAtIndex:0];
        NSString *url = [dic2 objectForKey:@"url"];
        NSLog(@"图片url == %@",url);
        return url;
    }
    return nil;
}
#pragma mark -- 获得汇报声音
- (NSString *) getSoundStringWith:(NSString *)jsonStr{
    WDataParse *wdParse = [WDataParse sharedWDataParse];
    NSDictionary *dic = [wdParse wGetDicJsonWithStringJson:jsonStr];
    NSLog(@"汇报声音字典 == %@ ",dic);
    NSArray *getArr = [dic objectForKey:@"soundUrl"];
    if (getArr.count) {
        NSDictionary *dic2 = [getArr objectAtIndex:0];
        NSString *url = [dic2 objectForKey:@"url"];
        NSLog(@"声音url == %@",url);
        return url;
    }
    return nil;
}
#pragma mark - 信息
#pragma mark -- 公司公告 部门公告 消息通知
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                   FirstReportRecord:(NSInteger)firstReportRecord
                     MaxReportRecord:(NSInteger)maxCountReportRecord
                       GotArrReports:(void(^)(NSArray *arr,WError * myError))callback{
    NSLog(@"HBServerKit == 获得公司公告");
    NSString * strPortReport = [NSString stringWithFormat:@"%@/report/organizationNews",self.strBaseUrl];
    NSLog(@"HBSserverKit == 获取数据公司公告 %@",strPortReport);
    NSMutableDictionary * dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:[NSNumber numberWithInteger:organizationId] forKey:ORGANIZATION_ID];
    [dicParams setObject:[NSNumber numberWithInteger:firstReportRecord] forKey:FIRST];
    [dicParams setObject:[NSNumber numberWithInteger:maxCountReportRecord] forKey:MAX_RecordCount];
    WDataService * wds = [WDataService sharedWDataService];
    WDataParse *wdp = [WDataParse sharedWDataParse];
    //使用字典向http://59.57.15.168:6363/report/saveReport存储数据
    [wds wPostRequestWithIsAsynchronous:YES
                                    Url:[NSURL URLWithString:strPortReport]
                           DicPostDatas:dicParams
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
     {
         if (!errorRequest){
             [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
             Body * body = [self getBodyWithDataResponse:dataResponse];
             if (body.success)//如果查公告成功
             {
                 NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
                 callback(arrReportsGot,nil);
             }else//如果查公告不成功
             {
                 WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                 Mark_Custom;
                 NSLog(@"HBServerKit 查公告不成功 %@",error.wErrorDescription);
                 callback(nil,error);
                 [error release];
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"%@",error.wErrorCode);
             callback(nil,error);
             [error release];
         }
    }];
}



#pragma mark - 用户操作
#pragma mark -登录
-(void)loggingWithUsername:(NSString *)username
             Md5PasswordUp:(NSString *)md5PassUp
               VersionCode:(NSString *)versionCode
                GotJsonDic:(void(^)(NSDictionary * dicUserLogged,WError * myError))callback
{
    NSLog(@"HBServerKit name=%@  |  md5PassUp=%@  |  versionCode=%@",username,md5PassUp,versionCode);
    
    NSLog(@"HBServerKit strBaseUrl == %@",self.strBaseUrl);
    NSMutableDictionary * dicParam = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParam setObject:username forKey:@"username"];
    [dicParam setObject:md5PassUp forKey:@"password"];
    [dicParam setObject:versionCode forKey:@"versionCode"];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    WDataService * wds = [WDataService sharedWDataService];
    [wds wPostRequestWithIsAsynchronous:YES
                                    Url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/util/login",self.strBaseUrl]]
                           DicPostDatas:dicParam
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
     {
         if (!errorRequest){
             [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];
             NSString *responseStrFromDic = [[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding];
             NSLog(@"HBServerKit 来自服务器的完整数据 strOfdataResponse == %@",responseStrFromDic);
             Body * body = [self getBodyWithDataResponse:dataResponse];
             if (body.success)//如果登录成功
             {
                 NSDictionary * dicUserLogged = [wdp wGetDicJsonWithStringJson:body.data];
                 NSLog(@"HBServerKit 只取Body部分的数据内容 dicUserLogged == %@",dicUserLogged);
                 callback(dicUserLogged,nil);
             }else//如果登录不成功
             {
                 WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                 Mark_Custom;
                 NSLog(@"%@",error.wErrorDescription);
                 callback(nil,error);
                 [error release];
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"%@",error.wErrorCode);
             callback(nil,error);
             [error release];
         }
     }];
}

-(void)loggingWithUsername:(NSString *)username
             Md5PasswordUp:(NSString *)md5PassUp
               VersionCode:(NSString *)versionCode
                GotIsLogged:(void(^)(bool isLogged))callback
{
    NSLog(@"HBServerk md5PassUp == %@",md5PassUp);
    NSMutableDictionary * dicParam = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParam setObject:username forKey:@"username"];
    [dicParam setObject:md5PassUp forKey:@"password"];
    [dicParam setObject:versionCode forKey:@"versionCode"];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    WDataService * wds = [WDataService sharedWDataService];
    [wds wPostRequestWithIsAsynchronous:YES
                                    Url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/util/login",self.strBaseUrl]]
                           DicPostDatas:dicParam
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
     {
         if (!errorRequest){
             [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];
             
             Body * body = [self getBodyWithDataResponse:dataResponse];
             if (body.success)//如果登录成功
             {
                 NSDictionary * dicUserLogged = [wdp wGetDicJsonWithStringJson:body.data];
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
             }else//如果登录不成功
             {
                 WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                 Mark_Custom;
                 NSLog(@"%@",error.wErrorDescription);
                 [error release];
                 callback(NO);
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"%@",error.wErrorCode);
             [error release];
             callback(NO);
         }
     }];
}
#pragma mark  记录查询
#pragma mark -- 查询用户所在部门
-(void)findUserOrganizationId:(NSInteger)organizationId
                     UserName:(NSString *)userName
                GotArrReports:(WbReportJsonArr)callback{
    NSString * strPortReport = [NSString stringWithFormat:@"%@/organization/orgunitByUsername",self.strBaseUrl];
    NSLog(@"HBSserverKit == 用户所在部门url %@",strPortReport);
    NSMutableDictionary * dicParams = [NSMutableDictionary dictionaryWithCapacity:6];
    [dicParams setObject:[NSNumber numberWithInteger:organizationId] forKey:ORGANIZATION_ID];
    [dicParams setObject:userName forKey:@"username"];
    [dicParams setObject:_cookie forKey:@"cookie"];
    WDataService * wds = [WDataService sharedWDataService];
    WDataParse *wdp = [WDataParse sharedWDataParse];
    
    [wds wPostRequestWithIsAsynchronous:YES
                                    Url:[NSURL URLWithString:strPortReport]
                           DicPostDatas:dicParams
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
     {
         if (!errorRequest){
             [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
             NSLog(@"HBServerKit 从服务端获得的完整json格式数据 == %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
             Body * body = [self getBodyWithDataResponse:dataResponse];
             NSLog(@"HBServerKit 完整数据之中取得body %@",body);
             if (body.success)//如果查汇报成功
             {
                 NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
                 NSLog(@"HBServerKit 从body取得data == %@",arrReportsGot);
                 callback(arrReportsGot,nil);
             }else//如果查汇报不成功
             {
                 WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                 Mark_Custom;
                 NSLog(@"%@",error.wErrorDescription);
                 callback(nil,error);
                 [error release];
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"%@",error.wErrorCode);
             callback(nil,error);
             [error release];
         }
     }];
}


#pragma mark --查询公司的部门列表
//http://hb.m.gitom.com/3.0/organization/rootOrgunits?organizationId=114&voidFlag=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                       GotArrReports:(WbReportJsonArr)callback
{
    NSString * strPortReport = [NSString stringWithFormat:@"%@/organization/rootOrgunits",self.strBaseUrl];
    NSLog(@"HBSserverKit == 获取查询公司的部门列表url %@",strPortReport);
    NSMutableDictionary * dicParams = [NSMutableDictionary dictionaryWithCapacity:6];
    [dicParams setObject:[NSNumber numberWithInteger:organizationId] forKey:ORGANIZATION_ID];
    [dicParams setObject:[NSNumber numberWithInteger:1] forKey:@"voidFlag"];
    [dicParams setObject:_cookie forKey:@"cookie"];
    WDataService * wds = [WDataService sharedWDataService];
    WDataParse *wdp = [WDataParse sharedWDataParse];
    
    [wds wPostRequestWithIsAsynchronous:YES
                                    Url:[NSURL URLWithString:strPortReport]
                           DicPostDatas:dicParams
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
     {
         if (!errorRequest){
             [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
             NSLog(@"HBServerKit 从服务端获得的完整json格式数据 == %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
             Body * body = [self getBodyWithDataResponse:dataResponse];
             NSLog(@"HBServerKit 完整数据之中取得body %@",body);
             if (body.success)//如果查汇报成功
             {
                 NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
                 NSLog(@"HBServerKit 从body取得data == %@",arrReportsGot);
                 callback(arrReportsGot,nil);
             }else//如果查汇报不成功
             {
                 WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                 Mark_Custom;
                 NSLog(@"%@",error.wErrorDescription);
                 callback(nil,error);
                 [error release];
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"%@",error.wErrorCode);
             callback(nil,error);
             [error release];
         }
     }];
}

#pragma mark -- 查看部门打卡(整个部门、个人:打卡) orgunitAttendance  userAttendance
//http://hb.m.gitom.com/3.0/attendance/orgunitAttendance?organizationId=114&orgunitId=1&beginDate=1279865600000&endDate=1379951999000&first=0&max=150&cookie=5533098A-43F1-4AFC-8641-E64875461345
//http://hb.m.gitom.com/3.0/attendance/userAttendance?organizationId=114&orgunitId=1&username=90261&beginDate=1279865600000&endDate=1379951999000&first=0&max=150&cookie=5533098A-43F1-4AFC-8641-E64875461345&reportType=REPORT_TYPE_GO_OUT
-(void)findAttendanceReportsOfMembersWithOrganizationId:(NSInteger)organizationId
                                              orgunitId:(NSInteger)orgunitId
                                      orgunitAttendance:(BOOL)yesOrNo
                                               userName:(NSInteger)userName
                                           BeginDateLli:(long long int)beginDateLli
                                             EndDateLli:(long long int)endDateLli
                                      FirstReportRecord:(NSInteger)firstReportRecord
                                        MaxReportRecord:(NSInteger)maxCountReportRecord
                                          GotArrReports:(WbReportJsonArr)callback{
    NSString *urlString = [[[NSString alloc]init]autorelease];
    
    if (yesOrNo == YES) {
        urlString = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/attendance/orgunitAttendance?organizationId=%@&orgunitId=%@&beginDate=%lld&endDate=%lld&first=0&max=150&cookie=%@",[NSNumber numberWithInteger:organizationId],[NSNumber numberWithInteger:orgunitId],beginDateLli,endDateLli,_cookie];
        NSLog(@"HBServerKit 部门打卡 urlString == %@",urlString);
    }else{
        urlString = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/attendance/userAttendance?organizationId=%@&orgunitId=%@&username=%@&beginDate=%lld&endDate=%lld&first=0&max=150&cookie=%@&reportType=REPORT_TYPE_GO_OUT",[NSNumber numberWithInteger:organizationId],[NSNumber numberWithInteger:orgunitId],[NSNumber numberWithInteger: userName],beginDateLli,endDateLli,_cookie];
        NSLog(@"HBServerKit 个人打卡 urlString == %@",urlString);
    }

    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSData *dataResponse = [req responseData];
        NSLog(@"部门汇报(整个部门打卡) == %@",[req responseString]);
        
        WDataParse *wdp = [WDataParse sharedWDataParse];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 部门汇报(整个部门打卡)== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 部门汇报(整个部门打卡) %@",body);
        NSLog(@"body.success == %c",body.success);
        if (body.success)//如果查汇报成功
        {
            NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
            NSLog(@"HBServerKit 从body取得data 部门汇报(整个部门打卡)== %@",arrReportsGot);
            callback(arrReportsGot,nil);
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            NSLog(@"部门汇报(整个部门打卡) ERROR == %@",error.wErrorDescription);
            callback(nil,error);
            [error release];
        }
    }];
    [req startAsynchronous];
}


#pragma mark -- 查看部门汇报(整个部门:上班、出差)
//http://hb.m.gitom.com/3.0/report/findOrgunitReports?organizationId=114&orgunitId=1&beginDate=1379865600000&endDate=1389951999000&first=0&max=150&cookie=5533098A-43F1-4AFC-8641-E64875461345&reportType=REPORT_TYPE_DAY_REPORT
//http://hb.m.gitom.com/3.0/report/findOrgunitReports?organizationId=114&orgunitId=1&beginDate=1379865600000&endDate=1389951999000&first=0&max=30&cookie=5533098A-43F1-4AFC-8641-E64875461345&reportType=REPORT_TYPE_GO_OUT
//http://hb.m.gitom.com/3.0/report/findOrgunitReports?organizationId=114&orgunitId=1&beginDate=1379865600000&endDate=1389951999000&first=0&max=150&cookie=5533098A-43F1-4AFC-8641-E64875461345&reportType=REPORT_TYPE_TRAVEL
-(void)findOrgunitReportsOfMembersWithOrganizationId:(NSInteger)organizationId
                                           orgunitId:(NSInteger)orgunitId
                                          ReportType:(NSString *)reportType
                                        BeginDateLli:(long long int)beginDateLli
                                          EndDateLli:(long long int)endDateLli
                                   FirstReportRecord:(NSInteger)firstReportRecord
                                     MaxReportRecord:(NSInteger)maxCountReportRecord
                                       GotArrReports:(WbReportJsonArr)callback{
    NSString *urlString = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/report/findOrgunitReports?organizationId=%@&orgunitId=%@&beginDate=%lld&endDate=%lld&first=0&max=150&cookie=%@&&reportType=%@",[NSNumber numberWithInteger:organizationId],[NSNumber numberWithInteger:orgunitId],beginDateLli,endDateLli,_cookie,reportType];
    NSLog(@"HBServerKit urlString == %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSData *dataResponse = [req responseData];
        NSLog(@"部门汇报(整个部门) == %@",[req responseString]);
        
        WDataParse *wdp = [WDataParse sharedWDataParse];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 部门汇报(整个部门)== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 部门汇报(整个部门) %@",body);
        NSLog(@"body.success == %c",body.success);
        if (body.success)//如果查汇报成功
        {
            NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
            NSLog(@"HBServerKit 从body取得data 部门汇报(整个部门)== %@",arrReportsGot);
            callback(arrReportsGot,nil);
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            NSLog(@"部门汇报(整个部门) ERROR == %@",error.wErrorDescription);
            callback(nil,error);
            [error release];
        }
    }];
    [req startAsynchronous];
}


#pragma mark -- 获取公司、部门公告
-(void)getNewsWithOrganizationId:(NSInteger)organizationId
                       orgunitId:(NSInteger)orgunitId
                        newsType:(NSString *)newsType
                   GotArrReports:(WbReportJsonArr)callback{
    //http://hb.m.gitom.com/3.0/organization/organizationNews?organizationId=%ld&orgunitId=%ld&first=0&max=1&cookie=%@
    
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/%@?organizationId=%ld&orgunitId=%ld&first=0&max=1&cookie=%@",newsType,(long)organizationId,(long)orgunitId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setDelegate:self];
    //[req startSynchronous];
    
    [req setCompletionBlock:^{
        NSData *dataResponse = [req responseData];
        NSLog(@"获取公司、部门公告 setCompletionBlock: == %@",[req responseString]);
        WDataParse *wdp = [WDataParse sharedWDataParse];
        //[self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 获取公司、部门公告== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 获取公司、部门公告 %@",body);
        NSLog(@"body.success == %c",body.success);
        if (body.success)//如果查汇报成功
        {
            NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
            NSLog(@"HBServerKit 从body取得data 获取公司、部门公告== %@",arrReportsGot);
            callback(arrReportsGot,nil);
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            NSLog(@"获取公司、部门公告 ERROR == %@",error.wErrorDescription);
            callback(nil,error);
            [error release];
        }
    }];
    [req startAsynchronous];
    
}

#pragma mark -查询申请
//http://hb.m.gitom.com/3.0/organization/applys?organizationId=114&orgunitId=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
-(void)findApplyWithOrganizationId:(NSInteger)organizationId
                         orgunitId:(NSInteger)orgunitId
                     GotArrReports:(WbReportJsonArr)callback{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/applys?organizationId=%d&orgunitId=%d&cookie=%@",organizationId,orgunitId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSData *dataResponse = [req responseData];
        NSLog(@"加入申请 == %@",[req responseString]);
        
        
        WDataParse *wdp = [WDataParse sharedWDataParse];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 加入申请== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 加入申请 %@",body);
        NSLog(@"body.success == %c",body.success);
        if (body.success)//如果查汇报成功
        {
            NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
            NSLog(@"HBServerKit 从body取得data 加入申请== %@",arrReportsGot);
            callback(arrReportsGot,nil);
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            NSLog(@"加入申请 ERROR == %@",error.wErrorDescription);
            callback(nil,error);
            [error release];
        }
    }];
    [req startAsynchronous];
}

#pragma mark - 获取考勤配置
//http://hb.m.gitom.com/3.0/attendance/attendanceConfig?organizationId=204&orgunitId=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
-(void)getAttendanceConfigWithOrganizationId:(NSInteger)organizationId
                                   orgunitId:(NSInteger)orgunitId
                               GotDicReports:(void(^)(NSDictionary * dicAttenConfig))callback{
    [SVProgressHUD showWithStatus:@"获取考勤配置……"];
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/attendance/attendanceConfig?organizationId=%d&orgunitId=%d&cookie=%@",organizationId,orgunitId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSData *dataResponse = [req responseData];
        NSLog(@"HBServerKit 从服务端获得的完整 获取考勤配置json == %@",[req responseString]);
        
        
        WDataParse *wdp = [WDataParse sharedWDataParse];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 获取考勤配置== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 获取考勤配置 %@",body);
        //NSLog(@"body.success == %c",body.success);
        if (body.success)//如果查汇报成功
        {
            NSDictionary * dicReportsGot = [wdp wGetDicJsonWithStringJson:body.data];
            [SVProgressHUD showSuccessWithStatus:@"获得考勤配置"];
            NSLog(@"HBServerKit 从body取得data 获取考勤配置== %@",dicReportsGot);
            callback(dicReportsGot);
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            NSLog(@"获取考勤配置 ERROR == %@",error.wErrorDescription);
            [SVProgressHUD showErrorWithStatus:@"未获得"];
            callback(nil);
            [error release];
        }
    }];
    [req startAsynchronous];
}

#pragma mark -- 部门的员工列表
//http://hb.m.gitom.com/3.0/user/findUsers?organizationId=114&orgunitId=1&voidFlag=1

-(void)findOrgunitMembersWithOrganizationId:(NSInteger)organizationId
                                  orgunitId:(NSInteger)orgunitId
                       GotArrReports:(WbReportJsonArr)callback
{
    NSString * strPortReport = [NSString stringWithFormat:@"%@/user/findUsers",self.strBaseUrl];
    NSLog(@"HBSserverKit == 获取查询部门员工url %@",strPortReport);
    NSMutableDictionary * dicParams = [NSMutableDictionary dictionaryWithCapacity:6];
    [dicParams setObject:[NSNumber numberWithInteger:organizationId] forKey:ORGANIZATION_ID];
    [dicParams setObject:[NSNumber numberWithInteger:orgunitId] forKey:ORGUNIT_ID];
    [dicParams setObject:[NSNumber numberWithInteger:1] forKey:@"voidFlag"];
    [dicParams setObject:_cookie forKey:@"cookie"];
    WDataService * wds = [WDataService sharedWDataService];
    WDataParse *wdp = [WDataParse sharedWDataParse];
    
    [wds wPostRequestWithIsAsynchronous:YES
                                    Url:[NSURL URLWithString:strPortReport]
                           DicPostDatas:dicParams
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
     {
         if (!errorRequest){
             [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
             NSLog(@"HBServerKit 从服务端获得的完整json格式数据 部门员工== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
             Body * body = [self getBodyWithDataResponse:dataResponse];
             NSLog(@"HBServerKit 完整数据之中取得body 部门员工 %@",body);
             if (body.success)//如果查汇报成功
             {
                 NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
                 NSLog(@"HBServerKit 从body取得data == %@",arrReportsGot);
                 callback(arrReportsGot,nil);
             }else//如果查汇报不成功
             {
                 WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                 Mark_Custom;
                 NSLog(@"%@",error.wErrorDescription);
                 callback(nil,error);
                 [error release];
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"%@",error.wErrorCode);
             callback(nil,error);
             [error release];
         }
     }];
}

#pragma mark - 汇报相关
#pragma mark -- 获得汇报记录(单个员工)
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                           OrgunitId:(NSInteger)orgunitId
                            Username:(NSString *)username
                          ReportType:(NSString *)typeReport
                        BeginDateLli:(long long int)beginDateLli
                          EndDateLli:(long long int)endDateLli
                   FirstReportRecord:(NSInteger)firstReportRecord
                     MaxReportRecord:(NSInteger)maxCountReportRecord
                       GotArrReports:(WbReportJsonArr)callback
{
    NSLog(@"HBSserverKit 汇报相关== organizationId:%ld | orgunitId:%ld | username:%@ | typeReport:%@  |  beginDateLli:%lld  | endDateLli:%lld  |  firstReportRecord:%ld  | maxCountReportRecord:%ld  ",(long)organizationId,(long)orgunitId,username,typeReport,beginDateLli,endDateLli,(long)firstReportRecord,(long)maxCountReportRecord);
    NSString * strPortReport = [NSString stringWithFormat:@"%@/report/findReports",self.strBaseUrl];
    NSLog(@"HBSserverKit == 获取汇报记录数据 %@",strPortReport);
    NSMutableDictionary * dicParams = [NSMutableDictionary dictionaryWithCapacity:6];
    [dicParams setObject:[NSNumber numberWithInteger:organizationId] forKey:ORGANIZATION_ID];
    [dicParams setObject:[NSNumber numberWithInteger:orgunitId] forKey:ORGUNIT_ID];
    [dicParams setObject:username forKey:USERNAME];
    [dicParams setObject:typeReport forKey:REPORT_TYPE];
    [dicParams setObject:[NSNumber numberWithLongLong:beginDateLli] forKey:BEGIN_DATE];
    NSLog(@"[NSNumber numberWithLongLong:beginDateLli]  = %@",[NSNumber numberWithLongLong:beginDateLli]);
    [dicParams setObject:[NSNumber numberWithLongLong:endDateLli] forKey:END_DATE];
    [dicParams setObject:[NSNumber numberWithInteger:firstReportRecord] forKey:FIRST];
    [dicParams setObject:[NSNumber numberWithInteger:maxCountReportRecord] forKey:MAX_RecordCount];
    [dicParams setObject:_cookie forKey:@"cookie"];
    WDataService * wds = [WDataService sharedWDataService];
    WDataParse *wdp = [WDataParse sharedWDataParse];
    //使用字典向http://59.57.15.168:6363/report/saveReport存储数据
    [wds wPostRequestWithIsAsynchronous:YES
                                    Url:[NSURL URLWithString:strPortReport]
                           DicPostDatas:dicParams
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
     {
         if (!errorRequest){
             [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
             NSLog(@"HBServerKit 从服务端获得的完整json格式数据 == %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
             Body * body = [self getBodyWithDataResponse:dataResponse];
             NSLog(@"HBServerKit 完整数据之中取得body %@",body);
             if (body.success)//如果查汇报成功
             {
                 NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
                 NSLog(@"HBServerKit 从body取得data == %@",arrReportsGot);
                 callback(arrReportsGot,nil);
             }else//如果查汇报不成功
             {
                 WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                 Mark_Custom;
                 NSLog(@"%@",error.wErrorDescription);
                 callback(nil,error);
                 [error release];
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"%@",error.wErrorCode);
             callback(nil,error);
             [error release];
         }
     }];
}

#pragma mark -- 保存打卡记录
//http://hb.m.gitom.com/3.0/attendance/saveAttendance?organizationId=204&orgunitId=1&username=58200&longitude=118.584221&latitude=24.799120&cookie=5533098A-43F1-4AFC-8641-E64875461345&punchType=onPunch
- (void) savePlayCardWithOrganizationId:(NSInteger)organizationId
                              OrgunitId:(NSInteger)orgunitId
                               Username:(NSString *)username
                             PunchType:(NSString *)punchType
                           Longitude:(CGFloat)longitude
                             Latitude:(CGFloat)latitude
                          GotArrReports:(WbReportJsonArr)callback{
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/attendance/saveAttendance?organizationId=%ld&orgunitId=%ld&username=%@&longitude=%f&latitude=%f&cookie=%@&punchType=%@",(long)organizationId,(long)orgunitId,username,longitude,latitude,_cookie,punchType];
    [SVProgressHUD showWithStatus:@"打卡…"];
    NSLog(@"HBServerKit 保存打卡记录 urlStr == %@",urlStr);
    ASIHTTPRequest *req = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [req setCompletionBlock:^{
        NSLog(@"%@",req.responseString);
        NSData *dataResponse = [req responseData];
        
        WDataParse *wdp = [WDataParse sharedWDataParse];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 保存打卡记录== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 保存打卡记录 %@",body);
        NSLog(@"body.success == %c",body.success);
        if (body.success)//如果查汇报成功
        {
            NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
            NSLog(@"HBServerKit 从body取得data 保存打卡记录 == %@",arrReportsGot);
            [SVProgressHUD showSuccessWithStatus:body.note duration:0.6];
            callback(arrReportsGot,nil);
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            NSLog(@"保存打卡记录 ERROR == %@",error.wErrorDescription);
            [SVProgressHUD showErrorWithStatus:body.warning duration:0.6];
            callback(nil,error);
            [error release];
        }
    }];
    [req startAsynchronous];
}


#pragma mark -- 保存上传图片
-(void)saveImageReportsOfMembersWithData:(NSString *)imgData
                           GotArrReports:(WbReportJsonArr)callback{
    NSString *urlString = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/util/fileUpload?cookie=%@",_cookie];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request addFile:imgData forKey:@"file"];
    [request setPostValue:[NSNumber numberWithInt:200] forKey:@"width"];
    [request setPostValue:[NSNumber numberWithInt:200] forKey:@"height"];
    NSLog(@"request url == %@",request);
    NSLog(@"_cookie == %@",_cookie);

    [request setCompletionBlock:^{
        
        NSLog(@"%@",request.responseString);
        NSData *dataResponse = [request responseData];
        
        WDataParse *wdp = [WDataParse sharedWDataParse];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 保存上传图片== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 保存上传图片 %@",body);
        NSLog(@"body.success == %c",body.success);
        if (body.success)//如果查汇报成功
        {
            NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
            NSLog(@"HBServerKit 从body取得data 保存上传图片 == %@",arrReportsGot);
            callback(arrReportsGot,nil);
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            NSLog(@"保存上传图片 ERROR == %@",error.wErrorDescription);
            callback(nil,error);
            [error release];
        }

    }];
    
    [request setFailedBlock:^{
        
        NSLog(@"asi error: %@",request.error.debugDescription);
        
    }];
    
    [request startAsynchronous];
    
}

#pragma mark -- 保存上传汇报数据
-(void)saveReportWithOrganizationId:(NSInteger)organizationId
                          OrgunitId:(NSInteger)orgunitId
                           Username:(NSString *)username
                         ReportType:(NSString *)reportType
                               Note:(NSString *)note
                            Address:(NSString *)address
                             ImgUrl:(NSString *)imgUrl
                           SoundUrl:(NSString *)soundUrl
                          Longitude:(double)longitude
                           Latitude:(double)latitude
                  GotIsSaveReportOk:(WbReportSave)callback
{
    NSString * strPortReport = [NSString stringWithFormat:@"%@/report/saveReport",self.strBaseUrl];
    NSLog(@"HBServerKit 存储数据 == %@",strPortReport);
    NSMutableDictionary * dicParams = [NSMutableDictionary dictionaryWithCapacity:10];
    [dicParams setObject:[NSNumber numberWithInteger:organizationId] forKey:@"organizationId"];
    [dicParams setObject:[NSNumber numberWithInteger:orgunitId] forKey:@"orgunitId"];
    if (username) [dicParams setObject:username forKey:@"username"];
    if (reportType) [dicParams setObject:reportType forKey:@"reportType"];
    if (address) [dicParams setObject:address forKey:@"address"];
    if (note) [dicParams setObject:note forKey:@"note"];
    if (!imgUrl){
        NSLog(@"imgeUrl nil");
        imgUrl = @"{\"imageUrl\":[]}";
    }else{
        
    }
    [dicParams setObject:imgUrl forKey:@"imgUrl"];
    if (!soundUrl) soundUrl = @"{\"soundUrl\":[]}";
    [dicParams setObject:soundUrl forKey:@"soundUrl"];
    [dicParams setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [dicParams setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [dicParams setObject:_cookie forKey:@"cookie"];
//    WDataParse *wdp = [WDataParse sharedWDataParse];
    WDataService * wds = [WDataService sharedWDataService];
    [wds wPostRequestWithIsAsynchronous:YES Url:[NSURL URLWithString:strPortReport] DicPostDatas:dicParams
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
    {
        if (!errorRequest){
            [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
            Body * body = [self getBodyWithDataResponse:dataResponse];
            if (body.success)//如果保存汇报成功
            {
                NSLog(@"保存汇报成功 == %@",body.data);
//                NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
                callback(YES,nil);
            }else//如果查汇报不成功
            {
                NSLog(@"汇报不成功");
                WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                Mark_Custom;
                NSLog(@"%@",error.wErrorDescription);
                callback(NO,error);
                [error release];
            }
        }else
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
            Mark_Custom;
            NSLog(@"HBServeKit == %@",error.wErrorCode);
            callback(NO,error);
            [error release];
        }
    }];

}

#pragma mark - 发布部门消息
-(void)saveReportWithOrganizationId:(NSInteger)organizationId
                          OrgunitId:(NSInteger)orgunitId
                           Username:(NSString *)username
                              Title:(NSString *)title
                            Content:(NSString *)content
                  GotIsSaveReportOk:(WbReportSave)callback{
    NSString * strPortReport = [NSString stringWithFormat:@"%@/organization/saveNews",self.strBaseUrl];
    NSLog(@"HBServerKit 发布部门消息用到接口 == %@",strPortReport);
    NSMutableDictionary * dicParams = [NSMutableDictionary dictionaryWithCapacity:10];
    [dicParams setObject:[NSNumber numberWithInteger:1] forKey:@"newsType"];
    [dicParams setObject:[NSNumber numberWithInteger:organizationId] forKey:@"organizationId"];
    [dicParams setObject:[NSNumber numberWithInteger:orgunitId] forKey:@"orgunitId"];
    if (username) [dicParams setObject:username forKey:@"username"];
    if (title) [dicParams setObject:title forKey:@"title"];
    if (content) [dicParams setObject:content forKey:@"content"];
    [dicParams setObject:_cookie forKey:@"cookie"];
    //    WDataParse *wdp = [WDataParse sharedWDataParse];
    WDataService * wds = [WDataService sharedWDataService];
    [wds wPostRequestWithIsAsynchronous:YES Url:[NSURL URLWithString:strPortReport] DicPostDatas:dicParams
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
     {
         if (!errorRequest){
             [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
             Body * body = [self getBodyWithDataResponse:dataResponse];
             if (body.success)//如果保存汇报成功
             {
                 NSLog(@"保存汇报成功 == %@",body.data);
                 //                NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
                 callback(YES,nil);
             }else//如果查汇报不成功
             {
                 NSLog(@"汇报不成功");
                 WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                 Mark_Custom;
                 NSLog(@"%@",error.wErrorDescription);
                 callback(NO,error);
                 [error release];
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"HBServeKit == %@",error.wErrorCode);
             callback(NO,error);
             [error release];
         }
     }];
}

//http://hb.m.gitom.com/3.0/organization/deleteOrgunit?organizationId=000&orgunitId=000&updateUser=58200&cookie=5533098A-43F1-4AFC-8641-E64875461345
#pragma mark -- 删除部门
- (void)deleteOrgunitWithOrganizationId:(NSInteger)organizationId
                           andOrgunitId:(NSInteger)orgunitId
                          andUpdateUser:(NSString *)updateUser{
    NSString *releaseUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/deleteOrgunit?organizationId=%d&orgunitId=%d&updateUser=%@&cookie=%@",organizationId,orgunitId,updateUser,_cookie];
    NSLog(@"删除部门 url == %@",releaseUrlStr);
    NSURL *url = [NSURL URLWithString:releaseUrlStr];
    ASIHTTPRequest *req = [[ASIHTTPRequest alloc]initWithURL:url];
    [req startAsynchronous];
    [req release];
}

#pragma mark -- 转移部门
//http://hb.m.gitom.com/3.0/organization/moveOrgunitUser?organizationId=204&orgunitId=1&tarOrgunitId=1&username=58200&updateUser=58200&cookie=5533098A-43F1-4AFC-8641-E64875461345
- (void)changeMemberToOtherOrgWihtOrganizationId:(NSInteger)organizationId
                                    andOrgunitId:(NSString *)orgunitId
                                 andTarOrgunitId:(NSString *)tarOrgunitId
                                     andUserName:(NSString *)userName
                                   andUpdateUser:(NSString *)updateUser{
    NSString *releaseUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/moveOrgunitUser?organizationId=%d&orgunitId=%@&tarOrgunitId=%@&username=%@&updateUser=%@&cookie=%@",organizationId,orgunitId,tarOrgunitId,userName,updateUser,_cookie];
    NSLog(@"转移部门 url == %@",releaseUrlStr);
    NSURL *url = [NSURL URLWithString:releaseUrlStr];
    ASIHTTPRequest *req = [[ASIHTTPRequest alloc]initWithURL:url];
    [req startAsynchronous];
    [req release];
}
#pragma mark - 考勤
//得到考勤配置(工作时间段，考勤距离，公司坐标等)
-(void)getAttendanceConfigWithOrganizationID:(NSInteger)organizationId
                                   OrgunitID:(NSInteger)orgunitID
                              GotAttenConfig:(void(^)(NSDictionary * dicAttenConfig))callback
{
    NSString * strPortReport = [NSString stringWithFormat:@"%@/attendance/attendanceConfig",self.strBaseUrl];
    NSMutableDictionary * dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:[NSNumber numberWithInteger:organizationId] forKey:@"organizationId"];
    [dicParams setObject:[NSNumber numberWithInteger:orgunitID] forKey:@"orgunitId"];
    if (_cookie) [dicParams setObject:_cookie forKey:@"cookie"];
    WDataService * wds = [WDataService sharedWDataService];
    [wds wPostRequestWithIsAsynchronous:YES
                                    Url:[NSURL URLWithString:strPortReport]
                           DicPostDatas:dicParams
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
    {
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        Body * body = [self getBodyWithDataResponse:dataResponse];
        WDataParse * wdp = [WDataParse sharedWDataParse];
        if (body.success)
        {
            //得到公司配置信息
            NSDictionary * dic = [wdp wGetDicJsonWithStringJson:body.data];
            callback(dic);
        }else
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
            Mark_Custom;
            NSLog(@"%@",error.wErrorCode);
            callback(nil);
            [error release];
        }
    }];
}

#pragma mark - ServerBaseModel
//得到data对应的字符串
-(NSString *)getStrDataWithDataResponse:(NSData *)dataResponse
{
    NSString * strResponse = [[[NSString alloc]initWithData:dataResponse encoding:4] autorelease];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    NSDictionary * dicServerBase = [wdp wGetDicJsonWithStringJson:strResponse];
    ServerBaseModel * serverBaseModel = [[ServerBaseModel alloc]initForAllJsonDataTypeWithDicFromJson:dicServerBase];
    Body * body = [[Body alloc]initForAllJsonDataTypeWithDicFromJson:serverBaseModel.body];
    [serverBaseModel release];
    NSString * strData = body.data;
    [body release];
    return strData;
}
//生成 ServerBaseModel
-(ServerBaseModel *)getServerBaseModelWithDataResponse:(NSData *)dataResponse
{
    NSString * strResponse = [[[NSString alloc]initWithData:dataResponse encoding:4] autorelease];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    NSDictionary * dicServerBase = [wdp wGetDicJsonWithStringJson:strResponse];
    ServerBaseModel * modelBase = [[[ServerBaseModel alloc]initForAllJsonDataTypeWithDicFromJson:dicServerBase] autorelease];
    return modelBase;
}
// 生成 Body
-(Body *)getBodyWithDataResponse:(NSData *)dataResponse
{
    NSString * strResponse = [[[NSString alloc]initWithData:dataResponse encoding:4] autorelease];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    NSDictionary * dicServerBase = [wdp wGetDicJsonWithStringJson:strResponse];
    ServerBaseModel * serverBaseModel = [[ServerBaseModel alloc]initForAllJsonDataTypeWithDicFromJson:dicServerBase];
    Body * body = [[[Body alloc]initForAllJsonDataTypeWithDicFromJson:serverBaseModel.body]autorelease];
    [serverBaseModel release];
    return body;
}
// 生成 Head
-(Head *)getHeadWithDataResponse:(NSData *)dataResponse
{
    NSString * strResponse = [[[NSString alloc]initWithData:dataResponse encoding:4] autorelease];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    NSDictionary * dicServerBase = [wdp wGetDicJsonWithStringJson:strResponse];
    ServerBaseModel * serverBaseModel = [[ServerBaseModel alloc]initForAllJsonDataTypeWithDicFromJson:dicServerBase];
    Head * head = [[[Head alloc]initForAllJsonDataTypeWithDicFromJson:serverBaseModel.head]autorelease];
    [serverBaseModel release];
    return head;
}

//判断服务器是不是没有异常
-(BOOL)getIsServerNoErrorWithDicHead:(NSDictionary *)dicHead
{
    BOOL isOk = YES;
    if (!dicHead || dicHead.count == 0) return NO;
    Head * head = [[[Head alloc]initForAllJsonDataTypeWithDicFromJson:dicHead]autorelease];
    if (!head.success)
    {
        NSLog(@"服务器异常:\nversion:%@\ncause:%@",head.version,head.cause);
        isOk = NO;
    }else
    {
        isOk = YES;
    }
    return isOk;
}
-(BOOL)getIsServerNoErrorWithHead:(Head *)head
{
    BOOL isOk = YES;
    if (!head) return NO;
    if (!head.success)
    {
        if ([head.cause isEqualToString:INVALID_COOKIE]) {
            GetCommonDataModel;
            if (comData.isLogged) {
                NSString * username = comData.userModel.username;
                NSString * password = comData.userModel.password;
                [self loggingWithUsername:username Md5PasswordUp:password VersionCode:@"9999" GotIsLogged:^(bool isLogged) {
                    
                }];
            }
        }
        
        NSLog(@"服务器异常:\nversion:%@\ncause:%@",head.version,head.cause);
        isOk = NO;
    }else
    {
        isOk = YES;
    }
    return isOk;
}

-(void)dealloc
{
    [_cookie release];
    [super dealloc];
}

@end
