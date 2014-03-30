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
@interface GLBBeaconsPlugin ()<CLLocationManagerDelegate>

@property(strong,nonatomic)CLLocationManager *locationManager;
@property(strong,nonatomic)CLBeaconRegion *iBeaconRegion;
@property(nonatomic,strong)  NSMutableDictionary *receivedBeaconDistances;

@end

@implementation GLBBeaconsPlugin

#pragma mark - Properties

-(NSMutableDictionary *)receivedBeaconDistances
{
    if (!_receivedBeaconDistances) {
        _receivedBeaconDistances = [[NSMutableDictionary alloc] init];
    }
    return _receivedBeaconDistances;
}

-(CLBeaconRegion *)iBeaconRegion {
    if(!_iBeaconRegion){
        NSUUID *iBeaconudid=[[NSUUID alloc] initWithUUIDString:UDID];
        _iBeaconRegion =[[CLBeaconRegion alloc] initWithProximityUUID:iBeaconudid
                                                           identifier:@"com.globant.ibeacon"];
    }
    return _iBeaconRegion;
}

-(CLLocationManager *)locationManager {
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
// this function sent a JSON string from the beacons X , Y and distance. 
- (NSString *)beaconsJson {
    NSString *jsonStr;
    NSMutableArray *beaconsArray = [[NSMutableArray alloc] initWithCapacity:0];
    if([self.receivedBeaconDistances count]) {
        for (NSInteger j = 1; j< [self.receivedBeaconDistances count]-2; j++) {
            double dist = [[self.receivedBeaconDistances objectForKey:[NSString stringWithFormat:@"%i",j]] floatValue];
            NSDictionary *beaconHash = @{ @"x": [NSNumber numberWithFloat:[self pointForBeaconWithMinor:j].x],
                                         @"y": [NSNumber numberWithFloat:[self pointForBeaconWithMinor:j].y],
                                         @"distance":[NSNumber numberWithDouble:dist]};
            [beaconsArray addObject:beaconHash];
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:beaconsArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
        jsonStr = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return jsonStr;
}

- (id)init
{
    self = [super init];
    return self;
}

- (void) startMonitoring {
    [self.locationManager startMonitoringForRegion:self.iBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.iBeaconRegion];
}

#pragma mark- LocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:self.iBeaconRegion];
}

- (NSArray *)filteredBeacons:(NSArray *)beacons
{
    // Filters duplicate beacons out; this may happen temporarily if the originating device changes its Bluetooth id
    NSMutableArray *mutableBeacons = [beacons mutableCopy];
    
    NSMutableSet *lookup = [[NSMutableSet alloc] init];
    for (int index = 0; index < [beacons count]; index++) {
        CLBeacon *curr = [beacons objectAtIndex:index];
        NSString *identifier = [NSString stringWithFormat:@"%@/%@", curr.major, curr.minor];
        
        // this is very fast constant time lookup in a hash table
        
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
              inRegion:(CLBeaconRegion *)region {
    NSArray *filteredBeacons = [self filteredBeacons:beacons];
    for (CLBeacon *beaconData in filteredBeacons) {
        self.receivedBeaconDistances[beaconData.minor] = @(beaconData.accuracy);
        if (beaconData.proximity == CLProximityImmediate) {
        }
    }
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
@end
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
        if (delegateObject == nil)
			delegateObject = [[GLBBeaconsPlugin alloc] init];
    }
    
    const char* _GetPositionArray ()
    {
        return MakeStringCopy([[delegateObject beaconsJson] UTF8String]);
    }
    
}
