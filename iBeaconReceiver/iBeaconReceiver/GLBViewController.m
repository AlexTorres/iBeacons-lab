//
//  GLBViewController.m
//  iBeaconReceiver
//
//  Created by Camila Gaitan Mosquera on 4/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBViewController.h"


#define UDID @"B7A78FBB-103E-4851-AEC5-319780B77B9F"

@interface GLBViewController ()

@end

@implementation GLBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.locationManager=[[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    
    
    NSUUID *iBeaconudid=[[NSUUID alloc] initWithUUIDString:UDID];
    self.iBeaconRegion=[[CLBeaconRegion alloc] initWithProximityUUID:iBeaconudid identifier:@"com.globant.ibeacon"];
    [self.locationManager startMonitoringForRegion:self.iBeaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
   CLLocationAccuracy accurancy= beaconData.accuracy;
    
    
    
    self.iBeaconUDID.text=UDIDString;
    self.iBeaconMajor.text=major;
    self.iBeaconMinor.text=minor;
}

@end
