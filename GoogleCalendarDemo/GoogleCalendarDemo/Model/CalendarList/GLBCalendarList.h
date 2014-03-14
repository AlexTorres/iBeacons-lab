//
//  GLBCalendarList.h
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 14/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "JSONModel.h"
#import "GLBCalendarListItem.h"

@interface GLBCalendarList : JSONModel
@property (strong, nonatomic) NSString* kind;
@property (strong, nonatomic) NSString* etag;
@property (strong, nonatomic) NSArray<GLBCalendarListItem>* items;

@end
