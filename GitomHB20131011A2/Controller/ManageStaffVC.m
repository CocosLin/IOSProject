//
//  ManageStaffVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-10.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ManageStaffVC.h"
#import "ManageStaffCell.h"
#import "OrganizationsModel.h"//部门信息类
#import "MemberOrgModel.h"//部门员工信息类
#import "HBServerKit.h"//post获得服务器json数据
#import "ManageStaffDetialVC.h"
#import "SVProgressHUD.h"


@interface ManageStaffVC ()

@end

@implementation ManageStaffVC{
    NSMutableDictionary *d;
}

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
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"刷新" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 50, 44);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    [btn1  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    self.manageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-66)];
    self.manageTableView.delegate = self;
    self.manageTableView.dataSource = self;
    [self.manageTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.manageTableView];
    
    OrganizationsModel *orgModel = [[OrganizationsModel alloc]init];
    orgModel = [self.orgArray objectAtIndex:0];
    NSLog(@"[self.orgArray objectAtIndex:0]%@  %@",[[self.orgArray objectAtIndex:0] organizationName],orgModel.organizationName);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 刷新
- (void)refreshAction{
    NSLog(@"refreshAction - 刷新");
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    [hbKit findReportsWithOrganizationId:comData.organization.organizationId Refresh:YES GotArrReports:^(NSArray *arrDicReports, WError *myError) {
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
            self.orgArray = mArrReports;
            [self.manageTableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"无部门"];
        }
    }];
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self orgArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[self.orgArray objectAtIndex:indexPath.row] organizationName];
        cell.imageView.image = [UIImage imageNamed:@"btn_list_extra_arrow.png"];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
        cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
        return cell;
    }else{
        static NSString *CellIdentifier = @"ManageStaffCell";
        ManageStaffCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ManageStaffCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.orgName.text = [[self.orgArray objectAtIndex:indexPath.row] organizationName];
        cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]]autorelease];
        cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]]autorelease];
        return cell;
    }
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[SVProgressHUD showWithStatus:@"加载部门数据…"];
    
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    GetCommonDataModel;
    OrganizationsModel *organization = [[OrganizationsModel alloc]init];
    organization = [self.orgArray objectAtIndex:indexPath.row];
    NSString *orgIdStr = organization.orgunitId;
    NSInteger intS = [orgIdStr intValue];
    [hbKit findOrgunitMembersWithOrganizationId:comData.organization.organizationId
                                      orgunitId:intS
                                        Refresh:NO
                                  GotArrReports:^(NSArray *arrDicReports, WError *myError)
     {
         if (arrDicReports.count) {
             NSLog(@"RecordQeryVC 数组循环次数 ==  %d",arrDicReports.count);
             NSMutableArray * mArrReports = [NSMutableArray arrayWithCapacity:arrDicReports.count];
             for (NSDictionary * dicReports in arrDicReports)
             {
                 NSLog(@"RecordQeryVC ReportManager 获得数据内容 == %@",dicReports);
                 
                 NSLog(@"RecordQeryVC  realname == %@",[dicReports objectForKey:@"realname"]);
                 NSLog(@"RecordQeryVC  roleId == %@",[dicReports objectForKey:@"roleId"]);
                 MemberOrgModel *memberIfo = [[MemberOrgModel alloc]init];
                 memberIfo.realName = [dicReports objectForKey:@"realname"];
                 memberIfo.username = [dicReports objectForKey:@"username"];
                 memberIfo.roleId = [dicReports objectForKey:@"roleId"];
                 memberIfo.photoUrl = [dicReports objectForKey:@"photo"];
                 memberIfo.telePhone = [dicReports objectForKey:@"telephone"];
                 memberIfo.orgunitId = [dicReports objectForKey:@"orgunitId"];
                 [mArrReports addObject:memberIfo];
                 [memberIfo release];
             }
             NSLog(@"RecordQeryVC 获取部门成员信息成功! %@",mArrReports);
             ManageStaffDetialVC *detailViewController = [[ManageStaffDetialVC alloc] initWithNibName:nil bundle:nil];
             detailViewController.orgArray = mArrReports;
             detailViewController.unitName = [[self.orgArray objectAtIndex:indexPath.row] organizationName];
             detailViewController.orgNumber = intS;
             //[SVProgressHUD dismissWithIsOk:YES String:@"加载成功"];
             
             [self.navigationController pushViewController:detailViewController animated:YES];
             [detailViewController release];
         }else
         {
             //[SVProgressHUD dismissWithIsOk:NO String:@"无人员数据"];
         }
     }];
}




#pragma mark -- 仿造QQ好友列表
//- (void)viewDidLoad {
//    [super viewDidLoad];
//	
////	//创建demo数据
////    self.orgArray = [[NSMutableArray alloc]initWithCapacity : 2];
////	
////	NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity : 2];
////	[dict setObject:@"好友" forKey:@"groupname"];
////	
////	//利用数组来填充数据
////	NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity : 2];
////	[arr addObject: @"关羽"];
////	[arr addObject: @"张飞"];
////	[arr addObject: @"孔明"];
////	[dict setObject:arr forKey:@"users"];
////	[arr release];
////	[self.orgArray addObject: dict];
////	[dict release];
////	
////	
////	dict = [[NSMutableDictionary alloc]initWithCapacity : 2];
////	[dict setObject:@"对手" forKey:@"groupname"];
////	
////	arr = [[NSMutableArray alloc] initWithCapacity : 2];
////	[arr addObject: @"曹操"];
////	[arr addObject: @"司马懿"];
////	[arr addObject: @"张辽"];
////	[dict setObject:arr forKey:@"users"];
////	[arr release];
////	[self.orgArray addObject: dict];
////	[dict release];
////	
//	
//	
//	//创建一个tableView视图
//	//创建UITableView 并指定代理
////	CGRect frame = [UIScreen mainScreen].applicationFrame;
////	frame.origin.y = 0;
////	self.manageTableView = [[UITableView alloc]initWithFrame: frame style:UITableViewStylePlain];
//    self.manageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-66) style:UITableViewStylePlain];
//	[self.manageTableView setDelegate: self];
//	[self.manageTableView setDataSource: self];
//	[self.view addSubview: self.manageTableView];
//	[self.manageTableView release];
//	NSLog(@"manageController %d",[self.orgArray count]);
//	[self.manageTableView reloadData];
//}
//
//
//
///*
// // Override to allow orientations other than the default portrait orientation.
// - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
// // Return YES for supported orientations
// return (interfaceOrientation == UIInterfaceOrientationPortrait);
// }
// */
//
//- (void)didReceiveMemoryWarning {
//	// Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//	
//	// Release any cached data, images, etc that aren't in use.
//}
//
//- (void)viewDidUnload {
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}
//
//
//- (void)dealloc {
//	[self.orgArray release];
//    [super dealloc];
//}
//
//
//
//#pragma mark -
//#pragma mark Table view data source
//
//
//#pragma mark -- 对指定的节进行“展开/折叠”操作
//-(void)collapseOrExpand:(int)section{
//	Boolean expanded = NO;
//	//Boolean searched = NO;
//	d = [[NSMutableDictionary alloc]initWithCapacity:2];
//    
//    [d setValue:0 forKey:@"expanded"];
//	NSLog(@"对指定的节进行“展开/折叠”操作 == d = %@",d );
//	//若本节model中的“expanded”属性不为空，则取出来
//	if([d objectForKey:@"expanded"]!=nil){
//		expanded=[[d objectForKey:@"expanded"]intValue];
//        NSLog(@"%@ , expanded == %c",d,expanded);}
//	//若原来是折叠的则展开，若原来是展开的则折叠
//	[d setObject:[NSNumber numberWithBool:!expanded] forKey:@"expanded"];
//    
//}
//
//
////返回指定节的“expanded”值
//#pragma mark -- 返回指定节的“expanded”值
//-(Boolean)isExpanded:(int)section{
//	Boolean expanded = NO;
//	//NSMutableDictionary* d=[self.orgArray objectAtIndex:section];
//    d = [[NSMutableDictionary alloc]initWithCapacity:2];
//    NSLog(@"返回指定节的“expanded”值 == %@",d);
//	//若本节model中的“expanded”属性不为空，则取出来
//	if([d objectForKey:@"expanded"]!=nil)
//		expanded=[[d objectForKey:@"expanded"]intValue];
//	
//	return expanded;
//}
//
//
//
//#pragma mark -- 按钮被点击时触发
//-(void)expandButtonClicked:(id)sender{
//	
//	UIButton* btn= (UIButton*)sender;
//	int section= btn.tag; //取得tag知道点击对应哪个块
//	
//	//	NSLog(@"click %d", section);
//	[self collapseOrExpand:section];
//	
//	//刷新tableview
//	[self.manageTableView reloadData];
//	
//}
//
//
//
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    
//    return [self.orgArray count];
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//	
//	
//	//对指定节进行“展开”判断
//	if (![self isExpanded:section]) {
//		
//		//若本节是“折叠”的，其行数返回为0
//		return 0;
//	}
//	
//	NSDictionary* d=[self.orgArray objectAtIndex:section];
//	return [[d objectForKey:@"users"] count];
//	
//}
//
//
//// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    
//	NSDictionary* m= (NSDictionary*)[self.orgArray objectAtIndex: indexPath.section];
//	NSArray *d = (NSArray*)[m objectForKey:@"users"];
//    
//	if (d == nil) {
//		return cell;
//	}
//	
//	//显示联系人名称
//    
//	cell.textLabel.text = [d objectAtIndex: indexPath.row];
//    
//	cell.textLabel.backgroundColor = [UIColor clearColor];
//	
//	//UIColor *newColor = [[UIColor alloc] initWithRed:(float) green:(float) blue:(float) alpha:(float)];
//	cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_listbg.png"]];
//	cell.imageView.image = [UIImage imageNamed:@"mod_user.png"];
//    
//	
//	//选中行时灰色
//	cell.selectionStyle = UITableViewCellSelectionStyleGray;
//	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
//    
//    return cell;
//}
//
//
//
//// 设置header的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//	return 40;
//}
//
//
//#pragma mark -- 定制单元格表头
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
//{
//	
//    
//	UIView *hView;
//	if (UIInterfaceOrientationLandscapeRight == [[UIDevice currentDevice] orientation] ||
//        UIInterfaceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation])
//	{
//		hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 40)];
//	}
//	else
//	{
//		hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//        //self.tableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 320.f, 44.f);
//	}
//    //UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//    
//	UIButton* eButton = [[UIButton alloc] init];
//    
//	//按钮填充整个视图
//	eButton.frame = hView.frame;
//	[eButton addTarget:self action:@selector(expandButtonClicked:)
//      forControlEvents:UIControlEventTouchUpInside];
//	eButton.tag = section;//把节号保存到按钮tag，以便传递到expandButtonClicked方法
//    
//	//根据是否展开，切换按钮显示图片
//	if ([self isExpanded:section])
//		[eButton setImage: [ UIImage imageNamed: @"btnDownList.png" ] forState:UIControlStateNormal];
//	else
//		[eButton setImage: [ UIImage imageNamed: @"btn_list_extra_arrow.png" ] forState:UIControlStateNormal];
//    
//    
//	//由于按钮的标题，
//	//4个参数是上边界，左边界，下边界，右边界。
//	eButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//	[eButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
//	[eButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
//    
//    
//	//设置按钮显示颜色
//	eButton.backgroundColor = [UIColor lightGrayColor];
//    [eButton setTitle:[[self.orgArray objectAtIndex:section]organizationName] forState:UIControlStateNormal];
//	//[eButton setTitle:[[self.orgArray objectAtIndex:section] objectForKey:@"groupname"] forState:UIControlStateNormal];
//	[eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//	
//	[eButton setBackgroundImage: [ UIImage imageNamed: @"btn_listbg.png" ] forState:UIControlStateNormal];//btn_line.png"
//	//[eButton setTitleShadowColor:[UIColor colorWithWhite:0.1 alpha:1] forState:UIControlStateNormal];
//	//[eButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
//    
//	[hView addSubview: eButton];
//    
//	[eButton release];
//	return hView;
//    
//}

@end
