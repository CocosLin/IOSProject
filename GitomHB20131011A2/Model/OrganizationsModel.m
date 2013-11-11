//
//  OrganizationsModel.m
//  GitomNetLjw
//
//  Created by jiawei on 13-9-23.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "OrganizationsModel.h"

@implementation OrganizationsModel


- (void)dealloc{
    [_organizationId release];
    [_organizationName release];
    [_orgunitId release];
    [_orgunitIdArray release];
    [_orgunitNameArray release];
    [_orgunitPropsArray release];
    [super dealloc];
}
@end
