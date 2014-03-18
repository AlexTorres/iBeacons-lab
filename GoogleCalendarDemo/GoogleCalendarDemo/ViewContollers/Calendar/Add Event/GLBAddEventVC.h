//
//  GLBAddEventVC.h
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 17/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleOAuth.h"
#import "GLBUser.h"
#import "GLBCalendarList.h"

@interface GLBAddEventVC : UIViewController <GoogleOAuthDelegate,UITextViewDelegate>
@property (nonatomic, strong) GoogleOAuth *googleOAuth;
@property (nonatomic, strong) GLBUser *user;
@property (nonatomic, strong) GLBCalendarList *calendarList;
@property (nonatomic, strong) GLBCalendarListItem *selectedCalendarListItem;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDatePicker;
@property (weak, nonatomic) IBOutlet UISwitch *fullEventSwitch;

@end
