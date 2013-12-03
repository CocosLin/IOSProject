//
//  ReportVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ReportVC.h"
#import "WCommonMacroDefine.h"
//#import "MakeAudioVC.h"
#import <QuartzCore/QuartzCore.h>
#import "HBServerKit.h"
#import "GitomSingal.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

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
//    UIImageView * imgViewPhoto1;
//    UIImageView * imgViewPhoto2;
//    UIImageView * imgViewPhoto3;
//    UIImageView * imgViewPhoto4;
}
@end

@implementation ReportVC


#pragma mark - 用户事件

//@synthesize recorderVC;

-(void)btnAction:(UIButton *)btn
{
//    if (btn.tag == TAG_BtnSaveReport)
//    {
        GitomSingal *singal = [GitomSingal getInstance];
        singal.recordedSound = NO;
        [self sendSoundFileToServe];
        //上传汇报
        [self saveMyReport];
//    }else if(btn.tag == TAG_BtnRecording)
//    {
//        //录音
//        MakeAudioVC * mavc = [[MakeAudioVC alloc]init];
//        [self.navigationController pushViewController:mavc animated:YES];
//        [mavc release];
//    }
}

#pragma mark -- 录音
static int makeSoundFlag;
- (void)saveSoundAction:(UIButton *)sender{
    makeSoundFlag = sender.tag;
    //录音
    MakeAudioVC * mavc = [[MakeAudioVC alloc]init];
    mavc.delegate = self;
    [self.navigationController pushViewController:mavc animated:YES];
  
}
#pragma mark - MakeAudioVC代理方法(录音)
- (void)hadeRecoredAndShowPicture:(NSData *)soundData{
    NSString *soundName = [NSString stringWithFormat:@"coverToAMR%d",makeSoundFlag+10];
    NSString *soundPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:soundName]stringByAppendingPathExtension:@"amr"];
    NSLog(@"wav to amr path = %@",soundPath);
    UIImageView *imgViewSound = (UIImageView *)[self.view viewWithTag:makeSoundFlag+10];
    imgViewSound.image =[UIImage imageNamed:@"111_19.png"];
    [soundData writeToFile:soundPath atomically:NO];
}

#pragma mark -- 获得服务器存放图片路径
// tmp里的： myPhoto3010.jpg、myPhoto3011.jpg、myPhoto3012.jpg、myPhoto3013.jpg  四张图片

- (void)sendFileToServe{
    NSLog(@"获得服务器存放图片路径");
    /*
     "imageUrl":"{"imageUrl":[{"id":" ","thumb":"http://imgcdn1.gitom.com/group1/M00/02/17/OzkPqFKHGfSATbLoAAAHORP77pg438.jpg","url":"http://imgcdn1.gitom.com/group1/M00/02/17/OzkPqFKHGfSASaQ6AAYOaLwhHsk136.jpg"},{"id":" ","thumb":"http://imgcdn1.gitom.com/group1/M00/02/17/OzkPqFKHGfWABYi4AAALCCsZ5iU806.jpg","url":"http://imgcdn1.gitom.com/group1/M00/02/17/OzkPqFKHGfWAOmWOAAbuZKfxxvU674.jpg"},{"id":" ","thumb":"http://imgcdn1.gitom.com/group1/M00/02/17/OzkPqFKHGfaAKEkqAAALR3h_srI016.jpg","url":"http://imgcdn1.gitom.com/group1/M00/02/17/OzkPqFKHGfaATYzqAAb_KCI8tl4008.jpg"},{"id":" ","thumb":"http://imgcdn1.gitom.com/group1/M00/02/17/OzkPqFKHGfeAaqPSAAALd8glIPg646.jpg","url":"http://imgcdn1.gitom.com/group1/M00/02/17/OzkPqFKHGfeAFMkTAAcLzJh395U092.jpg"}]}\"
     */
    
    NSMutableArray *imgpathStr = [[NSMutableArray alloc]init];
    for (int i =0; i<4; i++) {
        NSString *photoPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),[NSString stringWithFormat:@"myPhoto%d.jpg",3010+i]];
        NSData *photoData = [NSData dataWithContentsOfFile:photoPath];
    if (photoData) {
        [imgpathStr addObject:photoPath];
    }
    }
    //NSLog(@"ReportVC imgpathAr count == %d",imgpathAr.count);
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    
    NSMutableArray *photoUrlAr = [[NSMutableArray alloc]init];
    NSMutableDictionary *imageUrlDic = [[NSMutableDictionary alloc]init];

    for (NSString *imgUrl in imgpathStr) {
        NSLog(@"RportVC phtotDatauRL == %@",imgUrl);
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
        [hbKit saveImageReportsOfMembersWithData:imgUrl GotArrReports:^(NSArray *arrDicReports, WError *myError) {
            NSLog(@"arrDicReports == %@",arrDicReports);
//            NSString *group = [[[NSString alloc]init]autorelease];
//            NSString *filename = [[[NSString alloc]init]autorelease];
//            NSString *server = [[[NSString alloc]init]autorelease];
            NSString * group = [[arrDicReports objectAtIndex:0]objectForKey:@"group"];
            NSString * filename = [[arrDicReports objectAtIndex:0]objectForKey:@"filename"];
            NSString * server = [[arrDicReports objectAtIndex:0]objectForKey:@"server"];
            NSString *urlOfImg = [NSString stringWithFormat:@"http://%@/%@/%@",server,group,filename];
            [dic1 setObject:@" " forKey:@"id"];
            [dic1 setObject:urlOfImg forKey:@"thumb"];
            [dic1 setObject:urlOfImg forKey:@"url"];
            NSLog(@"dic1 = %@",dic1);
        }];
        [photoUrlAr addObject:dic1];
     
        NSLog(@"photoUrlAr content == %@",photoUrlAr);
    }
    [imageUrlDic setObject:photoUrlAr forKey:@"imageUrl"];
    NSLog(@"imageUrlDic == %@",imageUrlDic);
    NSData *getData = [NSJSONSerialization dataWithJSONObject:imageUrlDic
                                                  options:kNilOptions
                                                    error:nil];
    NSString *getStr = [[NSString alloc]initWithData:getData encoding:NSUTF8StringEncoding];
    NSLog(@"getStr == %@",getStr);
    self.imgUrlStr = getStr;
    NSLog(@"server imgPath == %@",self.imgUrlStr);
}
#pragma mark -- 获得服务器存放声音路径
- (void)sendSoundFileToServe{
    NSLog(@"获得服务器存放声音路径");
    
    NSMutableArray *soundpathStrAr = [[NSMutableArray alloc]init];
    for (int i =0; i<4; i++) {
        NSString *soundPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),[NSString stringWithFormat:@"coverToAMR%d.amr",4010+i]];
        NSData *soundData = [NSData dataWithContentsOfFile:soundPath];
        if (soundData) {
            [soundpathStrAr addObject:soundPath];
        }
    }
    //NSString *soundPath = [NSString stringWithFormat:@"%@",[[NSTemporaryDirectory() stringByAppendingPathComponent:@"coverToAMR"]stringByAppendingPathExtension:@"amr"]];
    /*
     "soundUrl":"{"soundUrl":[{"id":" ","url":"http://imgcdn1.gitom.com/group1/M00/02/15/OzkPqFKF-CqAZZSaAAAMxiYAzFg299.amr"}]}\"
     */
    NSMutableArray *soundUrlAr = [[NSMutableArray alloc]init];
    NSMutableDictionary *soundUrlDic = [[NSMutableDictionary alloc]init];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    for (NSString *soundPath in soundpathStrAr) {
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
        [hbKit saveSoundReportsOfMembersWithData:soundPath GotArrReports:^(NSArray *arrDicReports, WError *myError) {
            NSLog(@"arrDicReports == %@",arrDicReports);
//            NSString *group = [[[NSString alloc]init]autorelease];
//            NSString *filename = [[[NSString alloc]init]autorelease];
//            NSString *server = [[[NSString alloc]init]autorelease];
            NSString *group = [[arrDicReports objectAtIndex:0]objectForKey:@"group"];
            NSString *filename = [[arrDicReports objectAtIndex:0]objectForKey:@"filename"];
            NSString *server = [[arrDicReports objectAtIndex:0]objectForKey:@"server"];
            
            NSLog(@"server soundgeUrl == %@",[NSString stringWithFormat:@"http://%@/%@/%@",server,group,filename]);
            NSString *urlOfSound = [NSString stringWithFormat:@"http://%@/%@/%@",server,group,filename];
            //NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
            [dic1 setObject:@" " forKey:@"id"];
            [dic1 setObject:urlOfSound forKey:@"url"];
        }];
        [soundUrlAr addObject:dic1];
    }
    NSLog(@"soundUrlAr == %@",soundUrlAr);
    [soundUrlDic setObject:soundUrlAr forKey:@"soundUrl"];
    NSData *getData = [NSJSONSerialization dataWithJSONObject:soundUrlDic
                                                      options:kNilOptions
                                                        error:nil];
    NSString *getStr = [[NSString alloc]initWithData:getData encoding:NSUTF8StringEncoding];
    self.soundUrlStr = getStr;
    NSLog(@"server soundPath == %@",self.soundUrlStr);

}

#pragma mark -- 拍照
static int pickerImgFlag;
- (void)saveMyImage:(UIButton *)sender{
    
    NSLog(@"拍照按钮tag == %ld",(long)sender.tag);
    pickerImgFlag = sender.tag;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = YES; //是否可编辑
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //开启图片选取动画
        [self presentModalViewController:picker animated:YES];
        //释放内存
        
      
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
     NSLog(@"拍照按钮tag得到对应的ImageView == %d",pickerImgFlag);
    NSData *photoData = UIImageJPEGRepresentation(image, 0.0001);
    NSString *myPhotoPath = [NSString stringWithFormat:@"myPhoto%d.jpg",pickerImgFlag+10];//myPhoto3010.jpg\myPhoto3011.jpg\myPhoto3012.jpg\myPhoto3013.jpg  四张图片
    NSString *photoPath = [NSTemporaryDirectory() stringByAppendingString:myPhotoPath];
    NSLog(@".jpg%@",photoPath);
    UIButton *btn =(UIButton *)[self.view viewWithTag:pickerImgFlag];
    [btn setTitle:@"重拍" forState:UIControlStateNormal];
    UIImageView *imgViewPhoto1 = (UIImageView *)[self.view viewWithTag:pickerImgFlag+10];
    imgViewPhoto1.image = image;
    [photoData writeToFile:photoPath atomically:NO];
    
    
    
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
#pragma mark - 我的汇报上传
//
-(void)saveMyReport
{
    
    [self sendFileToServe];//将图片上传服务器，返回图片链接
    [self sendSoundFileToServe];//将音频上传服务器，返回图片链接
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
    NSLog(@"report.soundUrl == %@",self.soundUrlStr);
    report.soundUrl = self.soundUrlStr;
    ReportManager * rm = [ReportManager sharedReportManager];
    [rm saveReportWithReportModel:report GotIsReportOk:^(BOOL isReportOk)
     {NSLog(@"ReportVC == 上传汇报 ");}];
 
    
    
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 表格代理方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * sCellID = @"sCellID";
    NSLog(@"ReportVC breakOne");
    //UITableViewCell * myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sCellID];
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:sCellID];
    if (!myCell) {
        myCell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:sCellID];
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
    
      
        [topView setItems:buttonsArray];
        [_tvNoteInput setInputAccessoryView:topView];
       
        
    }else if(indexPath.row == 3)//附加图片
    {
        h = 90.0;
        for (int i=0; i<4; i++) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(61+(myCell.frame.size.width-80)/4*i, 0, (myCell.frame.size.width-80)/4, h)];
            UIColor *color = [UIColor colorWithRed:(208/255.0) green:(208/255.0) blue:(208/255.0) alpha:1];
            view.layer.borderColor = color.CGColor;
            view.layer.borderWidth = 1.0;
            view.tag = 100;
            [myCell addSubview:view];
            
            UIImageView * imgViewPhoto1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
            imgViewPhoto1.tag = 3010+i;
            imgViewPhoto1.userInteractionEnabled = YES;
            imgViewPhoto1.clipsToBounds = YES;
            [imgViewPhoto1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            imgViewPhoto1.image = [UIImage imageNamed:@"report_picture"];
            imgViewPhoto1.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:imgViewPhoto1];
            
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
            [btnMakePicture addTarget:self action:@selector(saveMyImage:) forControlEvents:UIControlEventTouchUpInside];
            btnMakePicture.tag = 3000+i;
         
        }
        
    }
    else if(indexPath.row == 4)//附加录音
    {
        h = 90.0;
        for (int i=0; i<4; i++) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(61+(myCell.frame.size.width-80)/4*i, 0, (myCell.frame.size.width-80)/4, h)];
            UIColor *color = [UIColor colorWithRed:(208/255.0) green:(208/255.0) blue:(208/255.0) alpha:1];
            view.layer.borderColor = color.CGColor;
            view.layer.borderWidth = 1.0;
            view.tag = 200;
            [myCell addSubview:view];
            
            UIImageView * imgViewSound = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
            imgViewSound.tag = 4010+i;
            imgViewSound.userInteractionEnabled = YES;
            //imgViewSound.clipsToBounds = YES;
           // [imgViewSound addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            imgViewSound.image = [UIImage imageNamed:@"report_recording"];
            imgViewSound.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:imgViewSound];
            
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
            [btnMakeSound addTarget:self action:@selector(saveSoundAction:) forControlEvents:UIControlEventTouchUpInside];
            btnMakeSound.tag = 4000+i;
           
        }
        /*
        h = 90.0;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(60, 0, myCell.frame.size.width - 75, h)];
        UIColor *color = [UIColor colorWithRed:(208/255.0) green:(208/255.0) blue:(208/255.0) alpha:1];
        view.layer.borderColor = color.CGColor;
        view.layer.borderWidth = 1.0;
        view.tag = 100;
        [myCell addSubview:view];
        
        UIImageView * imgViewSound = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width/2 - 50/2, 0, 50, 50)];
        imgViewSound.tag = 4000;
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
        
        
        [view release];*/
    }
    
    UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50,h)];
    lbl.text = _array[indexPath.row];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.lineBreakMode=NSLineBreakByCharWrapping;
    [myCell addSubview:lbl];
   
    
    UIView * viewLine = [[UIView alloc]initWithFrame:CGRectMake(56, 0, 1, tableView.frame.size.height)];
    [myCell addSubview:viewLine];
    [viewLine setBackgroundColor:[UIColor grayColor]];
 
    
    
    return myCell;
}

#pragma mark -- 放大图片
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSLog(@"放大图片");
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i<4; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        UIImageView *imgView = (UIImageView *)[self.view viewWithTag:3010+i];
        photo.srcImageView = imgView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    NSLog(@"显示相册");
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag-3010; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
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
//        [_myAddress release];
//        _myAddress = [myAddress copy];
        _myAddress = nil;
        _myAddress = myAddress;
    }
    _lblMyAddress.text = _myAddress;
}

#pragma mark - 视图生成
-(void)initWithReportInput
{
    _tvbReportInput = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, Width_Screen - 10, Height_Screen - 40 - 44 - 20 -10)];
    _tvbReportInput.scrollEnabled = NO;
    _tvbReportInput.delegate = self;
    _tvbReportInput.dataSource = self;
    _tvbReportInput.layer.borderWidth = 0.3;
    _tvbReportInput.layer.cornerRadius = 7;
    [_tvbReportInput setUserInteractionEnabled:YES];
    [self.view addSubview:_tvbReportInput];
    
}


#pragma mark - 重载父类方法
-(void)btnBack:(UIButton *)btn
{
    NSLog(@"ReportVC popViewControllerAnimated");
    //退出汇报删除图片，节约内存
    NSFileManager *manger = [NSFileManager defaultManager];
    for (int i =0; i<4; i++) {
        NSString *photoPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),[NSString stringWithFormat:@"myPhoto%d.jpg",3010+i]];
        NSData *photoData = [NSData dataWithContentsOfFile:photoPath];
        if (photoData) {
            NSLog(@"photo have %@",photoPath);
            [manger removeItemAtPath:photoPath error:nil];
        }else{
            NSLog(@"photo nil %@",photoPath);
        }
        
    }
    
    
    //退出汇报删除录音，节约内存
    for (int i =0; i<4; i++) {
        NSString *soundPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),[NSString stringWithFormat:@"coverToAMR%d.amr",4010+i]];
        NSData *soundData = [NSData dataWithContentsOfFile:soundPath];
        if (soundData) {
            NSLog(@"sound have %@",soundPath);
            [manger removeItemAtPath:soundPath error:nil];
        }else{
            NSLog(@"sound nil %@",soundPath);
        }
        
    }
    NSString *soundOtherPath = [NSString stringWithFormat:@"%@soundRecord.caf",NSTemporaryDirectory()];
    NSData *soundOtherData = [NSData dataWithContentsOfFile:soundOtherPath];
    if (soundOtherData) {
        [manger removeItemAtPath:soundOtherPath error:nil];
    }else{
        NSLog(@"sound nil");
    }

    [self.navigationController popViewControllerAnimated:YES];
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
     
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航条设置
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_On"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
  
    
    [self initWithReportInput];
    
    //上传汇报
    UIButton * btnSaveReoprt = [UIButton buttonWithType:0];
    btnSaveReoprt.tag = TAG_BtnSaveReport;
    [btnSaveReoprt setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btnSaveReoprt  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [btnSaveReoprt setTitle:@"上传汇报" forState:UIControlStateNormal];
    [btnSaveReoprt setFrame:CGRectMake(5, Height_Screen - 40 - 44 - 20, Width_Screen - 10, 40)];
    [btnSaveReoprt addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSaveReoprt];
    
    [self startPosition];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //UIImageView *imgViewSound = (UIImageView *)[self.view viewWithTag:4010];
    /*
    GitomSingal *singal = [GitomSingal getInstance];
    if (singal.recordedSound) {
        imgViewSound.image = [UIImage imageNamed:@"111_19.png"];
    }else{
        imgViewSound.image = [UIImage imageNamed:@"report_recording"];
    }
    singal.recordedSound = NO;*/
    [self startPosition];
    _bMapSearch = [[BMKSearch alloc]init];
    [_bMapSearch setDelegate:self];
    //[_tvbReportInput reloadData];
    //[self sendSoundFileToServe];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopPosition];
    _bMapSearch.delegate = nil;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
