//
//  GLBViewController.h
//  iBeaconReceiver
//
//  Created by Camila Gaitan Mosquera on 4/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GLBViewController : UIViewController<CLLocationManagerDelegate>


@property(weak,nonatomic)IBOutlet UILabel * iBeaconStatus;
@property(weak,nonatomic)IBOutlet UILabel * iBeaconUDID;
@property(weak,nonatomic)IBOutlet UILabel * iBeaconMajor;
@property(weak,nonatomic)IBOutlet UILabel * iBeaconMinor;
@property(strong,nonatomic)CLLocationManager *locationManager;
@property(strong,nonatomic)CLBeaconRegion *iBeaconRegion;

@end
