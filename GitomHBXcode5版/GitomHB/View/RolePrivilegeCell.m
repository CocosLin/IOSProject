//
//  RolePrivilegeCell.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-27.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "RolePrivilegeCell.h"

@implementation RolePrivilegeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 3, 40, 40)];
        self.headImageView.image = [UIImage imageNamed:@"checkbox_checked.png"];
        [self addSubview:self.headImageView];
        
        self.titleLb = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 120, 35)];
        self.titleLb.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLb];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.selected == YES) {
        self.selected = NO;
        self.headImageView.image = [UIImage imageNamed:@"checkbox_normal.png"];
    }else{
        self.headImageView.image = [UIImage imageNamed:@"checkbox_checked.png"];
        self.selected = YES;
    }
    // Configure the view for the selected state
}

@end
