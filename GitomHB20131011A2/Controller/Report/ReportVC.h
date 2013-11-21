//
//  ReportVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
#import "BMKMapView.h"
#import "ReportManager.h"
//#import "ChatVoiceRecorderVC.h"
#import "MakeAudioVC.h"


@interface ReportVC : VcWithNavBar
<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,BMKMapViewDelegate,BMKSearchDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MakeAudioVCprotocol>

@property(retain,nonatomic)BMKMapView * bMapView;
@property(nonatomic,assign)BOOL isShowRecord;//是否是查汇报记录(因为查记录的时候，不能上传)
@property(assign,nonatomic)Flag_ReportType intReportType;//汇报类型
@property(nonatomic,assign)double longitude;   // 经度
@property(nonatomic,assign)double latitude;    // 纬度
@property(nonatomic,copy)NSString * myAddress;//当前地址信息
@property(nonatomic,copy) NSString *imgUrlStr;//服务器图片路径
@property(nonatomic,copy) NSString *soundUrlStr;//服务器声音路径
@end
