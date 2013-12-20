//
//  RecordQeryReportsVcCellForios5.h
//  GitomNetLjw
//
//  Created by jiawei on 13-11-11.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellForios5Delegate;


@interface RecordQeryReportsVcCellForios5 : UITableViewCell
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *timeLabel;
@property (nonatomic,retain) UILabel *addressLabel;
@property (nonatomic,strong) id <CellForios5Delegate> delegate;
@property (nonatomic,retain) UIButton *removeBut;

@end

@protocol CellForios5Delegate <NSObject>

- (void)cellButtonClick:(UIButton *)sender;

@end
