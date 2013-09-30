//
//  FeedBack.h
//  GitomAPP
//
//  Created by jiawei on 13-7-16.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol feedBackViewPopProtocol <NSObject>

- (void) feedBackPopToLastView;

@end

@interface FeedBack : UIView<UITextFieldDelegate,UITextViewDelegate>


@property (strong, nonatomic) UIScrollView *baseView;
@property (strong, nonatomic) UITextField *address;
@property (strong, nonatomic) UITextView *feedBackInfo;


@property (assign, nonatomic) id<feedBackViewPopProtocol> delegate;

@end
