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
#import <ShareSDK/ShareSDK.h>

#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "OrganizationsModel.h"//存放公司部门信息类
#import "ReleaseAnnounceVC.h"//发布公告

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:Color_Background];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //用户信息视图
    [self initCustomUserInfoView];
    
    //用户公告栏
    [self initCustomNoticeBoard];
    
    //功能菜单
    [self iniCustomFunctionInfoWithRoleID:self.roleId];
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
    UIView * viewUserInfo = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, 50)] autorelease];
    [viewUserInfo setBackgroundColor:[UIColor whiteColor]];
    
    //头像imageView
    _imgViewUserPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    _imgViewUserPhoto.image = [UIImage imageNamed:@"user_control_user.png"];
    [viewUserInfo addSubview:_imgViewUserPhoto];
    
    //公司信息
    _lblOrganizationInfoInNavigation = [[UILabel alloc]initWithFrame:CGRectMake(50, 2, Width_Screen - 50 -40, 25)];
    [_lblOrganizationInfoInNavigation setFont:[UIFont systemFontOfSize:14]];
    [_lblOrganizationInfoInNavigation setBackgroundColor:[UIColor clearColor]];
    _lblOrganizationInfoInNavigation.text = self.organizationName;
    [viewUserInfo addSubview:_lblOrganizationInfoInNavigation];
    
    //用户信息
    _lblUserInfoInNavigation = [[UILabel alloc]initWithFrame:CGRectMake(50, 26, Width_Screen - 50-40, 25)];
    if (!self.userRealname) {
         _lblUserInfoInNavigation.text = [NSString stringWithFormat:@"(%@:%@)",_strUserRole,self.username];
    }else
    {
        _lblUserInfoInNavigation.text = [NSString stringWithFormat:@"%@(%@:%@)",self.userRealname,_strUserRole,self.username];
    }
    [_lblUserInfoInNavigation setBackgroundColor:[UIColor clearColor]];
    [_lblUserInfoInNavigation setFont:[UIFont systemFontOfSize:14]];
    [viewUserInfo addSubview:_lblUserInfoInNavigation];
    
    [self.view addSubview:viewUserInfo];
}
//公告栏
-(void)initCustomNoticeBoard
{
    float wViewNoticeAll = 260.0f;
    UIView * viewNoticeALL=[[[UIView alloc]initWithFrame:CGRectMake(0,50,wViewNoticeAll,50)] autorelease];
    viewNoticeALL.backgroundColor=[UIColor clearColor];
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
        btnNoticeOne.tag= TagFlag_BtnBaseNotice + i + 1;
        [btnNoticeOne setFrame:CGRectMake(0+i*wNoticeOne,0,wNoticeOne,50)];
        [viewNoticeALL addSubview:btnNoticeOne];
        [btnNoticeOne addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgViewNotice=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[arrNoticeImage objectAtIndex:i]]];
        imgViewNotice.backgroundColor=[UIColor clearColor];
        imgViewNotice.frame=CGRectMake(wNoticeOne/2-20/2,2,20,20);
        [btnNoticeOne addSubview:imgViewNotice];
        [imgViewNotice release];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,25,wNoticeOne,24)];
        label.text=[arrNoticeTitle objectAtIndex:i];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor clearColor];
        [btnNoticeOne addSubview:label];
        [label release];
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
    _tableViewFunction = [[UITableView alloc]initWithFrame:CGRectMake(60, 100, Width_Screen-60-50, Height_Screen -100)];
    [_tableViewFunction setBackgroundColor:[UIColor whiteColor]];
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
    [viewLeftMenuLine release];
    
    _imgViewLeftMenuFlag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_main_menu_left"]];
    _imgViewLeftMenuFlag.frame=CGRectMake(viewLeftMenuAll.frame.size.width-15,0,15,hLeftMenuOne);
    [viewLeftMenuAll addSubview:_imgViewLeftMenuFlag];
    
    [viewLeftMenuAll release];
}
#pragma mark --表格代理方法--
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arrFuncNames= nil;//
    if (_currentSeletedMenuFlag == 1) {
        arrFuncNames = @[@"移动汇报",@"我的记录",@"我的资料"];
    }else if(_currentSeletedMenuFlag == 2)
    {
        if (self.roleId == RoleId_Administrator) {
            arrFuncNames = @[@"员工记录查询",@"公告发布",@"加入申请",@"管理员工",@"管理部门"];
        }else
        {
            arrFuncNames = @[@"员工记录查询",@"公告发布",@"加入申请",@"管理员工",@"管理部门",@"管理公司"];
        }
    }else if(_currentSeletedMenuFlag == 3)
    {
        arrFuncNames = @[@"分享应用",@"关于",@"注销"];
    }
    
    
    static NSString * cellID = @"cellForRightMenu";
    NSLog(@"breakOne");
    //UITableViewCell * cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID]autorelease];
    }
    cell.textLabel.text = arrFuncNames[indexPath.row];
    cell.textLabel.lineBreakMode = 1;
    cell.textLabel.font = [UIFont systemFontOfSize:22];
    //        cell.textLabel.numberOfLines = 10;
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor blackColor];
    //        cell.textLabel.highlightedTextColor = [UIColor blackColor];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentSeletedMenuFlag == 1) {
        return 3;
    }else if(_currentSeletedMenuFlag == 2)
    {
        if (self.roleId == RoleId_Administrator) {
            return 5;
        }else
        {
            return 6;
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
    if (_currentSeletedMenuFlag == 1)
    {
        //@[@"移动汇报",@"我的记录",@"我的资料"];
        if (indexPath.row ==0)//@"移动汇报"
        {
            NSLog(@"移动汇报");
            MobileReportVC * mrVc = [[MobileReportVC alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mrVc];
            [mrVc release];
            self.sidePanelController.centerPanel=nav;
            [nav release];
        }else if(indexPath.row ==1){
            NSLog(@"汇报记录查询");
            MyRecordVC *employee=[[MyRecordVC alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:employee];
            self.sidePanelController.centerPanel=nav;
            [employee release];
            [nav release];
        }else if(indexPath.row ==2){
            NSLog(@"我的资料");
            [SVProgressHUD showWithStatus:@"加载数据…"];
            HBServerKit *hbServerKit = [[HBServerKit alloc]init];
            [hbServerKit findUserOrganizationId:comData.organization.organizationId UserName:comData.userModel.username GotArrReports:^(NSArray *arrDicReports, WError *myError)
            {
                if (arrDicReports.count) {
                    NSLog(@"ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                    NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                    NSString *uniteName = [[[NSString alloc]init]autorelease];
                    for (NSDictionary * dicReports in arrDicReports)
                    {
                        NSLog(@"我的资料 获得数据内容 == %@",dicReports);
                        
                        NSLog(@"我的资料 name == %@",[dicReports objectForKey:@"name"]);
                        uniteName = [dicReports objectForKey:@"name"];
                    }
                    NSLog(@"获取我的资料成功! %@",mArrReports);
                    [SVProgressHUD dismissWithIsOk:YES String:@"获取数据成功!"];
                    
                    MyDocumentVC *myDoc = [[MyDocumentVC alloc]init];
                    myDoc.unitName = uniteName;
                    
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myDoc];
                    self.sidePanelController.centerPanel = nav;
                    [myDoc release];
                    [nav release];
                }else
                {
                    [SVProgressHUD dismissWithIsOk:NO String:@"无汇报记录"];
                }
            }];
            
        }
    }else
        if (_currentSeletedMenuFlag == 2)
        {
            /*
             arrFuncNames = @[@"员工记录查询",@"公告发布",@"加入申请",@"管理员工",@"管理部门"];
             arrFuncNames = @[@"员工记录查询",@"公告发布",@"加入申请",@"管理员工",@"管理部门",@"管理公司"];
             */
            
            if (indexPath.row==0) //员工纪录查询
            {//http://hb.m.gitom.com/3.0/organization/rootOrgunits?organizationId=114&voidFlag=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
                [SVProgressHUD showWithStatus:@"加载数据…"];
                HBServerKit *hbKit = [[HBServerKit alloc]init];
                [hbKit findReportsWithOrganizationId:comData.organization.organizationId GotArrReports:^(NSArray *arrDicReports, WError *myError)
                 {
                     if (arrDicReports.count) {
                         NSLog(@"ReportManager 数组循环次数 ==  %d",arrDicReports.count);
                         NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
                         for (NSDictionary * dicReports in arrDicReports)
                         {
                             NSLog(@"444ReportManager 获得数据内容 == %@",dicReports);
                             
                             NSLog(@"444name == %@",[dicReports objectForKey:@"name"]);
                             OrganizationsModel *orgIfo = [[OrganizationsModel alloc]init];
                             orgIfo.organizationName = [dicReports objectForKey:@"name"];
                             orgIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                             orgIfo.organizationId = [dicReports objectForKey:@"organizationId"];
                             [mArrReports addObject:orgIfo];
                         }
                         NSLog(@"获取汇报记录成功! %@",mArrReports);
                         [SVProgressHUD dismissWithIsOk:YES String:@"获取数据成功!"];
                         RecordQeryVC *recordview = [[RecordQeryVC alloc]init];
                         recordview.title = @"记录查询";
                         recordview.orgArray = mArrReports;
                         UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:recordview];
                         self.sidePanelController.centerPanel =nav;
                         [recordview release];
                         [nav release];
                     }else
                     {
                         [SVProgressHUD dismissWithIsOk:NO String:@"无汇报记录"];
                     }
                 }];
                //NSLog(@"MenuVC OrganizationsModel == %@ ",mArrReports);
                
            }else if (indexPath.row==1) //公告发布
                //http://hb.m.gitom.com/3.0/organization/saveNews?organizationId=114&orgunitId=1&title=ddddd&content=dddddd&username=90261&newsType=1&cookie=5533098A-43F1-4AFC-8641-E64875461345
            {
                //ReleaseAnnounceVC *releaseAnnounce = [[ReleaseAnnounceVC alloc]init];
                ReleaseAnnounceVC *announcement=[[ReleaseAnnounceVC alloc]init];
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:announcement];
                self.sidePanelController.centerPanel = nav;
                [announcement release];
                [nav release];
            }else if (indexPath.row==2) //加入申请
            {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeCustomView;
//                hud.labelText = @"请您期待下一个版本";
//                hud.margin = 20.0f;
//                hud.yOffset = -50.0f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:1];
            }
            else if (indexPath.row==3) //管理员工
            {
                NSLog(@"%@",@"管理员工");
                [SVProgressHUD showWithStatus:@"加载数据…"];
                HBServerKit *hbKit = [[HBServerKit alloc]init];
                [hbKit findReportsWithOrganizationId:114 GotArrReports:^(NSArray *arrDicReports, WError *myError)
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
                         [SVProgressHUD dismissWithIsOk:YES String:@"获取数据成功!"];
                         ManageStaffVC *staffmanagement = [[ManageStaffVC alloc]init];
                         staffmanagement.title = @"管理员工";
                         staffmanagement.orgArray = mArrReports;
                         UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:staffmanagement];
                         self.sidePanelController.centerPanel = nav;
                         [staffmanagement release];
                         [nav release];
                     }else
                     {
                         [SVProgressHUD dismissWithIsOk:NO String:@"无数据内容"];
                     }
                 }];
                
                
            }
            else if (indexPath.row==4) //管理部门
            {
                NSLog(@"%@",@"管理部门");
                ManageDepartmentVC *manageDepartment = [[ManageDepartmentVC alloc]init];
                manageDepartment.title = @"管理部门";
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:manageDepartment];
                self.sidePanelController.centerPanel = nav;
                [manageDepartment release];
                [nav release];
            }
            else if (indexPath.row==5) //公司资料
            {

            }
            
        }else
            if (_currentSeletedMenuFlag == 3)
            {
                if (indexPath.row==0)//分享应用
                {
                    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
                    //构造分享内容
                    id<ISSContent> publishContent=[ShareSDK content:@"我在使用网即通-移动汇报http://app.gitom.com/mobileapp/list/10"
                                                     defaultContent:@"网即通"
                                                              image:[ShareSDK imageWithPath:imagePath]
                                                              title:@"移动汇报"
                                                                url:@"http://app.gitom.com"
                                                        description:@"移动汇报标准版提供公告、移动考勤、日常汇报、出差汇报、外出汇报、汇报点评、汇报记录、记录导出、员工管理等功能，移动汇报支持文字、图片、语音等多形式汇报方式，操作简洁方便，可谓是有图有真相，是移动互联网时代一款不可多得的企业管理助手。"
                                                          mediaType:SSPublishContentMediaTypeNews];
                    [ShareSDK showShareActionSheet:nil
                                         shareList:nil
                                           content:publishContent
                                     statusBarTips:YES
                                      authOptions :nil
                                      shareOptions:nil
                                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo,id<ICMErrorInfo>error,BOOL end)
                     {
                         if (state == SSPublishContentStateSuccess)
                         {
                             NSLog(@"分享成功");
                         }
                         else if (state == SSPublishContentStateFail)
                         {
                             NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],[error errorDescription]);
                         }
                     }];
                    
                }else if (indexPath.row==1)//关于
                {
                    AboutVC * avc = [[AboutVC alloc]init];
                    UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:avc];
                   self.sidePanelController.centerPanel=nc;
                    [avc release];
                    [nc release];


                } else if (indexPath.row == 2)//@"注销"
                {
                    GetCommonDataModel;
                    comData.isLogged = NO;
                    [self dismissViewControllerAnimated:YES completion:^{}];
                }
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
            __block OrganizationNoticVC *organizationNotic = [[OrganizationNoticVC alloc]init];
            
            NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/organizationNews?organizationId=%ld&orgunitId=%ld&first=0&max=1&cookie=%@",(long)comData.organization.organizationId,(long)comData.organization.orgunitId,comData.cookie];
            NSLog(@"urlstr == %@",urlStr);
            NSURL *url = [[NSURL alloc]initWithString:urlStr];
            __block ASIHTTPRequest *asiReq = [ASIHTTPRequest requestWithURL:url];
            [asiReq setCompletionBlock:^{
                NSData *getDta = [asiReq responseData];
                NSError *error = nil;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:getDta options:NSJSONReadingAllowFragments error:&error];
                NSDictionary *bodyDic = [jsonDic objectForKey:@"body"];
                NSString *dataDic = [bodyDic objectForKey:@"data"];
                NSLog(@"%@",bodyDic);
                NSLog(@"%@",dataDic);
                NSString *cutStr1 = [dataDic stringByReplacingOccurrencesOfString:@"," withString:@":"];
                NSArray *cutAr = [cutStr1 componentsSeparatedByString:@":"];
                //NSDictionary *contentDic = [dataDic objectAtIndex:0];
                NSLog(@"%@",cutAr);
                NSLog(@"%@",[cutAr objectAtIndex:1]);
                organizationNotic.content = [cutAr objectAtIndex:1];
                NSLog(@"title == %@",[cutAr objectAtIndex:15]);
                organizationNotic.textTitle = [cutAr objectAtIndex:15];
                NSLog(@"realname == %@",[cutAr objectAtIndex:13]);
                organizationNotic.realName = [cutAr objectAtIndex:13];
                NSLog(@"userid == %@",[cutAr objectAtIndex:19]);
                organizationNotic.userId = [cutAr objectAtIndex:19];
                
            }];
            [asiReq startAsynchronous];
            
            organizationNotic.title= @"公司公告";
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:organizationNotic];
            self.sidePanelController.centerPanel = nav;
            [organizationNotic release];
            [nav release];
            break;
        }
        case TagFlag_BtnOrgunitNotice://部门公告
        {
            NSLog(@"部门公告");
            __block OrganizationNoticVC *organizationNotic = [[OrganizationNoticVC alloc]init];
            NSString *urlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/orgunitNews?organizationId=%ld&orgunitId=%ld&first=0&max=1&cookie=%@",(long)comData.organization.organizationId,(long)comData.organization.orgunitId,comData.cookie];
            NSLog(@"urlstr == %@",urlStr);
            NSURL *url = [[NSURL alloc]initWithString:urlStr];
            __block ASIHTTPRequest *asiReq = [ASIHTTPRequest requestWithURL:url];
            [asiReq setCompletionBlock:^{
                NSData *getDta = [asiReq responseData];
                NSError *error = nil;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:getDta options:NSJSONReadingAllowFragments error:&error];
                NSDictionary *bodyDic = [jsonDic objectForKey:@"body"];
                NSString *dataDic = [bodyDic objectForKey:@"data"];

                NSLog(@"%@",bodyDic);
                NSLog(@"%@",dataDic);
                NSString *cutStr1 = [dataDic stringByReplacingOccurrencesOfString:@"," withString:@":"];
                NSArray *cutAr = [cutStr1 componentsSeparatedByString:@":"];
                NSLog(@"%@",cutAr);
                NSLog(@"%@",[cutAr objectAtIndex:1]);
                organizationNotic.content = [cutAr objectAtIndex:1];
                NSLog(@"title == %@",[cutAr objectAtIndex:15]);
                organizationNotic.textTitle = [cutAr objectAtIndex:15];
                NSLog(@"realname == %@",[cutAr objectAtIndex:13]);
                organizationNotic.realName = [cutAr objectAtIndex:13];
                NSLog(@"userid == %@",[cutAr objectAtIndex:19]);
                organizationNotic.userId = [cutAr objectAtIndex:19];
                
            }];
            [asiReq startAsynchronous];
            
            
            organizationNotic.title= @"部门公告";
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:organizationNotic];
            self.sidePanelController.centerPanel = nav;
            [organizationNotic release];
            [nav release];

            break;
        }
        case TagFlag_BtnMessageNotice://消息通知
        {
//            MBProgressHUD *hud = [MBProgressHUD alloc]ini
            NSLog(@"消息通知");
            OrganizationNoticVC *organizationNotic = [[OrganizationNoticVC alloc]init];
            organizationNotic.title= @"消息通知";
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:organizationNotic];
            self.sidePanelController.centerPanel = nav;
            [organizationNotic release];
            [nav release];
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
    [_userPhotoAddress release];
    _userPhotoAddress = [userPhotoAddress copy];
    
}

-(void)setOrganizationName:(NSString *)organizationName
{
    //设置了公司名，就显示在用户信息上面
    _lblOrganizationInfoInNavigation.text = organizationName;
    if (_organizationName == organizationName) {
        return;
    }
    [_organizationName release];
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
    [_username release];
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
    [_userRealname release];
    _userRealname = [userRealname copy];
}

@end

