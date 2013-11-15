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
#import "WTool.h"
#import "OrganizationsModel.h"



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
    /*
    if (strUserPhotoUrl.length <1) {
        return;
    }
    NSArray *getImgNameAr = [strUserPhotoUrl componentsSeparatedByString:@"/"];
    NSString *key = [[NSString alloc]init];
    if (getImgNameAr.count<7){
        key = [getImgNameAr lastObject];
    }else{
        key = [getImgNameAr objectAtIndex:7];
    }
        
    NSLog(@"getImgName = %@",key);
    NSData *data = [FTWCache objectForKey:key];
	if (data) {
		UIImage *image = [UIImage imageWithData:data];
        callback(image,nil);
	} else {
        ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUserPhotoUrl]];
        [req setCompletionBlock:^{
            NSData *adata = [req responseData];
            [FTWCache setObject:adata forKey:key];
            UIImage *image = [UIImage imageWithData:adata];
            callback (image,nil);
        }];
    }
    [key release];*/

        
	
    
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
                 NSLog(@"login error == %@",error.wErrorDescription);
                 callback(nil,error);
                 [error release];
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"request error == %@",error.wErrorCode);
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
                             Refresh:(BOOL)refreshOrNot
                       GotArrReports:(WbReportJsonArr)callback
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/organization/rootOrgunits?organizationId=%ld&voidFlag=1&cookie=%@",self.strBaseUrl,(long)organizationId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setDelegate:self];
    NSString *key = [NSString stringWithFormat:@"rootOrgunits%ld",(long)organizationId];
    NSData *dataResponse = [FTWCache objectForKey:key];
    if (dataResponse&&refreshOrNot == NO) {
        NSLog(@"部门列表 有缓存");
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
        
    }else{
        NSLog(@"部门列表 无缓存");
        [SVProgressHUD showWithStatus:@"加载…"];
        [req setCompletionBlock:^{
            NSData *dataResponse = [req responseData];
            [FTWCache setObject:dataResponse forKey:key];
            NSLog(@"获取公司、部门公告 setCompletionBlock: == %@",[req responseString]);
            WDataParse *wdp = [WDataParse sharedWDataParse];
            NSLog(@"HBServerKit 从服务端获得的完整json格式数据 获取公司、部门公告== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
            Body * body = [self getBodyWithDataResponse:dataResponse];
            NSLog(@"HBServerKit 完整数据之中取得body 获取公司、部门公告 %@",body);
            NSLog(@"body.success == %c",body.success);
            if (body.success)//如果查汇报成功
            {
                NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
                NSLog(@"HBServerKit 从body取得data 获取公司、部门公告== %@",arrReportsGot);
                callback(arrReportsGot,nil);
                [SVProgressHUD showSuccessWithStatus:@"完成"];
            }else//如果查汇报不成功
            {
                WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                Mark_Custom;
                NSLog(@"获取公司、部门公告 ERROR == %@",error.wErrorDescription);
                callback(nil,error);
                [SVProgressHUD showErrorWithStatus:@"失败"];
                [error release];
            }
        }];
        [req startAsynchronous];
    }

    /*
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
     }];*/
}

#pragma mark -- 获得汇报记录(单个员工)http://hb.m.gitom.com/3.0/report/findReports?organizationId=1&orgunitId=1&username=90261&beginDate=1279865600000&endDate=1399951999000&first=0&max=150&cookie=5533098A-43F1-4AFC-8641-E64875461345&reportType=REPORT_TYPE_DAY_REPORT
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                           OrgunitId:(NSInteger)orgunitId
                            Username:(NSString *)username
                          ReportType:(NSString *)typeReport
                        BeginDateLli:(long long int)beginDateLli
                          EndDateLli:(long long int)endDateLli
                   FirstReportRecord:(NSInteger)firstReportRecord
                     MaxReportRecord:(NSInteger)maxCountReportRecord
                         RefreshData:(BOOL)refshOrNot
                       GotArrReports:(WbReportJsonArr)callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@/report/findReports?organizationId=%d&orgunitId=%d&username=%@&beginDate=%lld&endDate=%lld&first=%d&max=%d&cookie=%@&reportType=%@",self.strBaseUrl,organizationId,orgunitId,username,beginDateLli,endDateLli,firstReportRecord,maxCountReportRecord,_cookie,typeReport];
    NSLog(@"HBServerKit urlString == %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    //[ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    
    WDataParse *wdp = [WDataParse sharedWDataParse];
    NSString *key = [NSString stringWithFormat:@"findReports%ld%ld%@",(long)organizationId,(long)orgunitId,typeReport];
    NSData *dataResponse = [FTWCache objectForKey:key];
    if (dataResponse&&refshOrNot==NO){
        NSLog(@"单个员工 有缓存");
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
        
    }else{
        [req setCompletionBlock:^{
            NSLog(@"单个员工 没缓存");
            NSData *dataResponse = [req responseData];
            [FTWCache setObject:dataResponse forKey:key];
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
                                            RefreshData:(BOOL)refshOrNot
                                          GotArrReports:(WbReportJsonArr)callback{
    NSString *urlString = [[[NSString alloc]init]autorelease];
    
    if (yesOrNo == YES) {
        urlString = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/attendance/orgunitAttendance?organizationId=%@&orgunitId=%@&beginDate=%lld&endDate=%lld&first=%d&max=%d&cookie=%@",[NSNumber numberWithInteger:organizationId],[NSNumber numberWithInteger:orgunitId],beginDateLli,endDateLli,firstReportRecord,maxCountReportRecord,_cookie];
        NSLog(@"HBServerKit 部门打卡 urlString == %@",urlString);
    }else{
        urlString = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/attendance/userAttendance?organizationId=%@&orgunitId=%@&username=%@&beginDate=%lld&endDate=%lld&first=0&max=150&cookie=%@&reportType=REPORT_TYPE_GO_OUT",[NSNumber numberWithInteger:organizationId],[NSNumber numberWithInteger:orgunitId],[NSNumber numberWithInteger: userName],beginDateLli,endDateLli,_cookie];
        NSLog(@"HBServerKit 个人打卡 urlString == %@",urlString);
    }

    NSURL *url = [NSURL URLWithString:urlString];
    //[ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    NSString *key = [NSString stringWithFormat:@"orgunitAttendance%ld%ld%c",(long)organizationId,(long)orgunitId,yesOrNo];
    NSData *dataResponse = [FTWCache objectForKey:key];
    
    if (dataResponse&&refshOrNot == NO&&dataResponse.length>2){
        NSLog(@"整个部门、个人:打卡缓存");
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

    }else{
        [SVProgressHUD showWithStatus:@"加载…"];
        [req setCompletionBlock:^{
            NSLog(@"整个部门、个人:打卡没有缓存");
            NSData *dataResponse = [req responseData];
            NSLog(@"部门汇报(整个部门打卡) == %@",[req responseString]);
            [FTWCache setObject:dataResponse forKey:key];
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
                [SVProgressHUD showSuccessWithStatus:@"完成"];
            }else//如果查汇报不成功
            {
                WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                Mark_Custom;
                NSLog(@"部门汇报(整个部门打卡) ERROR == %@",error.wErrorDescription);
                callback(nil,error);
                [SVProgressHUD showErrorWithStatus:@"无数据"];
                [error release];
            }
        }];
        [req startAsynchronous];
    }
    
    
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
                                         RefreshData:(BOOL)refshOrNot
                                       GotArrReports:(WbReportJsonArr)callback{
    NSString *urlString = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/report/findOrgunitReports?organizationId=%@&orgunitId=%@&beginDate=%lld&endDate=%lld&first=%d&max=%d&cookie=%@&&reportType=%@",[NSNumber numberWithInteger:organizationId],[NSNumber numberWithInteger:orgunitId],beginDateLli,endDateLli,firstReportRecord,maxCountReportRecord,_cookie,reportType];
    NSLog(@"HBServerKit urlString == %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    // [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    
    WDataParse *wdp = [WDataParse sharedWDataParse];
    NSString *key = [NSString stringWithFormat:@"findOrgunitReports%ld%ld%@",(long)organizationId,(long)orgunitId,reportType];//[urlString MD5Hash];
    NSData *dataResponse = [FTWCache objectForKey:key];
    if (dataResponse&&refshOrNot == NO){
        NSLog(@"所有部门汇报缓存");
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

    }else{
        [req setCompletionBlock:^{
            NSLog(@"所有部门汇报没缓存");
            NSData *dataResponse = [req responseData];
            NSLog(@"部门汇报(整个部门) == %@",[req responseString]);
            [FTWCache setObject:dataResponse forKey:key];
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
    
//    //获取全局变量
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    //设置缓存方式
//    [req setDownloadCache:appDelegate.myCache];
//    //设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
//    [req setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
}


#pragma mark -- 获取公司、部门公告
-(void)getNewsWithOrganizationId:(NSInteger)organizationId
                       orgunitId:(NSInteger)orgunitId
                        newsType:(NSString *)newsType
                         Refresh:(BOOL)refreshOrNot
                   GotArrReports:(WbReportJsonArr)callback{
    //http://hb.m.gitom.com/3.0/organization/organizationNews?organizationId=%ld&orgunitId=%ld&first=0&max=1&cookie=%@
    
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/%@?organizationId=%ld&orgunitId=%ld&first=0&max=1&cookie=%@",newsType,(long)organizationId,(long)orgunitId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setDelegate:self];
    //__block NSData *dataResponse = [[NSData alloc]init];//[req responseData];
    NSString *key = [NSString stringWithFormat:@"organizationNews%ld%ld%@",(long)organizationId,(long)orgunitId,newsType];
    //NSString *key = [urlStr MD5Hash];
    NSData *dataResponse = [FTWCache objectForKey:key];
    if (dataResponse&&refreshOrNot == NO) {
        NSLog(@"有缓存");
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

    }else{
        NSLog(@"无缓存");
        [SVProgressHUD showWithStatus:@"载入…"];
        [req setCompletionBlock:^{
            NSData *dataResponse = [req responseData];
            [FTWCache setObject:dataResponse forKey:key];
            
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
                [SVProgressHUD showSuccessWithStatus:@"完成"];
            }else//如果查汇报不成功
            {
                WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                Mark_Custom;
                NSLog(@"获取公司、部门公告 ERROR == %@",error.wErrorDescription);
                callback(nil,error);
                [SVProgressHUD showErrorWithStatus:@"无数据"];
                [error release];
            }
        }];
        [req startAsynchronous];
    }
    
    
    
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

#pragma mark -- 获取考勤配置
//http://hb.m.gitom.com/3.0/attendance/attendanceConfig?organizationId=204&orgunitId=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
-(void)getAttendanceConfigWithOrganizationId:(NSInteger)organizationId
                                   orgunitId:(NSInteger)orgunitId
                                     Refresh:(BOOL)refresh
                               GotDicReports:(void(^)(NSDictionary * dicAttenConfig))callback{
    //[SVProgressHUD showWithStatus:@"刷新…"];
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/attendance/attendanceConfig?organizationId=%d&orgunitId=%d&cookie=%@",organizationId,orgunitId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    WDataParse *wdp = [WDataParse sharedWDataParse];
    NSString *key = [NSString stringWithFormat:@"attendanceattendanceConfig%ld%ld",(long)organizationId,(long)orgunitId];
    NSData *dataResponse = [FTWCache objectForKey:key];
    if (dataResponse&&refresh==NO) {
        NSLog(@"考勤配 有缓存");
        
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 获取考勤配置== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 获取考勤配置 %@",body);
        //NSLog(@"body.success == %c",body.success);
        if (body.success)//如果查汇报成功
        {
            NSDictionary * dicReportsGot = [wdp wGetDicJsonWithStringJson:body.data];
            [SVProgressHUD showSuccessWithStatus:@"获得配置"];
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
    }else{
        [SVProgressHUD showWithStatus:@"加载…"];
        [req setCompletionBlock:^{
            NSData *dataResponse = [req responseData];
            NSLog(@"HBServerKit 从服务端获得的完整 获取考勤配置json == %@",[req responseString]);
            [FTWCache setObject:dataResponse forKey:key];
            
            [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
            NSLog(@"HBServerKit 从服务端获得的完整json格式数据 获取考勤配置== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
            Body * body = [self getBodyWithDataResponse:dataResponse];
            NSLog(@"HBServerKit 完整数据之中取得body 获取考勤配置 %@",body);
            //NSLog(@"body.success == %c",body.success);
            if (body.success)//如果查汇报成功
            {
                NSDictionary * dicReportsGot = [wdp wGetDicJsonWithStringJson:body.data];
                [SVProgressHUD showSuccessWithStatus:@"获得配置"];
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
    
}

#pragma mark -- 部门的员工列表
//http://hb.m.gitom.com/3.0/user/findUsers?organizationId=114&orgunitId=1&voidFlag=1

-(void)findOrgunitMembersWithOrganizationId:(NSInteger)organizationId
                                  orgunitId:(NSInteger)orgunitId
                                    Refresh:(BOOL)refreshYesOrNot
                       GotArrReports:(WbReportJsonArr)callback
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/findUsers?organizationId=%ld&orgunitId=%ld&voidFlag=1&cookie=%@",self.strBaseUrl,(long)organizationId,(long)orgunitId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setDelegate:self];
    NSString *key = [NSString stringWithFormat:@"userfindUsers%ld%ld",(long)organizationId,(long)orgunitId];
    NSData *dataResponse = [FTWCache objectForKey:key];
    if (dataResponse&&refreshYesOrNot == NO) {
        NSLog(@"员工列表 有缓存");
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
        
    }else{
        NSLog(@"员工列表 无缓存");
        [SVProgressHUD showWithStatus:@"加载…"];
        [req setCompletionBlock:^{
            NSData *dataResponse = [req responseData];
            [FTWCache setObject:dataResponse forKey:key];
            
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
                [SVProgressHUD showSuccessWithStatus:@"完成"];
            }else//如果查汇报不成功
            {
                WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                Mark_Custom;
                NSLog(@"获取公司、部门公告 ERROR == %@",error.wErrorDescription);
                callback(nil,error);
                [SVProgressHUD showErrorWithStatus:@"无数据"];
                [error release];
            }
        }];
        [req startAsynchronous];
    }
}

#pragma mark - 汇报相关

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
            [SVProgressHUD showSuccessWithStatus:body.note duration:1.2];
            callback(arrReportsGot,nil);
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            NSLog(@"保存打卡记录 ERROR == %@",error.wErrorDescription);
            [SVProgressHUD showErrorWithStatus:body.warning duration:1.2];
            callback(nil,error);
            [error release];
        }
    }];
    [req startAsynchronous];
}

#pragma mark -- 保存上传声音
-(void)saveSoundReportsOfMembersWithData:(NSString *)soundData
                           GotArrReports:(WbReportJsonArr)callback{
    NSString *urlString = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/util/fileUpload?cookie=%@",_cookie];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request addFile:soundData forKey:@"file"];
    [request startSynchronous];
    //[request setCompletionBlock:^{
        
        NSLog(@"%@",request.responseString);
        NSData *dataResponse = [request responseData];
        
        WDataParse *wdp = [WDataParse sharedWDataParse];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 保存上传声音== %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 保存上传声音 %@",body);
        NSLog(@"body.success == %c",body.success);
        if (body.success)//如果查汇报成功
        {
            NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
            NSLog(@"HBServerKit 从body取得data 保存上传声音 == %@",arrReportsGot);
            callback(arrReportsGot,nil);
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            NSLog(@"保存上传声音 ERROR == %@",error.wErrorDescription);
            callback(nil,error);
            [error release];
        }
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
    
    [request startSynchronous];
    
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
    if (!soundUrl) {
        NSLog(@"soundUrl nil");
        soundUrl = @"{\"soundUrl\":[]}";
    }else{
        NSLog(@"HBServerKit soundUrl%@",soundUrl);
    }
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
#pragma mark - 考勤数据处理
/*{"inTime":-14400000,"ordinal":1,"outTime":60000,"voidFlag":false}*/
#pragma mark -- 将考勤的打卡配置数据转换为字典
- (NSMutableArray *)getAttenWorktimeArrayBySetOutTime1:(int)outTime1
                                          andInTime1:(int)inTime1
                                         SetOutTime2:(int)outTime2
                                          andInTime2:(int)inTime2
                                         SetOutTime3:(int)outTime3
                                          andInTime3:(int)inTime3
{
    NSMutableDictionary *attenWorktimeDic1 = [[[NSMutableDictionary alloc]init]autorelease];
    [attenWorktimeDic1 setObject:[NSString stringWithFormat:@"%d",outTime1] forKey:@"outTime"];
    [attenWorktimeDic1 setObject:[NSString stringWithFormat:@"%d",inTime1] forKey:@"inTime"];
    [attenWorktimeDic1 setObject:@"1" forKey:@"ordinal"];
    [attenWorktimeDic1 setObject:@"false" forKey:@"voidFlag"];
    NSMutableDictionary *attenWorktimeDic2 = [[[NSMutableDictionary alloc]init]autorelease];
    [attenWorktimeDic2 setObject:[NSString stringWithFormat:@"%d",outTime2] forKey:@"outTime"];
    [attenWorktimeDic2 setObject:[NSString stringWithFormat:@"%d",inTime2] forKey:@"inTime"];
    [attenWorktimeDic2 setObject:@"2" forKey:@"ordinal"];
    [attenWorktimeDic2 setObject:@"false" forKey:@"voidFlag"];
    NSMutableDictionary *attenWorktimeDic3 = [[[NSMutableDictionary alloc]init]autorelease];
    [attenWorktimeDic3 setObject:[NSString stringWithFormat:@"%d",outTime3] forKey:@"outTime"];
    [attenWorktimeDic3 setObject:[NSString stringWithFormat:@"%d",inTime3] forKey:@"inTime"];
    [attenWorktimeDic3 setObject:@"3" forKey:@"ordinal"];
    [attenWorktimeDic3 setObject:@"false" forKey:@"voidFlag"];
    
    NSMutableArray *attenWorktimeArr = [[[NSMutableArray alloc]init]autorelease];
    [attenWorktimeArr addObject:attenWorktimeDic1];
    [attenWorktimeArr addObject:attenWorktimeDic2];
    if (outTime3>1) [attenWorktimeArr addObject:attenWorktimeDic3];
    
    NSLog(@"NSMutableArray == %@",attenWorktimeArr);
    
    return attenWorktimeArr;
}
/*attenInfo={"distance":"999","inMinute":"33","latitude":24.799119,"longitude":118.584223,"organizationId":204,"orgunitId":1,"outMinute":23,"updateUser":"58200","worktimes":[{"inTime":-14400000,"ordinal":1,"outTime":60000,"voidFlag":false},{"inTime":25020000,"ordinal":2,"outTime":32580000,"voidFlag":false}]}
 */
#pragma mark -- 考勤的其他数据转成字典
- (NSDictionary *)getAttenConfigDictionaryByUpdateUser:(NSString *)updateUser
                                 andDistance:(NSString *)distance
                                 andInMinute:(NSString *)inMinute
                                andOutMinute:(NSString *)outMinute
                                 andLatitude:(CGFloat)latitude
                                andLongitude:(CGFloat)longitude
                           andOrganizationId:(int)organizationId
                                andOrgunitId:(int)orgunitId
                             andWorkTimesArr:(NSArray *)worktimes{
    
    //    [attenWorktimeDic setObject:[NSString stringWithFormat:@"%lld",dateToSeconde] forKey:@"createDate"];
    NSMutableDictionary *attenWorktimeDic = [[[NSMutableDictionary alloc]init]autorelease];
    [attenWorktimeDic setObject:updateUser forKey:@"updateUser"];
    [attenWorktimeDic setObject:distance forKey:@"distance"];
    [attenWorktimeDic setObject:inMinute forKey:@"inMinute"];
    [attenWorktimeDic setObject:outMinute forKey:@"outMinute"];
    [attenWorktimeDic setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [attenWorktimeDic setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    [attenWorktimeDic setObject:[NSString stringWithFormat:@"%d",organizationId] forKey:@"organizationId"];
    [attenWorktimeDic setObject:[NSString stringWithFormat:@"%d",orgunitId] forKey:@"orgunitId"];
    [attenWorktimeDic setObject:worktimes forKey:@"worktimes"];
    return attenWorktimeDic;
}

- (NSString *)getUpdateAttendanceConfigUTF8stringByUpdateUser:(NSString *)updateUser
                                                  andDistance:(NSString *)distance
                                                  andInMinute:(NSString *)inMinute
                                                 andOutMinute:(NSString *)outMinute
                                                  andLatitude:(CGFloat)latitude
                                                 andLongitude:(CGFloat)longitude
                                            andOrganizationId:(int)organizationId
                                                 andOrgunitId:(int)orgunitId
                                                  SetOutTime1:(int)outTime1
                                                   andInTime1:(int)inTime1
                                                  SetOutTime2:(int)outTime2
                                                   andInTime2:(int)inTime2
                                                  SetOutTime3:(int)outTime3
                                                   andInTime3:(int)inTime3{
    NSArray *confingArr = [self getAttenWorktimeArrayBySetOutTime1:outTime1 andInTime1:inTime1 SetOutTime2:outTime2 andInTime2:inTime2 SetOutTime3:outTime3 andInTime3:inTime3];
    NSDictionary *confingDic = [self getAttenConfigDictionaryByUpdateUser:updateUser andDistance:distance andInMinute:inMinute andOutMinute:outMinute andLatitude:latitude andLongitude:longitude andOrganizationId:organizationId andOrgunitId:orgunitId andWorkTimesArr:confingArr];
    NSData *getData = [NSJSONSerialization dataWithJSONObject:confingDic options:kNilOptions error:nil];
    NSString *getStr = [[NSString alloc]initWithData:getData encoding:NSUTF8StringEncoding];
    NSLog(@"getStr of configDatasDic == %@",getStr);
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)getStr, NULL, NULL,  kCFStringEncodingUTF8 );
    NSLog(@"utf8 str == %@",encodedString);
    return encodedString;
}

#pragma mark -- 保存更改用户信息
- (void) saveUserDocumentWithUsername:(NSString *)userName
                          andRealName:(NSString *)realName
                         andTelephone:(NSString *)telephone
                             andPhoto:(NSString *)photo{
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/user/updateUser?username=%@&realname=%@&telephone=%@&cookie=%@&photo=%@",userName,realName,telephone,_cookie,photo];
    ASIHTTPRequest *forReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSLog(@"保存更改信息内容 == %@",urlStr);
    [forReq setCompletionBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"存储成功"];
    }];
    [forReq setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"编辑失败"];
    }];
    [forReq startAsynchronous];
}

#pragma mark -- 保存更新考勤参数
- (void) saveUpdateAttendanceConfigWithAttenInfoByUpdateUser:(NSString *)updateUser
                                                 andDistance:(NSString *)distance
                                                 andInMinute:(NSString *)inMinute
                                                andOutMinute:(NSString *)outMinute
                                                 andLatitude:(CGFloat)latitude
                                                andLongitude:(CGFloat)longitude
                                           andOrganizationId:(int)organizationId
                                                andOrgunitId:(int)orgunitId
                                                 SetOutTime1:(int)outTime1
                                                  andInTime1:(int)inTime1
                                                 SetOutTime2:(int)outTime2
                                                  andInTime2:(int)inTime2
                                                 SetOutTime3:(int)outTime3
                                                  andInTime3:(int)inTime3{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    long long int dateToSeconde = [WTool getEndDateTimeMsWithNSDate:[NSDate date]];
    NSLog(@"ManageAttendanceConfigVC dateToSeconde %lld",dateToSeconde);
    NSString *attenInfo = [self getUpdateAttendanceConfigUTF8stringByUpdateUser:updateUser andDistance:distance andInMinute:inMinute andOutMinute:outMinute andLatitude:latitude andLongitude:longitude andOrganizationId:organizationId andOrgunitId:orgunitId SetOutTime1:outTime1 andInTime1:inTime1 SetOutTime2:outTime2 andInTime2:inTime2 SetOutTime3:outTime3 andInTime3:inTime3];
    NSString *urlString = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/attendance/updateAttendanceConfig?attenInfo=%@&cookie=%@&temp=%lld",attenInfo,_cookie,dateToSeconde];
    NSLog(@"保存更新考勤参数 url == %@",urlString);
    [SVProgressHUD showWithStatus:@"修改考勤配置…"];
    ASIHTTPRequest *req = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    [req setCompletionBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
    [req startAsynchronous];
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
//http://hb.m.gitom.com/3.0/userRole/saveRolePrivilege?organizationId=204&roleId=2&operations=7,12&updateUser=58200&cookie=5533098A-43F1-4AFC-8641-E64875461345
#pragma mark -- 编辑主管权限
- (void)saveRolePrivilegeWithOrganizationId:(NSInteger)organizationId
                           andRoleId:(NSInteger)roleId
                              andOperations:(NSString *)operations
                          andUpdateUser:(NSString *)updateUser{
    NSString *releaseUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/userRole/saveRolePrivilege?organizationId=%d&roleId=%d&operations=%@&updateUser=%@&cookie=%@",organizationId,roleId,operations,updateUser,_cookie];
    NSLog(@"编辑主管权限 url == %@",releaseUrlStr);
    NSURL *url = [NSURL URLWithString:releaseUrlStr];
    ASIHTTPRequest *req = [[ASIHTTPRequest alloc]initWithURL:url];
    [req setCompletionBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"编辑成功"];
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }];
    [req startAsynchronous];
    [req release];
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

#pragma mark -- 更改部门名称
- (void)changeOrgNameWith:(NSInteger)organizationId
             andOrgunitId:(NSInteger)orgunitId
              andUsername:(NSString *)username
                  andName:(NSString *)name {
    NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/updateOrgunit?organizationId=%ld&orgunitId=%ld&username=%@&name=%@&cookie=%@",(long)organizationId,(long)orgunitId,username,name,_cookie];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:changeRoleUrlStr]];
    [req setCompletionBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }];
    [req startAsynchronous];
}

#pragma mark -- 更改坐标上传的间隔
- (void)changeSendPositionPointIntervalorganitzationId:(NSInteger)organizationId
                                          andOrgunitId:(NSInteger)orgunitId
                                            andInterval:(NSString *)intervalTime
                                           andUsername:(NSString *)username{
    NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/util/saveUploadLocationTime?organizationId=%ld&orgunitId=%ld&time==%@&updateUser=%@&cookie=%@",(long)organizationId,(long)orgunitId,intervalTime,username,_cookie];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:changeRoleUrlStr]];
    [req setCompletionBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"完成修改"];
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
    [req startAsynchronous];
}

#pragma mark -- 添加部门 
- (void)addOrgunitWithrganitzationId:(NSInteger)organizationId
                      andOrgunitName:(NSString *)creatName
                         andUsername:(NSString *)username{
    NSString *urlStr = [NSString stringWithFormat:@"%@/organization/saveOrgunit?organizationId=%ld&pid=0&username=%@&name=%@&cookie=%@",self.strBaseUrl,(long)organizationId,username,creatName,_cookie];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req setCompletionBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"完成部门添加"];
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"操作失败"];
    }];
    [req startAsynchronous];
}

#pragma mark - 获取考勤
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

//http://uc.gitom.com/api/user/send_resister_smscode?mobile=13328786791
#pragma mark - 注册用户
- (void)registerWithPhoneNumber:(NSString *)phoneNumber{
    NSString *urlStr = [NSString stringWithFormat:@"http://uc.gitom.com/api/user/send_resister_smscode?mobile=%@",phoneNumber];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        [req responseData];
        NSDictionary *getDic = [NSJSONSerialization JSONObjectWithData:[req responseData] options:kNilOptions error:nil];
        NSString *getMessage = [getDic objectForKey:@"message"];
        NSString *getResult = [getDic objectForKey:@"result"];
        NSString *getmessage_type = [getDic objectForKey:@"message_type"];
        NSString *getSuccess = [getDic objectForKey:@"success"];
        NSLog(@"getResult -== %@ %@ %@",getResult,getmessage_type,getSuccess);
        if ([getMessage isEqualToString:@"该手机号码已经被注册，不能重复注册！"]||[getMessage isEqualToString:@"手机号码格式有误！"]) {
            NSLog(@"error");
            [SVProgressHUD showErrorWithStatus:getMessage];
        }else{
            NSLog(@"success");
            [SVProgressHUD showSuccessWithStatus:getMessage];
        }
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"服务器数据获取失败"];
    }];
    
    [req startAsynchronous];
}
//http://uc.gitom.com/api/user/mobile_resister_user?mobile=13328786791&smscode=828573&password=1234567
- (BOOL)registerRealWithPhoneNumber:(NSString *)phoneNumber
                         andSmscode:(NSString *)smscode
                        andPassword:(NSString *)passWord{
    NSString *urlStr = [NSString stringWithFormat:@"http://uc.gitom.com/api/user/mobile_resister_user?mobile=%@&smscode=%@&password=%@",phoneNumber,smscode,passWord];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        [req responseData];
        NSDictionary *getDic = [NSJSONSerialization JSONObjectWithData:[req responseData] options:kNilOptions error:nil];
        NSString *getMessage = [getDic objectForKey:@"message"];
        NSString *getResult = [getDic objectForKey:@"result"];
        NSString *getmessage_type = [getDic objectForKey:@"message_type"];
        NSString *getSuccess = [getDic objectForKey:@"success"];
        NSLog(@"getResult -== %@ %@ %@",getResult,getmessage_type,getSuccess);
        NSRange range = [getMessage rangeOfString:@"有误"];
        if (range.location == NSNotFound) {
            [SVProgressHUD showSuccessWithStatus:getMessage];
            self.success = YES;
        }else{
            [SVProgressHUD showErrorWithStatus:getMessage];
            self.success = NO;
        }
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"服务器数据获取失败"];
    }];
    
    [req startAsynchronous];
    if (self.success) {
        return YES;
    }else{
        return NO;
    }
}
//http://hb.m.gitom.com/3.0/user/saveApply?organizationId=114&orgunitId=1&note=twoApply&username=90261&cookie=5533098A-43F1-4AFC-8641-E64875461345&verifyType=0
#pragma mark -- 申请加入公司
- (void)applyJoinToCompanyWithOrganizationId:(NSString *)organizationId
                                andOrgunitId:(NSString *)orgunitId
                                     andNote:(NSString *)note
                                  andUseName:(NSString *)username
                               andVerifyType:(int)verifyType{
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/user/saveApply?organizationId=%@&orgunitId=%@&note=%@&username=%@&cookie=%@&verifyType=%d",organizationId,orgunitId,note,username,_cookie,verifyType];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"搜索公司 urlStr == %@",urlStr);
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req startAsynchronous];
}

//http://hb.m.gitom.com/3.0/organization/organizations?key=1&first=1&max=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
#pragma mark -- 搜索公司
- (void)searchCompanyWithKey:(NSString *)key
                    andFirst:(int)first
                        andMax:(int)max
                        andGetArr:(void(^)(NSArray *companyAr))callBack{
    __block NSMutableArray *companyArr = [[NSMutableArray alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/organizations?key=%@&first=%d&max=%d&cookie=%@",key,first,max,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"搜索公司 urlStr == %@",urlStr);
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        WDataParse *wdp = [WDataParse sharedWDataParse];
        NSLog(@"搜索公司 responseString == %@",[req responseString]);
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:[req responseData]]];//检查服务器是否没有异常，如果有，就打印
        Body * body = [self getBodyWithDataResponse:[req responseData]];
        if (body.success)
        {
            NSArray *getArr = [wdp wGetArrJsonWithStringJson:body.data];
            if (getArr.count) {
                for (int i=0; i<getArr.count; i++) {
                    OrganizationsModel *orgModel = [[OrganizationsModel alloc]init];
                    orgModel.organizationName = [[getArr objectAtIndex:i]objectForKey:@"name"];
                    orgModel.organizationId = [[getArr objectAtIndex:i]objectForKey:@"organizationId"];
                    
                    NSMutableArray *orgNameArray = [[NSMutableArray alloc]init];
                    NSMutableArray *orgIdArray = [[NSMutableArray alloc]init];
                    NSMutableArray *orgPropsArray = [[NSMutableArray alloc]init];
                    NSArray *listArray = [[NSArray alloc]init];
                    listArray = [[getArr objectAtIndex:i]objectForKey:@"orgunitList"];
                    NSLog(@"orgunitList arrName == %@",listArray);
                    NSLog(@"orgunitList array == %d",listArray.count);
                    if (listArray.count) {
                        for (int j=0; j<listArray.count; j++) {
                            NSLog(@"j==%d",j);
                            [orgNameArray addObject:[[listArray objectAtIndex:j]objectForKey:@"name"]];
                            [orgIdArray addObject:[[listArray objectAtIndex:j]objectForKey:@"orgunitId"]];
                            [orgPropsArray addObject:[[listArray objectAtIndex:j]objectForKey:@"orgunitProps"]];
                        }
                    }

                    orgModel.orgunitIdArray = orgIdArray;
                    orgModel.orgunitNameArray = orgNameArray;
                    orgModel.orgunitPropsArray = orgPropsArray;
                    NSLog(@"HBServerKit orgIDARRAY == %@ . %@",orgIdArray,orgNameArray);
                    NSLog(@"HBServerKit orgPropsArray == %@",orgPropsArray);
                    [companyArr addObject:orgModel];
                    [orgModel release];
                    [orgIdArray release];
                    [orgNameArray release];
                    [orgPropsArray release];
                }
                OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
                orgMod = [companyArr objectAtIndex:9];
                NSLog(@"HBServerKit orgPropsArray ALL ARR == %@  index9 = %@",companyArr,orgMod.orgunitPropsArray);
                callBack(companyArr);
            }else{
                callBack(nil);
            }
            
        }else
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            NSLog(@"%@",error.wErrorDescription);
            [error release];
        }
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"服务器数据获取失败"];
    }];
    [req startAsynchronous];
}

#pragma mark -- 添加点评http://hb.m.gitom.com/3.0/report/saveReportComment?organizationId=114&orgunitId=1&reportId=1383292928438&content=123&score=10&createUser=90261&username=90261&cookie=5533098A-43F1-4AFC-8641-E64875461345&temp=13838947994114

- (void) addCommentWithOrganizationId:(NSInteger)organizationId
                            OrgunitId:(NSInteger)orgunitId
                             ReportId:(NSString *)reportId
                              Content:(NSString *)content
                                Score:(NSString *)score
                           CreateUser:(NSString *)createUser
                             Username:(NSString *)username{
    int temp = arc4random()%1000;
    NSString *urlStr = [NSString stringWithFormat:@"%@/report/saveReportComment?organizationId=%d&orgunitId=%d&reportId=%@&content=%@&score=%@&createUser=%@&username=%@&cookie=%@&temp=%d",self.strBaseUrl,organizationId,orgunitId,reportId,content,score,createUser,username,_cookie,temp];
    NSLog(@"HBServerKit comment == %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"已有人做过评价"];
    }];
    [req startAsynchronous];
}

#pragma mark -- 查询点评
- (void) findCommentWithOrganizationId:(NSInteger)organizationId
                             OrgunitId:(NSInteger)orgunitId
                              ReportId:(NSString *)reportId
                             andGetCommentMod:(void(^)(CommentModle *commentMod))callBack{
    __block CommentModle *commentModel = [[CommentModle alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"%@/report/findReportComments?organizationId=%d&orgunitId=%d&reportId=%@&first=0&max=1&cookie=%@",self.strBaseUrl,organizationId,orgunitId,reportId,_cookie];
    NSLog(@"HBServerKit comment == %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        WDataParse *wdp = [WDataParse sharedWDataParse];
        NSLog(@"查询点评 responseString == %@",[req responseString]);
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:[req responseData]]];//检查服务器是否没有异常，如果有，就打印
        Body * body = [self getBodyWithDataResponse:[req responseData]];
        if (body.success)
        {
            NSArray *getArr = [wdp wGetArrJsonWithStringJson:body.data];
            if (getArr.count) {
                for (int i=0; i<getArr.count; i++) {
                    commentModel.createDate = [[getArr objectAtIndex:i]objectForKey:@"createDate"];
                    commentModel.createUserId = [[getArr objectAtIndex:i]objectForKey:@"createUserId"];
                    commentModel.level = [[getArr objectAtIndex:i]objectForKey:@"level"];
                    commentModel.note = [[getArr objectAtIndex:i]objectForKey:@"note"];
                    commentModel.realname = [[getArr objectAtIndex:i]objectForKey:@"realname"];                    
                }
                callBack(commentModel);
            }else{
                callBack(nil);
            }
            
        }else
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            NSLog(@"%@",error.wErrorDescription);
            [error release];
        }
    }];
    [req startAsynchronous];
    //[commentModel release];
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
