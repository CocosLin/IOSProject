//
//  DetailRecordVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-7-3.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "DetailRecordVC.h"
#import "WCommonMacroDefine.h"
#import <QuartzCore/QuartzCore.h>
#import "WTool.h"
#import "ASIHTTPRequest.h"
#import "HBServerKit.h"
#import "SVProgressHUD.h"
#import "RecordAudio.h"

#define BIG_IMG_WIDTH  200.0
#define BIG_IMG_HEIGHT 200.0
@interface DetailRecordVC ()
{
    UITableView *_tvbRecordDetail;
}
@end

@implementation DetailRecordVC

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

-(void)suoxiao
{
    NSLog(@"移除");
    UIView *anView = (UIView *)[self.view viewWithTag:1001];
    [anView removeFromSuperview];
    [self.background removeFromSuperview];
    //[self.background removeFromSuperview];
}
#pragma mark -- 播放声音
- (void)showSound{
    NSLog(@"播放声音");
    NSURL *url = [NSURL URLWithString:self.soundStirng];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSData *getSound = DecodeAMRToWAVE([req responseData]);
        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithData:getSound error:nil];
        player.delegate = self;
        [player play];
    }];
    [req startAsynchronous];
}

- (void)showPhoto{
    UIButton *getAbutton = (UIButton *)[self.view viewWithTag:1001];
    [_tvbRecordDetail addSubview:getAbutton];
    [UIView animateWithDuration:1.0 animations:^{
        getAbutton.frame = CGRectMake(0, 0, 300, 0);
        getAbutton.frame = CGRectMake(0, 0, 300, 300);
    }];
    [getAbutton addTarget:self action:@selector(printWord) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- 放大图片
- (void)showBigPicture{
    
    NSLog(@"放大图片");
    //创建灰色透明背景，使其背后内容不可操作
    
    self.background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    [self.background setBackgroundColor:[UIColor colorWithRed:0.3
                                                        green:0.3
                                                         blue:0.3
                                                        alpha:0.7]];
    [_tvbRecordDetail addSubview:self.background];
    //创建边框视图
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,BIG_IMG_WIDTH+16, BIG_IMG_HEIGHT+16)];
    borderView.tag = 1001;
    //将图层的边框设置为圆脚
    borderView.layer.cornerRadius = 8;
    borderView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    borderView.layer.borderWidth = 8;
    borderView.layer.borderColor = [[UIColor colorWithRed:0.9
                                                    green:0.9
                                                     blue:0.9
                                                    alpha:0.7]CGColor];
    [borderView setCenter:self.view.center];
    [self.background addSubview:borderView];
    [borderView release];
    //创建关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(suoxiao) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"borderview is %@",borderView);
    [closeBtn setFrame:CGRectMake(borderView.frame.origin.x+borderView.frame.size.width-20, borderView.frame.origin.y-6, 26, 27)];
    [self.background addSubview:closeBtn];
    //创建显示图像视图
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, BIG_IMG_WIDTH, BIG_IMG_HEIGHT)];
    [imgView setImage:self.attenceImge];
    [borderView addSubview:imgView];
    [self shakeToShow:borderView];//放大过程中的动画
    [imgView release];
    
    //动画效果
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:2.6];//动画时间长度，单位秒，浮点数
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [UIView setAnimationDelegate:self.background];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}


#pragma mark - 表格视图代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    if (!myCell) {
        myCell = [[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:cellID]autorelease];
    }
    ReportModel * report = (ReportModel *)self.reportModel;
    float h = 45.0;
    if (indexPath.row == 0) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = [NSString stringWithFormat:@"%@(%@)",self.realname,self.username];
        [label release];
    }else if(indexPath.row == 1)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = self.phone;
        [label release];
    }else if(indexPath.row == 2)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = [WTool getStrDateTimeWithDateTimeMS:report.updateDate DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
        [label release];
    }else if(indexPath.row == 3)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = [NSString stringWithFormat:@"%lf,%lf",report.longitude,report.latitude];
        [label release];
    }else if(indexPath.row == 4)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = report.address;
        [label release];
    }else if(indexPath.row == 5)
    {
        h = 75.0;
        UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(60, 2, 245, h)];
        [myCell addSubview:textView];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.font = [UIFont systemFontOfSize:13];
        textView.backgroundColor = [UIColor clearColor];
        [textView setEditable:NO];
        textView.text = report.note;
        [textView release];
    }else if(indexPath.row == 6)
    {
        h = 45.0;
        NSLog(@"上传的汇报图片url == %@",self.reportModel.imageUrl);
        NSLog(@"DetailRecordVC 上传的汇报图片url  == %@",self.reportModel.imageUrl);
        
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        NSString *imgString = [hbKit getImgStringWith:self.reportModel.imageUrl];
        NSLog(@"tup == %@",imgString);
        
        UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imgButton.frame = CGRectMake(60, 2, 45, 40);
        if (imgString != nil) {
            NSURL *url = [NSURL URLWithString:imgString];
            ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
            [req setCompletionBlock:^{
                [imgButton setBackgroundImage:[UIImage imageWithData:[req responseData]] forState:UIControlStateNormal];
                imgButton.tag = 1001;
                //UIImage *getImg = [[[UIImage alloc]initWithData:[req responseData] scale:0.3]autorelease];
                //self.attenceImge = getImg;
                //[imgButton addTarget:self action:@selector(showBigPicture) forControlEvents:UIControlEventTouchUpInside];
                [imgButton addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
            }];
            [req startAsynchronous];
        }else{
            [imgButton setBackgroundImage:[[UIImage imageNamed:@"list_08.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            [imgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [imgButton setTitle:@"无" forState:UIControlStateNormal];
        }
        
        //imgButton.backgroundColor = [UIColor blackColor];
        
        [myCell addSubview:imgButton];
        [hbKit release];
    }else if(indexPath.row ==7){
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        NSLog(@"soundUrl == %@ ,%@",self.reportModel.soundUrl,[hbKit getSoundStringWith:self.reportModel.soundUrl]);
        self.soundStirng = [hbKit getSoundStringWith:self.reportModel.soundUrl];
        UIButton *soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        soundButton.frame = CGRectMake(60, 2, 45, 40);
        if (self.soundStirng != nil) {
            NSLog(@"声音文件存在");
            [soundButton addTarget:self action:@selector(showSound) forControlEvents:UIControlEventTouchUpInside];
            [soundButton setBackgroundImage:[UIImage imageNamed:@"111_19.png"] forState:UIControlStateNormal];
        }else{
            NSLog(@"sound nil");
            [soundButton setBackgroundImage:[[UIImage imageNamed:@"list_08.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            [soundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [soundButton setTitle:@"无" forState:UIControlStateNormal];
        }
        [myCell addSubview:soundButton];
        [hbKit release];
    }
    
    
    NSArray * arrLblText = @[@"汇报人",@"手机",@"时间",@"位置",@"地址",@"文字",@"图片",@"录音"];
    UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50,h)];
    lbl.text = arrLblText[indexPath.row];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.lineBreakMode=NSLineBreakByCharWrapping;
    [myCell addSubview:lbl];
    [lbl release];
    
    UIView * viewLine = [[UIView alloc]initWithFrame:CGRectMake(56, 0, 1, tableView.frame.size.height)];
    [myCell addSubview:viewLine];
    [viewLine setBackgroundColor:[UIColor grayColor]];
    [viewLine release];

    return myCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 80.0;
    }
    return 45.0;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - 属性控制
-(void)setReportModel:(ReportModel *)reportModel
{
    if (reportModel != _reportModel)
    {
        [_reportModel release];
        _reportModel = [reportModel retain];
    }
    [_tvbRecordDetail reloadData];
}

-(void)setUsername:(NSString *)username
{
    if (_username != username) {
        [_username release];
        _username = [username copy];
    }
//     self.title = [NSString stringWithFormat:@"%@(%@)",self.realname,username];
}
-(void)setRealname:(NSString *)realname
{
    if (_realname != realname) {
        [_realname release];
        _realname = [realname copy];
    }
//    self.title = [NSString stringWithFormat:@"%@(%@)",realname,self.username];
}

#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"汇报详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_On"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    
    _tvbRecordDetail = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, Width_Screen - 20 , Height_Screen - 10 - 30 - 49)];
    [self.view addSubview:_tvbRecordDetail];
    _tvbRecordDetail.delegate = self;
    _tvbRecordDetail.dataSource = self;
    [_tvbRecordDetail.layer setCornerRadius:7];
    [_tvbRecordDetail.layer setBorderWidth:0.7];
    [_tvbRecordDetail release];
}

- (void)dealloc{
    Release_Safe(_reportModel);
    Release_Safe(_attenceImge);
    Release_Safe(_background);
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
