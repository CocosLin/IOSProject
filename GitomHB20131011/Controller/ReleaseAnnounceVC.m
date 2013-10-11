//
//  ReleaseAnnounceVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-23.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ReleaseAnnounceVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CommonDataModel.h"
#import "HBServerKit.h"
#import "SVProgressHUD.h"

@interface ReleaseAnnounceVC ()

@end

@implementation ReleaseAnnounceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    UIButton *releaseBtn = [UIButton buttonWithType:0];
    [releaseBtn setFrame:CGRectMake(0, 0, 62.0, 30.0)];
	[releaseBtn setImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
	[releaseBtn addTarget:self action:@selector(announceAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:releaseBtn];
    barButtonItem.title = @"kkk";
    self.navigationItem.rightBarButtonItem = barButtonItem;
    */
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(announceAction)];
    barButtonItem.tintColor = [UIColor colorWithRed:194.0/255.0 green:214.0/255.0 blue:243.0/255.0 alpha:1];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 286)];
    _baseView.backgroundColor = [UIColor clearColor];
    //_baseView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_baseView];
    
    //与隐藏键盘相关
    UIView *addToBaseView = [[UIView alloc]initWithFrame:_baseView.frame];
    [_baseView addSubview:addToBaseView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 120, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = @"标题:";
    [addToBaseView addSubview:titleLabel];
    
    self.textTitle = [[UITextView alloc]initWithFrame:CGRectMake(20, 70, Screen_Width-40, 30)];
    self.textTitle.delegate = self;
    self.textTitle.layer.cornerRadius = 6;
    self.textTitle.textAlignment = NSTextAlignmentCenter;
    [addToBaseView addSubview:self.textTitle];
    
    //内容
    UILabel *thanks = [[UILabel alloc]initWithFrame:CGRectMake(20, 126, Screen_Width-45, 30)];
    thanks.userInteractionEnabled = NO;
    thanks.backgroundColor = [UIColor clearColor];
    thanks.text = @"公告内容:";
    thanks.font = [UIFont systemFontOfSize:15.0];
    [addToBaseView addSubview:thanks];
    
    self.announceContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 166, Screen_Width-40, 70)];
    self.announceContent.layer.cornerRadius = 8;
    self.announceContent.delegate = self;
    self.announceContent.keyboardType = UIKeyboardTypeTwitter;
    [addToBaseView addSubview:self.announceContent];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(tpeToDismissAction)];
    [addToBaseView addGestureRecognizer:tap];
    
    self.hideKeyBoardView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 50, 50)];
    self.hideKeyBoardView.backgroundColor = [UIColor clearColor];
    self.hideKeyBoardView.tag = 1001;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.hideKeyBoardView];
    UITapGestureRecognizer  *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoardAciton)];
    [self.hideKeyBoardView addGestureRecognizer:tap1];
    self.hideKeyBoardView.hidden= YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- 发布公告
//http://hb.m.gitom.com/3.0/organization/saveNews?organizationId=114&orgunitId=1&title=ddddd&content=dddddd&username=90261&newsType=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
- (void)announceAction{
    GetCommonDataModel;
    if (self.textTitle.text.length >0 && self.announceContent.text.length > 0) {
        NSString *tempStr = [NSString stringWithFormat:@"%@",self.textTitle.text];
        NSString *temp = [self URLEncodedString:tempStr];
        NSLog(@"temp == %@",temp);
        
        NSString *announceTemp = [self URLEncodedString:self.announceContent.text ];
        NSLog(@"announceTemp == %@",announceTemp);
        
        NSString *releaseUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/saveNews?organizationId=%d&orgunitId=1&title=%@&content=%@&username=%@&newsType=1&cookie=%@",comData.organization.organizationId,temp,announceTemp,comData.userModel.username,comData.cookie];
        NSLog(@"ReleaseAnnounceVC UrlStr %@",releaseUrlStr);
        NSURL *releaseUrl = [NSURL URLWithString:releaseUrlStr];
        NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
        [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
        NSLog(@"ReleaseAnnounceVC release announce");
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写发布内容"]; 
    }
    
    
}

#pragma mark -- NSString转UTF8方法
- (NSString *)URLEncodedString:(NSString *)sender
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)sender,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    _baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
//    _baseView.contentSize = self.view.frame.size;
//}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.hideKeyBoardView.hidden = NO;
    _baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
    _baseView.contentSize = self.view.frame.size;
    
}
#pragma mark -- 点击任意位置收起键盘
- (void)tpeToDismissAction{
    [self.textTitle resignFirstResponder];
    [self.announceContent resignFirstResponder];
    _baseView.frame = self.view.frame;
    _baseView.contentSize = self.view.frame.size;
    self.hideKeyBoardView.hidden = YES;
}
- (void)hideKeyBoardAciton{
    [self tpeToDismissAction];
}
- (void)dealloc {
    [_announceScrollView release];
    [_baseView release];
    [_hideKeyBoardView release];
    [_textTitle release];
    [_announceContent release];
    [super dealloc];
}
@end
