//
//  ReportModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "WBaseModel.h"
#import "BaseDataBean.h"

@interface ReportModel : BaseDataBean
//公司ID
@property(assign,nonatomic)NSInteger organizationId;
//部门ID
@property(assign,nonatomic)NSInteger orgunitId;
//记录ID
@property(nonatomic,copy) NSString *reportId;
//@property(nonatomic,assign)long long int reportId;

@property(nonatomic,copy)NSString *note;//文字汇报内容
@property(assign,nonatomic)CGFloat longitude;//汇报时坐标的经纬度
@property(assign,nonatomic)CGFloat latitude;
@property(nonatomic,copy)NSString * address;//汇报地址
@property(copy)NSString * imageUrl;//图片地址
@property(copy)NSString * soundUrl;//录音地址
@property(copy)NSString * reportType;//汇报类型
@property(copy)NSString * telephone;
@property(copy)NSString * realName;
@property (copy)NSString *userName;
@property()NSInteger voidFlag;

//-(id)initForCurrentUserInfoAndWithFlagTypeReport:(NSInteger)flagTypeReport
//                                         Longitude:(double)longitude
//                                          Latitude:(double)latitude
//                                           Address:(NSString *)address
//                                              Note:(NSString *)note
//                                          ImageUrl:(NSString *)imageUrl
//                                          SoundUrl:(NSString *)soundUrl;

@end
