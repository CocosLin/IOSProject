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

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UserPositionVC.h"

#define BIG_IMG_WIDTH  200.0
#define BIG_IMG_HEIGHT 200.0
@interface DetailRecordVC ()
{
    UITableView *_tvbRecordDetail;
    UIProgressView *soundProgress;
    UIView *soundProgressView;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self creatCommentViews];
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
- (void)showSound:(UIButton*)sender{
    NSLog(@"播放声音");
    NSURL *url = [NSURL URLWithString:[self.soundStirngAr objectAtIndex:sender.tag - 5000]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSData *getSound = DecodeAMRToWAVE([req responseData]);
        self.player = [[AVAudioPlayer alloc]initWithData:getSound error:nil];
        //[self.player prepareToPlay];
        self.player.delegate = self;
        soundProgressView.hidden = NO;
        [self.player play];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showtime:) userInfo:nil repeats:YES];
    }];
    [req startAsynchronous];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"UISimulatedMemoryWarningNotification", NULL, NULL, true);  
}

#pragma mark -- AVPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //停止计时
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"停止时间");
    soundProgressView.hidden = YES;
}

-(void)showtime:(id)sender{
    NSLog(@"显示时间");
    soundProgress.progress = ((double)self.player.currentTime)/self.player.duration;
    
}

#pragma mark - 查看大图
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
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSLog(@"放大图片");
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    NSArray * urlArray = [hbKit getImgStringWith:self.reportModel.imageUrl];
 
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:urlArray.count];
    for (int i = 0; i<urlArray.count; i++) {
        NSLog(@"url == %@",urlArray);
        //NSString *url = urlArray[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        //photo.url = [NSURL URLWithString:url]; // 图片路径
        UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1000+i];
        photo.srcImageView = imgView; // 来源于哪个UIImageView
        [photos addObject:photo];
  
        photo = nil;
    }
    NSLog(@"显示相册");
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag-1000; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
  
    browser = nil;
}


/*
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
}*/


#pragma mark - 表格视图代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    //UITableViewCell *myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!myCell) {
        myCell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:cellID];
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
  
    }else if(indexPath.row == 1)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = self.phone;
 
    }else if(indexPath.row == 2)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = [WTool getStrDateTimeWithDateTimeMS:report.updateDate DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
   
    }else if(indexPath.row == 3)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = [NSString stringWithFormat:@"%lf,%lf",report.longitude,report.latitude];
  
        
        UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        positionBtn.frame = CGRectMake(250, 5, 35, 35);
        [positionBtn setBackgroundImage:[UIImage imageNamed:@"location_icon.png"] forState:UIControlStateNormal];
        [positionBtn addTarget:self action:@selector(findPositionAction) forControlEvents:UIControlEventTouchUpInside];
        [myCell addSubview:positionBtn];
        
        
    }else if(indexPath.row == 4)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = report.address;
    
    }else if(indexPath.row == 5)
    {
        h = 45.0;
        UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(60, 0, 245, h)];
        [myCell addSubview:textView];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.font = [UIFont systemFontOfSize:13];
        textView.backgroundColor = [UIColor clearColor];
        [textView setEditable:NO];
        textView.text = report.note;
        
        
        
   
    }else if(indexPath.row == 6)
    {
        h = 45.0;
        NSLog(@"上传的汇报图片url == %@",self.reportModel.imageUrl);
        NSLog(@"DetailRecordVC 上传的汇报图片url  == %@",self.reportModel.imageUrl);
        
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        NSArray *_urls = [[NSArray alloc]init];
        _urls = [hbKit getImgStringWith:self.reportModel.imageUrl];
        NSLog(@"tup == %@",_urls);
        NSLog(@"tup count == %d",_urls.count);
        // 1.创建个UIImageView
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
        CGFloat width = 45;
        CGFloat height = 40;
        if (_urls) {
            for (int i = 0; i<_urls.count; i++) {
                UIImageView *imageView = [[UIImageView alloc] init];
                NSLog(@"下载图片%d",i);
                [self.view addSubview:imageView];
                CGFloat x = 60;
                CGFloat y = 2;
                imageView.frame = CGRectMake(x+46*i, y, width, height);
                
                // 下载图片
                [imageView setImageURLStr:_urls[i] placeholder:placeholder];
                // 事件监听
                imageView.tag = 1000+i;
                NSLog(@"imageView.tag == %d",imageView.tag);
                imageView.userInteractionEnabled = YES;
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
                [myCell addSubview:imageView];
                // 内容模式
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
         
            }
        }else{
            nil;
        }
    
    }else if(indexPath.row ==7){
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        NSLog(@"soundUrl == %@ ,%@",self.reportModel.soundUrl,[hbKit getSoundStringWith:self.reportModel.soundUrl]);
        self.soundStirngAr = [hbKit getSoundStringWith:self.reportModel.soundUrl];
        for (int i=0;i<self.soundStirngAr.count;i++) {
            UIButton *soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
            soundButton.tag = 5000+i;
            soundButton.frame = CGRectMake(60+i*47, 2, 45, 40);
            [myCell addSubview:soundButton];
            NSRange range = [[self.soundStirngAr objectAtIndex:i] rangeOfString:@"null"];
            if ([self.soundStirngAr objectAtIndex:i]!=nil && range.location == NSNotFound) {
                NSLog(@"声音文件存在");
                [soundButton addTarget:self action:@selector(showSound:) forControlEvents:UIControlEventTouchUpInside];
                [soundButton setBackgroundImage:[UIImage imageNamed:@"111_19.png"] forState:UIControlStateNormal];
            }else{
                nil;
            }

        }
   
        soundProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 15, Screen_Width-80, 100)];
        //[_tvbRecordDetail addSubview:soundProgress];
        //soundProgress.hidden = YES;
        soundProgressView = [[UIView alloc]initWithFrame:CGRectMake(60, 2, Screen_Width-80, 41)];
        [soundProgressView addSubview:soundProgress];
        soundProgressView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
        soundProgressView.hidden = YES;
        [myCell addSubview:soundProgressView];
    }
    
    
    NSArray * arrLblText = @[@"汇报人",@"手机",@"时间",@"位置",@"地址",@"文字",@"图片",@"录音"];
    UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50,h)];
    lbl.text = arrLblText[indexPath.row];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.lineBreakMode=NSLineBreakByCharWrapping;
    [myCell addSubview:lbl];
 
    
    UIView * viewLine = [[UIView alloc]initWithFrame:CGRectMake(56, 0, 1, tableView.frame.size.height)];
    [myCell addSubview:viewLine];
    myCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
    [viewLine setBackgroundColor:[UIColor grayColor]];
   

    return myCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 5) {
//        return 80.0;
//    }
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
#pragma mark - 用户位置定位
- (void)findPositionAction{
    ReportModel * report = (ReportModel *)self.reportModel;
    UserPositionVC *vc = [[UserPositionVC alloc]init];
    vc.addressStr = report.address;
    vc.latitude = report.latitude;
    vc.longitude = report.longitude;
    [self.navigationController pushViewController:vc animated:YES];

}



-(void)setReportModel:(ReportModel *)reportModel
{
    if (reportModel != _reportModel)
    {
//        [_reportModel release];
//        _reportModel = [reportModel retain];
        _reportModel = nil;
        _reportModel = reportModel;
    }
    [_tvbRecordDetail reloadData];
}

-(void)setUsername:(NSString *)username
{
    if (_username != username) {
//        [_username release];
//        _username = [username copy];
        _username = nil;
        _username = username;
        
    }
     //self.title = [NSString stringWithFormat:@"%@(%@)",self.realname,username];
}
-(void)setRealname:(NSString *)realname
{
    if (_realname != realname) {
//        [_realname release];
//        _realname = [realname copy];
        _realname = nil;
        _realname = realname;
    }
    self.title = [NSString stringWithFormat:@"%@(%@)",realname,self.username];
}

-(void)btnBack:(UIButton *)btn
{
    NSLog(@"DetailRecordVC popViewControllerAnimated");
    [self.player stop];
    [self.timer invalidate];
    //self.timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       //self.title = @"汇报详情";
    }
    return self;
}

#pragma mark -- 创建评论界面

- (void)creatCommentViews{
    
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit findCommentWithOrganizationId:self.reportModel.organizationId
                               OrgunitId:self.reportModel.orgunitId
                                ReportId:self.reportModel.reportId
                        andGetCommentMod:^(NSArray *commentArr) {
                            
                            if (commentArr) {
                                
                                NSLog(@"DetailQeryViewControlle == %d",commentArr.count);
                                
                                for (int i = 0; i<commentArr.count; i++) {
                                    
                                    CommentModle *commentMod = [[CommentModle alloc]init];
                                    commentMod = [commentArr objectAtIndex:i];
                                    NSLog(@"commentArr = %d %@ %@ ",i,commentMod,commentArr);
                                    
                                    
                                    
                                    //评论内容
                                    contentText = [[UITextView alloc]initWithFrame:CGRectMake(0, 410+i*64, Screen_Width, 200)];
                                    contentText.backgroundColor = [UIColor clearColor];
                                    contentText.editable = NO;
                                    contentText.font = [UIFont systemFontOfSize:15];
                                    CGRect orgRect=contentText.frame;//获取原始UITextView的frame
                                    if (commentMod.note != NULL) {
                                        contentText.textAlignment = UITextAlignmentLeft;
                                        contentText.contentMode = UIControlContentVerticalAlignmentCenter;
                                        
                                        CGSize  size = [[NSString stringWithFormat:@" 评语：%@",commentMod.note] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(240, 2000) lineBreakMode:UILineBreakModeWordWrap];
                                        orgRect.size.height=size.height+10;//获取自适应文本内容高度
                                        contentText.frame=orgRect;//重设UITextView的frame
                                        
                                        self.scrollView.contentSize = CGSizeMake(Screen_Width, 454+i*(84+orgRect.size.height));
                                        contentText.text=[NSString stringWithFormat:@" 评语：%@",commentMod.note];
                                        contentText.frame = CGRectMake(0, 415+i*(44+orgRect.size.height), Screen_Width, orgRect.size.height);
                                        [self.scrollView addSubview:contentText];
                                        
                                    }
                                    
                                    
                                    //评论人、评论时间
                                    UILabel *commentName = [[UILabel alloc]initWithFrame:CGRectMake(0, 380+i*(44+orgRect.size.height), Screen_Width, 24)];
                                    commentName.backgroundColor = BlueColor;
                                    commentName.font = [UIFont systemFontOfSize:15];
                                    commentName.text = [NSString stringWithFormat:@"   评论者：%@(%@)        %@分",commentMod.realname,commentMod.createUserId,commentMod.level];
                                    
                                    UILabel *creatDate = [[UILabel alloc ]initWithFrame:CGRectMake(0, 400+i*(44+orgRect.size.height), Screen_Width, 20)];
                                    creatDate.textColor = [UIColor grayColor];
                                    creatDate.backgroundColor = BlueColor;
                                    creatDate.font = [UIFont systemFontOfSize:13];
                                    creatDate.text = [NSString stringWithFormat:@"    时间：%@",[WTool getStrDateTimeWithDateTimeMS:[commentMod.createDate longLongValue] DateTimeStyle:@"YYYY-MM-dd HH:mm:ss"]];
                                    
                                    [self.scrollView addSubview:commentName];
                                    [self.scrollView addSubview:creatDate];
                                }
                                
                                
                                
                            }else{
                                
                                self.scrollView.contentSize = CGSizeMake(Screen_Width, 410);
                                UILabel *commentName = [[UILabel alloc]initWithFrame:CGRectMake(0, 380, Screen_Width, 24)];
                                commentName.backgroundColor = BlueColor;
                                commentName.font = [UIFont systemFontOfSize:15];
                                commentName.text = @"暂无评论";
                                commentName.textAlignment = NSTextAlignmentCenter;
                                [self.scrollView addSubview:commentName];
                                
                            }
                        }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
  
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, Screen_Height-60)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = NO;
    [self.view addSubview:self.scrollView];
    
   
    
    _tvbRecordDetail = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, Width_Screen - 20 , 360)];
    _tvbRecordDetail.scrollEnabled = NO;
    [_tvbRecordDetail setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.scrollView addSubview:_tvbRecordDetail];
    _tvbRecordDetail.delegate = self;
    _tvbRecordDetail.dataSource = self;
    [_tvbRecordDetail.layer setCornerRadius:7];
    [_tvbRecordDetail.layer setBorderWidth:0.7];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"DetailRecordVC didReceiveMemoryWarning");
    [self viewDidUnload];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.attenceImge = nil;
    self.scrollView = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    _tvbRecordDetail = nil;
    soundProgress = nil;
    soundProgressView = nil;
    self.attenceImge = nil;
    self.background = nil;
    //self.reportModel = nil;
    self.soundStirngAr = nil;
    self.scrollView = nil;
    self.player = nil;
    self.timer = nil;
}
@end
