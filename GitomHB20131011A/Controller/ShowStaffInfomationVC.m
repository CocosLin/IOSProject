//
//  ShowStaffInfomationVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-28.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ShowStaffInfomationVC.h"
#import "SVProgressHUD.h"
#import "HBServerKit.h"


@interface ShowStaffInfomationVC (){
    BOOL switchAlerDelegate;
}

@end

@implementation ShowStaffInfomationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.ifoArray = [[NSMutableArray alloc]init];
        //self.orgNameArr = [[NSArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit findReportsWithOrganizationId:comData.organization.organizationId GotArrReports:^(NSArray *arrDicReports, WError *myError) {
        self.orgNameArr = arrDicReports;
    }];
    NSLog(@"orgNameArr.count == %d",self.orgNameArr.count);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_On"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    
    // Do any additional setup after loading the view from its nib.
    //创建基本信息栏
    [self creatBaseInformationViews];
    //头像
    [self loadImage];
    //详细信息
    [self creatDetileInformationViews];
    //职位变更
    UIButton *changRoldBut = [UIButton buttonWithType:0];
    [changRoldBut addTarget:self action:@selector(changRoleId) forControlEvents:UIControlEventTouchUpInside];
    [changRoldBut setFrame:CGRectMake((Screen_Width-270)/4, Screen_Height-110, 90, 40)];
    [changRoldBut setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [changRoldBut  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [changRoldBut setTitle:@"职位变更" forState:UIControlStateNormal];
    [self.view addSubview:changRoldBut];
    //转移部门
    UIButton *changUnitBtu = [UIButton buttonWithType:0];
    [changUnitBtu addTarget:self action:@selector(moveToOtherOrgunit) forControlEvents:UIControlEventTouchUpInside];
    [changUnitBtu setFrame:CGRectMake((Screen_Width-270)/4+102, Screen_Height-110, 90, 40)];
    [changUnitBtu setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [changUnitBtu  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [changUnitBtu setTitle:@"转移部门" forState:UIControlStateNormal];
    [self.view addSubview:changUnitBtu];
    //删除员工
    UIButton *deletBtu = [UIButton buttonWithType:0];
    [deletBtu addTarget:self action:@selector(deleteOrgunitUser) forControlEvents:UIControlEventTouchUpInside];
    [deletBtu setFrame:CGRectMake((Screen_Width-270)/2+192, Screen_Height-110, 90, 40)];
    [deletBtu setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [deletBtu  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [deletBtu setTitle:@"删除员工" forState:UIControlStateNormal];
    [self.view addSubview:deletBtu];
}

//连接图片
- (void)loadImage
{
    //获得头像信息
    NSString *imgUrl = self.memberIfo.photoUrl;
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
    UIView *baseInformaton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 130)];
    baseInformaton.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1];//RGB(176,196,222)
    [self.view addSubview:baseInformaton];
    
    UIButton *callPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [callPhone addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [callPhone setFrame:CGRectMake((Screen_Width-263)/2, 80, 120, 40)];
    [callPhone setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [callPhone  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [callPhone setTitle:@"电话" forState:UIControlStateNormal];
    [callPhone setTitle:@"拨打" forState:UIControlStateHighlighted];
    [baseInformaton addSubview:callPhone];
    
    UIButton *sendMail = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sendMail addTarget:self action:@selector(sendMailTo:) forControlEvents:UIControlEventTouchUpInside];
    [sendMail setFrame:CGRectMake((Screen_Width-263)/2+143, 80, 120, 40)];
    [sendMail setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [sendMail  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [sendMail setTitle:@"短信" forState:UIControlStateNormal];
    [sendMail setTitle:@"发送" forState:UIControlStateHighlighted];
    [baseInformaton addSubview:sendMail];
    
    
    [baseInformaton release];
    
    UIImageView * tempHeadImageView= [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    
    self.headImage = tempHeadImageView;
    UIImage *imgHead = [UIImage imageNamed:@"icon_avatar_user.png"];
    self.headImage.image = imgHead;
    [baseInformaton addSubview:self.headImage];
    [tempHeadImageView release];
    
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
    _name.text = self.memberIfo.realName;
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(271, 10, 25, 25)];
    img1.image = [UIImage imageNamed:@"info_edit.png"];
    [baseInformaton addSubview:img1];
    [img1 release];
    
    //可编辑号码
    UITextField * tempPhoneNumber    = [[UITextField alloc]initWithFrame:CGRectMake(140, 45, 130, 25)];
    tempPhoneNumber.backgroundColor = [UIColor clearColor];
    //MemberOrgModel *memberModel = [[MemberOrgModel alloc]init];
    //memberModel = [self.ifoArray objectAtIndex:0];
    tempPhoneNumber.text = self.memberIfo.telePhone;
    NSLog(@"showstaffinfomationVC memberModel = %@",self.memberIfo.realName );
    self.phoneNumber = tempPhoneNumber;
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(271, 45, 25, 25)];
    img2.image = [UIImage imageNamed:@"info_edit.png"];
    [baseInformaton addSubview:img2];
    [img2 release];
    [baseInformaton addSubview:self.phoneNumber];
    
    [tempPhoneNumber release];
    
}

#pragma mark -- 调用电话
- (void)callPhone{
    
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",self.memberIfo.telePhone];
    NSLog(@"调用电话：%@",phoneNumber);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    //[phoneNumber release];
}
#pragma mark -- 调用短信
- (void)sendMailTo:(NSString *)sender{
    NSString *phoneNumber = [NSString stringWithFormat:@"sms://%@",self.memberIfo.telePhone];
    NSLog(@"调用短信:%@",phoneNumber);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    //[phoneNumber release];
}

#pragma mark -- 职位变更
- (void)changRoleId{
    [self changAlertView];
}

- (void)changAlertView{
    switchAlerDelegate = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"职位变更" message:[NSString stringWithFormat:@"使%@成为主管？",self.memberIfo.realName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [alert show];
    [alert release];
}

#pragma mark - UIAlertView代理方法 (变更职位)
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            GetCommonDataModel;
            if (switchAlerDelegate == YES) {
                NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/updateOrgunitUser?organizationId=%ld&orgunitId=%ld&roleId=%@&username=%@&updateUser=%@&cookie=%@&operations=8",(long)comData.organization.organizationId,(long)comData.organization.orgunitId,@"2",self.memberIfo.username,comData.userModel.username,comData.cookie];
                NSLog(@"ReleaseAnnounceVC UrlStr %@",changeRoleUrlStr);
                NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
                NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
                [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
                //[self alerAction];
                NSLog(@"alerAction");
            }else{
                NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/deleteOrgunitUser?organizationId=%ld&orgunitId=%ld&username=%@&updateUser=%@&cookie=%@&operations=4",(long)comData.organization.organizationId,(long)comData.organization.orgunitId,self.memberIfo.username,comData.userModel.username,comData.cookie];
                NSLog(@"ReleaseAnnounceVC UrlStr %@",changeRoleUrlStr);
                NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
                NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
                [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
            }
            
            break;
        }case 1:{
            return;
        }
        default:
            break;
    }
}

#pragma mark -- 转移部门
- (void)moveToOtherOrgunit{
    
    NSLog(@"转移部门");
    UITableView  *orgunitTableView= [[[UITableView alloc]init]autorelease];
    orgunitTableView.delegate = self;
    orgunitTableView.dataSource = self;
    UIView *orgView = [[[UIView alloc]init]autorelease];
    [UIView animateWithDuration:0.5 animations:^{
        orgView.frame = CGRectMake(Screen_Width/4, Screen_Height/4-45, Screen_Width/2+5, 0);
        orgView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"list_bg.png"]stretchableImageWithLeftCapWidth:100 topCapHeight:100]];
        [self.view addSubview:orgView];
        orgView.frame = CGRectMake(Screen_Width/4, Screen_Height/4, Screen_Width/2, Screen_Height/2+5);
        orgunitTableView.frame = CGRectMake(25,46, orgView.frame.size.width-35, orgView.frame.size.height/2+8);
        
        [orgView addSubview:orgunitTableView];
    }];
}

#pragma mark - 表格视图代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orgNameArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    if (!myCell) {
        myCell = [[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:cellID]autorelease];
    }
    NSLog(@"[[orgNameArr objectAtIndex:indexPath.row]objectForKey:@ = %@",[[self.orgNameArr objectAtIndex:indexPath.row]objectForKey:@"name"]);
    myCell.textLabel.text = [[self.orgNameArr objectAtIndex:indexPath.row]objectForKey:@"name"];
    return myCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showSuccessWithStatus:@"更新…"];
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
        NSLog(@"selected == %d",indexPath.row);
        GetCommonDataModel;
        
        HBServerKit *hbKit = [[HBServerKit alloc]init];
        [hbKit changeMemberToOtherOrgWihtOrganizationId:comData.organization.organizationId andOrgunitId:self.memberIfo.orgunitId andTarOrgunitId:[[self.orgNameArr objectAtIndex:indexPath.row]objectForKey:@"orgunitId"] andUserName:self.memberIfo.username andUpdateUser:comData.userModel.username];
        [hbKit release];
        [SVProgressHUD showSuccessWithStatus:@"完成转移"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    
}



#pragma mark -- 删除员工
- (void)deleteOrgunitUser{
    //GetCommonDataModel;
    switchAlerDelegate = NO;
    //NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/deleteOrgunitUser?organizationId=%ld&orgunitId=%ld&username=%@&updateUser=%@&cookie=%@&operations=4",(long)comData.organization.organizationId,(long)comData.organization.orgunitId,self.memberIfo.username,comData.userModel.username,comData.cookie];
    //NSLog(@"ReleaseAnnounceVC UrlStr %@",changeRoleUrlStr);
    //NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
   // NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
    //[NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
    //UIAlertView *delectedAler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [delectedAler show];
//    [delectedAler release];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"删除员工%@？",self.memberIfo.realName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [alert show];
    [alert release];
    NSLog(@"alerAction");
}

//获得详细信息
- (void) creatDetileInformationViews
{
    //GetCommonDataModel;
    
    [self creatLablesOfDetialTitle:@"账号" andLabelFrame:CGRectMake(5, 131, 40, 25) andLinkFrame:CGRectMake(0, 0, 0, 0) andDetileInformation:self.memberIfo.username andInfoFrame:CGRectMake(55, 131, 260, 25)];
    
    [self creatLablesOfDetialTitle:@"部门" andLabelFrame:CGRectMake(5,166, 40, 25) andLinkFrame:CGRectMake(5, 162, 310, 2) andDetileInformation:self.unitName andInfoFrame:CGRectMake(55, 166, 260, 25)];
    
    NSString *roleIdStr = [NSString stringWithFormat:@"%@",self.memberIfo.roleId];
    NSString *roleStr = [[NSString alloc]init];
    if ([roleIdStr isEqualToString:@"1"]) {
        roleStr = @"创建者";
    }else if ([roleIdStr isEqualToString:@"2"] ){
        roleStr = @"部门主管";
    }else{
        roleStr = @"员工";
    }
    [self creatLablesOfDetialTitle:@"职位" andLabelFrame:CGRectMake(5, 196, 40, 25) andLinkFrame:CGRectMake(5, 194, 310, 2) andDetileInformation:roleStr andInfoFrame:CGRectMake(55, 196, 260, 25)];
    
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
    [_ifoArray release];
    [_memberIfo release];
    [_name release];
    [_phoneNumber release];
    [_headImage release];
    [_unitName release];
    [_orgNameArr release];
    [super dealloc];
}
@end