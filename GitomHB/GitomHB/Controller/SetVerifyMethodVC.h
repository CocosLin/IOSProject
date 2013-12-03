//
//  SetVerifyMethodVC.h
//  GitomHB
//
//  Created by jiawei on 13-11-30.
//  Copyright (c) 2013年 GitomLJYU. All rights reserved.
//

#import "VcWithNavBar.h"
#import "RadioButton.h"

@interface SetVerifyMethodVC : VcWithNavBar<RadioButtonDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    UITextField *question;
    UITextField *answers;
    UIScrollView *baseView;
    UILabel * _lblRecordPromptUserInfo;
    int verifyIndex;
}

@end
