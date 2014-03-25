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
@property (weak, nonatomic) IBOutlet UILabel *detectedBeaconsLabel;
@property (weak, nonatomic) IBOutlet UILabel *distancesLabel;
@property (weak, nonatomic) IBOutlet UILabel *closestBeaconLabel;

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
    if ([self.receivedBeaconDistances count] >=3){

        
        NSMutableArray *P1 = [[NSMutableArray alloc] initWithCapacity:0];
        [P1 addObject:@([self pointForBeaconWithMinor:1].x)];
        [P1 addObject:@([self pointForBeaconWithMinor:1].y)];
        
        
        NSMutableArray *P2 = [[NSMutableArray alloc] initWithCapacity:0];
        [P2 addObject:@([self pointForBeaconWithMinor:2].x)];
        [P2 addObject:@([self pointForBeaconWithMinor:2].y)];
        
        NSMutableArray *P3 = [[NSMutableArray alloc] initWithCapacity:0];
        [P3 addObject:@([self pointForBeaconWithMinor:3].x)];
        [P3 addObject:@([self pointForBeaconWithMinor:3].y)];
        
        //this is the distance between all the points and the unknown point
        double DistA = [self.receivedBeaconDistances[@1] floatValue];;
        double DistB = [self.receivedBeaconDistances[@2] floatValue];;
        double DistC = [self.receivedBeaconDistances[@3] floatValue];;
        
        // ex = (P2 - P1)/(numpy.linalg.norm(P2 - P1))
        NSMutableArray *ex = [[NSMutableArray alloc] initWithCapacity:0];
        double temp = 0;
        for (int i = 0; i < [P1 count]; i++) {
            double t1 = [[P2 objectAtIndex:i] doubleValue];
            double t2 = [[P1 objectAtIndex:i] doubleValue];
            double t = t1 - t2;
            temp += (t*t);
        }
        for (int i = 0; i < [P1 count]; i++) {
            double t1 = [[P2 objectAtIndex:i] doubleValue];
            double t2 = [[P1 objectAtIndex:i] doubleValue];
            double exx = (t1 - t2)/sqrt(temp);
            [ex addObject:[NSNumber numberWithDouble:exx]];
        }
        
        // i = dot(ex, P3 - P1)
        NSMutableArray *p3p1 = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < [P3 count]; i++) {
            double t1 = [[P3 objectAtIndex:i] doubleValue];
            double t2 = [[P1 objectAtIndex:i] doubleValue];
            double t3 = t1 - t2;
            [p3p1 addObject:[NSNumber numberWithDouble:t3]];
        }
        
        double ival = 0;
        for (int i = 0; i < [ex count]; i++) {
            double t1 = [[ex objectAtIndex:i] doubleValue];
            double t2 = [[p3p1 objectAtIndex:i] doubleValue];
            ival += (t1*t2);
        }
        
        // ey = (P3 - P1 - i*ex)/(numpy.linalg.norm(P3 - P1 - i*ex))
        NSMutableArray *ey = [[NSMutableArray alloc] initWithCapacity:0];
        double p3p1i = 0;
        for (int  i = 0; i < [P3 count]; i++) {
            double t1 = [[P3 objectAtIndex:i] doubleValue];
            double t2 = [[P1 objectAtIndex:i] doubleValue];
            double t3 = [[ex objectAtIndex:i] doubleValue] * ival;
            double t = t1 - t2 -t3;
            p3p1i += (t*t);
        }
        for (int i = 0; i < [P3 count]; i++) {
            double t1 = [[P3 objectAtIndex:i] doubleValue];
            double t2 = [[P1 objectAtIndex:i] doubleValue];
            double t3 = [[ex objectAtIndex:i] doubleValue] * ival;
            double eyy = (t1 - t2 - t3)/sqrt(p3p1i);
            [ey addObject:[NSNumber numberWithDouble:eyy]];
        }
        
        
        // ez = numpy.cross(ex,ey)
        // if 2-dimensional vector then ez = 0
        NSMutableArray *ez = [[NSMutableArray alloc] initWithCapacity:0];
        double ezx;
        double ezy;
        double ezz;
        if ([P1 count] !=3){
            ezx = 0;
            ezy = 0;
            ezz = 0;
            
        }else{
            ezx = ([[ex objectAtIndex:1] doubleValue]*[[ey objectAtIndex:2]doubleValue]) - ([[ex objectAtIndex:2]doubleValue]*[[ey objectAtIndex:1]doubleValue]);
            ezy = ([[ex objectAtIndex:2] doubleValue]*[[ey objectAtIndex:0]doubleValue]) - ([[ex objectAtIndex:0]doubleValue]*[[ey objectAtIndex:2]doubleValue]);
            ezz = ([[ex objectAtIndex:0] doubleValue]*[[ey objectAtIndex:1]doubleValue]) - ([[ex objectAtIndex:1]doubleValue]*[[ey objectAtIndex:0]doubleValue]);
            
        }
        
        [ez addObject:[NSNumber numberWithDouble:ezx]];
        [ez addObject:[NSNumber numberWithDouble:ezy]];
        [ez addObject:[NSNumber numberWithDouble:ezz]];
        
        
        // d = numpy.linalg.norm(P2 - P1)
        double d = sqrt(temp);
        
        // j = dot(ey, P3 - P1)
        double jval = 0;
        for (int i = 0; i < [ey count]; i++) {
            double t1 = [[ey objectAtIndex:i] doubleValue];
            double t2 = [[p3p1 objectAtIndex:i] doubleValue];
            jval += (t1*t2);
        }
        
        // x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
        double xval = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d);
        
        // y = ((pow(DistA,2) - pow(DistC,2) + pow(i,2) + pow(j,2))/(2*j)) - ((i/j)*x)
        double yval = ((pow(DistA,2) - pow(DistC,2) + pow(ival,2) + pow(jval,2))/(2*jval)) - ((ival/jval)*xval);
        
        // z = sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
        // if 2-dimensional vector then z = 0
        double zval;
        if ([P1 count] !=3){
            zval = 0;
        }else{
            zval = sqrt(pow(DistA,2) - pow(xval,2) - pow(yval,2));
        }
        
        // triPt = P1 + x*ex + y*ey + z*ez
        NSMutableArray *triPt = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < [P1 count]; i++) {
            double t1 = [[P1 objectAtIndex:i] doubleValue];
            double t2 = [[ex objectAtIndex:i] doubleValue] * xval;
            double t3 = [[ey objectAtIndex:i] doubleValue] * yval;
            double t4 = [[ez objectAtIndex:i] doubleValue] * zval;
            double triptx = t1+t2+t3+t4;
            [triPt addObject:[NSNumber numberWithDouble:triptx]];
        }
        
        NSLog(@"ex %@",ex);
        NSLog(@"i %f",ival);
        NSLog(@"ey %@",ey);
        NSLog(@"d %f",d);
        NSLog(@"j %f",jval);
        NSLog(@"x %f",xval);
        NSLog(@"y %f",yval);
        NSLog(@"y %f",yval);
        NSLog(@"final result %@",triPt);
        
        
        
        
        return CGPointMake([triPt[0] floatValue], [triPt[1] floatValue]);
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
        if (beaconData.proximity == CLProximityImmediate) {
            self.iBeaconStatus.text=@"Beacon Found";
            
            self.positionLabel.text = [NSString stringWithFormat:@"%f, %f",self.currentCoordinate.x, self.currentCoordinate.y];
            self.detectedBeaconsLabel.text = [[self.receivedBeaconDistances allKeys] componentsJoinedByString:@","];
            
            self.distancesLabel.text = [[self.receivedBeaconDistances allValues] componentsJoinedByString:@", "];
            self.closestBeaconLabel.text = [NSString stringWithFormat:@"%@",beaconData.minor];
            
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
