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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

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
    
    
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_back_default.png"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    
    self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    self.search.placeholder = @"输入公司名称关键字";
    self.search.backgroundColor = BlueColor;
    self.search.delegate = self;
    [self.view addSubview:self.search];
    /*
    __block OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    NSString *utf8Str = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.search.text,NULL,NULL,kCFStringEncodingUTF8);
    if (utf8Str == nil) {
        utf8Str = @"1";
    }
    [hbKit searchCompanyWithKey:utf8Str andFirst:1 andMax:4 andGetArr:^(NSArray *companyAr) {
        orgMod = [companyAr objectAtIndex:0];
        NSLog(@"OrganizationsModel %@ %@ %@ %@",orgMod.orgunitName,orgMod.orgunitId,orgMod.orgunitName,orgMod.organizationId);
        self.searchAr = companyAr;
    }];
    [hbKit release];*/
    
    self.searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, Screen_Width, Screen_Height-105)];
    self.searchTable.delegate = self;
    self.searchTable.dataSource = self;
    [self.view addSubview:self.searchTable];
    
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    if ([searchText isEqualToString:@""]) {
        self.searchAr = @[@"空"];
        [self.searchTable reloadData];
        return;
    }
    
//    NSString *keyName = @"";
//    if (_searchState == DataSearchStateBank) {
//        keyName = [Bank keyName];
//    }
    /**< 模糊查找*/
    //NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", keyName, searchText];
    /**< 精确查找*/
    //  NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K == %@", keyName, searchText];
    
    //NSLog(@"predicate %@",predicateString);
    
    //__block NSArray  *filteredArray = [[NSArray alloc]init];
    __block OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    NSString *utf8Str = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.search.text,NULL,NULL,kCFStringEncodingUTF8);
    if (utf8Str == nil) {
        utf8Str = @"1";
    }
    [hbKit searchCompanyWithKey:utf8Str andFirst:0 andMax:10 andGetArr:^(NSArray *companyAr) {
        orgMod = [companyAr objectAtIndex:0];
        NSLog(@"OrganizationsModel %@ %@ %@ %@",orgMod.organizationName,orgMod.organizationId,orgMod.orgunitName,orgMod.organizationId);
        self.searchAr = companyAr;
        [self.searchTable reloadData];
    }];
    [hbKit release];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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
    return self.searchAr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell");
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    
//    NSLog(@"SearchComanyVC cell == %@",orgMod.organizationName);
    NSLog(@"array count = %d",self.searchAr.count);
    OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
    if (self.searchAr.count >1 && orgMod != nil ) {
        
        orgMod = [self.searchAr objectAtIndex:indexPath.row];
        cell.textLabel.text = orgMod.organizationName;
        NSLog(@"SearchComanyVC orgMod == %@",orgMod);
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
        NSLog(@"numberOfRows %d",orgMod.orgunitNameArray.count);
        return orgMod.orgunitNameArray.count;
        [orgMod release];
    } andCells:^UITableViewCell *(MLTableAlert *alert, NSIndexPath *indexPath) {
        NSLog(@"indexPath");
        OrganizationsModel *orgMod = [[OrganizationsModel alloc]init];
        orgMod = [self.searchAr objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [alert.table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"self.searchAr = %@",self.searchAr);
        orgMod = [self.searchAr objectAtIndex:self.uitableIndexPath];
        NSLog(@"MLTalert  indexPath.row %d",indexPath.row);
        cell.textLabel.text = [orgMod.orgunitNameArray objectAtIndex:indexPath.row];
        return cell;
        [orgMod release];
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
        NSLog(@"SearchComanyVC %@ %@ %@ %@",vc.orgName,vc.orgId,vc.companyName,vc.companyId);
        
        [self.navigationController pushViewController:vc animated:YES];
        
	} andCompletionBlock:^{
		NSLog(@"取消");
	}];
	
	// show the alert
	[self.alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
