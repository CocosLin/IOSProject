//
//  MenuVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-25.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "MenuVC.h"
#import "WCommonMacroDefine.h"
#import "JASidePanelController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserManager.h"
#import "MyRecordVC.h"
#import "MobileReportVC.h"
#import "AboutVC.h"

#import "MyDocumentVC.h"
#import "RecordQeryVC.h"
#import "ManageStaffVC.h"
#import "ManageDepartmentVC.h"

#import "OrganizationNoticVC.h"
#import "HBServerKit.h"
#import "CommonDataModel.h"//存储用户数据的类
#import "ReportManager.h"//管理来自服务器数据的类
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "OrganizationsModel.h"//存放公司部门信息类
#import "ReleaseAnnounceVC.h"//发布公告
#import "ApplyViewController.h"
#import "ApplyModel.h"//申请者实体类
#import "WTool.h"
#import "UserLoggingInfo.h"
#import "CreaterUserManageDeparmentVC.h"
#import "UMSocial.h"
#import "UserManager.h"
#import "UserLoggingInfo.h"
//#import "UserPositionModel.h"

typedef NS_ENUM(NSInteger, TagFlag)
{
    TagFlag_BtnBaseNotice = 100,
    TagFlag_BtnOrganizationNotice = TagFlag_BtnBaseNotice + 1,
    TagFlag_BtnOrgunitNotice = TagFlag_BtnBaseNotice + 2,
    TagFlag_BtnMessageNotice = TagFlag_BtnBaseNotice + 3,
    TagFlag_BtnBaseLeftMenu = 200,
    TagFlag_BtnLeftMenuStaff = TagFlag_BtnBaseLeftMenu +1,
    TagFlag_BtnLeftMenuManager = TagFlag_BtnBaseLeftMenu + 2,
    TagFlag_BtnLeftMenuMoreOpera = TagFlag_BtnBaseLeftMenu + 3
};
@interface MenuVC ()
{
    UIImage * _imgUserPhoto;
    UIImageView * _imgViewUserPhoto;
    UILabel * _lblOrganizationInfoInNavigation;
    UILabel * _lblUserInfoInNavigation;
    NSString * _strUserRole;
    UIImageView * _imgViewLeftMenuFlag;
    NSInteger _currentSeletedMenuFlag;
    UITableView * _tableViewFunction;
}
@end

@implementation MenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -- 获取考勤配置
- (void)loadConfingSitting{
    GetCommonDataModel;
    GetGitomSingal;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit getAttendanceConfigWithOrganizationId:comData.organization.organizationId
                                       orgunitId:comData.organization.orgunitId
                                         Refresh:YES
                                   GotDicReports:^(AttendanceWorktimeModel *dicAttenConfig) {
                                       
                                       NSLog(@"向单例存放考勤设置");
                                       singal.latitude = dicAttenConfig.latitude;
                                       singal.longitude = dicAttenConfig.longitude;
                                       singal.offTime1 = dicAttenConfig.offTime1;
                                       singal.oneTime1 = dicAttenConfig.oneTime1;
                                       singal.offTime2 = dicAttenConfig.offTime2;
                                       singal.oneTime2 = dicAttenConfig.oneTime2;
                                       singal.offTime3 = dicAttenConfig.offTime3;
                                       singal.oneTime3 = dicAttenConfig.oneTime3;
                                       singal.inMinute = dicAttenConfig.inMinute;
                                       singal.outMinute = dicAttenConfig.outMinute;
                                       singal.distance = dicAttenConfig.distance;
                            
        
           }];
   
}

#pragma mark -- 刷新部分数据
- (void)refreshAction{
    //获得新的配置信息
    [self loadConfingSitting];
    [self refreshNews];
    GetCommonDataModel;
    
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit getNewsWithOrganizationId:comData.organization.organizationId
                           orgunitId:comData.organization.orgunitId newsType:@"orgunitNews"
                             Refresh:YES
                       GotArrReports:^(NSArray *arrDicReports, WError *myError) {
                           nil;
                       }];
  
    
    //重新获得登入信息
    NSLog(@"MenuVC userManager ifo == %@",comData.userlogingInfo);
    UserManager *um = [[UserManager alloc]init];
    [um loggingWithLoggingInfo:comData.userlogingInfo WbLoggedInfo:^(UserLoggedInfo *loggedInfo, BOOL isLoggedOk) {
        if (isLoggedOk) {
            GetCommonDataModel;
            //这边要得到用户信息。。。
            comData.cookie = loggedInfo.cookie;//将登入时候获得的cookie
            UserModel * user = [[UserModel alloc] initForAllJsonDataTypeWithDicFromJson:loggedInfo.user];//传入loggedInfo中的user字典，用过UserModel的initForAllJsonDataTypeWithDicFromJson:方法获得字典中的所有内容。
            comData.userModel = user;//使用单例的userModel属性获得user中转换好的用户信息：头像url、账号等等
            
            Organization * organizationInfo = [[Organization alloc]initForAllJsonDataTypeWithDicFromJson:[loggedInfo.organizations lastObject]];
            comData.organization = organizationInfo;//使用单例的获得解析到的用户信息            
         
            
            NSLog(@"MenuVC unitName == %@ hobby %@ %@ %@　%@ %@",comData.userModel.unitName,comData.userModel.hobby,comData.userModel.photo,comData.userModel.username,comData.userModel.telephone,comData.userModel.password);
        }
    }];
    
    self.userPhotoAddress = comData.userModel.photo;

}

- (void)refreshUserInfomations{
    UserLoggingInfo *userLogInfo = [[UserLoggingInfo alloc]init];
    
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit loggingWithUsername:userLogInfo.username Md5PasswordUp:userLogInfo.password VersionCode:@"999" GotJsonDic:^(NSDictionary *dicUserLogged, WError *myError) {
        nil;
    }];
}

- (void)refreshNews{
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit getNewsWithOrganizationId:comData.organization.organizationId
                           orgunitId:comData.organization.orgunitId
                            newsType:@"organizationNews"
                             Refresh:NO
                       GotArrReports:^(NSArray *arrDicReports, WError *myError) {
                           nil;
                       }];
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[(AppDelegate *)[UIApplication sharedApplication].delegate timer] invalidate];
    
    NSLog(@"登入主界面成功");
    for (int i =0; i<4; i++) {
        NSString *photoPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),[NSString stringWithFormat:@"myPhoto%d.jpg",3010+i]];
        NSData *photoData = [NSData dataWithContentsOfFile:photoPath];
        if (photoData) {
            NSLog(@"photo have %@",photoPath);
            NSFileManager *manger = [NSFileManager defaultManager];
            [manger removeItemAtPath:photoPath error:nil];
        }else{
            NSLog(@"photo nil %@",photoPath);
        }
        
    }
    [self loadConfingSitting];
    [self.view setBackgroundColor:Color_Background];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //用户信息视图
    [self initCustomUserInfoView];
    
    //用户公告栏
    [self initCustomNoticeBoard];
    
    //功能菜单
    [self iniCustomFunctionInfoWithRoleID:self.roleId];
    
    //单独获得用户的部门名称
    GetCommonDataModel;
    HBServerKit *hbServerKit = [[HBServerKit alloc]init];
    [hbServerKit findUserOrganizationId:comData.organization.organizationId UserName:comData.userModel.username GotArrReports:^(NSArray *arrDicReports, WError *myError)
     {
         if (arrDicReports.count) {
             NSLog(@"MenuVC 数组循环次数 ==  %d",arrDicReports.count);
             NSString *uniteName = [[NSString alloc]init];
             for (NSDictionary * dicReports in arrDicReports)
             {
                 NSLog(@"MenuVC 获得数据内容 == %@",dicReports);
                 uniteName = [dicReports objectForKey:@"name"];
             }
             comData.userModel.unitName = uniteName;
         }else
         {
             NSLog(@"error");
         }
     }];
    
    [hbServerKit getVerifyOfOrgunitWithOrganizationName:comData.organization.name getVerifyArr:^(NSArray *verifyArr) {
        comData.verifyMethodArr = verifyArr;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithRoleId:(RoleId)roleId
         UsernameID:(NSString *)strUsernameId
       UserRealname:(NSString *)userRealname
   OrganizationName:(NSString *)organizationName
{
    if (self= [super init])
    {
        self.roleId = roleId;
        _username = strUsernameId;
        if(userRealname) _userRealname = userRealname;
        _organizationName = organizationName;
    }
    return self;
}
-(id)initWithRoleId:(RoleId)roleId
          UserModel:(UserModel *)userModel
   OrganizationName:(NSString *)organizationName
{
    if (self= [super init])
    {
        self.roleId = roleId;
        self.username = userModel.username;
        if(userModel.realname) self.userRealname = userModel.realname;
        if (userModel.photo) self.userPhotoAddress = userModel.photo;//获得图片的地址
        self.organizationName = organizationName;
        _currentSeletedMenuFlag = 1;
    }
    return self;
}

-(void)initCustomUserInfoView
{
    UIView * viewUserInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 50)];
    [viewUserInfo setBackgroundColor:[UIColor whiteColor]];
    [viewUserInfo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"user_control_top2.png"]]];
    
    //头像imageView
    _imgViewUserPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    _imgViewUserPhoto.image = [UIImage imageNamed:@"user_control_user.png"];
    _imgViewUserPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [viewUserInfo addSubview:_imgViewUserPhoto];
    
    //公司信息
    _lblOrganizationInfoInNavigation = [[UILabel alloc]initWithFrame:CGRectMake(50, 2, Width_Screen - 160, 25)];
    [_lblOrganizationInfoInNavigation setFont:[UIFont systemFontOfSize:14]];
    [_lblOrganizationInfoInNavigation setBackgroundColor:[UIColor clearColor]];
    _lblOrganizationInfoInNavigation.text = self.organizationName;
    [viewUserInfo addSubview:_lblOrganizationInfoInNavigation];
    
    //用户信息
    _lblUserInfoInNavigation = [[UILabel alloc]initWithFrame:CGRectMake(50, 26, Width_Screen - 90, 25)];
    if (!self.userRealname) {
         _lblUserInfoInNavigation.text = [NSString stringWithFormat:@"(%@:%@)",_strUserRole,self.username];
    }else
    {
        _lblUserInfoInNavigation.text = [NSString stringWithFormat:@"%@(%@:%@)",self.userRealname,_strUserRole,self.username];
    }
    [_lblUserInfoInNavigation setBackgroundColor:[UIColor clearColor]];
    [_lblUserInfoInNavigation setFont:[UIFont systemFontOfSize:14]];
    [viewUserInfo addSubview:_lblUserInfoInNavigation];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(Width_Screen-110, 5, 40, 40);
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"icon_update_normal.png"] forState:UIControlStateNormal];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"icon_update_pressed.png"] forState:UIControlStateHighlighted];
    [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [viewUserInfo addSubview:refreshButton];
    [self.view addSubview:viewUserInfo];
}
//公告栏
-(void)initCustomNoticeBoard
{
    float wViewNoticeAll = 260.0f;
    UIView * viewNoticeALL=[[UIView alloc]initWithFrame:CGRectMake(0,50,Screen_Width,50)];
    //viewNoticeALL.backgroundColor=[UIColor clearColor];
    viewNoticeALL.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main_menu2.png"]];
    viewNoticeALL.layer.borderColor=[UIColor grayColor].CGColor;
    viewNoticeALL.layer.borderWidth=1.0f;
    [self.view addSubview:viewNoticeALL];
    
    NSArray * arrNoticeTitle = @[@"公司公告",@"部门公告",@"消息通知"];
    NSArray * arrNoticeImage=@[@"user_control_notice.png",@"user_control_notice.png",@"user_control_msg.png"];
    float wNoticeOne = wViewNoticeAll/arrNoticeTitle.count;
    for (int i = 0; i<arrNoticeTitle.count; i++)
    {
        //
        UIButton * btnNoticeOne = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNoticeOne.backgroundColor=[UIColor clearColor];
        [btnNoticeOne setBackgroundImage:[UIImage imageNamed:@"ex_list_group_default.png"] forState:UIControlStateHighlighted];
        btnNoticeOne.tag= TagFlag_BtnBaseNotice + i + 1;
        [btnNoticeOne setFrame:CGRectMake(0+i*wNoticeOne,5,wNoticeOne,50)];
        [viewNoticeALL addSubview:btnNoticeOne];
        [btnNoticeOne addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgViewNotice=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[arrNoticeImage objectAtIndex:i]]];
        imgViewNotice.backgroundColor=[UIColor clearColor];
        imgViewNotice.frame=CGRectMake(wNoticeOne/2-20/2,2,20,20);
        [btnNoticeOne addSubview:imgViewNotice];
   
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,22,wNoticeOne,24)];
        label.text=[arrNoticeTitle objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor clearColor];
        [btnNoticeOne addSubview:label];
  
    }
}
//功能栏
-(void)iniCustomFunctionInfoWithRoleID:(RoleId)roleId
{
    [self initCustomFunctionInfoForLeftMenuWithRoleID:roleId];
    [self initRightMenuListTableView];
}
-(void)initRightMenuListTableView
{
    //具体功能菜单,用列表来显示
    _tableViewFunction = [[UITableView alloc]initWithFrame:CGRectMake(60, 100, Screen_Width-60, Screen_Height -100)];
    [_tableViewFunction setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main_menu2.png"]]];
    [_tableViewFunction setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableViewFunction.dataSource = self;
    _tableViewFunction.delegate = self;
    [self.view addSubview:_tableViewFunction];
}
#pragma marK - 初始化左边菜单栏
-(void)initCustomFunctionInfoForLeftMenuWithRoleID:(RoleId)roleId
{
    float hSelfView = self.view.bounds.size.height;//屏幕的高
    float hLeftMenuAll = hSelfView - 50 -50;
    NSArray * arrBtnLeftMenuNames =nil;//= @[@"员\n工\n功\n能",@"管\n理\n功\n能",@"更\n多\n操\n作"];
    
    UIView * viewLeftMenuAll = [[UIView alloc]initWithFrame:CGRectMake(0, hSelfView-hLeftMenuAll, 60, hLeftMenuAll)];
    [self.view addSubview:viewLeftMenuAll];
    
    int intCountMenu = 0;
    if (roleId== RoleId_Common) {
        intCountMenu = 2;
        arrBtnLeftMenuNames = @[@"员\n工\n功\n能",@"更\n多\n操\n作"];
    }
    else if (roleId== RoleId_Administrator || roleId == RoleId_Creator)
    {
        intCountMenu = 3;
        arrBtnLeftMenuNames = @[@"员\n工\n功\n能",@"管\n理\n功\n能",@"更\n多\n操\n作"];
    }
    float hLeftMenuOne = hLeftMenuAll/intCountMenu;
    for (int i = 0; i<intCountMenu; i++)
    {
        UIButton * btnLeftMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLeftMenu setFrame:CGRectMake(0, 0 + i*hLeftMenuOne, viewLeftMenuAll.frame.size.width -3, hLeftMenuOne)];
        [viewLeftMenuAll addSubview:btnLeftMenu];
        [btnLeftMenu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnLeftMenu setBackgroundColor:[UIColor clearColor]];
        [btnLeftMenu setTitle:arrBtnLeftMenuNames[i] forState:UIControlStateNormal];
        btnLeftMenu.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        btnLeftMenu.titleLabel.textAlignment=NSTextAlignmentCenter;
        btnLeftMenu.titleLabel.lineBreakMode = 1;
        btnLeftMenu.titleLabel.highlightedTextColor = [UIColor blackColor];
        if (intCountMenu==3) {
            btnLeftMenu.tag = TagFlag_BtnBaseLeftMenu + i + 1;
        }else
        {
            if (i!=0)
                btnLeftMenu.tag = TagFlag_BtnLeftMenuMoreOpera;
        }
        if (i==0)
        {
            btnLeftMenu.tag = TagFlag_BtnLeftMenuStaff;
            btnLeftMenu.titleLabel.highlighted = YES;
        }
        [btnLeftMenu addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //画线
    UIView * viewLeftMenuLine = [[UIView alloc]initWithFrame:CGRectMake(viewLeftMenuAll.frame.size.width -3, 0, 3, hLeftMenuAll)];
    [viewLeftMenuLine setBackgroundColor:[UIColor colorWithRed:153/255.0 green:159/255.0 blue:175/255.0 alpha:1]];
    [viewLeftMenuAll addSubview:viewLeftMenuLine];
   
    
    _imgViewLeftMenuFlag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_main_menu_left"]];
    _imgViewLeftMenuFlag.frame=CGRectMake(viewLeftMenuAll.frame.size.width-15,0,15,hLeftMenuOne);
    [viewLeftMenuAll addSubview:_imgViewLeftMenuFlag];
    
   
}
#pragma mark --表格代理方法--
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arrFuncNames= nil;//
    if (_currentSeletedMenuFlag == 1) {
        arrFuncNames = @[@"移动汇报",@"我的记录",@"我的资料"];
    }else if(_currentSeletedMenuFlag == 2)
    {
        GetCommonDataModel;
        NSRange option3Rang = [comData.organization.operations rangeOfString:@"3"];
        NSLog(@"MenuVC option3Rang == %@",comData.organization.operations);
        if (comData.organization.roleId !=1 && option3Rang.location == NSNotFound) {//是否有发布公告的权限
            NSLog(@"无发布公告的权限");
            if (self.roleId == RoleId_Administrator) {
                NSLog(@"RoleId_Administrator");
                arrFuncNames = @[@"记录查询",@"加入申请",@"管理员工",@"管理部门"];
            }else
            {
                NSLog(@"creater role");
                arrFuncNames = @[@"记录查询",@"加入申请",@"管理员工",@"管理部门",@"管理公司"];
            }
        }else{
            NSLog(@"有发布公告的权限");
            if (self.roleId == RoleId_Administrator) {
                NSLog(@"RoleId_Administrator");
                arrFuncNames = @[@"记录查询",@"加入申请",@"管理员工",@"管理部门",@"公告发布"];
            }else
            {
                NSLog(@"creater role");
                arrFuncNames = @[@"记录查询",@"加入申请",@"管理员工",@"管理部门",@"公告发布",@"管理公司"];
            }
        }
        
    }else if(_currentSeletedMenuFlag == 3)
    {
        arrFuncNames = @[@"分享应用",@"关于",@"注销"];
    }
    
    
    static NSString * cellID = @"cellForRightMenu";
    NSLog(@"------%@",arrFuncNames[indexPath.row]);
    //UITableViewCell * cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"      %@",arrFuncNames[indexPath.row]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.lineBreakMode = 1;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
    cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentSeletedMenuFlag == 1) {
        return 3;
    }else if(_currentSeletedMenuFlag == 2)
    {
        GetCommonDataModel;
        NSRange option3Rang = [comData.organization.operations rangeOfString:@"3"];
        if (comData.organization.roleId !=1 && option3Rang.location == NSNotFound) {//是否有发布公告的权限
            NSLog(@"无发布公告的权限");
            if (self.roleId == RoleId_Administrator) {
                return 4;
                NSLog(@"RoleId_Administrator");
            }else
            {
                return 5;
                NSLog(@"creater role");
            }
        }else{
            NSLog(@"有发布公告的权限");
            if (self.roleId == RoleId_Administrator) {
                return 5;
            }else
            {
                return 6;
            }
        }
        
    }else if(_currentSeletedMenuFlag == 3)
    {
        return 3;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark -- 移动汇报、我的资料、员工记录查询、加入申请、发布公告
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetCommonDataModel;
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    if (_currentSeletedMenuFlag == 1)
    {
        //@[@"移动汇报",@"我的记录",@"我的资料"];
        if (indexPath.row ==0)//@"移动汇报"
        {
            NSLog(@"移动汇报");
            MobileReportVC * mrVc = [[MobileReportVC alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mrVc];
    
            self.sidePanelController.centerPanel=nav;
   
        }else if(indexPath.row ==1){
            NSLog(@"我的记录");
            MyRecordVC *employee=[[MyRecordVC alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:employee];
            self.sidePanelController.centerPanel=nav;
       
      
        }else if(indexPath.row ==2){
            NSLog(@"我的资料");
//            [SVProgressHUD showWithStatus:@"加载数据…"];
//            [SVProgressHUD dismissWithIsOk:YES String:@"获取数据成功!"];
            MyDocumentVC *myDoc = [[MyDocumentVC alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myDoc];
            myDoc.imgdata = _imgUserPhoto;
            self.sidePanelController.centerPanel = nav;
         
        }
    }else
        if (_currentSeletedMenuFlag == 2)
        {
            /*
             arrFuncNames = @[@"员工记录查询",@"公告发布",@"加入申请",@"管理员工",@"管理部门"];
             arrFuncNames = @[@"员工记录查询",@"公告发布",@"加入申请",@"管理员工",@"管理部门",@"管理公司"];
             */
            
            if (indexPath.row==0) //纪录查询
            {
                [hbKit findReportsWithOrganizationId:comData.organization.organizationId Refresh:NO GotArrReports:^(NSArray *arrDicReports, WError *myError)
                 {
                     if (arrDicReports.count) {
                         NSLog(@"ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                         NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                         for (NSDictionary * dicReports in arrDicReports)
                         {
                             OrganizationsModel *orgIfo = [[OrganizationsModel alloc]init];
                             orgIfo.orgunitName = [dicReports objectForKey:@"name"];
                             orgIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                             orgIfo.organizationId = [dicReports objectForKey:@"organizationId"];
                             [mArrReports addObject:orgIfo];
                        
                         }
                         NSLog(@"获取汇报记录成功! %@",mArrReports);
                         RecordQeryVC *recordview = [[RecordQeryVC alloc]init];
                         recordview.title = @"记录查询";
                         recordview.orgArray = mArrReports;
                         UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:recordview];
                         self.sidePanelController.centerPanel =nav;
                        }else
                     {
                         //[SVProgressHUD dismissWithIsOk:NO String:@"无汇报记录"];
                     }
                 }];
                
            }else if (indexPath.row==1) //加入申请
            {
                NSLog(@"加入申请");
                NSRange option3Rang = [comData.organization.operations rangeOfString:@"1"];
                if (comData.organization.roleId !=1 && option3Rang.location == NSNotFound) {
                    
                    [SVProgressHUD showErrorWithStatus:@"您无该权限"];;
                    return;
                    
                }
                
                [SVProgressHUD showWithStatus:@"加载数据…"];
                int orgunitId;
                if (comData.organization.roleId == 1) {
                    orgunitId = 0;
                }else{
                    orgunitId = comData.organization.orgunitId;
                }
                
                [hbKit findApplyWithOrganizationId:comData.organization.organizationId
                                         orgunitId:orgunitId
                                     GotArrReports:^(NSArray *arrDicReports, WError *myError)
                 {
                         NSLog(@"ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                         NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                         for (NSDictionary * dicReports in arrDicReports)
                         {
                             NSLog(@"加入申请  444ReportManager 获得数据内容 == %@",dicReports);
                             NSLog(@"加入申请 444name == %@",[dicReports objectForKey:@"realname"]);
                             //ReportModel * reModel = [[ReportModel alloc]initForAllJsonDataTypeWithDicFromJson:dicReports];
                             ApplyModel *applyIfo = [[ApplyModel alloc]init];
                             applyIfo.realname = [dicReports objectForKey:@"realname"];
                             applyIfo.updateDate = [dicReports objectForKey:@"updateDate"];
                             applyIfo.createUserId = [dicReports objectForKey:@"createUserId"];
                             applyIfo.orgunitName = [dicReports objectForKey:@"orgunitName"];
                             applyIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                             applyIfo.note = [dicReports objectForKey:@"note"];
                             [mArrReports addObject:applyIfo];
                         }
                         NSLog(@"获取汇报记录成功! %@",mArrReports);
                         [SVProgressHUD dismissWithIsOk:YES String:@"获取数据成功!"];
                         
                         ApplyViewController *apply = [[ApplyViewController alloc]init];
                         apply.title = @"审核申请";
                         apply.arrData = mArrReports;
                         UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:apply];
                         self.sidePanelController.centerPanel = nav;
                    }];
            }
            else if (indexPath.row==2) //管理员工
            {
                NSLog(@"%@",@"管理员工");
                [hbKit findReportsWithOrganizationId:comData.organization.organizationId Refresh:NO  GotArrReports:^(NSArray *arrDicReports, WError *myError)
                 {
                     if (arrDicReports.count) {
                         NSLog(@"ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                         NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                         for (NSDictionary * dicReports in arrDicReports)
                         {
                             NSLog(@"管理员工  444ReportManager 获得数据内容 == %@",dicReports);
                             
                             NSLog(@"管理员工 444name == %@",[dicReports objectForKey:@"name"]);
                             //ReportModel * reModel = [[ReportModel alloc]initForAllJsonDataTypeWithDicFromJson:dicReports];
                             OrganizationsModel *orgIfo = [[OrganizationsModel alloc]init];
                             orgIfo.organizationName = [dicReports objectForKey:@"name"];
                             orgIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                             //orgIfo.organization.organizationId = [
                             [mArrReports addObject:orgIfo];
                             //                 [reModel release];
                         }
                         //                         callback(mArrReports,YES);
                         NSLog(@"获取汇报记录成功! %@",mArrReports);
                         //[SVProgressHUD dismissWithIsOk:YES String:@"获取数据成功!"];
                         ManageStaffVC *staffmanagement = [[ManageStaffVC alloc]init];
                         staffmanagement.title = @"管理员工";
                         staffmanagement.orgArray = mArrReports;
                         UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:staffmanagement];
                         self.sidePanelController.centerPanel = nav;
           
           
                     }else
                     {
                         [SVProgressHUD dismissWithIsOk:NO String:@"无数据内容"];
                     }
                 }];
            }
            else if (indexPath.row==3) //管理部门
            {
                if (comData.organization.roleId == 1) {//创建者可以管理多个部门
                    
                    [hbKit findReportsWithOrganizationId:comData.organization.organizationId Refresh:NO  GotArrReports:^(NSArray *arrDicReports, WError *myError)
                     {
                         if (arrDicReports.count) {
                             NSLog(@"MenuVC ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                             NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                             NSString *allOrgNames = [[NSString alloc]init];
                             for (NSDictionary * dicReports in arrDicReports)
                             {
                                 NSLog(@"MenuVC dicReports == %@",dicReports);
                                 OrganizationsModel *orgIfo = [[OrganizationsModel alloc]init];
                                 orgIfo.orgunitName = [dicReports objectForKey:@"name"];
                                 orgIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                                 allOrgNames = [allOrgNames stringByAppendingFormat:@",%@",[dicReports objectForKey:@"name"]];
                                 [mArrReports addObject:orgIfo];
                            }
                             NSLog(@"获取汇报记录成功! %@",mArrReports);
                             CreaterUserManageDeparmentVC *vc = [[CreaterUserManageDeparmentVC alloc]init];
                             vc.orgArray =  mArrReports;
                             vc.allOrgUnitNames = allOrgNames;
                             NSLog(@"MenuVC allorgnames = %@",vc.allOrgUnitNames);
                             UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                             self.sidePanelController.centerPanel = nav;
                        
                         }else
                         {
                             [SVProgressHUD dismissWithIsOk:NO String:@"无数据内容"];
                         }
                     }];
                    
                }else{
                    NSLog(@"管理部门");
                    OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
                    orgMod.orgunitName = comData.organization.name;
                    orgMod.orgunitId = [NSString stringWithFormat:@"%ld",(long)comData.organization.orgunitId];
                    
                    ManageDepartmentVC *manageDepartment = [[ManageDepartmentVC alloc]init];
                    manageDepartment.orgMod = orgMod;
                    NSLog(@"manageDepartment.orgMod.orgunitName = comData.userModel.unitName = %@ - %@   %@",comData.organization.name,manageDepartment.orgMod.orgunitName,manageDepartment.orgMod.orgunitId);
                    manageDepartment.title = @"管理部门";
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:manageDepartment];
                    self.sidePanelController.centerPanel = nav;


                }
                
            }
            else if (indexPath.row==4) //公告发布
                //http://hb.m.gitom.com/3.0/organization/saveNews?organizationId=114&orgunitId=1&title=ddddd&content=dddddd&username=90261&newsType=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
            {
                NSLog(@"公告发布");
                //ReleaseAnnounceVC *releaseAnnounce = [[ReleaseAnnounceVC alloc]init];
                ReleaseAnnounceVC *announcement=[[ReleaseAnnounceVC alloc]init];
                announcement.title = @"公告";
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:announcement];
                self.sidePanelController.centerPanel = nav;
            }
            else if (indexPath.row==5) //管理公司
                //http://hb.m.gitom.com/3.0/organization/updateOrganization?organizationId=204&updateUser=58200&name=WTO&cookie=5533098A-43F1-4AFC-8641-E64875461345
            {
                NSLog(@"管理公司");
                UIAlertView *changeOrgNameAler = [[UIAlertView alloc]initWithTitle:@"修改公司名称" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消",nil];
                changeOrgNameAler.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField *nameText = [changeOrgNameAler textFieldAtIndex:0];
                nameText.placeholder = @"请输入更改的名称";
                [changeOrgNameAler show];
              
            }
            
        }else
            if (_currentSeletedMenuFlag == 3)
            {
                if (indexPath.row==0)//分享应用
                {
                    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
                    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
                    [UMSocialData defaultData].extConfig.title = @"朋友圈分享内容";
                    [UMSocialSnsService presentSnsController:self
                                                         appKey:@"507fcab25270157b37000010"
                                                      shareText:@"正在使用网即通移动版http://app.gitom.com/mobileapp/list/12"
                                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToWechatSession,UMShareToQzone,UMShareToWechatTimeline,UMShareToEmail,UMShareToQQ,UMShareToSms,UMShareToTwitter,UMShareToFacebook, nil]
                                                       delegate:nil];
                    
                }else if (indexPath.row==1)//关于
                {
                    AboutVC * avc = [[AboutVC alloc]init];
                    UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:avc];
                   self.sidePanelController.centerPanel=nc;
                

                } else if (indexPath.row == 2)//@"注销"
                {
                    GetCommonDataModel;
                    comData.isLogged = NO;
                    [self dismissViewControllerAnimated:YES completion:^{}];
                }
            }
 
}

#pragma mark - UIAlertView代理方法
- (void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GetCommonDataModel;
    //得到输入框
    UITextField *tf=[alertView textFieldAtIndex:0];
    NSString * orgNameString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)tf.text, NULL, NULL,  kCFStringEncodingUTF8 ));
    //[NSString stringWithCString:[tf.text UTF8String]encoding:NSUnicodeStringEncoding];
    switch (buttonIndex) {
        case 0:
        {
            if (tf.text.length > 0) {
                
                HBServerKit *hbKit = [[HBServerKit alloc]init];
                
                if ([hbKit isNumbers:tf.text]) {
                    
                    [SVProgressHUD showErrorWithStatus:@"名称不能含数字！" duration:0.8];
                    
                }else if ([tf.text rangeOfString:@"网即通"].location != NSNotFound){
                    
                    [SVProgressHUD showErrorWithStatus:@"命名不能含网即通字样！" duration:0.8];
                    
                }else{
                    
                    NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/updateOrganization?organizationId=%ld&updateUser=%@&name=%@&cookie=%@",(long)comData.organization.organizationId,comData.userModel.username,orgNameString,comData.cookie];
                    NSLog(@"ManageDepartmentVC url = %@ ||ManageDepartmentVC UrlStr %@",changeRoleUrlStr,tf.text);
                    self.organizationName = tf.text;
                    NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
                    NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
                    [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
                    
                }
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"名称不能设置为空!"];
            }
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark -- 公司\部门公告
//用户事件
-(void)btnAction:(UIButton *)btn
{
    GetCommonDataModel;
    switch (btn.tag)
    {
        case TagFlag_BtnOrganizationNotice://公司公告
        {
            NSLog(@"公司公告");
            HBServerKit *hbKit = [[HBServerKit alloc]init];
            [hbKit getNewsWithOrganizationId:comData.organization.organizationId
                                   orgunitId:comData.organization.orgunitId
                                    newsType:@"organizationNews"
                                     Refresh:YES
                               GotArrReports:^(NSArray *arrDicReports, WError *myError) {
                if (arrDicReports.count) {
                    NSLog(@"获得公告内容数量 == %d",arrDicReports.count);
                    NSDictionary *dicNew = [arrDicReports objectAtIndex:0];
                    OrganizationNoticVC *notVc = [[OrganizationNoticVC alloc]init];
                    notVc.querMessage = NO;
                    notVc.content = [dicNew objectForKey:@"content"];
                    notVc.creatDate = [WTool getStrDateTimeWithDateTimeMS:[[dicNew objectForKey:@"createDate"] longLongValue] DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
                    notVc.textTitle = [dicNew objectForKey:@"title"];
                    notVc.userId = [dicNew objectForKey:@"createUserId"];
                    notVc.realName = [dicNew objectForKey:@"realname"];
                    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:notVc];
                    self.sidePanelController.centerPanel = nv;
           
           
                }else{
                    [SVProgressHUD showErrorWithStatus:@"暂无公告"];
                }
            }];
        
            
            break;
        }
        case TagFlag_BtnOrgunitNotice://部门公告
        {
            NSLog(@"部门公告");
            //[SVProgressHUD showWithStatus:@"加载…"];
            HBServerKit *hbKit = [[HBServerKit alloc]init];
            [hbKit getNewsWithOrganizationId:comData.organization.organizationId
                                   orgunitId:comData.organization.orgunitId newsType:@"orgunitNews"
                                     Refresh:YES
                               GotArrReports:^(NSArray *arrDicReports, WError *myError) {
                if (arrDicReports.count) {
                    NSLog(@"获得公告内容数量 == %d",arrDicReports.count);
                    NSDictionary *dicNew = [arrDicReports objectAtIndex:0];
                    NSLog(@"获得公告内容 == %@",dicNew);
                    OrganizationNoticVC *notVc = [[OrganizationNoticVC alloc]init];
                    notVc.querMessage = NO;
                    notVc.content = [dicNew objectForKey:@"content"];
                    notVc.creatDate = [WTool getStrDateTimeWithDateTimeMS:[[dicNew objectForKey:@"createDate"] longLongValue] DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"];
                    notVc.textTitle = [dicNew objectForKey:@"title"];
                    notVc.userId = [dicNew objectForKey:@"username"];
                    NSLog(@"获得公告内容 userid == %@ %@",notVc.userId,[dicNew objectForKey:@"username"]);
                    notVc.realName = [dicNew objectForKey:@"realname"];
                    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:notVc];
                    self.sidePanelController.centerPanel = nv;


                }else{
                    [SVProgressHUD showErrorWithStatus:@"无部门公告"];
                }
            }];
          
            
            break;
        }
        case TagFlag_BtnMessageNotice://消息通知
        {
            if (![comData.organization.appLevelCode isEqualToString:kAdvance]) {
                [SVProgressHUD showErrorWithStatus:@"您所使用的是标准版，没有该功能" duration:3];
                return;
            }
            NSLog(@"消息通知");
            OrganizationNoticVC *organizationNotic = [[OrganizationNoticVC alloc]init];
            organizationNotic.querMessage = YES;
            organizationNotic.title= @"消息通知";
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:organizationNotic];
            self.sidePanelController.centerPanel = nav;
       
       
            break;
        }
        case TagFlag_BtnLeftMenuStaff://员工功能
        {
            [self setNoAllLeftMenuHighlighted];//设置不高亮
            btn.titleLabel.highlighted = YES;
            [self setImageViewLeftMenuFlagToFlag:btn.tag];//设置滚动图标志
            _currentSeletedMenuFlag = 1;
            [_tableViewFunction reloadData];
            break;
        }
        case TagFlag_BtnLeftMenuManager://管理功能
        {
            [self setNoAllLeftMenuHighlighted];
            btn.titleLabel.highlighted = YES;
            [self setImageViewLeftMenuFlagToFlag:btn.tag];
            _currentSeletedMenuFlag = 2;
            [_tableViewFunction reloadData];
            break;
        }
        case TagFlag_BtnLeftMenuMoreOpera://更多操作
        {
            [self setNoAllLeftMenuHighlighted];
            btn.titleLabel.highlighted = YES;
            [self setImageViewLeftMenuFlagToFlag:btn.tag];
            _currentSeletedMenuFlag = 3;
            [_tableViewFunction reloadData];
            break;
        }
        default:
            break;
    }
}



//改变标志图片的位置
-(void)setImageViewLeftMenuFlagToFlag:(NSInteger)btnTag
{
    [UIView beginAnimations:@"ani" context:nil];
    [UIView setAnimationDuration:0.3];
    if (btnTag == TagFlag_BtnLeftMenuMoreOpera) {
        CGRect frameImgViewLeftMenuFlag = _imgViewLeftMenuFlag.frame ;
        int countHeight = 0;
        if (self.roleId == RoleId_Common)
        {
            countHeight = 1;
        }else
        {
            countHeight = 2;
        }
        _imgViewLeftMenuFlag.frame = CGRectMake(frameImgViewLeftMenuFlag.origin.x, frameImgViewLeftMenuFlag.size.height * countHeight, frameImgViewLeftMenuFlag.size.width, frameImgViewLeftMenuFlag.size.height);
    }else if(btnTag == TagFlag_BtnLeftMenuManager)
    {
        CGRect frameImgViewLeftMenuFlag = _imgViewLeftMenuFlag.frame ;
        _imgViewLeftMenuFlag.frame = CGRectMake(frameImgViewLeftMenuFlag.origin.x, frameImgViewLeftMenuFlag.size.height, frameImgViewLeftMenuFlag.size.width, frameImgViewLeftMenuFlag.size.height);
    }else if(btnTag == TagFlag_BtnLeftMenuStaff)
    {
        CGRect frameImgViewLeftMenuFlag = _imgViewLeftMenuFlag.frame ;
        _imgViewLeftMenuFlag.frame = CGRectMake(frameImgViewLeftMenuFlag.origin.x, 0, frameImgViewLeftMenuFlag.size.width, frameImgViewLeftMenuFlag.size.height);
    }
    [UIView commitAnimations];
}

//让左功能栏的字体不高亮
-(void)setNoAllLeftMenuHighlighted
{
    UIButton * btn = ( UIButton * )[self.view viewWithTag:TagFlag_BtnLeftMenuManager];
    btn.titleLabel.highlighted = NO;
    btn =( UIButton * )[self.view viewWithTag:TagFlag_BtnLeftMenuStaff];
    btn.titleLabel.highlighted = NO;
    btn =( UIButton * )[self.view viewWithTag:TagFlag_BtnLeftMenuMoreOpera];
    btn.titleLabel.highlighted = NO;
}
#pragma mark --属性控制--
-(void)setUserPhotoAddress:(NSString *)userPhotoAddress
{
    //只要设置了图片地址，就去下载图片
    UserManager * um = [UserManager sharedUserManager];
    if (userPhotoAddress != nil) {
        [um getUserPhotoImageWithStrUserPhotoUrl:userPhotoAddress GotResult:^(UIImage *imgUserPhoto, BOOL isOK)
         {
             if (isOK)
             {
                 _imgUserPhoto = imgUserPhoto;
                 _imgViewUserPhoto.image = _imgUserPhoto;
             }
         }];
    }
    
    if (_userPhotoAddress == userPhotoAddress)
    {
        return;
    }
  
    _userPhotoAddress = [userPhotoAddress copy];
    
}

-(void)setOrganizationName:(NSString *)organizationName
{
    //设置了公司名，就显示在用户信息上面
    _lblOrganizationInfoInNavigation.text = organizationName;
    if (_organizationName == organizationName) {
        return;
    }
   
    _organizationName = [organizationName copy];
}
-(void)setRoleId:(RoleId)roleId
{
    //设置了权限，就把用户权限保存
    _roleId = roleId;
    if (roleId == RoleId_Common){
        _strUserRole = @"普通用户";
    }else if(roleId == RoleId_Administrator){
        _strUserRole = @"管理员";
    }else if(roleId == RoleId_Creator) {
        _strUserRole = @"创建者";
    }
}
-(void)setUsername:(NSString *)username
{
    //设置了用户账号，就显示用户信息
    if (!_userRealname) {
        _lblUserInfoInNavigation.text = [NSString stringWithFormat:@"%@:%@",_strUserRole,username];
    }else
    {
        _lblUserInfoInNavigation.text = [NSString stringWithFormat:@"%@(%@:%@)",username,_strUserRole,_userRealname];
    }
    if (username == _username) return;
 
    _username = [username copy];
}
-(void)setUserRealname:(NSString *)userRealname
{
    //设置了用户真实名字，就显示用户信息
    if (!_userRealname) {
        _lblUserInfoInNavigation.text = [NSString stringWithFormat:@"%@:%@",_strUserRole,_username];
    }else
    {
        _lblUserInfoInNavigation.text = [NSString stringWithFormat:@"%@(%@:%@)",_username,_strUserRole,_userRealname];
    }
    if (_userRealname == userRealname) return;
  
    _userRealname = [userRealname copy];
}

@end

