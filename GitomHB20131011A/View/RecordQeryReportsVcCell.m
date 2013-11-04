//
//  RecordQeryReportsVcCell.m
//  GitomNetLjw
//
//  Created by jiawei on 13-10-10.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "RecordQeryReportsVcCell.h"

@implementation RecordQeryReportsVcCell

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
    [_realName release];
    [_creatDate release];
    [_address release];
    [_rightImg release];
    [super dealloc];
}
@end
