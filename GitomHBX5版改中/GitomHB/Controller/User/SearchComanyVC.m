//
//  SearchComanyVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-5.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "SearchComanyVC.h"
#import "HBServerKit.h"
#import "OrganizationsModel.h"
#import "ApplyNotesVC.h"


@interface SearchComanyVC ()

@end

@implementation SearchComanyVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"搜索公司";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}*/

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 高亮
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
 
    
    //搜索框
    self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    self.search.placeholder = @"输入公司名称关键字";
    self.search.backgroundColor = BlueColor;
    self.search.delegate = self;
    [self.view addSubview:self.search];

    //列表
    self.searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, Screen_Width, Screen_Height-105)];
    self.searchTable.delegate = self;
    self.searchTable.dataSource = self;
    [self.view addSubview:self.searchTable];
    
    
    //上拉刷新的控件添加在tableView上
    refreshView = [[EGORefreshTableFooterView alloc]  initWithFrame:CGRectZero];
    refreshView.delegate = self;
    [self.searchTable addSubview:refreshView];
    reloading = NO;
}

#pragma mark search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    HBServerKit *hbKit = [[HBServerKit alloc]init];
    NSString *utf8Str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.search.text,NULL,NULL,kCFStringEncodingUTF8));
    if (utf8Str == nil) {
        utf8Str = @"1";
    }
    [hbKit searchCompanyWithKey:utf8Str
                       andFirst:0
                         andMax:10
                      andGetArr:^(NSArray *companyAr) {
        
        for (OrganizationsModel *aorgMod in companyAr) {
            NSLog(@"OrganizationsModel %@ %@ %@ ",aorgMod.organizationName,aorgMod.organizationId,aorgMod.orgunitPropsArray);
        }
        
        self.searchAr = companyAr;
        [self.searchTable reloadData];
    }];
   
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.search resignFirstResponder];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"searchA count == %d",self.searchAr.count);
    if (!self.searchAr) {
        return 0;
    }
    return self.searchAr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell");
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    NSLog(@"array count = %d",self.searchAr.count);
    
    if (self.searchAr.count >=1) {
        OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
        orgMod = [self.searchAr objectAtIndex:indexPath.row];
        NSLog(@"SearchComanyVC orgMod == %@",orgMod);
        if (orgMod) {
            cell.textLabel.text = orgMod.organizationName;
        }else{
            cell.textLabel.text = @"-";
        }
    }
    return cell;
}
#pragma mark - TableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"#pragma mark - TableViewdelegate");
    self.uitableIndexPath = indexPath.row;
    self.alert = [MLTableAlert tableAlertWithTitle:@"选择部门" cancelButtonTitle:@"取消" numberOfRows:^NSInteger(NSInteger section) {
        OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
        orgMod = [self.searchAr objectAtIndex:indexPath.row];
        return orgMod.orgunitNameArray.count; 
       
    } andCells:^UITableViewCell *(MLTableAlert *alert, NSIndexPath *indexPath) {
        NSLog(@"indexPath");
        OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
        orgMod = [self.searchAr objectAtIndex:self.uitableIndexPath];
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [alert.table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"self.searchAr = %@",self.searchAr);
        orgMod = [self.searchAr objectAtIndex:self.uitableIndexPath];
        NSLog(@"MLTalert  indexPath.row %d",indexPath.row);
        cell.textLabel.text = [orgMod.orgunitNameArray objectAtIndex:indexPath.row];
        return cell;
    
    }];
	
	
	// Setting custom alert height
	self.alert.height = 350;
	
	// configure actions to perform
	[self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
		ApplyNotesVC *vc = [[ApplyNotesVC alloc]init];
        OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
        orgMod = [self.searchAr objectAtIndex:self.uitableIndexPath];
//        orgMod
        NSLog(@"selectedIndex == %d",selectedIndex.row);
        //vc.orgMod = [self.searchAr objectAtIndex:selectedIndex.row];
        vc.orgName = [orgMod.orgunitNameArray objectAtIndex:selectedIndex.row];
        vc.orgId = [orgMod.orgunitIdArray objectAtIndex:selectedIndex.row];
        vc.companyName = orgMod.organizationName;
        vc.companyId = orgMod.organizationId;
        vc.orgPropsArray = [orgMod.orgunitPropsArray objectAtIndex:selectedIndex.row];
        NSLog(@"SearchComanyVC %@ %@ %@ %@",vc.orgName,vc.orgId,vc.companyName,vc.companyId);
        NSLog(@"SearchComanyVC orgPropsArray == %@",vc.orgPropsArray);
        [self.navigationController pushViewController:vc animated:YES];
        
	} andCompletionBlock:^{
		NSLog(@"取消");
	}];
	
	// show the alert
	[self.alert show];
    
}

#pragma mark - 上拉刷新相关
-(void)viewDidAppear:(BOOL)animated
{
    //frame应在表格加载完数据源之后再设置
    [self setRefreshViewFrame];
    [super viewDidAppear:animated];
}
//请求数据
-(void)reloadData
{
    reloading = YES;
    //新建一个线程来加载数据
    [NSThread detachNewThreadSelector:@selector(requestData)
                             toTarget:self
                           withObject:nil];
}
static int addDataInt=0;
-(void)requestData
{   NSLog(@"上拉刷新 addDataInt == %d",addDataInt);
    addDataInt=addDataInt +10;
    
    //查汇报记录
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    NSString *utf8Str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.search.text,NULL,NULL,kCFStringEncodingUTF8));
    if (utf8Str == nil) {
        utf8Str = @"1";
    }
    [hbKit searchCompanyWithKey:utf8Str
                       andFirst:0
                         andMax:10+addDataInt
                      andGetArr:^(NSArray *companyAr) {
        
        for (OrganizationsModel *aorgMod in companyAr) {
            NSLog(@"OrganizationsModel %@ %@ %@ ",aorgMod.organizationName,aorgMod.organizationId,aorgMod.orgunitPropsArray);
        }
        
        self.searchAr = companyAr;
        [self.searchTable reloadData];
    }];
      
    
    sleep(3);
    //在主线程中刷新UI
    [self performSelectorOnMainThread:@selector(reloadUI)
                           withObject:nil
                        waitUntilDone:NO];
}

-(void)reloadUI
{
	reloading = NO;
    
    //停止上拉的动作,恢复表格的便宜
	[refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.searchTable];
    //更新界面
    [self.searchTable reloadData];
    [self setRefreshViewFrame];
}

-(void)setRefreshViewFrame
{
    //如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    int height = MAX(self.searchTable.bounds.size.height,self.searchTable.contentSize.height);
    refreshView.frame =CGRectMake(0.0f, height, self.view.frame.size.width, self.searchTable.bounds.size.height-90);
}
#pragma mark - EGORefreshTableFooterDelegate
//出发下拉刷新动作，开始拉取数据
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    [self reloadData];
}
//返回当前刷新状态：是否在刷新
- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return reloading;
}
//返回刷新时间
-(NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view
{
    return [NSDate date];
}

#pragma mark - UIScrollView
//在下拉一段距离到提示松开和松开后提示都应该有变化，变化可以在这里实现
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
}
//松开后判断表格是否在刷新，若在刷新则表格位置偏移，且状态说明文字变化为loading...
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
