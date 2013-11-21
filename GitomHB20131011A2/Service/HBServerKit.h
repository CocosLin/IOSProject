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
#import "CommentModle.h"

#import "FTWCache.h"
#import "NSString+MD5.h"


@interface HBServerKit : BaseService
@property(nonatomic,retain)ServerBaseModel * serverBaseMessage;
@property (nonatomic,assign) BOOL success;
#pragma mark - 用户相关操作
#pragma mark -得到用户头像
-(void)getUserPhotoImageWithStrUserPhotoUrl:(NSString *)strUserPhotoUrl
                                  GotResult:(void(^)(UIImage *imgUserPhoto, WError * myError))callback;
#pragma mark -- 获得汇报图片
- (NSArray *) getImgStringWith:(NSString *)jsonStr;
- (NSArray *) getSoundStringWith:(NSString *)jsonStr;
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


typedef void(^WbReportJsonArr)(NSArray * arrDicReports,WError * myError);

#pragma mark -- 修改密码
- (void)changePassWordWithName:(NSString *)username
                     andOldPwd:(NSString *)oldPwd
                     andNewPwd:(NSString *)newPwd;
#pragma mark - 注册用户
- (void)registerWithPhoneNumber:(NSString *)phoneNumber;
- (BOOL)registerRealWithPhoneNumber:(NSString *)phoneNumber
                         andSmscode:(NSString *)smscode
                        andPassword:(NSString *)passWord;

#pragma mark -- 申请加入公司
- (void)applyJoinToCompanyWithOrganizationId:(NSString *)organizationId
                                andOrgunitId:(NSString *)orgunitId
                                     andNote:(NSString *)note
                                  andUseName:(NSString *)username
                               andVerifyType:(int)verifyType;

#pragma mark -- 搜索公司
- (void)searchCompanyWithKey:(NSString *)key
                         andFirst:(int)first
                           andMax:(int)max
                        andGetArr:(void(^)(NSArray *companyAr))callBack;

#pragma mark -- 查询点评
- (void) findCommentWithOrganizationId:(NSInteger)organizationId
                             OrgunitId:(NSInteger)orgunitId
                              ReportId:(NSString *)reportId
                      andGetCommentMod:(void(^)(CommentModle *commentMod))callBack;

#pragma mark -- 添加点评
- (void) addCommentWithOrganizationId:(NSInteger)organizationId
                            OrgunitId:(NSInteger)orgunitId
                             ReportId:(NSString *)reportId
                              Content:(NSString *)content
                                Score:(NSString *)score
                           CreateUser:(NSString *)createUser
                             Username:(NSString *)username;

#pragma mark -- 保存更改信息内容telephone  http://hb.m.gitom.com/3.0/user/updateUser?username=90261&realname=婷婷01&telephone=90261&photo=nil&cookie=5533098A-43F1-4AFC-8641-E64875461345
- (void) saveUserDocumentWithUsername:(NSString *)userName
                          andRealName:(NSString *)realName
                         andTelephone:(NSString *)telephone
                             andPhoto:(NSString *)photo;

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

#pragma mark -- 保存打卡记录
- (void) savePlayCardWithOrganizationId:(NSInteger)organizationId
                              OrgunitId:(NSInteger)orgunitId
                               Username:(NSString *)username
                              PunchType:(NSString *)punchType
                              Longitude:(CGFloat)longitude
                               Latitude:(CGFloat)latitude
                          GotArrReports:(WbReportJsonArr)callback;

#pragma mark -- 保存上传声音
-(void)saveSoundReportsOfMembersWithData:(NSString *)imgData
                           GotArrReports:(WbReportJsonArr)callback;


#pragma mark -- 上传图片，返回服务器图片链接  http://hb.m.gitom.com/3.0/util/fileUpload/此处是图片的二进制data数据?width==200&height==200&cookie=5533098A-43F1-4AFC-8641-E64875461345
#pragma mark -- 保存上传图片
-(void)saveImageReportsOfMembersWithData:(NSString *)imgData
                           GotArrReports:(WbReportJsonArr)callback;

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
                                                  andInTime3:(int)inTime3;

#pragma mark - 发布部门消息
-(void)saveReportWithOrganizationId:(NSInteger)organizationId
                          OrgunitId:(NSInteger)orgunitId
                           Username:(NSString *)username
                         Title:(NSString *)title
                               Content:(NSString *)content
                  GotIsSaveReportOk:(WbReportSave)callback;

#pragma mark -- 编辑主管权限
- (void)saveRolePrivilegeWithOrganizationId:(NSInteger)organizationId
                                  andRoleId:(NSInteger)roleId
                              andOperations:(NSString *)operations
                              andUpdateUser:(NSString *)updateUser;

#pragma mark -- 删除部门
- (void)deleteOrgunitWithOrganizationId:(NSInteger)organizationId
                           andOrgunitId:(NSInteger)orgunitId
                          andUpdateUser:(NSString *)updateUser;

#pragma mark -- 转移部门
- (void)changeMemberToOtherOrgWihtOrganizationId:(NSInteger)organizationId
                                    andOrgunitId:(NSString *)orgunitId
                                 andTarOrgunitId:(NSString *)tarOrgunitId
                                     andUserName:(NSString *)userName
                                   andUpdateUser:(NSString *)updateUser;

#pragma mark -- 添加部门
- (void)addOrgunitWithrganitzationId:(NSInteger)organizationId
                      andOrgunitName:(NSString *)creatName
                         andUsername:(NSString *)username;

#pragma mark -- 更改部门名称
- (void)changeOrgNameWith:(NSInteger)organizationId
             andOrgunitId:(NSInteger)orgunitId
              andUsername:(NSString *)username
                  andName:(NSString *)name;

#pragma mark - 更改坐标上传的间隔
- (void)changeSendPositionPointIntervalorganitzationId:(NSInteger)organizationId
                                          andOrgunitId:(NSInteger)orgunitId
                                           andInterval:(NSString *)intervalTime
                                           andUsername:(NSString *)username;

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
                             Refresh:(BOOL)refreshOrNot
                       GotArrReports:(WbReportJsonArr)callback;

#pragma mark - 查询部门成员
-(void)findOrgunitMembersWithOrganizationId:(NSInteger)organizationId
                                  orgunitId:(NSInteger)orgunitId
                                    Refresh:(BOOL)refreshYesOrNot
                              GotArrReports:(WbReportJsonArr)callback;

#pragma mark - 查看部门打卡(整个部门、个人:打卡)
-(void)findAttendanceReportsOfMembersWithOrganizationId:(NSInteger)organizationId
                                           orgunitId:(NSInteger)orgunitId
                                      orgunitAttendance:(BOOL)yesOrNo
                                               userName:(NSInteger)userName
                                        BeginDateLli:(long long int)beginDateLli
                                          EndDateLli:(long long int)endDateLli
                                   FirstReportRecord:(NSInteger)firstReportRecord
                                     MaxReportRecord:(NSInteger)maxCountReportRecord
                                         RefreshData:(BOOL)refshOrNot
                                       GotArrReports:(WbReportJsonArr)callback;
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
                       GotArrReports:(WbReportJsonArr)callback;

#pragma mark - 查看部门汇报(整个部门:上班、出差)
-(void)findOrgunitReportsOfMembersWithOrganizationId:(NSInteger)organizationId
                                           orgunitId:(NSInteger)orgunitId
                                          ReportType:(NSString *)reportType
                                        BeginDateLli:(long long int)beginDateLli
                                          EndDateLli:(long long int)endDateLli
                                   FirstReportRecord:(NSInteger)firstReportRecord
                                     MaxReportRecord:(NSInteger)maxCountReportRecord
                                         RefreshData:(BOOL)refshOrNot
                                       GotArrReports:(WbReportJsonArr)callback;
#pragma mark -查询申请
-(void)findApplyWithOrganizationId:(NSInteger)organizationId
                                  orgunitId:(NSInteger)orgunitId
                              GotArrReports:(WbReportJsonArr)callback;

#pragma mark - 获取考勤配置
-(void)getAttendanceConfigWithOrganizationId:(NSInteger)organizationId
                                   orgunitId:(NSInteger)orgunitId
                                     Refresh:(BOOL)refresh
                               GotDicReports:(void(^)(NSDictionary * dicAttenConfig))callback;

#pragma mark -- 获取公司、部门公告
-(void)getNewsWithOrganizationId:(NSInteger)organizationId
                         orgunitId:(NSInteger)orgunitId
                         newsType:(NSString *)newsType
                         Refresh:(BOOL)refreshOrNot
                     GotArrReports:(WbReportJsonArr)callback;

@end
