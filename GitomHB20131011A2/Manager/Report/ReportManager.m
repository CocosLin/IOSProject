//
//  ReportManager.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ReportManager.h"
#import "WTool.h"
#import "SVProgressHUD.h"
#import "ReportModel.h"
@implementation ReportManager
- (id)init
{
    self = [super init];
    if (self) {
        //        _serverKit = [];
    }
    return self;
}
SINGLETON_FOR_CLASS_Implementation(ReportManager)

//得到今天自身的汇报记录
/*
-(void)getArrMyReportsTodayWithIntReportType:(NSInteger)intTypeReport
                           FirstNumRecord:(NSInteger)numFirstRecord
                             MaxNumRecord:(NSInteger)numMaxRecord
                            GotArrReports:(WbArrReports)callback
{
    NSLog(@"ReportManager getReport today == 获得当天的汇报记录");
    NSString * strTypeReport = TypeReport_Work;
    if (intTypeReport == 1) {
        strTypeReport = TypeReport_Work;
    }
    [SVProgressHUD showWithStatus:@"正在获取今天的汇报记录" maskType:4];
    GetCommonDataModel;
    NSDate * dateNow = [NSDate date];
    long long dtBeginNow = [WTool getBeginDateTimeMsWithNSDate:dateNow];
  
    long long dtEndNow = [WTool getEndDateTimeMsWithNSDate:dateNow];
      NSLog(@"dtBeginNow : %@",[NSDate dateWithTimeIntervalSince1970:dtBeginNow/1000]);
      NSLog(@"dtEndNow : %@",[NSDate dateWithTimeIntervalSince1970:dtEndNow/1000]);
    NSString * username = comData.userModel.username;
    NSInteger organnizationId = comData.organization.organizationId;
    NSInteger orgunitId = comData.organization.orgunitId;
    [_serverKit findReportsWithOrganizationId:organnizationId
                                    OrgunitId:orgunitId
                                     Username:username
                                   ReportType:strTypeReport
                                 BeginDateLli:dtBeginNow
                                   EndDateLli:dtEndNow
                            FirstReportRecord:numFirstRecord
                              MaxReportRecord:numMaxRecord
                                GotArrReports:^(NSArray *arrDicReports, WError *myError)
     {
         if (arrDicReports.count) {
             NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
             for (NSDictionary * dicReports in arrDicReports) {
                 ReportModel * reModel = [[ReportModel alloc]initForAllJsonDataTypeWithDicFromJson:dicReports];
                 [mArrReports addObject:reModel];
                 [reModel release];
             }
             callback(mArrReports,YES);
             [SVProgressHUD dismissWithIsOk:YES String:@"获取今天的汇报成功!"];
         }else
         {
             [SVProgressHUD dismissWithIsOk:NO String:@"无今天的汇报记录"];
         }

     }];
}*/
#pragma mark -- 获得当天的汇报记录
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                           OrgunitId:(NSInteger)orgunitId
                            Username:(NSString *)username
                          ReportType:(NSString *)typeReport
                        BeginDateLli:(long long int)beginDateLli
                          EndDateLli:(long long int)endDateLli
                   FirstReportRecord:(NSInteger)firstReportRecord
                     MaxReportRecord:(NSInteger)maxCountReportRecord
                       GotArrReports:(WbArrReports)callback
{
    NSLog(@"ReportManager == 开始获得汇报记录");
    //[SVProgressHUD showWithStatus:@"正在获取汇报记录..." maskType:4];
//    NSLog(@"dtBeginNow : %@",[WTool getStrDateTimeWithDateTimeMS:beginDateLli DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"]);
//    NSLog(@"dtEndNow : %@",[WTool getStrDateTimeWithDateTimeMS:endDateLli DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"]);
    [_serverKit findReportsWithOrganizationId:organizationId
                                    OrgunitId:orgunitId
                                     Username:username
                                   ReportType:typeReport
                                 BeginDateLli:beginDateLli
                                   EndDateLli:endDateLli
                            FirstReportRecord:firstReportRecord
                              MaxReportRecord:maxCountReportRecord
                                GotArrReports:^(NSArray *arrDicReports, WError *myError)
     {
         if (arrDicReports.count) {
             NSLog(@"ReportManager 数组循环次数 ==  %d \n %@",arrDicReports.count,arrDicReports);
             NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
             for (NSDictionary * dicReports in arrDicReports)
             {
                 NSLog(@"ReportManager 获得数据内容 == %@",dicReports);
                 ReportModel * reModel = [[ReportModel alloc]initForAllJsonDataTypeWithDicFromJson:dicReports];
                 [mArrReports addObject:reModel];
                 [reModel release];
             }
             callback(mArrReports,YES);
             //[SVProgressHUD dismissWithIsOk:YES String:@"获取汇报记录成功!"];
         }else
         {
             [SVProgressHUD dismissWithIsOk:NO String:@"无汇报记录"];
         }
     }];
}

#pragma mark -- 公司公告
//获取公司公告
- (void)getOrganizationNewsWithOrganizationId:(NSInteger)organizationId
                            FirstReportRecord:(NSInteger)firstReportRecord
                              MaxReportRecord:(NSInteger)maxCountReportRecord
                                GotArrReports:(WbArrReports)callback{
    NSLog(@"ReportManager == 开始获得公司公告");
    [SVProgressHUD showWithStatus:@"正在获取公司公告..." maskType:4];
    //    NSLog(@"dtBeginNow : %@",[WTool getStrDateTimeWithDateTimeMS:beginDateLli DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"]);
    //    NSLog(@"dtEndNow : %@",[WTool getStrDateTimeWithDateTimeMS:endDateLli DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"]);
    [_serverKit findReportsWithOrganizationId:organizationId
                            FirstReportRecord:firstReportRecord
                              MaxReportRecord:maxCountReportRecord
                                GotArrReports:^(NSArray *arrDicReports, WError *myError)
     {
         if (arrDicReports.count) {
             NSLog(@"ReportManager 数组循环次数 ==  %d",arrDicReports.count);
             NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
             for (NSDictionary * dicReports in arrDicReports)
             {
                 NSLog(@"ReportManager 获得数据内容 == %@",dicReports);
                 ReportModel * reModel = [[ReportModel alloc]initForAllJsonDataTypeWithDicFromJson:dicReports];
                 [mArrReports addObject:reModel];
                 [reModel release];
             }
             callback(mArrReports,YES);
             [SVProgressHUD dismissWithIsOk:YES String:@"获取汇报记录成功!"];
         }else
         {
             [SVProgressHUD dismissWithIsOk:NO String:@"无汇报记录"];
         }
     }];

}



//上传汇报
#pragma mark -- 上传汇报
-(void)saveReportWithReportModel:(ReportModel *)reportModel GotIsReportOk:(void(^)(BOOL isReportOk))callback
{
    
    [SVProgressHUD showWithStatus:@"正在上传汇报,请耐心等待" maskType:4];
    GetCommonDataModel;
    if ([reportModel.note isEqualToString:@""] || reportModel.note == nil) {
        [SVProgressHUD dismissWithIsOk:NO  String:@"请输入汇报内容!"];
        return;
    }
    [_serverKit saveReportWithOrganizationId:reportModel.organizationId
                                   OrgunitId:reportModel.orgunitId
                                    Username:comData.userModel.username
                                  ReportType:reportModel.reportType
                                        Note:reportModel.note
                                     Address:reportModel.address
                                      ImgUrl:reportModel.imageUrl
                                    SoundUrl:reportModel.soundUrl
                                   Longitude:reportModel.longitude
                                    Latitude:reportModel.latitude
                           GotIsSaveReportOk:^(BOOL isReportOk, WError *myError)
     {
         NSString * strShow = @"上传汇报成功!";
         if (!isReportOk) {
             strShow = myError.wErrorDescription;
         }
         callback(isReportOk);
         [SVProgressHUD dismissWithIsOk:isReportOk String:strShow];
    }];
}


+(NSString *)getStrTypeReportWithIntReportType:(Flag_ReportType)intTypeReport
{
    NSString * strTypeReport = nil;
    if (intTypeReport == Flag_ReportType_Work)//工作汇报
    {
        strTypeReport = TypeReport_Work;
    }
    else if(intTypeReport == Flag_ReportType_Travel)
    {
        strTypeReport = TypeReport_Travel;
    }
    else if(intTypeReport == Flag_ReportType_GoOut)
    {
        strTypeReport = TypeReport_GoOut;
    }
    else if(intTypeReport == Flag_ReportType_All)
    {
        strTypeReport = TypeReport_ALL;
    }
    return strTypeReport;
}

@end
