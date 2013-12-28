//
//  AboutView.m
//  GitomHB
//
//  Created by huangpeng on 13-5-22.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "AboutView.h"

@implementation AboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self UIbuttonOne];
    }
    return self;
}
-(void)UIbuttonOne
{

    UITableView *mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,320,Screen_Height-44) style:UITableViewStylePlain];
    mtableview.delegate=self;
    mtableview.dataSource=self;
    [self addSubview:mtableview];
 
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (indexPath.section==0)
    {

        NSString *str = @"版权归属:网即通网络科技有限公司\n高级版/标准版: 高级版\n发行版/内测版: 内测版";
        CGSize labelSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]
                           constrainedToSize:CGSizeMake(300,70)
                               lineBreakMode:NSLineBreakByWordWrapping];   
        UILabel *patternLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5,labelSize.width, labelSize.height)];
        patternLabel.text = str;
        patternLabel.backgroundColor = [UIColor clearColor];
        patternLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        patternLabel.numberOfLines = 0;// 不可少Label属性之一
        patternLabel.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
        [cell addSubview:patternLabel];

        
    }
    if (indexPath.section==1)
    {
        NSString *str = @"我们的愿景-让商务充满快乐。\n我们的使命是--为中小企业提供一站式在线商务服务。";
        CGSize labelSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:15.0f]
                           constrainedToSize:CGSizeMake(300,70)
                               lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *patternLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5,labelSize.width, labelSize.height)];
        patternLabel.text = str;
        patternLabel.backgroundColor = [UIColor clearColor];
        patternLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        patternLabel.numberOfLines = 0;// 不可少Label属性之一
        patternLabel.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
        [cell addSubview:patternLabel];

    }
    if (indexPath.section==2)
    {
        NSString *str = @"移动汇报标准版提供公告、移动考勤、日常汇报、出差汇报、外出汇报、汇报点评、汇报记录、员工管理等功能，移动汇报支持文字、图片、语音等多形式汇报方式，操作简洁方便，可谓是有图有真相，是移动互联网时代一款不可多得的企业管理助手。";
        CGSize labelSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:15.0f]
                           constrainedToSize:CGSizeMake(300,130)
                               lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *patternLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5,labelSize.width, labelSize.height)];
        patternLabel.text = str;
        patternLabel.backgroundColor = [UIColor clearColor];
        patternLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        patternLabel.numberOfLines = 0;// 不可少Label属性之一
        patternLabel.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
        [cell addSubview:patternLabel];
  
    }
//    if (indexPath.section==3)
//    {
//        NSString *str = @"移动汇报高级版增加接收汇报消息通知、出差员工实时位置查看喝和路线轨迹分析等功能，让管理者身处智能云端也能在第一时间掌控现场资讯，极大的提高了员工的工作效率。";
//        CGSize labelSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:15.0f]
//                           constrainedToSize:CGSizeMake(300,140)
//                               lineBreakMode:NSLineBreakByWordWrapping];
//        UILabel *patternLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5,labelSize.width, labelSize.height)];
//        patternLabel.text = str;
//        patternLabel.backgroundColor = [UIColor clearColor];
//        patternLabel.font = [UIFont boldSystemFontOfSize:15.0f];
//        patternLabel.numberOfLines = 0;// 不可少Label属性之一
//        patternLabel.lineBreakMode = NSLineBreakByCharWrapping;// 不可少Label属性之二
//        [cell addSubview:patternLabel];
//         [patternLabel release];
//    }
   [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0||indexPath.section==1)
    {
        return 70;
    }
    return 350;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionView setBackgroundColor:BlueColor];
    
    //增加UILabel
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 320, 18)];
    [text setTextColor:[UIColor whiteColor]];
    [text setBackgroundColor:[UIColor clearColor]];
    NSArray *array=[NSArray arrayWithObjects:@"版本信息",@"网即通网络科技有限公司",@"iOS版移动汇报", nil];
    [text setText:[array objectAtIndex:section]];
    [text setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    [sectionView addSubview:text];
    return sectionView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
