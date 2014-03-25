//
//  GLBViewController.m
//  iBeaconReceiver
//
//  Created by Mauricio Santos on 3/25/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "GLBViewController.h"


#define UDID @"B7A78FBB-103E-4851-AEC5-319780B77B9F"

@interface GLBViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property(weak,nonatomic)IBOutlet UILabel * iBeaconStatus;

@property(strong,nonatomic)CLLocationManager *locationManager;
@property(strong,nonatomic)CLBeaconRegion *iBeaconRegion;

@property(nonatomic,strong)  NSMutableDictionary *receivedBeaconDistances;
@property(nonatomic,readonly)  CGPoint currentCoordinate;

@end

@implementation GLBViewController


#pragma mark - Properties

-(NSMutableDictionary *)receivedBeaconDistances
{
    if (!_receivedBeaconDistances) {
        _receivedBeaconDistances = [[NSMutableDictionary alloc] init];
    }
    return _receivedBeaconDistances;
}


-(CGPoint)currentCoordinate
{
    if ([self.receivedBeaconDistances count] ==3){
        CGPoint a = [self pointForBeaconWithMinor:1];
        CGPoint b = [self pointForBeaconWithMinor:2];
        CGPoint c = [self pointForBeaconWithMinor:2];
        
        CGFloat dA = [self.receivedBeaconDistances[@1] floatValue];
        CGFloat dB = [self.receivedBeaconDistances[@2] floatValue];
        CGFloat dC = [self.receivedBeaconDistances[@3] floatValue];
        
        
        CGFloat W, Z, x, y, y2;
        W = dA*dA - dB*dB - a.x*a.x - a.y*a.y + b.x*b.x + b.y*b.y;
        Z = dB*dB - dC*dC - b.x*b.x - b.y*b.y + c.x*c.x + c.y*c.y;
        
        x = (W*(c.y-b.y) - Z*(b.y-a.y)) / (2 * ((b.x-a.x)*(c.y-b.y) - (c.x-b.x)*(b.y-a.y)));
        y = (W - 2*x*(b.x-a.x)) / (2*(b.y-a.y));
        y2 = (Z - 2*x*(c.x-b.x)) / (2*(c.y-b.y));
        
        y = (y + y2) / 2;
        return CGPointMake(x, y);
    }
    return CGPointMake(-1, -1);
    
}

-(CLBeaconRegion *)iBeaconRegion
{
    if(!_iBeaconRegion){
        NSUUID *iBeaconudid=[[NSUUID alloc] initWithUUIDString:UDID];
        _iBeaconRegion =[[CLBeaconRegion alloc] initWithProximityUUID:iBeaconudid identifier:@"com.globant.ibeacon"];
    }
    return _iBeaconRegion;
}

-(CLLocationManager *)locationManager
{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSArray *filteredBeacons = [self filteredBeacons:beacons];
    for (CLBeacon *beaconData in filteredBeacons) {
        self.receivedBeaconDistances[beaconData.minor] = @(beaconData.accuracy);
    }
    
    self.iBeaconStatus.text=@"Beacon Found";
    
    self.positionLabel.text = [NSString stringWithFormat:@"%f, %f",self.currentCoordinate.x, self.currentCoordinate.y];
}


-(CGPoint) pointForBeaconWithMinor:(NSUInteger)minor
{
    if(minor==1){
        return CGPointMake(0, 0);
    }
    else if(minor==2){
        return CGPointMake(0, 10);
    } else{
        return CGPointMake(5, 10);
    }
}



@end
