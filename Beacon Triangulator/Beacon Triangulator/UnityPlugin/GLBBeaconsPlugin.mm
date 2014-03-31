//
//  GLBBeaconsPlugin.m
//  Beacon Triangulator
//
//  Created by John A Torres B on 29/03/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "GLBBeaconsPlugin.h"
#import <CoreLocation/CoreLocation.h>


#define UDID @"B7A78FBB-103E-4851-AEC5-319780B77B9F"
#define IDENTIFIER @"com.globant.ibeacon"

@interface GLBBeaconsPlugin () <CLLocationManagerDelegate>

@property(strong,nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic) CLBeaconRegion *iBeaconRegion;
@property(nonatomic,strong) NSMutableArray *receivedBeacons; // Of Clbeacons

@end

@implementation GLBBeaconsPlugin

#pragma mark - Properties

-(NSMutableArray *)receivedBeacons
{
    if (!_receivedBeacons) {
        _receivedBeacons = [[NSMutableArray alloc] init];
    }
    return _receivedBeacons;
}

-(CLBeaconRegion *)iBeaconRegion
{
    if (!_iBeaconRegion) {
        NSUUID *iBeaconudid=[[NSUUID alloc] initWithUUIDString:UDID];
        _iBeaconRegion =[[CLBeaconRegion alloc] initWithProximityUUID:iBeaconudid
                                                           identifier:IDENTIFIER];
    }
    return _iBeaconRegion;
}

-(CLLocationManager *)locationManager
{
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}


#pragma mark- Monitoring

- (void) startMonitoringBeacons
{
    [self.locationManager startMonitoringForRegion:self.iBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.iBeaconRegion];
}

#pragma mark- LocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
        didEnterRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:self.iBeaconRegion];
}

- (NSArray *)filteredBeacons:(NSArray *)beacons
{
    // Filters duplicate beacons out
    NSMutableArray *mutableBeacons = [beacons mutableCopy];
    
    NSMutableSet *lookup = [[NSMutableSet alloc] init];
    for (int index = 0; index < [beacons count]; index++) {
        CLBeacon *curr = [beacons objectAtIndex:index];
        NSString *identifier = [NSString stringWithFormat:@"%@/%@", curr.major, curr.minor];
        
        if ([lookup containsObject:identifier]) {
            [mutableBeacons removeObjectAtIndex:index];
        } else {
            [lookup addObject:identifier];
        }
    }
    return [mutableBeacons copy];
}

-(void)locationManager:(CLLocationManager *)manager
       didRangeBeacons:(NSArray *)beacons
              inRegion:(CLBeaconRegion *)region
{
    NSArray *filteredBeacons = [self filteredBeacons:beacons];
    [self.receivedBeacons removeAllObjects];
    [self.receivedBeacons addObjectsFromArray:filteredBeacons];
}

-(CGPoint) pointForBeaconWithMinor:(NSUInteger)minor
{
    if(minor==1){
        return CGPointMake(0, 0);
    }
    else if(minor==2){
        return CGPointMake(0, 5);
    } else if(minor==3){
        return CGPointMake(3, 4.5);
    }
    return  CGPointMake(-1, -1);
    
}

#pragma mark- Unity Plugin

// this function sent a JSON string from the beacons X , Y and distance.
- (NSString *)beaconsJSON
{
    NSString *jsonStr;
    NSMutableArray *beaconsArray = [[NSMutableArray alloc] init];
    
    for(CLBeacon *beacon in self.receivedBeacons) {
        NSDictionary *beaconHash = @{ @"major": beacon.major,
                                      @"minor": beacon.minor,
                                      @"rssi":@(beacon.rssi)};
        
        [beaconsArray addObject:beaconHash];
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"rssi" ascending:YES];
    [beaconsArray sortUsingDescriptors:@[descriptor]];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:beaconsArray
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    jsonStr = [[NSString alloc] initWithData:data
                                    encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end


#pragma mark- Unity Plugin

static GLBBeaconsPlugin *delegateObject = nil;

// Converts C style string to NSString
NSString* CreateNSString (const char* string)
{
	if (string)
		return [NSString stringWithUTF8String: string];
	else
		return [NSString stringWithUTF8String: ""];
}

// Helper method to create C string copy
char* MakeStringCopy (const char* string)
{
	if (string == NULL)
		return NULL;
	
	char* res = (char*)malloc(strlen(string) + 1);
	strcpy(res, string);
	return res;
}

// The wonderfull c ++
extern "C"
{
    void _StartBeaconsDetection ()
    {
        if (delegateObject == nil) {
            delegateObject = [[GLBBeaconsPlugin alloc] init];
            [delegateObject startMonitoringBeacons];
        }
        
    }
    const char* _GetPositionArray ()
    {
        return MakeStringCopy([[delegateObject beaconsJSON] UTF8String]);
    }
    
}
