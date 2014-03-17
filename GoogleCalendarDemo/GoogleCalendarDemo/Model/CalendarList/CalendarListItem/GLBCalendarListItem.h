//
//  GLBCalendarListItem.h
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 14/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "JSONModel.h"
@protocol GLBCalendarListItem
@end

@interface GLBCalendarListItem : JSONModel
@property (strong, nonatomic) NSString* kind;
@property (strong, nonatomic) NSString* etag;
@property (strong, nonatomic) NSString* calendarID;
@property (strong, nonatomic) NSString* summary;
@property (strong, nonatomic) NSString* timeZone;
@property (strong, nonatomic) NSString* colorId;
@property (strong, nonatomic) NSString* backgroundColor;
@property (strong, nonatomic) NSString * foregroundColor;
@property (strong, nonatomic) NSString<Optional> *selected;
@property (strong, nonatomic) NSString* accessRole;

@end
