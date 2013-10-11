//
//  HBServerKit.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "BaseService.h"
#import "WCommonMacroDefine.h"
#import "UserLoggedInfo.h"
#import "WError.h"
#import "WDataParse.h"
#import "WDataService.h"
#import "ServerBaseModel.h"
@interface HBServerKit : BaseService
@property(nonatomic,retain)ServerBaseModel * serverBaseMessage;
#pragma mark - 用户相关操作
#pragma mark -得到用户头像
-(void)getUserPhotoImageWithStrUserPhotoUrl:(NSString *)strUserPhotoUrl
                                  GotResult:(void(^)(UIImage *imgUserPhoto, WError * myError))callback;


#pragma mark -信息
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                   FirstReportRecord:(NSInteger)firstReportRecord
                     MaxReportRecord:(NSInteger)maxCountReportRecord
                       GotArrReports:(void(^)(NSArray * arr,WError * myError))callback;

#pragma mark -登录
typedef void(^WbLoginJsonDic)(NSDictionary * dicUserLogged,WError * myError);
-(void)loggingWithUsername:(NSString *)username
             Md5PasswordUp:(NSString *)md5PassUp
               VersionCode:(NSString *)versionCode
                GotJsonDic:(WbLoginJsonDic)callback;

#pragma mark -- 获得汇报记录
typedef void(^WbReportJsonArr)(NSArray * arrDicReports,WError * myError);
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                           OrgunitId:(NSInteger)orgunitId
                            Username:(NSString *)username
                          ReportType:(NSString *)typeReport
                        BeginDateLli:(long long int)beginDateLli
                          EndDateLli:(long long int)endDateLli
                   FirstReportRecord:(NSInteger)firstReportRecord
                     MaxReportRecord:(NSInteger)maxCountReportRecord
                       GotArrReports:(WbReportJsonArr)callback;

#pragma mark -- 保存上传汇报数据
typedef  void(^WbReportSave)(BOOL isReportOk,WError * myError);
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
                  GotIsSaveReportOk:(WbReportSave)callback;

#pragma mark - 发布部门消息
-(void)saveReportWithOrganizationId:(NSInteger)organizationId
                          OrgunitId:(NSInteger)orgunitId
                           Username:(NSString *)username
                         Title:(NSString *)title
                               Content:(NSString *)content
                  GotIsSaveReportOk:(WbReportSave)callback;


#pragma mark - 考勤
//得到考勤配置(工作时间段，考勤距离，公司坐标等)
-(void)getAttendanceConfigWithOrganizationID:(NSInteger)organizationId
                                   OrgunitID:(NSInteger)orgunitID
                              GotAttenConfig:(void(^)(NSDictionary * dicAttenConfig))callback;

#pragma mark - 查询用户所在部门
-(void)findUserOrganizationId:(NSInteger)organizationId
                     UserName:(NSString *)userName
                       GotArrReports:(WbReportJsonArr)callback;

#pragma mark - 查询公司部门
-(void)findReportsWithOrganizationId:(NSInteger)organizationId
                       GotArrReports:(WbReportJsonArr)callback;

#pragma mark - 查询部门成员
-(void)findOrgunitMembersWithOrganizationId:(NSInteger)organizationId
                                  orgunitId:(NSInteger)orgunitId
                              GotArrReports:(WbReportJsonArr)callback;
#pragma mark - 查看部门汇报
-(void)findOrgunitReportsOfMembersWithOrganizationId:(NSInteger)organizationId
                                           orgunitId:(NSInteger)orgunitId
                                          ReportType:(NSString *)reportType
                                        BeginDateLli:(long long int)beginDateLli
                                          EndDateLli:(long long int)endDateLli
                                   FirstReportRecord:(NSInteger)firstReportRecord
                                     MaxReportRecord:(NSInteger)maxCountReportRecord
                                       GotArrReports:(WbReportJsonArr)callback;

@end
