//
//  MyRecordVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-6-26.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "MyRecordVC.h"
#import "WCommonMacroDefine.h"
#import "RecordListVC.h"




@interface MyRecordVC ()
{
    NSArray *  _arrMenuRecordNames;
    NSArray * _arrMenuImageNames;
    CGFloat _hTbMenu;
    UITableView * _tbMenu;
}

@end

@implementation MyRecordVC
#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.myVcTitle = @"我的记录";
        self.title = @"我的记录";
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor colorWithRed:200 green:200 blue:200 alpha:1],[UIFont boldSystemFontOfSize:20.0f],[UIColor colorWithWhite:0.0 alpha:1], nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor, nil]];
        self.navigationController.navigationBar.titleTextAttributes = dict;
        [self initData];
        _hTbMenu = 160;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_block.png"]]];
    [self initData];
    //加入视图
    [self initTbMenuWithFrame:CGRectMake(10, 10, Width_Screen - 20, _hTbMenu)];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - 部分视图初始化
-(void)initTbMenuWithFrame:(CGRect)frame
{
    _tbMenu = [[UITableView alloc]initWithFrame:frame];
    [self.view addSubview:_tbMenu];
    [_tbMenu.layer setBorderWidth:0.7];
    [_tbMenu.layer setCornerRadius:7];
    [_tbMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tbMenu.scrollEnabled = NO;
    _tbMenu.delegate = self;
    _tbMenu.dataSource = self;
    [_tbMenu setBackgroundColor:[UIColor whiteColor]];
//    [tbMenu release];
}
#pragma mark - tableview相关代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * myCellID =@"MyCellID";
    NSLog(@"MyRecord breakOne");
    //UITableViewCell * myCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:myCellID];
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:myCellID];
    if (!myCell)
    {
        myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellID];
    }
    myCell.textLabel.text = [_arrMenuRecordNames objectAtIndex:indexPath.row];
    myCell.textLabel.backgroundColor = [UIColor clearColor];
    myCell.imageView.image = [UIImage imageNamed:_arrMenuImageNames[indexPath.row]];
    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    myCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
    myCell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
    return myCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrMenuRecordNames.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _hTbMenu/_arrMenuRecordNames.count;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//选中之后
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"MyRecordVC ==》RecordListVC ，显示查询结果");
    GetCommonDataModel;
    NSString * username = comData.userModel.username;
    NSString * userRealname = comData.userModel.realname;
    RecordListVC * rl = [[RecordListVC alloc]initWithRecordType:indexPath.row
                                                       Username:username
                                                   UserRealname:userRealname];
    [self.navigationController pushViewController:rl animated:YES];
 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----
-(void)initData
{
    _arrMenuRecordNames = @[@"打卡考勤查询",@"工作汇报查询",@"外出汇报查询",@"出差汇报查询"];
    _arrMenuImageNames = @[@"icon_staff_addendance",@"icon_staff_report_work",@"icon_staff_report_goout",@"icon_staff_report_business"];
}



@end
