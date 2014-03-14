//
//  GLBUser.h
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 13/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "JSONModel.h"

@interface GLBUser : JSONModel
@property (strong, nonatomic) NSString* givenName;
@property (strong, nonatomic) NSString* familyName;
@property (strong, nonatomic) NSString* gender;
@property (strong, nonatomic) NSString* link;
@property (strong, nonatomic) NSString* locale;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* picture;
@property (strong, nonatomic) NSString* userID;

@end
