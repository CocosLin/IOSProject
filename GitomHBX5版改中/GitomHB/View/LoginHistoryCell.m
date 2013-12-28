//
//  LoginHistoryCell.m
//  GitomHB
//
//  Created by jiawei on 13-12-16.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "LoginHistoryCell.h"

@implementation LoginHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.removeBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        removeBut.tag = indexPath.row+100;
        [self.removeBut setBackgroundImage:[UIImage imageNamed:@"ad_close_icon.png"] forState:UIControlStateNormal];
        [self.removeBut addTarget:self action:@selector(removeUserHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
        self.removeBut.frame = CGRectMake(Screen_Width-45, 7, 26, 26);
        [self addSubview:self.removeBut];
    }
    return self;
}

- (void)removeUserHistoryAction:(UIButton *)sender{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(removeHistoryDelegat:)]) {
        [self.delegate removeHistoryDelegat:sender];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
