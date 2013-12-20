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
#define kMyPhotoName @"releaseImg.jpg"
@interface ReleaseAnnounceVC (){
    UILabel *thanks;
    UIView *addToBaseView;
    BOOL organizationNews;//是否为公司公告
    NSData *photoData;
}

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
    
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(announceAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;

    
    _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-65)];
    _baseView.backgroundColor = [UIColor clearColor];
    //_baseView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_baseView];
    
    //公告类型
    GetCommonDataModel;
    if (comData.organization.roleId!=1) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width/2, 10,25, 25)];
        [imgView setImage:[UIImage imageNamed:@"checkbox_checked"]];
        [self.view addSubview:imgView];
  
        UILabel *styleLb = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/2+40, 3, 80, 40)];
        styleLb.backgroundColor = [UIColor clearColor];
        [self.view addSubview:styleLb];
        styleLb.text= @"部门公告";
 
        
    }else{
        
        UIButton *lfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [lfButton setImage:[UIImage imageNamed:@"checkbox_normal.png"] forState:UIControlStateNormal];
        [lfButton addTarget:self action:@selector(lfButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        lfButton.tag = 2201;
        lfButton.frame = CGRectMake(20, 10, 25, 25);
        UILabel *lfStyleLb = [[UILabel alloc]initWithFrame:CGRectMake(50, 1, 80, 40)];
        lfStyleLb.text = @"公司公告";
        lfStyleLb.backgroundColor = [UIColor clearColor];
        [self.view addSubview:lfButton];
        [self.view addSubview:lfStyleLb];
 
        
        UIButton *rtButton = [UIButton buttonWithType:0];
        [rtButton setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
        [rtButton addTarget:self action:@selector(rtButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        rtButton.tag = 2202;
        rtButton.frame = CGRectMake(Screen_Width/2+20, 10, 25, 25);
        [self.view addSubview:rtButton];
 
        UILabel *rtStyleLb = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/2+50, 1, 80, 40)];
        rtStyleLb.backgroundColor = [UIColor clearColor];
        [self.view addSubview:rtStyleLb];
        rtStyleLb.text= @"部门公告";
  
        
    }
    
    //与隐藏键盘相关
    addToBaseView = [[UIView alloc]initWithFrame:_baseView.frame];
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
    
    //上传图片
    [self initReleaseImageViews];
    

    //内容
    [self initContentViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(tpeToDismissAction)];
    [addToBaseView addGestureRecognizer:tap];
}

#pragma mark -- 选择发布公告类型
- (void)lfButtonAction:(UIButton *)sender{
    [sender setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
    UIButton *rtButton = (UIButton *)[self.view viewWithTag:2202];
    [rtButton setImage:[UIImage imageNamed:@"checkbox_normal.png"] forState:UIControlStateNormal];
    NSLog(@"选择发布公告类型 == gs");
    organizationNews = YES;
}

- (void)rtButtonAction:(UIButton *)sender{
    [sender setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
    UIButton *rtButton = (UIButton *)[self.view viewWithTag:2201];
    [rtButton setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    NSLog(@"选择发布公告类型 == bm");
    organizationNews = NO;
}

#pragma mark -- 上传图片相关方法
- (void)initReleaseImageViews{
    
    UIButton * btnMakePicture = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMakePicture.tag = 10001;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]<6.0) {
        [btnMakePicture addTarget:self action:@selector(postMyImage) forControlEvents:UIControlEventTouchDown];
    }else{
        [btnMakePicture addTarget:self action:@selector(postMyImage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [btnMakePicture setBackgroundImage:[[UIImage imageNamed:@"btn_group_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btnMakePicture setTitle:@"图片" forState:UIControlStateNormal];
    [btnMakePicture setBackgroundImage:[[UIImage imageNamed:@"btn_group_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [btnMakePicture setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMakePicture.titleLabel setFont:[UIFont systemFontOfSize:13]];
    UIColor *color = [UIColor colorWithRed:(208/255.0) green:(208/255.0) blue:(208/255.0) alpha:1];
    btnMakePicture.layer.borderColor = color.CGColor;
    btnMakePicture.layer.borderWidth = 1.0;
    btnMakePicture.frame = CGRectMake(Screen_Width-80, 110, 60, 30);
    [addToBaseView addSubview:btnMakePicture];
    
    self.releaseImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [addToBaseView addSubview:self.releaseImage];
    
}

- (void) initContentViews{
    thanks = [[UILabel alloc]initWithFrame:CGRectMake(20, 126, Screen_Width-45, 30)];
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"ReleaseAnnounceVC didReceiveMemoryWarning");
    [self viewDidUnload];
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    //if (self.releaseImage) self.releaseImage = nil;
    if (thanks) thanks = nil;
    if (photoData) photoData = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


#pragma mark -- 发布公告
//http://hb.m.gitom.com/3.0/organization/saveNews?organizationId=114&orgunitId=1&title=ddddd&content=dddddd&username=90261&newsType=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
- (void)announceAction{
    
    [self performSelectorOnMainThread:@selector(sendFileToServe) withObject:nil waitUntilDone:YES];
    
    GetCommonDataModel;
    if (self.textTitle.text.length >0 && self.announceContent.text.length > 0) {
        
        NSString *tempStr = [NSString stringWithFormat:@"%@",self.textTitle.text];
        NSString *temp = [self URLEncodedString:tempStr];
        NSLog(@"temp == %@ self.releaseImgUrlStr == %@",temp,self.releaseImgUrlStr);
        NSString *announceTemp = [[NSString alloc]init];
        
        if (self.releaseImgUrlStr) {//\n[附加图片]
            
            announceTemp = [self URLEncodedString:[NSString stringWithFormat:@"%@\n[附加图片]%@",[self URLEncodedString:self.announceContent.text],[self URLEncodedString:self.releaseImgUrlStr]]];
             NSLog(@"ReleaseAnnounceVC announceTemp == %@",announceTemp);
            
        }else{
            
            announceTemp = [[self URLEncodedString:self.announceContent.text ]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
        }
        
        NSLog(@"announceTemp == %@",announceTemp);
        NSString *releaseUrlStr;
        if (organizationNews) {
            
            releaseUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/saveNews?organizationId=%d&orgunitId=0&title=%@&content=%@&username=%@&newsType=%d&cookie=%@",comData.organization.organizationId,temp,announceTemp,comData.userModel.username,comData.organization.orgunitId,comData.cookie];
            
        }else{
            
            releaseUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/saveNews?organizationId=%d&orgunitId=%d&title=%@&content=%@&username=%@&newsType=1&cookie=%@",comData.organization.organizationId,comData.organization.orgunitId,[temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],announceTemp,comData.userModel.username,comData.cookie];
            
        }
        
        NSLog(@"ReleaseAnnounceVC UrlStr %@",releaseUrlStr);
        NSURL *releaseUrl = [NSURL URLWithString:releaseUrlStr];
        NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
        [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
        NSLog(@"ReleaseAnnounceVC release announce");
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@releaseImg.jpg",NSTemporaryDirectory()] error:nil];
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"请填写发布内容"];
        
    }
    
}

#pragma mark -- NSString转UTF8方法
- (NSString *)URLEncodedString:(NSString *)sender
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)sender,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
 
    return result;
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _baseView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-190);
    _baseView.contentSize = self.view.frame.size;
    
}

#pragma mark -- 点击任意位置收起键盘
- (void)tpeToDismissAction{
    [self.textTitle resignFirstResponder];
    [self.announceContent resignFirstResponder];
    _baseView.frame = self.view.frame;
    _baseView.contentSize = self.view.frame.size;
    //self.hideKeyBoardView.hidden = YES;
}

#pragma mark -- 隐藏键盘
- (void)hideKeyBoardAciton{
    [self tpeToDismissAction];
}

#pragma mark - 上传图片相关
- (void)postMyImage{
    NSLog(@"上传图片按钮");
    UIButton *but = (UIButton *)[self.view viewWithTag:10001];
    [but setTitle:@"重新选择" forState:UIControlStateNormal];
    self.releaseImage.frame = CGRectMake(20, 120, Screen_Width-80, 100);
    self.releaseImage.contentMode = UIViewContentModeScaleAspectFit;
    thanks.frame = CGRectMake(20, 126+110, Screen_Width-45, 30);
    self.announceContent.frame = CGRectMake(20, 166+110, Screen_Width-40, 70);
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"选择拍照" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"选择图片", nil];
    [aler show];

}

#pragma mark -- UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            NSLog(@"选取图片");
        case 1:
        {
            NSLog(@"camera");
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case 2:{
            NSLog(@"album");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //打开相册选择照片
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                //开启图片选取动画
                [self presentModalViewController:picker animated:YES];
                //释放内存
                
    
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相册中没有图片" delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil];
                [alert show];
            }
        }
        default:
            break;
    }
}

#pragma mark -- UIImagePickerControllerDelegate
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    photoData = UIImageJPEGRepresentation(image, 0.0001);
    NSString *photoPath = [NSTemporaryDirectory() stringByAppendingString:kMyPhotoName];
    NSLog(@"photoPath == %@",photoPath);
    self.releaseImage.image = image;
    [photoData writeToFile:photoPath atomically:NO];
    [self dismissModalViewControllerAnimated:YES];
}*/

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
    
}

- (void)useImage:(UIImage *)image {
    
    //对图片进行压缩
    CGSize newSize = CGSizeMake(320, 480);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //照片写入本地temp临时存储
    photoData = UIImageJPEGRepresentation(newImage, 0.0000000000001);
    NSString *photoPath = [NSTemporaryDirectory() stringByAppendingString:kMyPhotoName];
    NSLog(@"photoPath == %@",photoPath);
    self.releaseImage.image = image;
    [photoData writeToFile:photoPath atomically:NO];
    
    
}

#pragma mark -- 获得服务器存放图片路径
- (void)sendFileToServe{
    NSLog(@"获得服务器存放图片路径");
    NSString *photoPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),kMyPhotoName];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit saveImageReportsOfMembersWithData:photoPath GotArrReports:^(NSArray *arrDicReports, WError *myError) {
        NSLog(@"arrDicReports == %@",arrDicReports);
        NSString *group = [[NSString alloc]init];
        NSString *filename = [[NSString alloc]init];
        NSString *server = [[NSString alloc]init];
        group = [[arrDicReports objectAtIndex:0]objectForKey:@"group"];
        filename = [[arrDicReports objectAtIndex:0]objectForKey:@"filename"];
        server = [[arrDicReports objectAtIndex:0]objectForKey:@"server"];
        NSString *urlOfImg = [NSString stringWithFormat:@"http://%@/%@/%@",server,group,filename];
        self.releaseImgUrlStr = urlOfImg;
        NSLog(@"server imgPath == %@",self.releaseImgUrlStr);
        
    }];
}


@end
