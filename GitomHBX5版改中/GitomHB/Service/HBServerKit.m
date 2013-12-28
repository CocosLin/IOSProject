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
#import "QueryMessageModel.h"
#import "UserPositionModel.h"




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
   
         }
     }];
}

#pragma mark -- 获得汇报图片
- (NSArray *) getImgStringWith:(NSString *)jsonStr{
    WDataParse *wdParse = [WDataParse sharedWDataParse];
    NSDictionary *dic = [wdParse wGetDicJsonWithStringJson:jsonStr];
    NSLog(@"汇报图片字典 == %@ ",dic);
    NSArray *getArr = [dic objectForKey:@"imageUrl"];
    NSMutableArray *urlArray = [[NSMutableArray alloc]init];
    if (!getArr.count) return nil;
    for (NSDictionary *dic in getArr) {
        NSLog(@"HBServerKit dictionary == %@",dic);
        NSString *url = [[NSString alloc]init];
        url = [dic objectForKey:@"url"];
        [urlArray addObject:url];
    }
    NSLog(@"HBServerKit urlArray%@",urlArray);
    return urlArray;
}

#pragma mark -- 获得汇报声音
- (NSArray *) getSoundStringWith:(NSString *)jsonStr{
    WDataParse *wdParse = [WDataParse sharedWDataParse];
    NSDictionary *dic = [wdParse wGetDicJsonWithStringJson:jsonStr];
    NSLog(@"汇报声音字典 == %@ ",dic);
    NSArray *getArr = [dic objectForKey:@"soundUrl"];
    NSMutableArray *urlArray = [[NSMutableArray alloc]init];
    for (NSDictionary *soundDic in getArr) {
        NSString *url = [[NSString alloc]init];
        url = [soundDic objectForKey:@"url"];
        NSLog(@"声音url == %@",url);
        [urlArray addObject:url];
    }
    return urlArray;
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
 
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"%@",error.wErrorCode);
             callback(nil,error);
 
         }
    }];
}



#pragma mark - 用户操作
#pragma mark --登录
-(void)loggingWithUsername:(NSString *)username
             Md5PasswordUp:(NSString *)md5PassUp
               VersionCode:(NSString *)versionCode
                GotJsonDic:(void(^)(NSDictionary * dicUserLogged,WError * myError))callback
{
    NSLog(@"HBServerKit name=%@  |  md5PassUp=%@  |  versionCode=%@",username,md5PassUp,versionCode);
    
    WDataParse * wdp = [WDataParse sharedWDataParse];
    
    NSLog(@"HBServerKit strBaseUrl == %@",self.strBaseUrl);
    NSMutableDictionary * dicParam = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParam setObject:username forKey:@"username"];
    [dicParam setObject:[[wdp wMd5HexDigest:md5PassUp]uppercaseString] forKey:@"password"];
    [dicParam setObject:versionCode forKey:@"versionCode"];
    
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
                 NSLog(@"HBServerKit 只取Body部分的数据内容 dicUserLogged == %@",dicUserLogged);
                 callback(dicUserLogged,nil);
             }else//如果登录不成功
             {
                 WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                 Mark_Custom;
                 NSLog(@"login error == %@",error.wErrorDescription);
                 callback(nil,error);
    
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"request error == %@",error.wErrorCode);
             callback(nil,error);
    
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
                 
                 Organization * organizationInfo = [[Organization alloc]initForAllJsonDataTypeWithDicFromJson:[loggedInfo.organizations lastObject]];
                 comData.organization = organizationInfo;
   
                 
                 callback(YES);
          
             }else//如果登录不成功
             {
                 Mark_Custom;
      
                 callback(NO);
             }
         }else
         {
             Mark_Custom;
       
             callback(NO);
         }
     }];
}
#pragma mark  记录查询

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
            
        }
        
    }else{
        NSLog(@"员工列表 无缓存");
        [SVProgressHUD showWithStatus:@"加载员工…"];
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
                if (arrReportsGot.count>0) {
                    [SVProgressHUD showSuccessWithStatus:@"完成"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"该部门无员工"];
                }
            
            }else//如果查汇报不成功
            {
                WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                Mark_Custom;
                NSLog(@"获取公司、部门公告 ERROR == %@",error.wErrorDescription);
                callback(nil,error);
                [SVProgressHUD showErrorWithStatus:@"无数据"];
                
            }
        }];
        [req startAsynchronous];
    }
}


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
  
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"%@",error.wErrorCode);
             callback(nil,error);
 
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
      
        }
        
    }else{
        NSLog(@"部门列表 无缓存");
        [SVProgressHUD showWithStatus:@"加载部门…"];
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
    
            }
        }];
        [req startAsynchronous];
    }
    
}

#pragma mark -- 获取单个记录
/**
 * 查找单个汇报
 * @param organizationId
 * @param orgunitId
 * @param reportId    1381457232757
 */
- (void)findReportWithOrganizationId:(NSInteger)organizationId
                           OrgunitId:(NSInteger)orgunitId
                         andReportId:(NSString *)reportId
                        getReportMod:(void(^)(ReportModel *reportMod))callBack{
    
    [SVProgressHUD showWithStatus:@"加载汇报…"];
    NSString *urlString = [NSString stringWithFormat:@"%@/report/findReport?organizationId=%d&orgunitId=%d&reportId=%@&cookie=%@",self.strBaseUrl,organizationId,orgunitId,reportId,_cookie];
    NSLog(@"HBServerKit 获取单个记录 urlString == %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    WDataParse *wdp = [WDataParse sharedWDataParse];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSData *dataResponse = [req responseData];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        Body * body = [self getBodyWithDataResponse:dataResponse];
        
        NSLog(@"HBServerKit 完整数据之中取得body 获取单个记录 %@",body);
        if (body.success)//如果查汇报成功
        {
            
            NSArray * reportArray = [wdp wGetArrJsonWithStringJson:body.data];
            for (NSDictionary *massageDic in reportArray) {
                ReportModel *reportMod = [[ReportModel alloc]init];
                reportMod.address = [massageDic objectForKey:@"address"];
                reportMod.createDate = [[massageDic objectForKey:@"createDate"] longLongValue];
                reportMod.updateDate = [[massageDic objectForKey:@"updateDate"] longLongValue];
                reportMod.soundUrl = [massageDic objectForKey:@"soundUrl"];
                reportMod.imageUrl = [massageDic objectForKey:@"imageUrl"];
                reportMod.userName = [massageDic objectForKey:@"createUserId"];
                reportMod.realName = [massageDic objectForKey:@"realname"];
                reportMod.latitude = [[massageDic objectForKey:@"latitude"] floatValue];
                reportMod.longitude = [[massageDic objectForKey:@"longitude"] floatValue];
                reportMod.note = [massageDic objectForKey:@"note"];
                reportMod.telephone = [massageDic objectForKey:@"telephone"];
                reportMod.organizationId = [[massageDic objectForKey:@"organizationId"] integerValue];
                reportMod.orgunitId = [[massageDic objectForKey:@"orgunitId"] integerValue];
                reportMod.reportId = [massageDic objectForKey:@"reportId"];
                reportMod.reportType = [massageDic objectForKey:@"reportType"];
                reportMod.telephone = [massageDic objectForKey:@"telephone"];
                reportMod.voidFlag = [[massageDic objectForKey:@"voidFlag"] intValue];
                NSLog(@"HBServerKit reportMod.realName == %@",reportMod.realName);
                callBack(reportMod);
                [SVProgressHUD showSuccessWithStatus:@"获得"];
  
            }
        }else//如果查汇报不成功
        {
//            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
//            Mark_Custom;
//            NSLog(@"获取消息通知 ERROR == %@",error.wErrorDescription);
//            callBack(nil);
            [SVProgressHUD showErrorWithStatus:@"未获得"];
  
            
        }
    }]; 
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"数据获取失败"];
    }];
    
    [req startAsynchronous];
}

#pragma mark -- 获得汇报记录(单个员工)
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
                                               userName:(NSString *)userName
                                           BeginDateLli:(long long int)beginDateLli
                                             EndDateLli:(long long int)endDateLli
                                      FirstReportRecord:(NSInteger)firstReportRecord
                                        MaxReportRecord:(NSInteger)maxCountReportRecord
                                            RefreshData:(BOOL)refshOrNot
                                          GotArrReports:(WbReportJsonArr)callback{
    NSString *urlString = [[NSString alloc]init];
    
    if (yesOrNo == YES) {
        urlString = [NSString stringWithFormat:@"%@/attendance/orgunitAttendance?organizationId=%@&orgunitId=%@&beginDate=%lld&endDate=%lld&first=%d&max=%d&cookie=%@",self.strBaseUrl,[NSNumber numberWithInteger:organizationId],[NSNumber numberWithInteger:orgunitId],beginDateLli,endDateLli,firstReportRecord,maxCountReportRecord,_cookie];
        NSLog(@"HBServerKit 部门打卡 urlString == %@",urlString);
    }else{
        urlString = [NSString stringWithFormat:@"%@/attendance/userAttendance?organizationId=%@&orgunitId=%@&username=%@&beginDate=%lld&endDate=%lld&first=%d&max=%d&cookie=%@&reportType=REPORT_TYPE_GO_OUT",self.strBaseUrl,[NSNumber numberWithInteger:organizationId],[NSNumber numberWithInteger:orgunitId],userName,beginDateLli,endDateLli,firstReportRecord,maxCountReportRecord,_cookie];
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
    
        }

    }else{
//        [SVProgressHUD showWithStatus:@"加载考勤…"];
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
//                [SVProgressHUD showSuccessWithStatus:@"完成"];
            }else//如果查汇报不成功
            {
                WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                Mark_Custom;
                NSLog(@"部门汇报(整个部门打卡) ERROR == %@",error.wErrorDescription);
                callback(nil,error);
                [SVProgressHUD showErrorWithStatus:@"无数据"];
       
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
    NSString *urlString = [NSString stringWithFormat:@"%@/report/findOrgunitReports?organizationId=%@&orgunitId=%@&beginDate=%lld&endDate=%lld&first=%d&max=%d&cookie=%@&&reportType=%@",self.strBaseUrl,[NSNumber numberWithInteger:organizationId],[NSNumber numberWithInteger:orgunitId],beginDateLli,endDateLli,firstReportRecord,maxCountReportRecord,_cookie,reportType];
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/organization/%@?organizationId=%ld&orgunitId=%ld&first=0&max=1&cookie=%@",self.strBaseUrl,newsType,(long)organizationId,(long)orgunitId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"获取公司、部门公告 url == %@",urlStr);
    
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
      
        }

    }else{
        NSLog(@"无缓存");
        [SVProgressHUD showWithStatus:@"载入中…"];
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
                if (arrReportsGot.count>0) {
                    [SVProgressHUD showSuccessWithStatus:@"完成"];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"暂时无公告"];
                }
            
            }else//如果查汇报不成功
            {
                WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
                Mark_Custom;
                NSLog(@"获取公司、部门公告 ERROR == %@",error.wErrorDescription);
                callback(nil,error);
                [SVProgressHUD showErrorWithStatus:@"无数据"];
    
            }
        }];
        [req startAsynchronous];
    }
    
    
    
}

#pragma mark -- 查询加入申请
//http://hb.m.gitom.com/3.0/organization/applys?organizationId=114&orgunitId=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
-(void)findApplyWithOrganizationId:(NSInteger)organizationId
                         orgunitId:(NSInteger)orgunitId
                     GotArrReports:(WbReportJsonArr)callback{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/organization/applys?organizationId=%d&orgunitId=%d&cookie=%@",self.strBaseUrl,organizationId,orgunitId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"查询申请 url == %@",urlStr);
    
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
 
        }
    }];
    [req startAsynchronous];
}
#pragma mark 消息通知相关
#pragma mark -- 获取设置读取通知的帐号 
//http://hb.m.gitom.com/3.0/report/reportReader?reader=58200&cookie=5533098A-43F1-4AFC-8641-E64875461345
- (void)reportReaderWithReader:(NSString *)reader
            GetReportNSDictionary:(void(^)(NSDictionary *readerDic))callBack{
    NSString *urlStr = [NSString stringWithFormat:@"%@/report/reportReader?reader=%@&cookie=%@",self.strBaseUrl,reader,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"获取设置读取通知的帐号 url == %@",urlStr);
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSData *dataResponse = [req responseData];
        WDataParse *wdp = [WDataParse sharedWDataParse];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        Body * body = [self getBodyWithDataResponse:dataResponse];
        NSLog(@"HBServerKit 完整数据之中取得body 获取设置读取通知的帐号 %@",body);
        if (body.success)//如果查汇报成功
        {
            NSDictionary * arrReportsGot = [wdp wGetDicJsonWithStringJson:body.data];
            NSLog(@"HBServerKit 从body取得data 获取设置读取通知的帐号== %@",arrReportsGot);
            callBack(arrReportsGot);
        }else//如果查汇报不成功
        {
//            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
//            NSLog(@"加入申请 ERROR == %@",error.wErrorDescription);
            callBack(nil);
  
        }
    }]; 
    [req startAsynchronous];
}

#pragma mark -- 设置消息已读状态
- (void)setMsgReadStatusOrgId:(NSInteger)organizationId
                    orgunitId:(NSInteger)orgunitId
                 andMessageId:(NSString *)messageId
                  andUsername:(NSString *)username{
    NSString *urlStr = [NSString stringWithFormat:@"%@/util/updateMsgReadStatus?organizationId=%d&orgunitId=%d&messageId=%@&username=%@&cookie=%@",self.strBaseUrl,organizationId,orgunitId,messageId,username,_cookie];
    NSLog(@"设置消息已读状态 url == %@",urlStr);
    ASIHTTPRequest *req = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [req startAsynchronous];
}

#pragma mark -- 获取消息通知
- (void)getNotcFromMemberOrgId:(NSInteger)organizationId
                     orgunitId:(NSInteger)orgunitId
                   andUserName:(NSString *)username
                  andBeginTime:(NSString *)beginTime
                      andFirst:(int)first
                        andMax:(int)max
        getQueryMessageArray:(void(^)(NSArray *messageArray))callBack{
    
    [SVProgressHUD showWithStatus:@"读取消息"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/util/queryMessage?organizationId=%d&orgunitId=%d&username=%@&beginTime=%@&first=%d&max=%d&cookie=%@",self.strBaseUrl,organizationId,orgunitId,username,beginTime,first,max,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"获取消息通知 url == %@",urlStr);
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    
    WDataParse *wdp = [WDataParse sharedWDataParse];
    [req setCompletionBlock:^{
        NSData *dataResponse = [req responseData];
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:dataResponse]];//检查服务器是否没有异常，如果有，就打印
        NSLog(@"HBServerKit 从服务端获得的完整json格式数据 获取消息通知 == %@",[[NSString alloc]initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        Body * body = [self getBodyWithDataResponse:dataResponse];
        
        NSLog(@"HBServerKit 完整数据之中取得body 获取消息通知 %@",body);
        if (body.success)//如果查汇报成功
        {
            
            NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
            NSMutableArray *massageMutableAr = [[NSMutableArray alloc]initWithCapacity:arrReportsGot.count];
            for (NSDictionary *massageDic in arrReportsGot) {
                QueryMessageModel *messageMod = [[QueryMessageModel alloc]init];
                messageMod.organizationId = [massageDic objectForKey:@"organizationId"];
                messageMod.createDate = [[massageDic objectForKey:@"createDate"]longLongValue];
                messageMod.updateDate = [[massageDic objectForKey:@"createDate"]longLongValue];
                messageMod.dtx = [massageDic objectForKey:@"dtx"];
                messageMod.extend = [massageDic objectForKey:@"extend"];
                messageMod.messageId = [massageDic objectForKey:@"messageId"];
                messageMod.orgunitId = [massageDic objectForKey:@"orgunitId"];
                messageMod.readUser = [massageDic objectForKey:@"readUser"];
                messageMod.sender = [massageDic objectForKey:@"sender"];
                messageMod.senderReadname = [massageDic objectForKey:@"senderReadname"];
                messageMod.username = [massageDic objectForKey:@"username"];
                messageMod.voidFlag = [[massageDic objectForKey:@"voidFlag"] intValue];
                [massageMutableAr addObject:messageMod];
        
            }
            
            callBack(massageMutableAr);
            if (massageMutableAr.count > 0) {
                [SVProgressHUD showSuccessWithStatus:@"获得"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"暂无消息"];
            }
            
            NSLog(@"HBServerKit 从body取得data 获取消息通知 == %@",arrReportsGot);
            //[arrReportsGot release];
        }else//如果查汇报不成功
        {
//            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
//            Mark_Custom;
//            NSLog(@"获取消息通知 ERROR == %@",error.wErrorDescription);
//            callBack(nil);
            [SVProgressHUD showErrorWithStatus:@"未获得"];
     
        }
    }];
    [req startAsynchronous];

}

#pragma mark -- 添加对应帐号消息通知http://hb.m.gitom.com/3.0/report/saveReportReader?reader=58200&username=71781&cookie=5533098A-43F1-4AFC-8641-E64875461345
- (void)saveReportReaderWithReader:(NSString *)reader
                        andUsernae:(NSString *)username
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/report/saveReportReader?reader=%@&username=%@&cookie=%@",self.strBaseUrl,reader,username,_cookie];
    NSLog(@"添加对应帐号消息通知 url == %@",urlStr);
    ASIHTTPRequest *req = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [req startAsynchronous];
}

#pragma mark -- 取消对应帐号消息通知
- (void)removeReportReaderWithReader:(NSString *)reader
                        andUsernae:(NSString *)username
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/report/removeReportReader?reader=%@&username=%@&cookie=%@",self.strBaseUrl,reader,username,_cookie];
    NSLog(@"添加对应帐号消息通知 url == %@",urlStr);
    ASIHTTPRequest *req = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [req startAsynchronous];
}

#pragma mark -- 获取考勤配置
-(void)getAttendanceConfigWithOrganizationId:(NSInteger)organizationId
                                   orgunitId:(NSInteger)orgunitId
                                     Refresh:(BOOL)refresh
                               GotDicReports:(void(^)(AttendanceWorktimeModel * dicAttenConfig))callback{

    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/attendanceConfig?organizationId=%d&orgunitId=%d&cookie=%@",self.strBaseUrl,organizationId,orgunitId,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    WDataParse *wdp = [WDataParse sharedWDataParse];
    NSString *key = [NSString stringWithFormat:@"attendanceattendanceConfig%ld%ld",(long)organizationId,(long)orgunitId];
    NSData *dataResponse = [FTWCache objectForKey:key];
    if (dataResponse&&refresh==NO) {
        nil;
    }else{
        
        [SVProgressHUD showWithStatus:@"加载配置…"];
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
                
                /*
                {\"attenConfig\":{\"createDate\":1369210033000,\"createUserId\":\"58200\",\"distance\":999,\"inMinute\":33,\"latitude\":24.798796,\"longitude\":118.583923,\"organizationId\":204,\"orgunitId\":1,\"outMinute\":33,\"updateDate\":1387248480000,\"updateUserId\":\"58\"},\"attenWorktime\":[{\"createDate\":1387248480000,\"createUserId\":\"58\",\"offTime\":0,\"onTime\":-20280000,\"ordinal\":1,\"organizationId\":204,\"orgunitId\":1,\"updateDate\":1387248480000,\"updateUserId\":\"58\",\"voidFlag\":false}]}*/
                
                NSDictionary * dicAttenConfig = [wdp wGetDicJsonWithStringJson:body.data];
                AttendanceWorktimeModel *attendanceMod = [[AttendanceWorktimeModel alloc]init];
                
                NSArray *countAr = [dicAttenConfig objectForKey:@"attenWorktime"];
                
                attendanceMod.latitude = [[[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"latitude"]floatValue];
                attendanceMod.longitude = [[[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"longitude"]floatValue];
                
                attendanceMod.inMinute = [[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"inMinute"];
                attendanceMod.outMinute = [[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"outMinute"];
                
                attendanceMod.distance = [[dicAttenConfig objectForKey:@"attenConfig"]objectForKey:@"distance"];
                
                if (countAr.count) {
                    NSString * offTimeStr1 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:0]objectForKey:@"offTime"];
                    NSString * onTimeStr1 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:0]objectForKey:@"onTime"];
                    attendanceMod.oneTime1 = [onTimeStr1 intValue];
                    attendanceMod.offTime1 = [offTimeStr1 intValue];
                }else{
                    attendanceMod.oneTime1 = kNotSetTime;
                    attendanceMod.offTime1 = kNotSetTime;
                }
                
                if (countAr.count>1) {
                    NSString * offTimeStr2 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:1]objectForKey:@"offTime"];
                    NSString * onTimeStr2 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:1]objectForKey:@"onTime"];
                    attendanceMod.offTime2 = [offTimeStr2 intValue];
                    attendanceMod.oneTime2 = [onTimeStr2 intValue];
                }else{
                    attendanceMod.offTime2 = kNotSetTime;
                    attendanceMod.oneTime2 = kNotSetTime;
                }
                
                
                if (countAr.count>2) {
                    NSString * offTimeStr3 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:2]objectForKey:@"offTime"];
                    NSLog(@"offTimeStr 3 = %@",offTimeStr3);
                    NSString * onTimeStr3 = [[[dicAttenConfig objectForKey:@"attenWorktime"]objectAtIndex:2]objectForKey:@"onTime"];
                    attendanceMod.offTime3 = [offTimeStr3 intValue] ;
                    attendanceMod.oneTime3 = [onTimeStr3 intValue];
                }else{
                    attendanceMod.offTime3 = kNotSetTime;
                    attendanceMod.oneTime3 = kNotSetTime;
                }
                
                [SVProgressHUD showSuccessWithStatus:@"获得配置"];
                NSLog(@"HBServerKit 从body取得data 获取考勤配置== %@",dicAttenConfig);
                callback(attendanceMod);
            }else//如果查汇报不成功
            {
//                WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
//                Mark_Custom;
//                NSLog(@"获取考勤配置 ERROR == %@",error.wErrorDescription);
                [SVProgressHUD showErrorWithStatus:@"未获得"];
                callback(nil);
 
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/saveAttendance?organizationId=%ld&orgunitId=%ld&username=%@&longitude=%f&latitude=%f&cookie=%@&punchType=%@",self.strBaseUrl,(long)organizationId,(long)orgunitId,username,longitude,latitude,_cookie,punchType];
    [SVProgressHUD showWithStatus:@"打卡…"];
    NSLog(@"HBServerKit 保存打卡记录 urlStr == %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
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
         
        }
    }];
    [req startAsynchronous];
}

#pragma mark -- 保存上传声音
-(void)saveSoundReportsOfMembersWithData:(NSString *)soundData
                           GotArrReports:(WbReportJsonArr)callback{
    NSString *urlString = [NSString stringWithFormat:@"%@/util/fileUpload?cookie=%@",self.strBaseUrl,_cookie];
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
    if (note) [dicParams setObject:[note stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"note"];
    
    if (!imgUrl ){
        NSLog(@"imgeUrl nil");
        imgUrl = @"{\"imageUrl\":[]}";
    }else{
        
    }
    [dicParams setObject:imgUrl forKey:@"imgUrl"];
    NSRange range = [soundUrl rangeOfString:@"null"];
    if (!soundUrl&& range.location != NSNotFound) {
        NSLog(@"soundUrl nil");
        soundUrl = @"{\"soundUrl\":[]}";
    }else{
        NSLog(@"HBServerKit soundUrl%@",soundUrl);
    }
    [dicParams setObject:soundUrl forKey:@"soundUrl"];
    [dicParams setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [dicParams setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [dicParams setObject:_cookie forKey:@"cookie"];
    WDataService * wds = [WDataService sharedWDataService];
    [wds wPostRequestWithIsAsynchronous:YES Url:[NSURL URLWithString:strPortReport] DicPostDatas:dicParams
                              GetResult:^(NSData *dataResponse, NSError *errorRequest)
    {
        if (!errorRequest){
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
            
            }
        }else
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
            Mark_Custom;
            NSLog(@"HBServeKit == %@",error.wErrorCode);
            callback(NO,error);
   
        }
    }];

}
#pragma mark -- 考勤数据处理
/*{"inTime":-14400000,"ordinal":1,"outTime":60000,"voidFlag":false}*/
#pragma mark -- 将考勤的打卡配置数据转换为字典
- (NSMutableArray *)getAttenWorktimeArrayBySetOutTime1:(int)outTime1
                                          andInTime1:(int)inTime1
                                         SetOutTime2:(int)outTime2
                                          andInTime2:(int)inTime2
                                         SetOutTime3:(int)outTime3
                                          andInTime3:(int)inTime3
{
    NSMutableDictionary *attenWorktimeDic1 = [[NSMutableDictionary alloc]init];
    [attenWorktimeDic1 setObject:[NSString stringWithFormat:@"%d",outTime1] forKey:@"outTime"];
    [attenWorktimeDic1 setObject:[NSString stringWithFormat:@"%d",inTime1] forKey:@"inTime"];
    [attenWorktimeDic1 setObject:@"1" forKey:@"ordinal"];
    [attenWorktimeDic1 setObject:@"false" forKey:@"voidFlag"];
    
    NSMutableDictionary *attenWorktimeDic2 = [[NSMutableDictionary alloc]init];
    [attenWorktimeDic2 setObject:[NSString stringWithFormat:@"%d",outTime2] forKey:@"outTime"];
    [attenWorktimeDic2 setObject:[NSString stringWithFormat:@"%d",inTime2] forKey:@"inTime"];
    [attenWorktimeDic2 setObject:@"2" forKey:@"ordinal"];
    [attenWorktimeDic2 setObject:@"false" forKey:@"voidFlag"];
    
    NSMutableDictionary *attenWorktimeDic3 = [[NSMutableDictionary alloc]init];
    [attenWorktimeDic3 setObject:[NSString stringWithFormat:@"%d",outTime3] forKey:@"outTime"];
    [attenWorktimeDic3 setObject:[NSString stringWithFormat:@"%d",inTime3] forKey:@"inTime"];
    [attenWorktimeDic3 setObject:@"3" forKey:@"ordinal"];
    [attenWorktimeDic3 setObject:@"false" forKey:@"voidFlag"];
    
    NSMutableArray *attenWorktimeArr = [[NSMutableArray alloc]init];
    if (outTime1!=kNotSetTime) [attenWorktimeArr addObject:attenWorktimeDic1];
    if (outTime2!=kNotSetTime) [attenWorktimeArr addObject:attenWorktimeDic2];
    if (outTime3!=kNotSetTime) [attenWorktimeArr addObject:attenWorktimeDic3];
    
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
    NSMutableDictionary *attenWorktimeDic = [[NSMutableDictionary alloc]init];
    if (!updateUser) {
        updateUser = @"58";
    }
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
    
    NSArray *confingArr = [self getAttenWorktimeArrayBySetOutTime1:outTime1
                                                        andInTime1:inTime1
                                                       SetOutTime2:outTime2
                                                        andInTime2:inTime2
                                                       SetOutTime3:outTime3
                                                        andInTime3:inTime3];
    
    NSDictionary *confingDic = [self getAttenConfigDictionaryByUpdateUser:updateUser
                                                              andDistance:distance
                                                              andInMinute:inMinute
                                                             andOutMinute:outMinute
                                                              andLatitude:latitude
                                                             andLongitude:longitude
                                                        andOrganizationId:organizationId
                                                             andOrgunitId:orgunitId
                                                          andWorkTimesArr:confingArr];
    
    NSData *getData = [NSJSONSerialization dataWithJSONObject:confingDic options:kNilOptions error:nil];
    
    NSString *getStr = [[NSString alloc]initWithData:getData encoding:NSUTF8StringEncoding];
    
    NSLog(@"getStr of configDatasDic == %@",getStr);
    
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)getStr, NULL, NULL,  kCFStringEncodingUTF8 ));
    
    NSLog(@"utf8 str == %@",encodedString);
    return encodedString;
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    long long int dateToSeconde = [WTool getEndDateTimeMsWithNSDate:[NSDate date]];
    
    NSLog(@"ManageAttendanceConfigVC dateToSeconde %lld  updateUser == %@",dateToSeconde,updateUser);
    
    NSString *attenInfo = [self getUpdateAttendanceConfigUTF8stringByUpdateUser:updateUser
                                                                    andDistance:distance
                                                                    andInMinute:inMinute
                                                                   andOutMinute:outMinute
                                                                    andLatitude:latitude
                                                                   andLongitude:longitude
                                                              andOrganizationId:organizationId
                                                                   andOrgunitId:orgunitId
                                                                    SetOutTime1:outTime1
                                                                     andInTime1:inTime1
                                                                    SetOutTime2:outTime2
                                                                     andInTime2:inTime2
                                                                    SetOutTime3:outTime3
                                                                     andInTime3:inTime3];
    
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


#pragma mark -- 发布部门公告
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
    if (title) [dicParams setObject:[title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"title"];
    if (content) [dicParams setObject:[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"content"];
    [dicParams setObject:_cookie forKey:@"cookie"];
    
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
       
             }
         }else
         {
             WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
             Mark_Custom;
             NSLog(@"HBServeKit == %@",error.wErrorCode);
             callback(NO,error);
     
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

    NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/util/saveUploadLocationTime?organizationId=%ld&orgunitId=%ld&millisecond=%lld&updateUser=%@&cookie=%@",(long)organizationId,(long)orgunitId,[intervalTime longLongValue] *60000,username,_cookie];
    NSLog(@"坐标上传的间隔 url == %@",changeRoleUrlStr);
    
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:changeRoleUrlStr]];
    [req setCompletionBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"完成修改"];
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
    [req startAsynchronous];
    
}


#pragma mark -- 上传用户坐标
- (void)sendUserPositionWithaccuracy:(float)accuracy
                         andlatitude:(float)latitude
                         andlocation:(NSString *)location
                        andlongitude:(float)longitude
                         andusername:(NSString *)username{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/util/saveLocation?username=%@&location=%@&longitude=%f&latitude=%f&accuracy=%f&cookie=%@",self.strBaseUrl,username,[location stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],longitude,latitude,accuracy,_cookie];
    NSLog(@"urlstr position == %@",urlStr);
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req setCompletionBlock:^{
        NSLog(@"完成上传");
    }];
    [req setFailedBlock:^{
        NSLog(@"上传失败");
    }];
    
    [req startAsynchronous];
    
}

#pragma mark -- 获取用户经过的位置
//http://hb.m.gitom.com/3.0/util/locations?username=58200&beginTime=1355155199000&endTime=1586259199000&cookie=A1920C78-5F22-4516-91C0-7B2786FD4A7D
- (void)getPositonsWithUserName:(NSString *)username
                   andbeginTime:(long long)beginTime
                     andendTime:(long long)endTime
                       getArray:(void(^)(NSArray *arr,WError * myError))callback{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/util/locations?username=%@&beginTime=%lld&endTime=%lld&cookie=%@",self.strBaseUrl,username,beginTime,endTime,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"userPositions == %@",urlStr);
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    //req.persistentConnectionTimeoutSeconds = 10;
    req.timeOutSeconds = 5;
    [req setDelegate:self];
    
    [SVProgressHUD showWithStatus:@"加载坐标…"];
    
    [req setCompletionBlock:^{
//        NSError *error = [req error]; NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
        NSData *dataResponse = [req responseData];
 
        WDataParse *wdp = [WDataParse sharedWDataParse];

        Body * body = [self getBodyWithDataResponse:dataResponse];

        if (body.success)//如果查汇报成功
        {
            /*
             {\"accuracy\":12345.1,\"createDate\":1386560300000,\"createUserId\":\"58200\",\"latitude\":0.582,\"location\":\"晋江青阳路253号\",\"logTime\":1386560300613,\"longitude\":0.582,\"updateDate\":1386560300000,\"updateUserId\":\"58200\",\"username\":\"58200\"}
             */
            NSArray * arrReportsGot = [wdp wGetArrJsonWithStringJson:body.data];
            NSMutableArray *userPositionAr = [[NSMutableArray alloc]init];
            
            for (NSDictionary *positionDic in arrReportsGot) {
 
                UserPositionModel *posMod = [[UserPositionModel alloc]init];
                posMod.loc = [[CLLocation alloc]initWithLatitude:[[positionDic objectForKey:@"latitude"]floatValue] longitude:[[positionDic objectForKey:@"longitude"]floatValue]];
                posMod.createDate = [positionDic objectForKey:@"createDate"];
                posMod.location = [positionDic objectForKey:@"location"];
                [userPositionAr addObject:posMod];
                
            }
            NSLog(@"UserPositionAr == %@",userPositionAr);
             callback(userPositionAr,nil);
            if (userPositionAr.count>0) {
                [SVProgressHUD showSuccessWithStatus:@"完成"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"无记录"];
            }
        
            
        }else//如果查汇报不成功
        {
            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
            Mark_Custom;
            callback(nil,error);
            [SVProgressHUD showErrorWithStatus:@"无数据"];
            
        }
        
    }];
    
    [req startAsynchronous];
    
}

#pragma mark -- 修改密码
- (void)changePassWordWithName:(NSString *)username
                     andOldPwd:(NSString *)oldPwd
                     andNewPwd:(NSString *)newPwd{
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@/util/changePwd?username=%@&oldPwd=%@&newPwd=%@&cookie=%@",self.strBaseUrl,username,oldPwd,newPwd,_cookie ];
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req setCompletionBlock:^{
        Body * body = [self getBodyWithDataResponse:[req responseData]];
        NSLog(@"HBServerKit 修改密码 %@",body);
        if (body.success)
        {
            [SVProgressHUD showSuccessWithStatus:@"完成修改"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"用户名密码错误"];
        }
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

#pragma mark -- 获取考勤
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
//            WError * error = [[WError alloc]initWithWErrorType:WErrorType_NetworkRequests];
            Mark_Custom;
//            NSLog(@"%@",error.wErrorCode);
            callback(nil);
   
        }
    }];
}

//http://uc.gitom.com/api/user/send_resister_smscode?mobile=13328786791
#pragma mark -- 注册用户
- (void)registerWithPhoneNumber:(NSString *)phoneNumber{
    NSString *urlStr = [NSString stringWithFormat:@"http://uc.gitom.com/api/user/send_resister_smscode?mobile=%@",phoneNumber];
    NSURL *url = [NSURL URLWithString:urlStr];
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        [req responseData];
        NSDictionary *getDic = [NSJSONSerialization JSONObjectWithData:[req responseData] options:kNilOptions error:nil];
        NSString *getMessage = [getDic objectForKey:@"message"];
//        NSString *getResult = [getDic objectForKey:@"result"];
//        NSString *getmessage_type = [getDic objectForKey:@"message_type"];
//        NSString *getSuccess = [getDic objectForKey:@"success"];
//        NSLog(@"getResult -== %@ %@ %@",getResult,getmessage_type,getSuccess);
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
    NSLog(@"api/user/mobile_resister_user == %@",urlStr);
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSLog(@"__weak req");
        [req responseData];
        NSDictionary *getDic = [NSJSONSerialization JSONObjectWithData:[req responseData] options:kNilOptions error:nil];
        NSString *getMessage = [getDic objectForKey:@"message"];
//        NSString *getResult = [getDic objectForKey:@"result"];13328786791 828573 111111
//        NSString *getmessage_type = [getDic objectForKey:@"message_type"];
//        NSString *getSuccess = [getDic objectForKey:@"success"];
//        NSLog(@"getResult -== %@ %@ %@",getResult,getmessage_type,getSuccess);
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
                               andVerifyType:(NSString *)verifyType{
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/user/saveApply?organizationId=%@&orgunitId=%@&note=%@&username=%@&cookie=%@&verifyType=%@",organizationId,orgunitId,[note stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],_cookie,[verifyType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"申请加入公司 urlStr == %@",urlStr);
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSLog(@"成功加入");
    }];
    [req setFailedBlock:^{
        NSLog(@"错误");
    }];
    [req startAsynchronous];
}
//http://hb.m.gitom.com/3.0/organization/joinOrgunitUser?organizationId=204&orgunitId=16&username=71781&roleId=2&updateUser=5820&cookie=5533098A-43F1-4AFC-8641-E64875461345
#pragma mark -- 直接加入公司
- (void) noApplyJoinToCompanyWithOrganizationId:(NSString *)organizationId
                                   andOrgunitId:(NSString *)orgunitId
                                     andUseName:(NSString *)username
                                    andRealName:(NSString *)realName
                                   andTelephone:(NSString *)telePhone
                                  andUpdateUser:(NSString *)updateUser{
    NSString *urlStr = [NSString stringWithFormat:@"%@/organization/joinOrgunitUser?organizationId=%@&orgunitId=%@&username=%@&realname=%@&telephone=%@&updateUser=%@&cookie=%@",self.strBaseUrl,organizationId,orgunitId,username,[realName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],telePhone,updateUser,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"直接加入公司 urlStr == %@",urlStr);
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req startAsynchronous];
}

#pragma mark -- 获得对应公司各部门的审核方式
- (void) getVerifyOfOrgunitWithOrganizationName:(NSString *)organizationName
                                   getVerifyArr:(void(^)(NSArray *verifyArr))callBack{
    
    NSString *utf8Str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)organizationName,NULL,NULL,kCFStringEncodingUTF8));
    
     NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/organizations?key=%@&first=0&max=1&cookie=%@",utf8Str,_cookie];
    
     ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req setCompletionBlock:^{
        WDataParse *wdp = [WDataParse sharedWDataParse];
        NSLog(@"获得对应公司各部门的审核方式 responseString == %@",[req responseString]);
        [self getIsServerNoErrorWithHead:[self getHeadWithDataResponse:[req responseData]]];//检查服务器是否没有异常，如果有，就打印
        Body * body = [self getBodyWithDataResponse:[req responseData]];
        if (body.success)
        {
            NSMutableArray *propsMutAr = [[NSMutableArray alloc]init];
            NSArray *getArr = [wdp wGetArrJsonWithStringJson:body.data];
            //NSArray *verifyMethodAr = [[NSArray alloc]init];
            if (getArr.count) {
                
                NSArray *verifyMethodAr = [[getArr objectAtIndex:0]objectForKey:@"orgunitList"];
                NSLog(@"HBServerKit verifyMethodAR == %@",verifyMethodAr);
                    for (NSDictionary *orgunitPropsDic in verifyMethodAr) {
                        NSArray *propsStr = [[NSArray alloc]init];
                        propsStr = [orgunitPropsDic objectForKey:@"orgunitProps"];
                        [propsMutAr addObject:propsStr];
                    
                    }
                
                }
            NSLog(@"HBServerKit propsMutAr == %@",propsMutAr);
                callBack(propsMutAr);
            }else{
                callBack(nil);
            }
            
     }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"服务器数据获取失败"];
    }];
    [req startAsynchronous];
    
    
}


#pragma mark -- 修改审核方式
- (void)changeApplyJoinWayToCompanyWithOrganizationId:(NSInteger)organizationId
                                         andOrgunitId:(NSInteger)orgunitId
                                            andMethod:(NSString *)method
                                          andQuestion:(NSString *)question
                                            andAnswer:(NSString *)answer
                                        andUpdateUser:(NSString *)updateUser{
    
    [SVProgressHUD showWithStatus:@"保存…"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/organization/saveVerifyMethod?organizationId=%d&orgunitId=%d&method=%@&question=%@&answer=%@&updateUser=%@&cookie=%@",self.strBaseUrl,organizationId,orgunitId,[method stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[question stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[answer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],updateUser,_cookie];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"修改审核方式 urlStr == %@",urlStr);
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"完成修改"];
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
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

                }/*
                OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
                orgMod = [companyArr objectAtIndex:9];
                NSLog(@"HBServerKit orgPropsArray ALL ARR == %@  index9 = %@",companyArr,orgMod.orgunitPropsArray);*/
                callBack(companyArr);
            }else{
                callBack(nil);
            }
            
        }else
        {
//            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
//            NSLog(@"%@",error.wErrorDescription);
         
        }
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"服务器数据获取失败"];
    }];
    [req startAsynchronous];
}

#pragma mark -- 添加点评
- (void) addCommentWithOrganizationId:(NSInteger)organizationId
                            OrgunitId:(NSInteger)orgunitId
                             ReportId:(NSString *)reportId
                              Content:(NSString *)content
                                Score:(NSString *)score
                           CreateUser:(NSString *)createUser
                             Username:(NSString *)username{
    int temp = arc4random()%1000;
    NSString *urlStr = [NSString stringWithFormat:@"%@/report/saveReportComment?organizationId=%d&orgunitId=%d&reportId=%@&content=%@&score=%@&createUser=%@&username=%@&cookie=%@&temp=%d",self.strBaseUrl,organizationId,orgunitId,reportId,[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],score,createUser,username,_cookie,temp];
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
                             andGetCommentMod:(void(^)(NSArray *commentMod))callBack{

    NSString *urlStr = [NSString stringWithFormat:@"%@/report/findReportComments?organizationId=%d&orgunitId=%d&reportId=%@&first=0&max=10&cookie=%@",self.strBaseUrl,organizationId,orgunitId,reportId,_cookie];
    
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
                
                NSMutableArray *commentArray = [[NSMutableArray alloc]init];
                
                for (int i=0; i<getArr.count; i++) {
                    
                    CommentModle *commentModel = [[CommentModle alloc]init];
                    NSLog(@"HBServerKit getArr Count == %d | i == %d",getArr.count,i);
                    commentModel.createDate = [[getArr objectAtIndex:i]objectForKey:@"createDate"];
                    commentModel.createUserId = [[getArr objectAtIndex:i]objectForKey:@"createUserId"];
                    commentModel.level = [[getArr objectAtIndex:i]objectForKey:@"level"];
                    commentModel.note = [[getArr objectAtIndex:i]objectForKey:@"note"];
                    commentModel.realname = [[getArr objectAtIndex:i]objectForKey:@"realname"];
                    
                    [commentArray addObject:commentModel];
                }
                NSLog(@"HBServerKit commentArray == %@",commentArray);
                callBack(commentArray);
      
            }else{
                
                callBack(nil);
                
            }
            
        }else
        {
            
//            WError * error = [[WError alloc]initWithWErrorType:WErrorType_Logic wErrorDescription:body.warning];
//            NSLog(@"%@",error.wErrorDescription);
         
        }
    }];
    [req startAsynchronous];
}

#pragma mark --上传位置 http://hb.m.gitom.com/3.0/util/saveLocation?username=204&location=0000&longitude=58200&latitude=WTO&cookie=5533098A-43F1-4AFC-8641-E64875461345
- (void) saveLocationWithUserName:(NSInteger)username
                      andLocation:(NSString *)location
                     andLongitude:(NSString *)longitude
                      andLatitude:(NSString *)latitude{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/util/saveLocation?username=%d&location=%@&longitude=%@&latitude=%@&cookie=%@",self.strBaseUrl,username,location,longitude,latitude,_cookie];
    NSLog(@"HBServerKit 上传位置 url == %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req startAsynchronous];
    
}


#pragma mark - ServerBaseModel
//得到data对应的字符串
-(NSString *)getStrDataWithDataResponse:(NSData *)dataResponse
{
    NSString * strResponse = [[NSString alloc]initWithData:dataResponse encoding:4];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    NSDictionary * dicServerBase = [wdp wGetDicJsonWithStringJson:strResponse];
    ServerBaseModel * serverBaseModel = [[ServerBaseModel alloc]initForAllJsonDataTypeWithDicFromJson:dicServerBase];
    Body * body = [[Body alloc]initForAllJsonDataTypeWithDicFromJson:serverBaseModel.body];
 
    NSString * strData = body.data;
 
    return strData;
}
//生成 ServerBaseModel
-(ServerBaseModel *)getServerBaseModelWithDataResponse:(NSData *)dataResponse
{
    NSString * strResponse = [[NSString alloc]initWithData:dataResponse encoding:4];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    NSDictionary * dicServerBase = [wdp wGetDicJsonWithStringJson:strResponse];
    ServerBaseModel * modelBase = [[ServerBaseModel alloc]initForAllJsonDataTypeWithDicFromJson:dicServerBase];
    return modelBase;
}
// 生成 Body
-(Body *)getBodyWithDataResponse:(NSData *)dataResponse
{
    NSString * strResponse = [[NSString alloc]initWithData:dataResponse encoding:4];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    NSDictionary * dicServerBase = [wdp wGetDicJsonWithStringJson:strResponse];
    ServerBaseModel * serverBaseModel = [[ServerBaseModel alloc]initForAllJsonDataTypeWithDicFromJson:dicServerBase];
    Body * body = [[Body alloc]initForAllJsonDataTypeWithDicFromJson:serverBaseModel.body];
 
    return body;
}
// 生成 Head
-(Head *)getHeadWithDataResponse:(NSData *)dataResponse
{
    NSString * strResponse = [[NSString alloc]initWithData:dataResponse encoding:4];
    WDataParse * wdp = [WDataParse sharedWDataParse];
    NSDictionary * dicServerBase = [wdp wGetDicJsonWithStringJson:strResponse];
    ServerBaseModel * serverBaseModel = [[ServerBaseModel alloc]initForAllJsonDataTypeWithDicFromJson:dicServerBase];
    Head * head = [[Head alloc]initForAllJsonDataTypeWithDicFromJson:serverBaseModel.head];
  
    return head;
}

//判断服务器是不是没有异常
-(BOOL)getIsServerNoErrorWithDicHead:(NSDictionary *)dicHead
{
    BOOL isOk = YES;
    if (!dicHead || dicHead.count == 0) return NO;
    Head * head = [[Head alloc]initForAllJsonDataTypeWithDicFromJson:dicHead];
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

#pragma mark -- 字符串是否含有数字
- (BOOL)isNumbers:(NSString *)sender{
    NSLog(@"字符串是否为数字");
    NSRange str1 = [sender rangeOfString:@"1"];
    NSRange str2 = [sender rangeOfString:@"2"];
    NSRange str3 = [sender rangeOfString:@"3"];
    NSRange str4 = [sender rangeOfString:@"4"];
    NSRange str5 = [sender rangeOfString:@"5"];
    NSRange str6 = [sender rangeOfString:@"6"];
    NSRange str7 = [sender rangeOfString:@"7"];
    NSRange str8 = [sender rangeOfString:@"8"];
    NSRange str9 = [sender rangeOfString:@"9"];
    NSRange str0 = [sender rangeOfString:@"0"];
    if (str1.location != NSNotFound|str2.location != NSNotFound|str3.location != NSNotFound|str4.location != NSNotFound|str5.location != NSNotFound|str6.location != NSNotFound|str7.location != NSNotFound|str8.location != NSNotFound|str9.location != NSNotFound|str0.location != NSNotFound) {
        NSLog(@"是数字");
        return YES;
    }
    return NO;

    
}

@end
