//
//  ManageStaffDetialCell.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-24.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "ManageStaffDetialCell.h"

@implementation ManageStaffDetialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImg release];
//    [_nameLbel release];
//    [_roleIdLbel release];
    [_headImg release];
    [_name release];
    [_roleId release];
    [super dealloc];
}
@end
