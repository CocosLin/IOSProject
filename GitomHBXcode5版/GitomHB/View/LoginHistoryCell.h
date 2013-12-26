//
//  LoginHistoryCell.h
//  GitomHB
//
//  Created by jiawei on 13-12-16.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginHistorCellDelegate <NSObject>

- (void)removeHistoryDelegat:(UIButton *)sender;

@end

@interface LoginHistoryCell : UITableViewCell

@property (nonatomic, weak) id <LoginHistorCellDelegate> delegate;
@property (nonatomic, strong) UIButton *removeBut;

@end

