//
//  ReportManager.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCommonMacroDefine.h"
#import "BaseManager.h"
#import "ReportModel.h"
typedef NS_ENUM(NSInteger, Flag_ReportType) {
    Flag_ReportType_Work = 1,
    Flag_ReportType_GoOut = 2,
    Flag_ReportType_Travel = 3,
    Flag_ReportType_All = 4
};

/*
 //与服务器对应
 REPORT_TYPE_GO_OUT  // 外出汇报
 REPORT_TYPE_TRAVEL   // 出差汇报
 REPORT_TYPE_DAY_REPORT  // 工作汇报
 REPORT_TYPE_ALL // 所有汇报 (暂时没用)
 */
#define TypeReport_GoOut @"REPORT_TYPE_GO_OUT"// 外出汇报
#define TypeReport_Travel @"REPORT_TYPE_TRAVEL"// 出差汇报
#define TypeReport_Work @"REPORT_TYPE_DAY_REPORT"// 工作汇报
#define TypeReport_ALL @"REPORT_TYPE_ALL"// 所有汇报 (暂时没用)
@interface ReportManager : BaseManager

SINGLETON_FOR_CLASS_Interface(ReportManager);

//得到今天自身的汇报记录
typedef void(^WbArrReports)(NSArray * arrReports,BOOL isOk);
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                           OrgunitId:(NSInteger)orgunitId
                            Username:(NSString *)username
                          ReportType:(NSString *)typeReport
                        BeginDateLli:(long long int)beginDateLli
                          EndDateLli:(long long int)endDateLli
                   FirstReportRecord:(NSInteger)firstReportRecord
                     MaxReportRecord:(NSInteger)maxCountReportRecord
                              Refrsh:(BOOL)refreshOrNot
                       GotArrReports:(WbArrReports)callback;


-(void)getArrMyReportsTodayWithIntReportType:(NSInteger)intTypeReport
                              FirstNumRecord:(NSInteger)numFirstRecord
                                MaxNumRecord:(NSInteger)numMaxRecord
                               GotArrReports:(WbArrReports)callback;


//上传我的汇报
-(void)saveReportWithReportModel:(ReportModel *)reportModel GotIsReportOk:(void(^)(BOOL isReportOk))callback;


+(NSString *)getStrTypeReportWithIntReportType:(Flag_ReportType)intTypeReport;

//获取公司公告
- (void)getOrganizationNewsWithOrganizationId:(NSInteger)organizationId
                            FirstReportRecord:(NSInteger)firstReportRecord
                              MaxReportRecord:(NSInteger)maxCountReportRecord
GotArrReports:(WbArrReports)callback;







@end
