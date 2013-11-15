//
//  MyDocumentVC.m
//  GitomNetLjw
//
//  Created by GitomYiwan on 13-7-6.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "MyDocumentVC.h"

#import "UserModel.h"
#import "UserManager.h"
#import "HBServerKit.h"
#define kMyPhotoName @"headImg.jpg"
@interface MyDocumentVC ()
@end

@implementation MyDocumentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的资料";
    }
    return self;
}

#pragma mark - 更换用户头像
- (void)chooseHeadPhoto{
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"选择拍照" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"选择图片", nil];
    [aler show];
    [aler release];
}
#pragma mark - UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            
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
                
                [picker release];
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
                //picker.allowsEditing = YES; //是否可编辑
                //打开相册选择照片
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                //开启图片选取动画
                [self presentModalViewController:picker animated:YES];
                //释放内存
                
                [picker release];
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSData *photoData = UIImageJPEGRepresentation(image, 0.0001);
    NSString *photoPath = [NSTemporaryDirectory() stringByAppendingString:kMyPhotoName];
    NSLog(@"photoPath == %@",photoPath);
    self.headImage.image = image;
    [photoData writeToFile:photoPath atomically:NO];
    
    [self dismissModalViewControllerAnimated:YES];
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
        self.headImgUrlStr = urlOfImg;
        NSLog(@"server imgPath == %@",self.headImgUrlStr);
        
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setTitle:@"保存" forState:UIControlStateNormal];
    [rbtn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    rbtn.frame = CGRectMake(0, 0, 50, 44);
    [rbtn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    // 高亮
    [rbtn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [rbtn addTarget:self action:@selector(saveUserDocumentAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rbarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rbtn];
    self.navigationItem.rightBarButtonItem = rbarButtonItem;
    [rbarButtonItem release];
    
    UITapGestureRecognizer *tapHideKey = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHideKeyBoard)];
    [self.view addGestureRecognizer:tapHideKey];
    
	//创建基本信息栏
    [self creatBaseInformationViews];
    
    //头像
    [self loadImage];
    
    //详细信息
    [self creatDetileInformationViews];
    [tapHideKey release];
}

#pragma mark - 更改用户信息
- (void)saveUserDocumentAction{
    [self sendFileToServe];
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    NSString * nameEncod = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)_name.text, NULL, NULL,  kCFStringEncodingUTF8 );
    [hbKit saveUserDocumentWithUsername:comData.userModel.username andRealName:nameEncod andTelephone:_phoneNumber.text andPhoto:self.headImgUrlStr];
    [self tapHideKeyBoard];
    [hbKit release];
}
//连接图片
- (void)loadImage
{
    //获得头像信息
    /*
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    
    NSString *imgUrl = comData.userModel.photo;
    //if (imgUrl != nil) {
        [hbKit getUserPhotoImageWithStrUserPhotoUrl:imgUrl GotResult:^(UIImage *imgUserPhoto, WError *myError) {
            
            self.headImage.image = imgUserPhoto;
        }];
    //}*/
    if (self.imgdata != nil) {
        self.headImage.image = self.imgdata;
    }
    
        
}

//基本信息
- (void)creatBaseInformationViews
{
    UIView *baseInformaton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    baseInformaton.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1];//RGB(176,196,222)
    [self.view addSubview:baseInformaton];
    
    [baseInformaton release];
    
    UIImageView *card_head_camera = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_head_camera.png"]];
    card_head_camera.frame = CGRectMake(0, 0, 10, 10);
    
    
    self.headImage= [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    UIImage *imgHead = [UIImage imageNamed:@"icon_avatar_user.png"];
    self.headImage.image = imgHead;
    [baseInformaton addSubview:self.headImage];
    [self.headImage addSubview:card_head_camera];
    
    UIButton *chooseHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseHeadBtn.frame = CGRectMake(10, 10, 60, 60);
    [chooseHeadBtn addTarget:self action:@selector(chooseHeadPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseHeadBtn];
//    UITapGestureRecognizer *tapChooseHead = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseHeadPhoto)];
//    [self.headImage addGestureRecognizer:tapChooseHead];
//    
    
    UIView *link = [[UIView alloc]initWithFrame:CGRectMake(85, 39, 210, 2)];
    link.backgroundColor = [UIColor colorWithRed:119/255.0 green:136/255.0 blue:153/255.0 alpha:1];//RGB(119,136,153)（浅石板灰）
    [baseInformaton addSubview:link];
    [link release];
    
    UILabel *nameLB1 = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, 60, 25)];
    nameLB1.textAlignment = NSTextAlignmentCenter;
    nameLB1.text = @"姓名:";
    nameLB1.backgroundColor = [UIColor clearColor];
    [baseInformaton addSubview:nameLB1];
    [nameLB1 release];
    
    UILabel *nameLB2 = [[UILabel alloc]initWithFrame:CGRectMake(85, 45, 60, 25)];
    nameLB2.text = @"电话:";
    nameLB2.backgroundColor = [UIColor clearColor];
    nameLB2.textAlignment = NSTextAlignmentCenter;
    [baseInformaton addSubview:nameLB2];
    [nameLB2 release];
    
    //可编辑名字
    _name = [[UITextField alloc]initWithFrame:CGRectMake(140, 10, 130, 25)];
    _name.enabled= YES;
    _name.delegate = self;
    [baseInformaton addSubview:self.name];
    _name.backgroundColor = [UIColor clearColor];
    GetCommonDataModel;
    _name.text = comData.userModel.realname;
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(271, 10, 25, 25)];
    img1.image = [UIImage imageNamed:@"info_edit.png"];
    [baseInformaton addSubview:img1];
    [img1 release];
    
    //可编辑号码
    _phoneNumber    = [[UITextField alloc]initWithFrame:CGRectMake(140, 45, 130, 25)];
    _phoneNumber.enabled = YES;
    _phoneNumber.delegate = self;
    _phoneNumber.backgroundColor = [UIColor clearColor];
    _phoneNumber.text = comData.userModel.telephone;
    NSLog(@"comData.userModel.cellphone==%@",comData.userModel.telephone);
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(271, 45, 25, 25)];
    img2.image = [UIImage imageNamed:@"info_edit.png"];
    [baseInformaton addSubview:img2];
    [img2 release];
    [baseInformaton addSubview:_phoneNumber];
    
}

- (void)tapHideKeyBoard{
    [_name resignFirstResponder];
    [_phoneNumber resignFirstResponder];
}
//获得详细信息
- (void) creatDetileInformationViews
{
    GetCommonDataModel;
    
    [self creatLablesOfDetialTitle:@"账号" andLabelFrame:CGRectMake(5, 81, 40, 25) andLinkFrame:CGRectMake(5, 105, 310, 2) andDetileInformation:[NSString stringWithFormat:@"%@",comData.userModel.username] andInfoFrame:CGRectMake(55, 81, 260, 25)];
    
    //公司 部门 职位

    //标题
    UILabel *userId = [[UILabel alloc]initWithFrame:CGRectMake(5, 111, 40, 25)];
    userId.backgroundColor = [UIColor clearColor];
    userId.text = @"公司";
    userId.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:userId];
    [userId release];
    //信息
    UILabel *ifoLB  = [[UILabel alloc]initWithFrame:CGRectMake(55, 111, 260, 25)];//CGRectMake(55, 81, 260, 25)
    ifoLB.text = comData.organization.name;
    ifoLB.backgroundColor = [UIColor clearColor];
    ifoLB.font = [UIFont systemFontOfSize:13];
    ifoLB.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:ifoLB];
    [ifoLB release];

    //线条
    UIView *link = [[UIView alloc]initWithFrame:CGRectMake(5, 145, 310, 2)];
    link.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1];
    [self.view addSubview:link];
    [link release];
    
    [self creatLablesOfDetialTitle:@"部门" andLabelFrame:CGRectMake(5, 151, 40, 25) andLinkFrame:CGRectMake(5, 175, 310, 2) andDetileInformation:comData.userModel.unitName andInfoFrame:CGRectMake(55, 151, 260, 25)];
    
    //NSString *roleIdStr = [NSString stringWithFormat:@"%d",comData.organization.roleId];
    NSString *roleStr = [[NSString alloc]init];
    if (comData.organization.roleId == 1) {
        roleStr = @"创建者";
    }else if (comData.organization.roleId == 2){
        roleStr = @"部门主管";
    }else{
        roleStr = @"员工";
    }
    
    [self creatLablesOfDetialTitle:@"职位" andLabelFrame:CGRectMake(5, 176, 40, 25) andLinkFrame:CGRectMake(5, 200, 310, 2) andDetileInformation:roleStr andInfoFrame:CGRectMake(55, 176, 260, 25)];
    [roleStr release];
    
}


- (void) creatLablesOfDetialTitle:(NSString *) aTitle
                    andLabelFrame:(CGRect)lbFrame
                     andLinkFrame:(CGRect)lkFram
             andDetileInformation:(NSString *) info
                     andInfoFrame:(CGRect)infoFram{
    
    //标题
    UILabel *userId = [[UILabel alloc]initWithFrame:lbFrame];
    userId.backgroundColor = [UIColor clearColor];
    userId.text = aTitle;
    userId.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:userId];
    [userId release];
    //信息
    UILabel *ifoLB  = [[UILabel alloc]initWithFrame:infoFram];//CGRectMake(55, 81, 260, 25)
    ifoLB.text = info;
    ifoLB.backgroundColor = [UIColor clearColor];
    ifoLB.font = [UIFont systemFontOfSize:13];
    ifoLB.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:ifoLB];
    [ifoLB release];
    //线条
    UIView *link = [[UIView alloc]initWithFrame:lkFram];
    link.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1];
    [self.view addSubview:link];
    [link release];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_name release];
    [_phoneNumber release];
    [_headImage release];
    [_unitName release];
    [super dealloc];
}


@end
