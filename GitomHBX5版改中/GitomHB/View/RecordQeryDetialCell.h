//
//  RecordQeryDetialCell.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-24.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordQeryDetialCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headImg;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *roleId;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;

@end
