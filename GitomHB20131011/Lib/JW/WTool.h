//
//  WTool.h
//  GitomNetLjw
//
//  Created by jiawei on 13-6-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTool : NSObject
//得到一天的开始时间值,如@"2012-6-10 00:00:00"，这一天的0点就是开始时间
+(long long int)getBeginDateTimeMsWithNSDate:(NSDate *)date;

//得到一天的结束时间值,如@"2012-6-10 23:59:59"，这一天的24点前一秒就是结束时间
+(long long int)getEndDateTimeMsWithNSDate:(NSDate *)date;

//得到一天的结束时间值,如@"2012-6-10 23:59:59"，这一天的24点前一秒就是结束时间
+(long long int)getEndDateTimeMsWithdtBeginMS:(long long int)dtBeginMS;

//得到时间的星期数
+(NSInteger)getWeekdayIntegerWithNSdate:(NSDate *)date;
//得到时间的星期显示
+(NSString *)getStrWeekdayWithNSdate:(NSDate *)date;

//得到某个日期的毫秒级时间戳(只有小时、分钟、秒)
+(long long int)getTimeMsWithNSDate:(NSDate *)date;


+(NSDateComponents *)getDateComponentsWithDate:(NSDate *)date;

//根据毫秒级时间戳来得到时间字符串
+(NSString *)getStrDateTimeWithDateTimeMS:(long long int)dtMS DateTimeStyle:(NSString *)dateTimeStyle;
@end
