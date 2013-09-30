//
//  FeedBack.m
//  GitomAPP
//
//  Created by jiawei on 13-7-16.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "FeedBack.h"
#import <QuartzCore/QuartzCore.h>

@implementation FeedBack

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BackgroundColor_Black;
        
        _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 286)];
        _baseView.backgroundColor = BackgroundColor_Black;
        //_baseView.backgroundColor = [UIColor greenColor];
        [self addSubview:_baseView];
        
        UITextView *thanks = [[UITextView alloc]initWithFrame:CGRectMake(20, 20, Screen_Width-45, 66)];
        thanks.userInteractionEnabled = NO;
        thanks.backgroundColor = [UIColor clearColor];
        thanks.text = @"非常感谢您的支持,在使用产品过程中有任何问题,都欢迎反馈给我们:";
        thanks.textColor = [UIColor whiteColor];
        thanks.font = [UIFont systemFontOfSize:15.0];
        [_baseView addSubview:thanks];
        
        _feedBackInfo = [[UITextView alloc]initWithFrame:CGRectMake(20, 86, Screen_Width-40, 70)];
        _feedBackInfo.layer.cornerRadius = 8;
        _feedBackInfo.delegate = self;
        _feedBackInfo.keyboardType = UIKeyboardTypeTwitter;
        //feedBackInfo.delegate = self;
        //feedBackInfo.keyboardType = UIKeyboardTypeDefault;
        //feedBackInfo.borderStyle = UITextBorderStyleRoundedRect;
        [_baseView addSubview:_feedBackInfo];
        
        UILabel *email = [[UILabel alloc]initWithFrame:CGRectMake(20, 186, 120, 20)];
        email.backgroundColor = [UIColor clearColor];
        email.font = [UIFont systemFontOfSize:15.0];
        email.textColor = [UIColor whiteColor];
        email.text = @"您的邮箱(选填):";
        [_baseView addSubview:email];
        
        _address = [[UITextField alloc]initWithFrame:CGRectMake(20, 216, Screen_Width-40, 30)];
        _address.delegate = self;
        _address.keyboardType = UIKeyboardTypeEmailAddress;
        _address.borderStyle = UITextBorderStyleRoundedRect;
        [_baseView addSubview:_address];
        
        //发送反馈
        UIButton *loginBT = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBT.backgroundColor = [UIColor colorWithRed:119/255.0 green:136/255.0 blue:153/255.0 alpha:1];
        
        [loginBT addTarget:self action:@selector(sendFeedBack) forControlEvents:UIControlEventTouchUpInside];
        [loginBT setImage:[UIImage imageNamed:@"bottom_bg.png"] forState:UIControlStateHighlighted];
        [loginBT setTintColor:[UIColor whiteColor]];
        
        [loginBT setTitle:@"发送" forState:UIControlStateNormal];
        loginBT.frame = CGRectMake(Screen_Width-100, 256, 60, 30);
        [_baseView addSubview:loginBT];

        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self
    action:@selector(swipeToDismissAction)];
        [_baseView addGestureRecognizer:swipe];
        
    }
    return self;
}

- (void)swipeToDismissAction
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(feedBackPopToLastView)]) {
        [self.delegate feedBackPopToLastView];
    }
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
    _baseView.contentSize = self.frame.size;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
    _baseView.contentSize = self.frame.size;
}

- (void)sendFeedBack
{
    //NSLog(@"反馈");
    if ([_feedBackInfo.text isEqual: @" "]) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"对不起，反馈内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }
    else{
        NSString *sysDate = [NSDate date];//加入反馈时间
        NSString *addDateToFeedBack = [NSString stringWithFormat:@"%@Time:%@",_feedBackInfo.text,sysDate];
        NSLog(@"反馈内容：%@",addDateToFeedBack);
        
        NSString *cutSpaceStr = [_feedBackInfo.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *senDedFeedBack = [NSString stringWithFormat:@"http://gapp.gitom.com/api/SaveThrowable.json?email=%@&content=%@",_address.text,cutSpaceStr];
        //NSLog(@"%@",senDedFeedBack);
    
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:senDedFeedBack]];
    
        [NSURLConnection connectionWithRequest:request delegate:self];
        
        //获得连接数据
        NSError *error = nil;
        NSData *getData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSDictionary *dataJeson = [NSJSONSerialization JSONObjectWithData:getData options:NSJSONReadingMutableLeaves error:&error];
    
        NSString *result = [dataJeson objectForKey:@"success"];
        //NSLog(@"%@",result);
        int intResult = (int)result;
        //    bool resultBool = (BOOL)result;
        //    NSLog(@"%c",resultBool);(BOOL)result == \
    
        if (intResult == 1) {
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"对不起，发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
    }else{
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功，谢谢您的宝贵意见" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(feedBackPopToLastView)]) {
            [self.delegate feedBackPopToLastView];
        }
        
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
