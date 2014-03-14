//
//  GLBUser.m
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 13/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBUser.h"

@implementation GLBUser
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"userID",
                                                       @"family_name": @"familyName",
                                                       @"given_name": @"givenName"
                                                       }];
}

@end
