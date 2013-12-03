//
//  OrganizationsModel.h
//  GitomNetLjw
//
//  Created by jiawei on 13-9-23.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganizationsModel : NSObject
@property (nonatomic, copy) NSString *organizationName;
@property (nonatomic, copy) NSString *organizationId;
@property (nonatomic, copy) NSString *orgunitId;
@property (nonatomic, copy) NSString *orgunitName;
@property (nonatomic, retain) NSMutableArray *orgunitNameArray;
@property (nonatomic, retain) NSArray *orgunitIdArray;
@property (nonatomic, retain) NSArray *orgunitPropsArray;
@end
