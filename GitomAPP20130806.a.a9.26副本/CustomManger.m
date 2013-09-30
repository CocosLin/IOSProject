//
//  CustomManger.m
//  IOS_Javascript
//
//  Created by jiawei on 13-7-11.
//  Copyright (c) 2013年 GitomYiwan. All rights reserved.
//

#import "CustomManger.h"
#import "Custom.h"
#import "LoginStatueSingal.h"

@implementation CustomManger

- (Custom *)connectWithCustomURLgetIndex:(int) aIndex
{
    _custom = [[Custom alloc]init];
    
    //使用同步连接的方法进行NSJSONS解析
    //_indx = aIndex;
    //请求连接
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    [NSURLConnection connectionWithRequest:request delegate:self];
//    //获得连接数据
//    
    NSError *error = nil;
//    NSData *getData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    LoginStatueSingal *loginSingal = [LoginStatueSingal shareLogStatu];
    NSData *getData = loginSingal.customUrlData;
    
    if (getData == nil) {
        _custom.imgUrl = @"glyphicons_085_repeat.png";
        _custom.title = @"刷新";
        NSArray  *ar = @[@1];
        _custom.customAr = ar;
    }else{
        //开始解析
        //IOS5自带解析类NSJSONSserialization从getData解析出数据放到字典里
        NSDictionary *dataJeson = [NSJSONSerialization JSONObjectWithData:getData options:NSJSONReadingMutableLeaves error:&error];
        
        
        //NSDictionary *jeson = [dataJeson objectForKey:@"items"];
        NSArray *jeson1 = [dataJeson objectForKey:@"arr"];
        
        // NSLog(@"含有数组的数量：%d",jeson1.count);
        
        NSDictionary *jeson2 = [jeson1 objectAtIndex:aIndex];
        NSString *jeson3 = [jeson2 objectForKey:@"img"];
        NSString *title = [jeson2 objectForKey:@"title"];
        NSString *paramer = [jeson2 objectForKey:@"paramer"];
        // NSLog(@"img: %@",jeson3);//图片地址
        // NSLog(@"title: %@",title);//标题
        //NSLog(@"连接的网站-----------：%@",paramer);//连接http://gapp.gitom.com/app/com.gitom.app/images/wxhelp1.html
        
        _custom.imgUrl = jeson3;
        _custom.title = title;
        _custom.paramer = paramer;
        _custom.customAr = jeson1;//含有数组数量
    }
    return _custom;
}

/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _getData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_getData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
    //开始解析
    //IOS5自带解析类NSJSONSserialization从getData解析出数据放到字典里
    NSDictionary *dataJeson = [NSJSONSerialization JSONObjectWithData:_getData options:NSJSONReadingMutableLeaves error:nil];
    //NSDictionary *jeson = [dataJeson objectForKey:@"items"];
    NSArray *jeson1 = [dataJeson objectForKey:@"arr"];
    
    NSLog(@"含有数组的数量：%d",jeson1.count);
    
    NSDictionary *jeson2 = [jeson1 objectAtIndex:_indx];
    NSString *jeson3 = [jeson2 objectForKey:@"img"];
    NSString *title = [jeson2 objectForKey:@"title"];
    NSString *paramer = [jeson2 objectForKey:@"paramer"];
    NSLog(@"img: %@",jeson3);//图片地址
    NSLog(@"title: %@",title);//标题
    NSLog(@"连接的网站：%@",paramer);//连接
    
    _custom.imgUrl = jeson3;
    _custom.title = title;
    _custom.paramer = paramer;
    _custom.customAr = jeson1;//含有数组数量
     
}
*/

@end
