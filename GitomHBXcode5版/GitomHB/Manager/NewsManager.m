//
//  NewsManager.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-22.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "NewsManager.h"

@implementation NewsManager

//部门公告http://hb.m.gitom.com/3.0/organization/orgunitNews?organizationId=114&orgunitId=1&first=0&max=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
- (void)getNewsOforganizationId:(NSInteger)organId andOrgunitId:(NSInteger)unitId andCookie:(NSString *)aCookie{
    NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/orgunitNews?organizationId=%ld&orgunitId=%ld&first=0&max=1&cookie=%@",(long)organId,(long)unitId,aCookie];
    NSLog(@"urlstr == %@",urlStr);
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    __weak ASIHTTPRequest *asiReq = [ASIHTTPRequest requestWithURL:url];
  
    NewsManager *newsManger = [[NewsManager alloc]init];
    [asiReq setCompletionBlock:^{
        NSData *getDta = [asiReq responseData];
        NSError *error = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:getDta options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *bodyDic = [jsonDic objectForKey:@"body"];
        NSString *dataDic = [bodyDic objectForKey:@"data"];

        NSLog(@"%@",bodyDic);
        NSLog(@"%@",dataDic);
        NSString *cutStr1 = [dataDic stringByReplacingOccurrencesOfString:@"," withString:@":"];
        NSArray *cutAr = [[NSArray alloc]init];
        cutAr = [cutStr1 componentsSeparatedByString:@":"];
        
        NSLog(@"%@",cutAr);
        newsManger.content = [cutAr objectAtIndex:1];
        NSLog(@"%@",[cutAr objectAtIndex:1]);
        NSLog(@"内容 == %@",newsManger.content);
        NSLog(@"title == %@",[cutAr objectAtIndex:15]);
        NSLog(@"realname == %@",[cutAr objectAtIndex:13]);
        NSLog(@"userid == %@",[cutAr objectAtIndex:19]);
    }];
//    NSLog(@"NewsManger title %@",newsManger.title );
//    NSLog(@"NewsManger content %@",newsManger.content);
    NSLog(@"newsManger.content%@==",newsManger.content);
    [asiReq startAsynchronous];
  
    
}
@end
