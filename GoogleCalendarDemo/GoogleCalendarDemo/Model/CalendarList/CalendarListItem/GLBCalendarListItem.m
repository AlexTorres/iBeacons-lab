//
//  GLBCalendarListItem.m
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 14/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBCalendarListItem.h"

@implementation GLBCalendarListItem
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"calendarID"
                                                       }];
}

@end
