//
//  GLBViewController.m
//  BroadcastingApp
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
    [super viewWillAppear: YES];
    
    //Create the iBeacon  UDID
    
    NSUUID * iBeaconUdid=[[NSUUID alloc] initWithUUIDString:UDID];
    
    //Create the iBeacon Region
    
    self.iBeaconRegion=[[CLBeaconRegion alloc] initWithProximityUUID:iBeaconUdid major:1 minor:2 identifier:@"com.globant.ibeacon"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- ViewControllerActions

-(IBAction)broadcastButton:(id)sender
{
    //Obtain the Beacon Data
    self.iBeaconData=[self.iBeaconRegion peripheralDataWithMeasuredPower:nil];
    
    //Obtain the Bluetooth Status
    self.iBeaconManager=[[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil ];
}

#pragma mark- CBPeripheraDelegate

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            self.IBeaconStatus.text=@"Broadcasting......";
            [self.iBeaconManager startAdvertising:self.iBeaconData];
            break;
        case CBPeripheralManagerStatePoweredOff:
            self.IBeaconStatus.text=@"Stopped......";
            [self.iBeaconManager stopAdvertising];
            break;
        case CBPeripheralManagerStateUnsupported:
            self.IBeaconStatus.text=@"Unsupported......";
            break;
        default:
            break;
    }
}

@end
