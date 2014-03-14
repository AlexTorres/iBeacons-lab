//
//  GLBCalendarVC.h
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 13/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleOAuth.h"
#import "GLBUser.h"
#import "GLBCalendarList.h"

@interface GLBCalendarVC : UIViewController <GoogleOAuthDelegate>
@property (nonatomic, strong) GoogleOAuth *googleOAuth;
@property (nonatomic, strong) GLBUser *user;
@property (nonatomic, strong) GLBCalendarList *calendarList;

@end
