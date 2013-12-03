//
//  GitomSingal.h
//  GitomNetLjw
//
//  Created by jiawei on 13-10-28.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitomSingal : NSObject

@property (nonatomic,assign) BOOL recordedSound;//ReportVC用来区分是否录音的标记

/*以下为显示ManageDepartmentVC内考勤的内容*/
@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;

@property (nonatomic,assign) long offTime1;
@property (nonatomic,assign) long oneTime1;
@property (nonatomic,assign) long offTime2;
@property (nonatomic,assign) long oneTime2;
@property (nonatomic,assign) long offTime3;
@property (nonatomic,assign) long oneTime3;

@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *outMinute;
@property (nonatomic,copy) NSString *inMinute;

@property (nonatomic,copy) NSString *registerName;

//单例声明
+ (id) getInstance;

@end
