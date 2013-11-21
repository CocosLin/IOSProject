//
//  RecordQeryReportsVcCellForios5.m
//  GitomNetLjw
//
//  Created by jiawei on 13-11-11.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "RecordQeryReportsVcCellForios5.h"

@implementation RecordQeryReportsVcCellForios5

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 260, 21)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 21, 260, 21)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.timeLabel];

        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 36, 260, 21)];
        self.addressLabel.font = [UIFont systemFontOfSize:12];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.addressLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
