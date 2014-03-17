//
//  GLBViewController.h
//  GoogleCalendarDemo
//
//  Created by Camila Gaitan Mosquera on 12/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleOAuth.h"
#import "GLBUser.h"
#import <CoreLocation/CoreLocation.h>


@interface GLBViewController : UIViewController<GoogleOAuthDelegate,CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revokeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *calendarEventsButton;
@property (nonatomic, strong) NSMutableArray *arrProfileInfo;
@property (nonatomic, strong) NSMutableArray *arrProfileInfoLabel;
@property (nonatomic, strong) GoogleOAuth *googleOAuth;
@property (nonatomic, strong) GLBUser *user;


@property(weak,nonatomic)IBOutlet UILabel * iBeaconStatus;
@property(weak,nonatomic)IBOutlet UILabel * iBeaconUDID;
@property(weak,nonatomic)IBOutlet UILabel * iBeaconMajor;
@property(weak,nonatomic)IBOutlet UILabel * iBeaconMinor;
@property(strong,nonatomic)CLLocationManager *locationManager;
@property(strong,nonatomic)CLBeaconRegion *iBeaconRegion;

- (IBAction)showProfile:(id)sender;
- (IBAction)revokeAccess:(id)sender;
- (IBAction)calendarEvents:(id)sender;

@end
