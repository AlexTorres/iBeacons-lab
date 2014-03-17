//
//  GLBViewController.h
//  BroadcastingApp
//
//  Created by Camila Gaitan Mosquera on 4/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface GLBViewController : UIViewController<CBPeripheralManagerDelegate>


@property(strong,nonatomic)IBOutlet UILabel * IBeaconStatus;
@property(strong,nonatomic)CLBeaconRegion *iBeaconRegion;
@property(strong,nonatomic)NSDictionary *iBeaconData;
@property(strong,nonatomic)CBPeripheralManager *iBeaconManager;


@end
