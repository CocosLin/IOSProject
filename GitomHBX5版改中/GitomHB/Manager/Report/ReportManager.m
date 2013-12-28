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

#pragma mark -- 获得当天的汇报记录
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                           OrgunitId:(NSInteger)orgunitId
                            Username:(NSString *)username
                          ReportType:(NSString *)typeReport
                        BeginDateLli:(long long int)beginDateLli
                          EndDateLli:(long long int)endDateLli
                   FirstReportRecord:(NSInteger)firstReportRecord
                     MaxReportRecord:(NSInteger)maxCountReportRecord
                              Refrsh:(BOOL)refreshOrNot
                       GotArrReports:(WbArrReports)callback
{
    NSLog(@"ReportManager == 开始获得汇报记录");
    
    [_serverKit findReportsWithOrganizationId:organizationId
                                    OrgunitId:orgunitId
                                     Username:username
                                   ReportType:typeReport
                                 BeginDateLli:beginDateLli
                                   EndDateLli:endDateLli
                            FirstReportRecord:firstReportRecord
                              MaxReportRecord:maxCountReportRecord
                                  RefreshData:refreshOrNot
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
  
             }
             callback(mArrReports,YES);
 
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
         }else{
             callback(isReportOk);
         [SVProgressHUD dismissWithIsOk:isReportOk String:strShow];
             //汇报结束删除图片，节约内存
             NSFileManager *manger = [NSFileManager defaultManager];
             for (int i =0; i<4; i++) {
                 NSString *photoPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),[NSString stringWithFormat:@"myPhoto%d.jpg",3010+i]];
                 NSData *photoData = [NSData dataWithContentsOfFile:photoPath];
                 if (photoData) {
                     NSLog(@"photo have %@",photoPath);
                     [manger removeItemAtPath:photoPath error:nil];
                 }else{
                     NSLog(@"photo nil %@",photoPath);
                 }
                 
             }
             //汇报结束删除录音，节约内存
             for (int i =0; i<4; i++) {
                 NSString *soundPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),[NSString stringWithFormat:@"coverToAMR%d.amr",4010+i]];
                 NSData *soundData = [NSData dataWithContentsOfFile:soundPath];
                 if (soundData) {
                     NSLog(@"sound have %@",soundPath);
                     [manger removeItemAtPath:soundPath error:nil];
                 }else{
                     NSLog(@"sound nil %@",soundPath);
                 }
                 
             }
             NSString *soundOtherPath = [NSString stringWithFormat:@"%@soundRecord.caf",NSTemporaryDirectory()];
             NSData *soundOtherData = [NSData dataWithContentsOfFile:soundOtherPath];
             if (soundOtherData) {
                 [manger removeItemAtPath:soundOtherPath error:nil];
             }else{
                 NSLog(@"sound nil");
             }
         }
         
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
