//
//  ReportVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ReportVC.h"
#import "WCommonMacroDefine.h"
#import "MakeAudioVC.h"
#import <QuartzCore/QuartzCore.h>
#import "HBServerKit.h"
#import "GitomSingal.h"
#define kMyPhotoName @"myPhoto.jpg"

typedef NS_ENUM(NSInteger, Tag_ReportVC) {
    TAG_BtnSaveReport = 101,
    TAG_BtnShowLocation = 102,
    TAG_BtnRecording = 103
};
@interface ReportVC ()
{
    UITableView * _tvbReportInput;
    UILabel * _lblLocationInfo;
    UILabel * _lblMyAddress;
    UITextView * _tvNoteInput;
    BMKUserLocation * _userLocation;
    BMKSearch * _bMapSearch;
    NSString * _strReportType;
    UIImageView * imgViewPhoto;
}
@end

@implementation ReportVC


#pragma mark - 用户事件

//@synthesize recorderVC;

-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == TAG_BtnSaveReport)
    {
        GitomSingal *singal = [GitomSingal getInstance];
        singal.recordedSound = NO;
        [self sendSoundFileToServe];
        //上传汇报
        [self saveMyReport];
    }else if(btn.tag == TAG_BtnRecording)
    {
        //录音
        MakeAudioVC * mavc = [[MakeAudioVC alloc]init];
        [self.navigationController pushViewController:mavc animated:YES];
        [mavc release];
    }
}



#pragma mark -- 获得服务器存放图片路径
- (void)sendFileToServe{
    NSLog(@"获得服务器存放图片路径");
    NSString *photoPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),kMyPhotoName];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit saveImageReportsOfMembersWithData:photoPath GotArrReports:^(NSArray *arrDicReports, WError *myError) {
        NSLog(@"arrDicReports == %@",arrDicReports);
        NSString *group = [[[NSString alloc]init]autorelease];
        NSString *filename = [[[NSString alloc]init]autorelease];
        NSString *server = [[[NSString alloc]init]autorelease];
        group = [[arrDicReports objectAtIndex:0]objectForKey:@"group"];
        filename = [[arrDicReports objectAtIndex:0]objectForKey:@"filename"];
        server = [[arrDicReports objectAtIndex:0]objectForKey:@"server"];
        NSString *urlOfImg = [NSString stringWithFormat:@"http://%@/%@/%@",server,group,filename];
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
        [dic1 setObject:@" " forKey:@"id"];
        [dic1 setObject:@" " forKey:@"thumb"];
        [dic1 setObject:urlOfImg forKey:@"url"];
        
        NSArray *imgArr = [NSArray arrayWithObject:dic1];
        
        NSMutableDictionary *imgDic = [[NSMutableDictionary alloc]init];
        [imgDic setObject:imgArr forKey:@"imageUrl"];
        NSLog(@"imgDic == %@",imgDic);
        NSData *getData = [NSJSONSerialization dataWithJSONObject:imgDic
                                                          options:kNilOptions
                                                            error:nil];
        NSString *getStr = [[NSString alloc]initWithData:getData encoding:NSUTF8StringEncoding];
        NSLog(@"getStr == %@",getStr);
        self.imgUrlStr = getStr;
        NSLog(@"server imgPath == %@",self.imgUrlStr);
        
    }];
}
#pragma mark -- 获得服务器存放声音路径
- (void)sendSoundFileToServe{
    NSLog(@"获得服务器存放声音路径");
    NSString *soundPath = [NSString stringWithFormat:@"%@",[[NSTemporaryDirectory() stringByAppendingPathComponent:@"coverToAMR"]stringByAppendingPathExtension:@"amr"]];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit saveSoundReportsOfMembersWithData:soundPath GotArrReports:^(NSArray *arrDicReports, WError *myError) {
        NSLog(@"arrDicReports == %@",arrDicReports);
        NSString *group = [[[NSString alloc]init]autorelease];
        NSString *filename = [[[NSString alloc]init]autorelease];
        NSString *server = [[[NSString alloc]init]autorelease];
        group = [[arrDicReports objectAtIndex:0]objectForKey:@"group"];
        filename = [[arrDicReports objectAtIndex:0]objectForKey:@"filename"];
        server = [[arrDicReports objectAtIndex:0]objectForKey:@"server"];
        
        NSLog(@"server soundgeUrl == %@",[NSString stringWithFormat:@"http://%@/%@/%@",server,group,filename]);
        NSString *urlOfSound = [NSString stringWithFormat:@"http://%@/%@/%@",server,group,filename];
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
        [dic1 setObject:@" " forKey:@"id"];
        [dic1 setObject:urlOfSound forKey:@"url"];
        
        NSArray *imgArr = [NSArray arrayWithObject:dic1];
                NSMutableDictionary *soundDic = [[NSMutableDictionary alloc]init];
        [soundDic setObject:imgArr forKey:@"soundUrl"];
        NSLog(@"soundDic == %@",soundDic);
        //self.imgUrlStr = imgDic;
        NSData *getData = [NSJSONSerialization dataWithJSONObject:soundDic
                                                          options:kNilOptions
                                                            error:nil];
        NSString *getStr = [[NSString alloc]initWithData:getData encoding:NSUTF8StringEncoding];
        self.soundUrlStr = getStr;
        NSLog(@"server soundPath == %@",self.soundUrlStr);
    }];
}

#pragma mark -- 拍照
- (void)saveMyImage{
    NSLog(@"拍照");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = YES; //是否可编辑
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //开启图片选取动画
        [self presentModalViewController:picker animated:YES];
        //释放内存
        
        [picker release];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSData *photoData = UIImageJPEGRepresentation(image, 0.0001);
    NSString *photoPath = [NSTemporaryDirectory() stringByAppendingString:kMyPhotoName];
    NSLog(@"photoPath == %@",photoPath);
    imgViewPhoto.image = image;
    [photoData writeToFile:photoPath atomically:NO];
    [self sendFileToServe];
    [self dismissModalViewControllerAnimated:YES];
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setEditing:NO];
}
#pragma mark - 自定义方法
//开始定位
-(void)startPosition
{
    self.bMapView.showsUserLocation = YES;
    self.bMapView.delegate = self;
}

//结束定位
-(void)stopPosition
{
    self.bMapView.showsUserLocation = NO;
    self.bMapView.delegate = nil;
}
-(void)dismissKeyBoard
{
    [_tvNoteInput resignFirstResponder];
}

//我的汇报上传
-(void)saveMyReport
{
    
    
    ReportModel * report = [[ReportModel alloc]init];
    GetCommonDataModel;
    report.organizationId = comData.organization.organizationId;
    report.orgunitId = comData.organization.orgunitId;
    report.reportType = [ReportManager getStrTypeReportWithIntReportType:self.intReportType];
    report.latitude = self.latitude;
    report.longitude = self.longitude;
    report.address = self.myAddress;
    report.note = _tvNoteInput.text;
    report.voidFlag = NO;
    /*
     \"{\\\"imageUrl\\\":[{\\\"id\\\":\\\"\\\",\\\"thumb\\\":\\\"http:\\\\\/\\\\\/imgcdn1.gitom.com\\\\\/group1\\\\\/M00\\\\\/01\\\\\/C0\\\\\/OzkPqFJg8QaAJoexAAAF31GLukg274.jpg\\\",\\\"url\\\":\\\"http:\\\\\/\\\\\/imgcdn1.gitom.com\\\\\/group1\\\\\/M00\\\\\/01\\\\\/C0\\\\\/OzkPqFJg8QWAOMKhAAYiO57ScNY757.jpg\\\"}]}\",
     */
    
    report.imageUrl = self.imgUrlStr;
//    if ([[NSTemporaryDirectory() stringByAppendingPathComponent:@"coverToAMR"]stringByAppendingPathExtension:@"amr"]) {
//        [self sendSoundFileToServe];
//        report.soundUrl = self.soundUrlStr;
//    }else{
//        NSLog(@"不存在soundURL路径");
//        report.soundUrl = nil;
//    }
    NSLog(@"report.soundUrl == %@",self.soundUrlStr);
    report.soundUrl = self.soundUrlStr;
    ReportManager * rm = [ReportManager sharedReportManager];
    [rm saveReportWithReportModel:report GotIsReportOk:^(BOOL isReportOk)
     {NSLog(@"ReportVC == 上传汇报 ");}];
    [report release];
}

#pragma mark - 表格代理方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * sCellID = @"sCellID";
    NSLog(@"breakOne");
    //UITableViewCell * myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sCellID];
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:sCellID];
    if (!myCell) {
        myCell = [[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:sCellID]autorelease];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * _array=[NSArray arrayWithObjects:@"当前位置",@"当前地址",@"附加文字",@"附加照片",@"附加录音", nil];
    float h = 80;
    if (indexPath.row == 0) {
        h = 30.0;
        _lblLocationInfo = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, myCell.frame.size.width - 60-50, h)];
        [_lblLocationInfo setBackgroundColor:[UIColor clearColor]];
        _lblLocationInfo.text = [NSString stringWithFormat:@"正在获取您当前位置..."];
        [_lblLocationInfo setFont:[UIFont systemFontOfSize:12]];
        [myCell addSubview:_lblLocationInfo];
        [self startPosition];
    }else if(indexPath.row == 1)
    {
        h = 40.0;
        _lblMyAddress = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, myCell.frame.size.width - 60-5, h)];
        _lblMyAddress.text = @"正在读取您当前位置,请确保GPS和网络已开启!";
        _lblMyAddress.lineBreakMode = 3;
        _lblMyAddress.numberOfLines = 2;
        [_lblMyAddress setFont:[UIFont systemFontOfSize:12]];
        [myCell addSubview:_lblMyAddress];
    }else if(indexPath.row == 2)
    {
        h = tableView.frame.size.height - 30 - 40 -90 -90;
        _tvNoteInput = [[UITextView alloc]initWithFrame:CGRectMake(60, 1, myCell.frame.size.width - 60 -5 - 5 - 3, h - 4)];
        [_tvNoteInput setBackgroundColor:[UIColor clearColor]];
        [_tvNoteInput.layer setBorderWidth:0.2];
        [_tvNoteInput.layer setCornerRadius:7];
        [_tvNoteInput setFont:[UIFont systemFontOfSize:13]];
        _tvNoteInput.delegate = self;
        [myCell addSubview:_tvNoteInput];
        
        //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
        UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
        [btnSpace release];
        [doneButton release];
        [topView setItems:buttonsArray];
        [_tvNoteInput setInputAccessoryView:topView];
        [topView release];
        
    }else if(indexPath.row == 3)//附加图片
    {
        h = 90.0;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(60, 0, myCell.frame.size.width - 75, h)];
        UIColor *color = [UIColor colorWithRed:(208/255.0) green:(208/255.0) blue:(208/255.0) alpha:1];
        view.layer.borderColor = color.CGColor;
        view.layer.borderWidth = 1.0;
        view.tag = 100;
        [myCell addSubview:view];
        
        imgViewPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width/2 - 50/2, 0, 50, 50)];
        imgViewPhoto.image = [UIImage imageNamed:@"report_picture"];
        [view addSubview:imgViewPhoto];
        
        UIButton * btnMakePicture = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMakePicture setBackgroundImage:[[UIImage imageNamed:@"btn_group_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [btnMakePicture setTitle:@"拍照" forState:UIControlStateNormal];
        [btnMakePicture setBackgroundImage:[[UIImage imageNamed:@"btn_group_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
        [btnMakePicture setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnMakePicture.titleLabel setFont:[UIFont systemFontOfSize:13]];
        btnMakePicture.layer.borderColor = color.CGColor;
        btnMakePicture.layer.borderWidth = 1.0;
        btnMakePicture.frame = CGRectMake(0+5, view.frame.size.height - 35, view.frame.size.width-10, 30);
        [view addSubview:btnMakePicture];
        [btnMakePicture addTarget:self action:@selector(saveMyImage) forControlEvents:UIControlEventTouchUpInside];
        btnMakePicture.tag = TAG_BtnRecording;
        [view release];
    }
    else if(indexPath.row == 4)//附加录音
    {
        h = 90.0;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(60, 0, myCell.frame.size.width - 75, h)];
        UIColor *color = [UIColor colorWithRed:(208/255.0) green:(208/255.0) blue:(208/255.0) alpha:1];
        view.layer.borderColor = color.CGColor;
        view.layer.borderWidth = 1.0;
        view.tag = 100;
        [myCell addSubview:view];
        
        UIImageView * imgViewSound = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width/2 - 50/2, 0, 50, 50)];
        GitomSingal *singal = [GitomSingal getInstance];
        if (singal.recordedSound) {
            imgViewSound.image = [UIImage imageNamed:@"111_19.png"];
        }else{
            imgViewSound.image = [UIImage imageNamed:@"report_recording"];
        }
        
        [view addSubview:imgViewSound];
        [imgViewSound release];
        
        UIButton * btnMakeSound = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMakeSound setBackgroundImage:[[UIImage imageNamed:@"btn_group_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
             [btnMakeSound setTitle:@"录音" forState:UIControlStateNormal];
        [btnMakeSound setBackgroundImage:[[UIImage imageNamed:@"btn_group_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
        [btnMakeSound setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [btnMakeSound.titleLabel setFont:[UIFont systemFontOfSize:13]];
        btnMakeSound.layer.borderColor = color.CGColor;
        btnMakeSound.layer.borderWidth = 1.0;
        btnMakeSound.frame = CGRectMake(0+5, view.frame.size.height - 35, view.frame.size.width-10, 30);
        [view addSubview:btnMakeSound];
        [btnMakeSound addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btnMakeSound.tag = TAG_BtnRecording;
        
        
        [view release];
    }
    
    UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50,h)];
    lbl.text = _array[indexPath.row];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 30;
    }else if(indexPath.row == 1)
    {
        return 40;
    }
    if (indexPath.row == 2)
    {
        return tableView.frame.size.height - 30 - 40 -90 -90;
    }
    return 90.0;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissKeyBoard];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark - 百度地图代理方法
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
        //定位一次
        _userLocation = userLocation;
        self.longitude = _userLocation.coordinate.longitude;
        self.latitude = _userLocation.coordinate.latitude;
    
        //反编码地址
        [_bMapSearch reverseGeocode:_userLocation.coordinate];
    
}

-(void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    _userLocation = nil;
}
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
   _userLocation = mapView.userLocation;
//    NSLog(@"%@",[ReportManager getStrTypeReportWithIntReportType:self.intReportType]);
}

#pragma mark -百度地图服务
-(void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error
{
    
    self.myAddress = result.strAddr;
    //解析完就停止定位
    self.bMapView.showsUserLocation = NO;
}

#pragma mark - 属性控制
-(void)setIntReportType:(Flag_ReportType)intReportType
{
    _intReportType = intReportType;
    if (_intReportType == Flag_ReportType_Work)
    {
        self.title = @"工作汇报";
    }
    else if(_intReportType == Flag_ReportType_GoOut)
    {
        self.title = @"外出汇报";
    }
    else if(_intReportType == Flag_ReportType_Travel)
    {
        self.title = @"出差汇报";
    }
    else
    {
        self.title = @"汇报";
    }
}

-(void)setIsShowRecord:(BOOL)isShowRecord
{
    _isShowRecord = isShowRecord;
    if (_isShowRecord) {
        //如果是查汇报，就把按钮去掉，让汇报内容不可以编辑等
    }else
    {
        //如果不是查汇报，就把按钮显示出来，让汇报内容可以编辑等
    }
}

-(void)setLatitude:(double)latitude
{
    _latitude = latitude;
    _lblLocationInfo.text = [NSString stringWithFormat:@"%.6lf,%.6lf",_latitude,_longitude];
}

-(void)setLongitude:(double)longitude
{
    _longitude = longitude;
    _lblLocationInfo.text = [NSString stringWithFormat:@"%.6lf,%.6lf",_latitude,_longitude];
}

-(void)setMyAddress:(NSString *)myAddress
{
    if (myAddress != _myAddress) {
        [_myAddress release];
        _myAddress = [myAddress copy];
    }
    _lblMyAddress.text = _myAddress;
}

#pragma mark - 视图生成
-(void)initWithReportInput
{
    _tvbReportInput = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, Width_Screen - 10, Height_Screen - 40 - 44 - 20 -10)];
    _tvbReportInput.delegate = self;
    _tvbReportInput.dataSource = self;
    _tvbReportInput.layer.borderWidth = 0.3;
    _tvbReportInput.layer.cornerRadius = 7;
    [_tvbReportInput setUserInteractionEnabled:YES];
    [self.view addSubview:_tvbReportInput];
    
}

#pragma mark - 生命周期

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.isShowRecord = NO;
        //测试
        BMKMapView * mapView = [[BMKMapView alloc]init];
        self.bMapView = mapView;
        [self startPosition];
        [mapView release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化录音vc
  //  recorderVC = [[ChatVoiceRecorderVC alloc]init];
 //   recorderVC.vrbDelegate = self;
    
    //导航条设置
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_On"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    
    [self initWithReportInput];
    
    //上传汇报
    UIButton * btnSaveReoprt = [UIButton buttonWithType:0];
    btnSaveReoprt.tag = TAG_BtnSaveReport;
    [btnSaveReoprt setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btnSaveReoprt  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [btnSaveReoprt setTitle:@"上传汇报" forState:UIControlStateNormal];
    [btnSaveReoprt setTitle:@"放手上传吧..." forState:UIControlStateHighlighted];
    [btnSaveReoprt setFrame:CGRectMake(5, Height_Screen - 40 - 44 - 20, Width_Screen - 10, 40)];
    [btnSaveReoprt addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSaveReoprt];
    
    [self startPosition];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startPosition];
    _bMapSearch = [[BMKSearch alloc]init];
    [_bMapSearch setDelegate:self];
    [_tvbReportInput reloadData];
    //[self sendSoundFileToServe];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopPosition];
    _bMapSearch.delegate = nil;
    [_bMapSearch release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_lblLocationInfo release];
    [_lblMyAddress release];
    [_tvNoteInput release];
    [_tvbReportInput release];
    
    [super dealloc];
}
@end
