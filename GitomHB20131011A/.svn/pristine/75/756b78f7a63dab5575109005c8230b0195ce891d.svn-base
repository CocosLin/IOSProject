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

- (void)viewDidLoad
{
    [super viewDidLoad];
	//创建基本信息栏
    [self creatBaseInformationViews];
    
    //头像
    [self loadImage];
    
    //详细信息
    [self creatDetileInformationViews];
    
}

//连接图片
- (void)loadImage
{
    //获得头像信息
    GetCommonDataModel;
    NSString *imgUrl = comData.userModel.photo;
    NSLog(@"imgUrl==%@",imgUrl);
    if (imgUrl != nil) {
        NSURL *url = [NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *pthotoData  = [NSData dataWithContentsOfURL:url];
        self.headImage.image = [UIImage imageWithData:pthotoData];
    }
    
    
        
}

//基本信息
- (void)creatBaseInformationViews
{
    UIView *baseInformaton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    baseInformaton.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1];//RGB(176,196,222)
    [self.view addSubview:baseInformaton];
    
    [baseInformaton release];
    
    
    UIImageView * tempHeadImageView= [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    
    self.headImage = tempHeadImageView;
    UIImage *imgHead = [UIImage imageNamed:@"icon_avatar_user.png"];
    //self.headImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_avatar_user.png"]];
    self.headImage.image = imgHead;
    [baseInformaton addSubview:self.headImage];
    [tempHeadImageView release];
    //UIView *cameraImg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 31, 28)];
    //[tempHeadImageView addSubview:cameraImg];
    //[cameraImg release];
    
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
    [baseInformaton addSubview:self.name];
    _name.backgroundColor = [UIColor clearColor];
    GetCommonDataModel;
    _name.text = comData.userModel.realname;
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(271, 10, 25, 25)];
    img1.image = [UIImage imageNamed:@"info_edit.png"];
    [baseInformaton addSubview:img1];
    [img1 release];
    
    //可编辑号码
    UITextField * tempPhoneNumber    = [[UITextField alloc]initWithFrame:CGRectMake(140, 45, 130, 25)];
    tempPhoneNumber.backgroundColor = [UIColor clearColor];
    tempPhoneNumber.text = comData.userModel.telephone;
    NSLog(@"comData.userModel.cellphone==%@",comData.userModel.telephone);
    self.phoneNumber = tempPhoneNumber;
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(271, 45, 25, 25)];
    img2.image = [UIImage imageNamed:@"info_edit.png"];
    [baseInformaton addSubview:img2];
    [img2 release];
    [baseInformaton addSubview:self.phoneNumber];
    
    [tempPhoneNumber release];
    
}

//获得详细信息
- (void) creatDetileInformationViews
{
    GetCommonDataModel;
    
    [self creatLablesOfDetialTitle:@"账号" andLabelFrame:CGRectMake(5, 81, 40, 25) andLinkFrame:CGRectMake(5, 105, 310, 2) andDetileInformation:[NSString stringWithFormat:@"%@",comData.userModel.username] andInfoFrame:CGRectMake(55, 81, 260, 25)];
    
    //公司 部门 职位

    //标题
    UILabel *userId = [[UILabel alloc]initWithFrame:CGRectMake(5, 116, 40, 25)];
    userId.backgroundColor = [UIColor clearColor];
    userId.text = @"公司";
    userId.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:userId];
    [userId release];
    //信息
    UILabel *ifoLB  = [[UILabel alloc]initWithFrame:CGRectMake(55, 116, 260, 25)];//CGRectMake(55, 81, 260, 25)
    ifoLB.text = comData.organization.name;
    ifoLB.backgroundColor = [UIColor clearColor];
    ifoLB.font = [UIFont systemFontOfSize:13];
    ifoLB.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:ifoLB];
    [ifoLB release];
    //公司编号
    
    
    
    //线条
    UIView *link = [[UIView alloc]initWithFrame:CGRectMake(5, 165, 310, 2)];
    link.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1];
    [self.view addSubview:link];
    [link release];
    
    [self creatLablesOfDetialTitle:@"部门" andLabelFrame:CGRectMake(5, 166, 40, 25) andLinkFrame:CGRectMake(5, 190, 310, 2) andDetileInformation:self.unitName andInfoFrame:CGRectMake(55, 166, 260, 25)];
    
    //NSString *roleIdStr = [NSString stringWithFormat:@"%d",comData.organization.roleId];
    NSString *roleStr = [[NSString alloc]init];
    if (comData.organization.roleId == 1) {
        roleStr = @"创建者";
    }else if (comData.organization.roleId == 2){
        roleStr = @"部门主管";
    }else{
        roleStr = @"员工";
    }
    
    [self creatLablesOfDetialTitle:@"职位" andLabelFrame:CGRectMake(5, 191, 40, 25) andLinkFrame:CGRectMake(5, 215, 310, 2) andDetileInformation:roleStr andInfoFrame:CGRectMake(55, 191, 260, 25)];
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
