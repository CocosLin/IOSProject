//
//  SearchStaffVC.m
//  GitomHB
//
//  Created by jiawei on 13-12-26.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "SearchStaffVC.h"
#import "ShowStaffInfomationVC.h"

@interface SearchStaffVC ()

@end

@implementation SearchStaffVC

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
	// Do any additional setup after loading the view.
}

#pragma mark - TableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowStaffInfomationVC *detailViewController = [[ShowStaffInfomationVC alloc] initWithNibName:@"ShowStaffInfomationVC" bundle:nil];
    MemberOrgModel *orgMod = [[MemberOrgModel alloc]init];
    orgMod.orgunitId = [[self.searchAr objectAtIndex:self.seledBtIdx] objectForKey:@"orgunitId"];
    orgMod.username = [[self.searchAr objectAtIndex:self.seledBtIdx] objectForKey:@"username"];
    orgMod.realName = [[self.searchAr objectAtIndex:self.seledBtIdx] objectForKey:@"realname"];
    orgMod.photoUrl = [[self.searchAr objectAtIndex:self.seledBtIdx] objectForKey:@"photo"];
    orgMod.telePhone = [[self.searchAr objectAtIndex:self.seledBtIdx] objectForKey:@"telephone"];
    orgMod.orgunitId = [[self.searchAr objectAtIndex:self.seledBtIdx] objectForKey:@"orgunitId"];
    NSLog(@"self.orgArray = %@",orgMod.photoUrl);
    detailViewController.memberIfo = orgMod;
    GetCommonDataModel;
    detailViewController.unitName = comData.userModel.unitName;
    [self.navigationController pushViewController:detailViewController animated:YES];
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
