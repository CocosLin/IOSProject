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
    BOOL moveStaffToOtherOrg;
    //BOOL readerSwitchOn;//是否开启消息通知
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


static bool readerSwitchOn = NO;//是否开启消息通知
- (void)viewDidLoad
{
    [super viewDidLoad];
    //获得员工数据
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit findReportsWithOrganizationId:comData.organization.organizationId Refresh:NO GotArrReports:^(NSArray *arrDicReports, WError *myError) {
        self.orgNameArr = arrDicReports;
    }];
    NSLog(@"orgNameArr.count == %d",self.orgNameArr.count);

    
    //获得消息通知数据（开启、关闭）
    //接收消息开关,自己无法看到消息开关
    if (![comData.userModel.username isEqualToString:self.memberIfo.username]) {
        [hbKit reportReaderWithReader:comData.userModel.username GetReportNSDictionary:^(NSDictionary *readerDic) {
            NSLog(@"MenuVC readerDic  == %@ , userName == %@",[readerDic objectForKey:@"users"],self.memberIfo.username);
            NSRange rg = [[readerDic objectForKey:@"users"] rangeOfString:self.memberIfo.username];
            if (rg.location != NSNotFound ) {
                NSLog(@"readerSwitchOn = YES");
                readerSwitchOn = YES;
            }else{
                NSLog(@"readerSwitchOn = NO");
                readerSwitchOn = NO;
            }
            
            //是否为高级版移动汇报
            if ([comData.organization.appLevelCode isEqualToString:kAdvance]) {
                
                //创建者、部门人员能够进行汇报内容的接收
                if (comData.organization.roleId == 1|comData.organization.orgunitId == [self.memberIfo.orgunitId integerValue])
                    
                    //如果级别相同，无法接受汇报内容
                    if (comData.organization.roleId != [self.memberIfo.roleId integerValue]) {
                        [self creatReceiveSwitch];
                    }
            }
            
            
        }];
     
    }
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
   
    
    //创建基本信息栏
    [self creatBaseInformationViews];
    //头像
    [self loadImage];
    //详细信息
    [self creatDetileInformationViews];
    
    
    
    
    //职位变更
    UIButton *changRoldBut = [UIButton buttonWithType:0];
    [changRoldBut setFrame:CGRectMake((Screen_Width-270)/4, Screen_Height-110, 90, 40)];
    [changRoldBut setTitle:@"职位变更" forState:UIControlStateNormal];
    [self.view addSubview:changRoldBut];
    
    //转移部门
    UIButton *changUnitBtu = [UIButton buttonWithType:0];
    [changUnitBtu setFrame:CGRectMake((Screen_Width-270)/4+102, Screen_Height-110, 90, 40)];
    [changUnitBtu setTitle:@"转移部门" forState:UIControlStateNormal];
    [self.view addSubview:changUnitBtu];
    
    //删除员工
    UIButton *deletBtu = [UIButton buttonWithType:0];
    [deletBtu setFrame:CGRectMake((Screen_Width-270)/2+192, Screen_Height-110, 90, 40)];
    [deletBtu setTitle:@"删除员工" forState:UIControlStateNormal];
    [self.view addSubview:deletBtu];
    
    NSString *roleString = [[NSString alloc]init];
    if (comData.organization.roleId == 2) {
        roleString = @"部门主管";
    }else if (comData.organization.roleId == 4){
        roleString = @"普通员工";
    }
    
    //职位变更、转移部门、删除员工操作的权限 operation: 8  13  4
    NSLog(@"ShowStaffInomationVC comData.organization.operations == %@",comData.organization.operations);
    NSLog(@"comData = %d memberIfo = %d",comData.organization.roleId, [self.memberIfo.roleId integerValue]);
    if (comData.organization.roleId  >=[self.memberIfo.roleId intValue]||(comData.organization.roleId !=1 && comData.organization.orgunitId != [self.memberIfo.orgunitId intValue])||comData.userModel.username == self.memberIfo.username) {
        
        UITextView *alerLB = [[UITextView alloc]initWithFrame:CGRectMake(0, Screen_Height-170, Screen_Width, 60)];
        alerLB.textColor = [UIColor grayColor];
        alerLB.font = [UIFont systemFontOfSize:15];
        alerLB.editable = NO;
        alerLB.backgroundColor = [UIColor clearColor];
        
        
        if (comData.organization.orgunitId != [self.memberIfo.orgunitId intValue]){
            alerLB.text = [NSString stringWithFormat:@"您是%@\n但是不能对其他部门进行以下操作",roleString];
        }else if([comData.userModel.username isEqualToString:self.memberIfo.username]){
            alerLB.text = [NSString stringWithFormat:@"对不起\n不能对自己进行操作"];
        }else{
            alerLB.text = [NSString stringWithFormat:@"您是%@\n不能对其他主管和创建者进行以下操作",roleString];
        }
        alerLB.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:alerLB];
        
        
        
        deletBtu.backgroundColor = [UIColor lightGrayColor];
        changRoldBut.backgroundColor = [UIColor lightGrayColor];
        changUnitBtu.backgroundColor = [UIColor lightGrayColor];
    
        
    }else{//判断部门主管是否有权限
        
        NSRange deletoperation = [comData.organization.operations rangeOfString:@",4"];
        if (comData.organization.roleId !=1 &&deletoperation.location == NSNotFound) {
            deletBtu.backgroundColor = [UIColor lightGrayColor];
        }else{
            [deletBtu setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            [deletBtu  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
            [deletBtu addTarget:self action:@selector(deleteOrgunitUser) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSRange changUnitoperation = [comData.organization.operations rangeOfString:@"13"];
        if (comData.organization.roleId !=1 &&changUnitoperation.location == NSNotFound){
            changUnitBtu.backgroundColor = [UIColor lightGrayColor];
        }else{
            [changUnitBtu setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            [changUnitBtu  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
            [changUnitBtu addTarget:self action:@selector(moveToOtherOrgunit) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSRange changRoldoperation = [comData.organization.operations rangeOfString:@"8"];
        if (comData.organization.roleId !=1 &&changRoldoperation.location == NSNotFound){
            changRoldBut.backgroundColor = [UIColor lightGrayColor];
        }else{
            [changRoldBut setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            [changRoldBut  setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
            [changRoldBut addTarget:self action:@selector(changRoleId) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (deletoperation.location == NSNotFound | changRoldoperation.location == NSNotFound | changUnitoperation.location == NSNotFound) {
            UITextView *alerLB = [[UITextView alloc]initWithFrame:CGRectMake(0, Screen_Height-170, Screen_Width, 60)];
            alerLB.textColor = [UIColor grayColor];
            alerLB.font = [UIFont systemFontOfSize:15];
            alerLB.editable = NO;
            alerLB.backgroundColor = [UIColor clearColor];
            alerLB.textAlignment = NSTextAlignmentCenter;
            if (comData.organization.roleId != 1) alerLB.text = @"您是部门主管\n部分操作被禁用";
            [self.view addSubview:alerLB];
          
        }
        
    }
 
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
    
    
  
    
    UIImageView * tempHeadImageView= [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    
    self.headImage = tempHeadImageView;
    UIImage *imgHead = [UIImage imageNamed:@"icon_avatar_user.png"];
    self.headImage.image = imgHead;
    [baseInformaton addSubview:self.headImage];
 
    
    UILabel *nameLB1 = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, 60, 25)];
    nameLB1.textAlignment = NSTextAlignmentCenter;
    nameLB1.text = @"姓名:";
    nameLB1.backgroundColor = [UIColor clearColor];
    [baseInformaton addSubview:nameLB1];
  
    
    UILabel *nameLB2 = [[UILabel alloc]initWithFrame:CGRectMake(85, 45, 60, 25)];
    nameLB2.text = @"电话:";
    nameLB2.backgroundColor = [UIColor clearColor];
    nameLB2.textAlignment = NSTextAlignmentCenter;
    [baseInformaton addSubview:nameLB2];
  
    
    //可编辑名字
    _name = [[UITextField alloc]initWithFrame:CGRectMake(140, 10, 130, 25)];
    [baseInformaton addSubview:self.name];
    _name.backgroundColor = [UIColor clearColor];
    _name.text = self.memberIfo.realName;
    _name.enabled = NO;
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(271, 10, 25, 25)];
    img1.image = [UIImage imageNamed:@"info_edit.png"];
    [baseInformaton addSubview:img1];
   
    
    //可编辑号码
    UITextField * tempPhoneNumber    = [[UITextField alloc]initWithFrame:CGRectMake(140, 45, 130, 25)];
    tempPhoneNumber.backgroundColor = [UIColor clearColor];
    tempPhoneNumber.enabled = NO;
    tempPhoneNumber.text = self.memberIfo.telePhone;
    NSLog(@"showstaffinfomationVC memberModel = %@",self.memberIfo.realName );
    self.phoneNumber = tempPhoneNumber;
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(271, 45, 25, 25)];
    img2.image = [UIImage imageNamed:@"info_edit.png"];
    [baseInformaton addSubview:img2];
  
    [baseInformaton addSubview:self.phoneNumber];
    
   
    
    
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
    GetCommonDataModel;
    if (comData.organization.roleId  >=[self.memberIfo.roleId intValue] &&comData.organization.roleId!=1) {
        nil;
    }else{
        [self changAlertView];
    }
    
}

- (void)changAlertView{
    GetCommonDataModel;
    if (comData.organization.roleId  >=[self.memberIfo.roleId intValue] &&comData.organization.roleId!=1){
        nil;
    }else{
        switchAlerDelegate = YES;
        if ([self.memberIfo.roleId integerValue] == 2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"职位变更" message:[NSString stringWithFormat:@"使%@降职为员工？",self.memberIfo.realName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
            alert.tag = 2222;
            [alert show];
         
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"职位变更" message:[NSString stringWithFormat:@"使%@成为主管？",self.memberIfo.realName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
            [alert show];
         
        }
        
    }
    
}

#pragma mark - UIAlertView代理方法 (变更职位)
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            GetCommonDataModel;
            if (switchAlerDelegate == YES) {
                
                if (alertView.tag == 2222) {
                    NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/updateOrgunitUser?organizationId=%ld&orgunitId=%@&roleId=%@&username=%@&updateUser=%@&cookie=%@&operations=8",(long)comData.organization.organizationId,self.memberIfo.orgunitId,@"4",self.memberIfo.username,comData.userModel.username,comData.cookie];
                    NSLog(@"ReleaseAnnounceVC UrlStr %@",changeRoleUrlStr);
                    NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
                    NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
                    [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
                    [SVProgressHUD showSuccessWithStatus:@"成功修改权限"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    //[self alerAction];
                    NSLog(@"alerAction");
                }else{
                    NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/updateOrgunitUser?organizationId=%ld&orgunitId=%@&roleId=%@&username=%@&updateUser=%@&cookie=%@&operations=8",(long)comData.organization.organizationId,self.memberIfo.orgunitId,@"2",self.memberIfo.username,comData.userModel.username,comData.cookie];
                    NSLog(@"ReleaseAnnounceVC UrlStr %@",changeRoleUrlStr);
                    NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
                    NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
                    [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
                    [SVProgressHUD showSuccessWithStatus:@"成功修改权限"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    //[self alerAction];
                    NSLog(@"alerAction");
                }
                
            }else{
                if (comData.organization.roleId!=1 && comData.organization.orgunitId!=[self.memberIfo.orgunitId integerValue]) {
                    [SVProgressHUD showErrorWithStatus:@"您不能对非本部门的员工进行删除操作！" duration:0.8];
                    return;
                }
                NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/deleteOrgunitUser?organizationId=%ld&orgunitId=%@&username=%@&updateUser=%@&cookie=%@&operations=4",(long)comData.organization.organizationId,self.memberIfo.orgunitId,self.memberIfo.username,comData.userModel.username,comData.cookie];
                NSLog(@"ReleaseAnnounceVC UrlStr %@",changeRoleUrlStr);
                NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
                NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
                [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
                [SVProgressHUD showSuccessWithStatus:@"成功删除"];
                [self.navigationController popToRootViewControllerAnimated:YES];
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
    GetCommonDataModel;
    if (comData.organization.roleId  >=[self.memberIfo.roleId intValue] &&comData.organization.roleId!=1){
        nil;
    }else{
        NSLog(@"#pragma mark - TableViewdelegate");
        self.alert = [MLTableAlert tableAlertWithTitle:@"选择部门" cancelButtonTitle:@"取消" numberOfRows:^NSInteger(NSInteger section) {
            return  self.orgNameArr.count;
        } andCells:^UITableViewCell *(MLTableAlert *alert, NSIndexPath *indexPath) {
            NSLog(@"indexPath");
            static NSString *CellIdentifier = @"CellIdentifier";
            UITableViewCell *cell = [alert.table dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.text = [[self.orgNameArr objectAtIndex:indexPath.row]objectForKey:@"name"];
            return cell;
        }];
        
        self.alert.height = 250;
        // configure actions to perform
        [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            GetCommonDataModel;
            HBServerKit *hbKit = [[HBServerKit alloc]init];
            [hbKit changeMemberToOtherOrgWihtOrganizationId:comData.organization.organizationId andOrgunitId:self.memberIfo.orgunitId andTarOrgunitId:[[self.orgNameArr objectAtIndex:selectedIndex.row]objectForKey:@"orgunitId"] andUserName:self.memberIfo.username andUpdateUser:comData.userModel.username];
          
            [SVProgressHUD showSuccessWithStatus:@"完成转移"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } andCompletionBlock:^{
            NSLog(@"取消");
        }];
        
        // show the alert
        [self.alert show];
    }
    
}
#pragma mark -- 删除员工
- (void)deleteOrgunitUser{
    //GetCommonDataModel;
    GetCommonDataModel;
    if (comData.organization.roleId  >=[self.memberIfo.roleId intValue] &&comData.organization.roleId!=1){
        nil;
    }else{
        switchAlerDelegate = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"删除员工%@？",self.memberIfo.realName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        [alert show];
       
        NSLog(@"alerAction");
    }
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
 
    
    
}

#pragma mark -- 提交汇报通知
- (void) creatReceiveSwitch{
    UIView *link = [[UIView alloc]initWithFrame:CGRectMake(5, 221, 310, 2)];
    link.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1];
    [self.view addSubview:link];
   
    
    UILabel *userId = [[UILabel alloc]initWithFrame:CGRectMake(5, 223, 80, 25)];
    userId.backgroundColor = [UIColor clearColor];
    userId.text = @"提交汇报通知";
    userId.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:userId];
 
    
    UISwitch *noticSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(Screen_Width-90, 225, 60, 10)];
    [self.view addSubview:noticSwitch];
    noticSwitch.onTintColor = [UIColor greenColor];
    NSLog(@"readerSwitchOn == %c",readerSwitchOn);
    //noticSwitch.on = YES;
    noticSwitch.on = readerSwitchOn;
    [noticSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
   
}

- (void)switchAction:(UISwitch *)sender{
    BOOL onStaute = sender.on;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    if (onStaute) {
        NSLog(@"switch on");
        [hbKit saveReportReaderWithReader:comData.userModel.username andUsernae:self.memberIfo.username];
    }else{
        NSLog(@"switch off");
        [hbKit removeReportReaderWithReader:comData.userModel.username andUsernae:self.memberIfo.username];
    }
  
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
    
    //信息
    UILabel *ifoLB  = [[UILabel alloc]initWithFrame:infoFram];//CGRectMake(55, 81, 260, 25)
    ifoLB.text = info;
    ifoLB.backgroundColor = [UIColor clearColor];
    ifoLB.font = [UIFont systemFontOfSize:13];
    ifoLB.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:ifoLB];
    
    //线条
    UIView *link = [[UIView alloc]initWithFrame:lkFram];
    link.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1];
    [self.view addSubview:link];
  
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
