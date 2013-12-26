//
//  DetailQeryViewController.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-11.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "DetailQeryViewController.h"
#import "WCommonMacroDefine.h"
#import <QuartzCore/QuartzCore.h>
#import "WTool.h"
#import "UserManager.h"
#import "ASIHTTPRequest.h"
#import "RecordAudio.h"
#import "SVProgressHUD.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "AddCommentVC.h"
#import "UserPositionVC.h"

#define BIG_IMG_WIDTH  200.0
#define BIG_IMG_HEIGHT 200.0

@interface DetailQeryViewController (){
    UITableView *_tvbRecordDetail;
//    AVAudioPlayer *player;
    UIProgressView *soundProgress;
    UIView *soundProgressView;
    UITextView *contentText;
}
@end

@implementation DetailQeryViewController

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    [contentText removeFromSuperview];
//    [self creatCommentViews];
//}





#pragma mark -- 播放声音
- (void)showSound:(UIButton *)sender{
    NSLog(@"播放声音");
    NSURL *url = [NSURL URLWithString:[self.soundStirngAr objectAtIndex:sender.tag - 5000]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setCompletionBlock:^{
        NSData *getSound = DecodeAMRToWAVE([req responseData]);
        self.player = [[AVAudioPlayer alloc]initWithData:getSound error:nil];
        //[self.player prepareToPlay];
        self.player.delegate = self;
        [self.player play];
        soundProgressView.hidden = NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showtime:) userInfo:nil repeats:YES];
    }];
    [req startAsynchronous];
}

#pragma mark -- AVPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.timer invalidate];//停止计时
    self.timer = nil;
    NSLog(@"停止时间");
    soundProgressView.hidden = YES; 
}

-(void)showtime:(id)sender{
    NSLog(@"显示时间");
    soundProgress.progress = ((double)self.player.currentTime)/self.player.duration;
    
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
        MJPhoto *photo = [[MJPhoto alloc] init];
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

#pragma mark - 点评
- (void) saveReportComment{
    AddCommentVC *vc = [[AddCommentVC alloc]init];
    vc.reportMod = self.reportModel;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark -- 调用短信
- (void) report_mail:(id)sender{
    
    NSString *phoneNumber = [NSString stringWithFormat:@"sms://%@",self.reportModel.telephone];
    NSLog(@"调用短信:%@",phoneNumber);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
    
}

#pragma mark -- 调用电话
- (void) report_tel:(id)sender{
    
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",self.reportModel.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}

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
    float h = 45.0;
    if (indexPath.row == 0) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = [NSString stringWithFormat:@"%@(%@)",self.reportModel.realName,self.reportModel.userName];
      
    }else if(indexPath.row == 1)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = self.reportModel.telephone;
        
        UIButton *report_telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        report_telBtn.frame = CGRectMake(210, 5, 35, 35);
        [report_telBtn setBackgroundImage:[UIImage imageNamed:@"report_tel.png"] forState:UIControlStateNormal];
        [report_telBtn addTarget:self action:@selector(report_tel:) forControlEvents:UIControlEventTouchUpInside];
        [myCell addSubview:report_telBtn];
        
        UIButton *report_mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        report_mailBtn.frame = CGRectMake(250, 5, 35, 35);
        [report_mailBtn setBackgroundImage:[UIImage imageNamed:@"report_mail.png"] forState:UIControlStateNormal];
        [report_mailBtn addTarget:self action:@selector(report_mail:) forControlEvents:UIControlEventTouchUpInside];
        [myCell addSubview:report_mailBtn];
    
    }else if(indexPath.row == 2)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = [WTool getStrDateTimeWithDateTimeMS:self.reportModel.updateDate DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
       
   
    }else if(indexPath.row == 3)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = [NSString stringWithFormat:@"%lf,%lf",self.reportModel.longitude,self.reportModel.latitude];
     
        
        UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        positionBtn.frame = CGRectMake(250, 5, 35, 35);
        [positionBtn setBackgroundImage:[UIImage imageNamed:@"location_icon.png"] forState:UIControlStateNormal];
        [positionBtn addTarget:self action:@selector(findPositionAction) forControlEvents:UIControlEventTouchUpInside];
        [myCell addSubview:positionBtn];
        
    }else if(indexPath.row == 4)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 280, h)];
        [myCell addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByCharWrapping;
        label.text = self.reportModel.address;
   
    }else if(indexPath.row == 5)
    {
        h = 45.0;
        UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(60, 2, 245, h)];
        [myCell addSubview:textView];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.font = [UIFont systemFontOfSize:13];
        textView.backgroundColor = [UIColor clearColor];
        [textView setEditable:NO];
        textView.text = self.reportModel.note;
      
    }else if(indexPath.row == 6)
    {
        h = 45.0;
        NSLog(@"上传的汇报图片url == %@",self.reportModel.imageUrl);
        NSLog(@"DetailRecordVC 上传的汇报图片url  == %@",self.reportModel.imageUrl);
        
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        NSArray *_urls = [[NSArray alloc]init];
        //_urls = [[NSArray alloc]init];
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
                //int column = i%3;
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
    [viewLine setBackgroundColor:[UIColor grayColor]];
    myCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];

    
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
#pragma mark -- 汇报人员位置
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
        // self.title = [NSString stringWithFormat:@"%@(%@)",self.realname,username];
}
-(void)setRealname:(NSString *)realname
{
    if (_realname != realname) {
//        [_realname release];
//        _realname = [realname copy];
        _realname = nil;
        _realname = realname;
    }

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

-(void)btnBack:(UIButton *)btn
{
    NSLog(@"DetailQeryViewController popViewControllerAnimated");
    [self.player stop];
    [self.timer invalidate];
    //self.timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航条按钮
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, 370)];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    
    //汇报列表
    _tvbRecordDetail = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, Width_Screen - 20 , 360)];
    _tvbRecordDetail.scrollEnabled = NO;
    [_tvbRecordDetail setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.scrollView addSubview:_tvbRecordDetail];
    _tvbRecordDetail.delegate = self;
    _tvbRecordDetail.dataSource = self;
    [_tvbRecordDetail.layer setCornerRadius:7];
    [_tvbRecordDetail.layer setBorderWidth:0.7];
  
    NSLog(@"self.reportModel.reportId == %@",self.reportModel.reportId);
    

    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [but1 setTitle:@"添加点评" forState:UIControlStateNormal];
    but1.frame = CGRectMake(10, Screen_Height-110, Screen_Width-20, 42);
    [but1 setBackgroundImage:[[UIImage imageNamed:@"03.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [but1 setBackgroundImage:[[UIImage imageNamed:@"04.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [but1 addTarget: self action:@selector(saveReportComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
    
    [self creatCommentViews];
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
                                        contentText.frame = CGRectMake(0, 410+i*(44+orgRect.size.height), Screen_Width, orgRect.size.height);
                                        [self.scrollView addSubview:contentText];
                                        
                                        //contentText = nil;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"DetailQeryViewController 内存警告");
    // Dispose of any resources that can be recreated.
    //[self viewDidUnload];
}


- (void)viewDidUnload{
    [super viewDidUnload];
    NSLog(@"DetailQeryViewController 卸载");
    //if (_player) _player =nil;
    if (soundProgress) soundProgress =nil;
    if (contentText) contentText =nil;
    if (_attenceImge) _attenceImge =nil;
    //if (_soundData) _soundData =nil;
    if (_background) _background =nil;
    //if (_reportModel) _reportModel =nil;
    if (_soundStirngAr) _soundStirngAr =nil;
    if (_scrollView) _scrollView =nil;
    //if (_timer) _timer =nil;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
    if (soundProgress) soundProgress =nil;
    if (contentText) contentText =nil;
    if (_attenceImge) _attenceImge =nil;
    if (_background) _background =nil;
//    if (_reportModel) _reportModel =nil;
    if (_soundStirngAr) _soundStirngAr =nil;
    if (_scrollView) _scrollView =nil;
    if (_timer) _timer =nil;
    if (_player) _player =nil;
}

@end
