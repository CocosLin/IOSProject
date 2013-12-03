//
//  ApplyViewController.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-14.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ApplyViewController.h"
#import "RecordQeryReportsVcCell.h"
#import "WTool.h"
#import "ApplyModel.h"
#import "HBServerKit.h"
#import "SVProgressHUD.h"
#import "RecordQeryReportsVcCellForios5.h"

@interface ApplyViewController (){
    UITableView *_tvbRecordInfo;
    UILabel * _lblRecordPromptUserInfo;
    ApplyModel *applyMod;
    int selectedIndex;
}

@end

@implementation ApplyViewController

#pragma mark - 表格代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"RecordListVC tableView 含有的数据内容是 == %@",self.arrData);
    return self.arrData.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0) {
        static NSString *CellIdentifier = @"Cell";
        RecordQeryReportsVcCellForios5 *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (myCell == nil) {
            myCell = [[RecordQeryReportsVcCellForios5 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            myCell.removeBut.hidden = YES;
        }
        applyMod = [self.arrData objectAtIndex:indexPath.row];
        myCell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)申请加入[%@]",applyMod.realname,applyMod.createUserId,applyMod.orgunitName];
        myCell.nameLabel.font = [UIFont systemFontOfSize:12];
        myCell.timeLabel.text = [NSString stringWithFormat:@"申请时间:%@",[WTool getStrDateTimeWithDateTimeMS:[applyMod.updateDate doubleValue] DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"]];
        myCell.addressLabel.text = [NSString stringWithFormat:@"申请理由:%@",applyMod.note];
        myCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        myCell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        return myCell;
        
    }else{
        static NSString * cellID = @"RecordQeryReportsVcCell";
        RecordQeryReportsVcCell * myCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!myCell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RecordQeryReportsVcCell" owner:self options:nil];
            myCell = [nib objectAtIndex:0];
        }
        
        applyMod = [self.arrData objectAtIndex:indexPath.row];
        myCell.realName.text = [NSString stringWithFormat:@"%@(%@)申请加入[%@]",applyMod.realname,applyMod.createUserId,applyMod.orgunitName];
        myCell.creatDate.text = [NSString stringWithFormat:@"申请时间:%@",[WTool getStrDateTimeWithDateTimeMS:[applyMod.updateDate doubleValue] DateTimeStyle:@"yyyy-MM-dd HH:mm:ss"]];
        myCell.address.text = [NSString stringWithFormat:@"申请理由:%@",applyMod.note];
        myCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        myCell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        return myCell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"如何处理申请？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"接受",@"拒绝",@"取消", nil];
    selectedIndex = indexPath.row;
    [aler show];
 
}

#pragma mark -- UIAlerView代理方法
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{            GetCommonDataModel;
    applyMod = [self.arrData objectAtIndex:selectedIndex];
    switch (buttonIndex) {
        case 0:
            //同意申请http://hb.m.gitom.com/3.0/organization/saveOrgunitUser?organizationId=114&orgunitId=1&username=90261&roleId=4&updateUser=90261&cookie=5533098A-43F1-4AFC-8641-E64875461345
        {
            NSString *saveOrgunitUserStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/saveOrgunitUser?organizationId=%ld&orgunitId=%ld&roleId=%@&username=%@&updateUser=%@&cookie=%@&operations=8",(long)comData.organization.organizationId,(long)comData.organization.orgunitId,@"4",applyMod.createUserId,comData.userModel.username,comData.cookie];
            NSLog(@"ApplyViewController saveOrgunitUser UrlStr %@",saveOrgunitUserStr);
            NSURL *saveOrgunitUserUrl = [NSURL URLWithString:saveOrgunitUserStr];
            NSURLRequest *req = [NSURLRequest requestWithURL:saveOrgunitUserUrl];
            NSData *returnData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
            NSDictionary *dic1 = [jsonDic objectForKey:@"body"];
            BOOL bo = [[jsonDic objectForKey:@"success"] boolValue];
            if (bo) {
                NSLog(@"success %c",bo);
                [SVProgressHUD showSuccessWithStatus:@"接受申请"];
            }else{
                NSString *warningStr = [dic1 objectForKey:@"warning"];
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%@",applyMod.realname,warningStr]];
                NSLog(@"warning %@",warningStr);
            }
            
            
            break;
        }case 1:{
            //拒绝申请http://hb.m.gitom.com/3.0/organization/deleteApply?organizationId=114&orgunitId=1&username=58200&updateUser=90261&cookie=5533098A-43F1-4AFC-8641-E64875461345
            NSString *changeRoleUrlStr = [NSString stringWithFormat:@"http://hb.m.gitom.com/3.0/organization/deleteApply?organizationId=%ld&orgunitId=%ld&username=%@&updateUser=%@&cookie=%@",(long)comData.organization.organizationId,(long)comData.organization.orgunitId,applyMod.createUserId,comData.userModel.username,comData.cookie];
            NSLog(@"ApplyViewController UrlStr %@",changeRoleUrlStr);
            NSURL *releaseUrl = [NSURL URLWithString:changeRoleUrlStr];
            NSURLRequest *req = [NSURLRequest requestWithURL:releaseUrl];
            [NSURLConnection sendAsynchronousRequest:req queue:nil completionHandler:nil];
            break;
        }case 2:{
            return;
        }
        default:
            break;
    }
}

//记录提示信息
-(void)initRecordPromptInfo
{
    CGFloat hViewRecordPromptInfo = 40;
    UIView * viewRecordPromptInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, hViewRecordPromptInfo)];
    [viewRecordPromptInfo setBackgroundColor:BlueColor];
    
    _lblRecordPromptUserInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, hViewRecordPromptInfo)];
    [viewRecordPromptInfo addSubview:_lblRecordPromptUserInfo];
    _lblRecordPromptUserInfo.textAlignment = NSTextAlignmentCenter;
    _lblRecordPromptUserInfo.textColor = [UIColor blackColor];
    [_lblRecordPromptUserInfo setFont:[UIFont systemFontOfSize:26]];
    
    NSString *recordType = [[NSString alloc]init];
    _lblRecordPromptUserInfo.text = @"加入申请";
    _lblRecordPromptUserInfo.font = [UIFont systemFontOfSize:18];

    [_lblRecordPromptUserInfo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewRecordPromptInfo];
    
 
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 刷新
- (void)refreshAction{
    GetCommonDataModel;
    [SVProgressHUD showWithStatus:@"刷新"];
    HBServerKit *hbKit = [[HBServerKit alloc]init];
    [hbKit findApplyWithOrganizationId:comData.organization.organizationId
                             orgunitId:comData.organization.orgunitId
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
                 applyIfo.note = [dicReports objectForKey:@"note"];
                 [mArrReports addObject:applyIfo];
             }
             NSLog(@"获取汇报记录成功! %@",mArrReports);
             [SVProgressHUD dismissWithIsOk:YES String:@"完成刷新!"];
             self.arrData = mArrReports;
         [_tvbRecordInfo reloadData];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:103.0/255.0 green:154.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_title_text_default"] forState:UIControlStateNormal];
    // 高亮
    [btn  setBackgroundImage:[UIImage imageNamed:@"btn_title_text_pressed"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
 
    
    [self initRecordPromptInfo];
    
    _tvbRecordInfo = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, Screen_Width, Screen_Height-51)];
    [self.view addSubview:_tvbRecordInfo];
    [_tvbRecordInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tvbRecordInfo setBackgroundColor:[UIColor whiteColor]];
    [_tvbRecordInfo setDelegate:self];
    [_tvbRecordInfo setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
