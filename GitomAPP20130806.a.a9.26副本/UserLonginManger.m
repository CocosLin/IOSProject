//
//  UserLonginManger.m
//  GitomAPP
//
//  Created by jiawei on 13-7-17.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "UserLonginManger.h"
#import "UserLogin.h"

@implementation UserLonginManger

- (UserLogin *) connectUrl:(NSString *)aUrl{
    _userlogin = [[UserLogin alloc]init];
    
    //请求连接
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:aUrl]];
    
    //获得连接数据
    //[NSURLConnection connectionWithRequest:request delegate:self];
    NSData *getData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (getData == nil) {//无网络连接的时，无法获得数据内容
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSDictionary *dataJeson = [NSJSONSerialization JSONObjectWithData:getData options:NSJSONReadingMutableLeaves error:nil];
    
    _userlogin.code = [dataJeson objectForKey:@"code"];
    _userlogin.message = [dataJeson objectForKey:@"message"];
    _userlogin.success = [dataJeson objectForKey:@"success"];
    _userlogin.result = [dataJeson objectForKey:@"result"];//登入成功或失败的标记，1 表示验证成功，0表示失败
    
    //NSLog(@"登入===%@",_userlogin.code);
    //NSLog(@"登入===%@",_userlogin.message);
    //NSLog(@"登入===%@",_userlogin.success);
    //NSLog(@"登入===%@",_userlogin.result);
    return _userlogin;
    

    
}
/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _getData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_getData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //IOS5自带解析类NSJSONSserialization从getData解析出数据放到字典里
    NSDictionary *dataJeson = [NSJSONSerialization JSONObjectWithData:_getData options:NSJSONReadingMutableLeaves error:nil];
    
    
    //NSDictionary *jeson = [dataJeson objectForKey:@"items"];
    int jeson1 = [dataJeson objectForKey:@"code"];
    
    // NSLog(@"含有数组的数量：%d",jeson1.count);
    
    NSDictionary *jeson2 = [jeson1 objectAtIndex:aIndex];
    NSString *jeson3 = [jeson2 objectForKey:@"img"];
    NSString *title = [jeson2 objectForKey:@"title"];
    NSString *paramer = [jeson2 objectForKey:@"paramer"];
    
}
*/

@end
