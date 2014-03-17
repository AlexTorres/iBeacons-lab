//
//  GLBViewController.m
//  GoogleCalendarDemo
//
//  Created by Camila Gaitan Mosquera on 12/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBViewController.h"
#import "GLBCalendarVC.h"
#import "GLBProfileVC.h"


#define kCalendarSegue @"gotoCalendar"
#define kProfileSegue  @"gotoProfile"


#define UDID @"B7A78FBB-103E-4851-AEC5-319780B77B9F"

@interface GLBViewController ()

@end

@implementation GLBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.arrProfileInfo = [[NSMutableArray alloc] init];
    self.arrProfileInfoLabel = [[NSMutableArray alloc] init];
    
    self.googleOAuth = [[GoogleOAuth alloc] initWithFrame:self.view.frame];
    [self.googleOAuth setGoogleDelegate:self];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init

-(void)initiBeaconsComponents
{
    self.locationManager=[[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    
    
    NSUUID *iBeaconudid=[[NSUUID alloc] initWithUUIDString:UDID];
    self.iBeaconRegion=[[CLBeaconRegion alloc] initWithProximityUUID:iBeaconudid identifier:@"com.globant.ibeacon"];
    [self.locationManager startMonitoringForRegion:self.iBeaconRegion];
}


#pragma mark- LocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:self.iBeaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self.locationManager stopRangingBeaconsInRegion:self.iBeaconRegion];
    self.iBeaconStatus.text=@"NO";
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    self.iBeaconStatus.text=@"Beacon Found";
    CLBeacon *beaconData= [beacons firstObject];
    
    NSString *UDIDString= beaconData.proximityUUID.UUIDString;
    NSString *major= [NSString stringWithFormat:@"%@",beaconData.major];
    NSString *minor=[NSString stringWithFormat:@"%@",beaconData.minor];
    
    self.iBeaconUDID.text=UDIDString;
    self.iBeaconMajor.text=major;
    self.iBeaconMinor.text=minor;
}


#pragma mark - GoogleOAuthDelegate

-(void)authorizationWasSuccessful{
    [self.googleOAuth callAPI:@"https://www.googleapis.com/oauth2/v1/userinfo"
           withHttpMethod:httpMethod_GET
       postParameterNames:nil postParameterValues:nil];
}

-(void)accessTokenWasRevoked{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Your access was revoked!"
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    [self.arrProfileInfo removeAllObjects];
    [self.arrProfileInfoLabel removeAllObjects];
    
}

-(void)errorOccuredWithShortDescription:(NSString *)errorShortDescription andErrorDetails:(NSString *)errorDetails{
    NSLog(@"%@", errorShortDescription);
    NSLog(@"%@", errorDetails);
}


-(void)errorInResponseWithBody:(NSString *)errorMessage{
    NSLog(@"%@", errorMessage);
}

-(void)responseFromServiceWasReceived:(NSString *)responseJSONAsString andResponseJSONAsData:(NSData *)responseJSONAsData{
    if ([responseJSONAsString rangeOfString:@"family_name"].location != NSNotFound) {
        NSError *error;

        self.user = [[GLBUser alloc] initWithString:responseJSONAsString error:&error];
        if (error) {
            NSLog(@"An error occured while converting JSON data to dictionary.");
            return;
        }
        else{
            if (self.arrProfileInfoLabel != nil) {
                self.arrProfileInfoLabel = nil;
                self.arrProfileInfo = nil;
                self.arrProfileInfo = [[NSMutableArray alloc] init];
            }
            
            self.arrProfileInfoLabel = [[NSMutableArray alloc] initWithArray:[[self.user toDictionary] allKeys] copyItems:YES];
            for (int i=0; i<[self.arrProfileInfoLabel count]; i++) {
                [self.arrProfileInfo addObject:[[self.user toDictionary]  objectForKey:[self.arrProfileInfoLabel objectAtIndex:i]]];
            }
            
            [self performSegueWithIdentifier:kProfileSegue sender:self];
            
        }
    }
}

#pragma mark - Actions

- (IBAction)showProfile:(id)sender {
    [self.googleOAuth authorizeUserWithClienID:@"855181453471.apps.googleusercontent.com"
                           andClientSecret:@"ooyZUrGgdp7rGM37SSRtReJ4"
                             andParentView:self.view
                                 andScopes:[NSArray arrayWithObjects:@"https://www.googleapis.com/auth/userinfo.profile", @"https://www.googleapis.com/auth/calendar",@"https://www.googleapis.com/auth/calendar.readonly",nil]
     ];
    
    
}

- (IBAction)revokeAccess:(id)sender {
    [self.googleOAuth revokeAccessToken];
}

- (IBAction)calendarEvents:(id)sender {
    [self performSegueWithIdentifier:kCalendarSegue sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:kCalendarSegue])
    {
        GLBCalendarVC *calendarVC = segue.destinationViewController;
        [calendarVC setUser:self.user];
        [calendarVC setGoogleOAuth:self.googleOAuth];
        [calendarVC setTitle:@"Calendars"];
    }
    
    if([[segue identifier]isEqualToString:kProfileSegue])
    {
        GLBProfileVC *profileVC=segue.destinationViewController;
        [profileVC setArrProfileInfo:self.arrProfileInfo];
        [profileVC  setArrProfileInfoLabel:self.arrProfileInfoLabel];
        [profileVC setTitle:@"Profile"];
    }
}

@end
