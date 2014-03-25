//
//  GLBViewController.m
//  BroadcastingApp
//
//  Created by Camila Gaitan Mosquera on 4/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBViewController.h"


@interface GLBViewController () <GLBBeaconAdvertiserDelegate>

@property(strong,nonatomic) IBOutlet UILabel * statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
@property (weak, nonatomic) IBOutlet UITextField *minorTextField;
@property (weak, nonatomic) IBOutlet UIButton *broadcastButton;

@property(strong,nonatomic) GLBBeaconAdvertiser *beaconAdvertiser;

@end

@implementation GLBViewController

#pragma mark - Properties

#define UDID @"B7A78FBB-103E-4851-AEC5-319780B77B9F"
#define IDENTIFIER @"com.globant.ibeacon"

- (GLBBeaconAdvertiser *)beaconAdvertiser
{
    if(!_beaconAdvertiser){
        _beaconAdvertiser = [[GLBBeaconAdvertiser alloc] init];
        _beaconAdvertiser.delegate = self;
        _beaconAdvertiser.beaconIdentifier = IDENTIFIER;
        _beaconAdvertiser.beaconUUDID = [[NSUUID alloc] initWithUUIDString:UDID];
        _beaconAdvertiser.beaconMajor = [self.majorTextField.text integerValue];
        _beaconAdvertiser.beaconMinor = [self.minorTextField.text integerValue];
    }
    
    return _beaconAdvertiser;
}

#pragma mark- ViewController Actions

- (IBAction)didSelectBroadcastButton:(UIButton *)sender
{
    if (self.beaconAdvertiser.isAdvertising) {
        [self.beaconAdvertiser stopAdvertising];
        [sender setTitle:@"Start Broadcast" forState:UIControlStateNormal];
        self.statusLabel.text = @"Stopped";
    }
    else {
         self.statusLabel.text = @"Broadcasting...";
        [self.beaconAdvertiser startAdvertising];
        [sender setTitle:@"Stop Broadcast" forState:UIControlStateNormal];
    }
}

#pragma mark - BeaconBroadcasterDelegate

- (void)advertiser:(GLBBeaconAdvertiser *)beaconBroadcaster
   didFailWithError:(NSError *)error
{
    NSInteger code = error.code;
    switch (code) {
        case GLBBluetoothOff:
            self.statusLabel.text = @"Bluetooth is off";
            break;
        case GLBBeaconUnsupported:
            self.statusLabel.text = @"Beacon functionality is unsupported";
            break;
        case GLBBluetoothRestricted:
            self.statusLabel.text = @"Bluetooth is restricted";
            break;
        default:
            self.statusLabel.text = @"Unknown Error";
            break;
    }
    [self.broadcastButton setTitle:@"Start Broadcast" forState:UIControlStateNormal];

}

#pragma mark - TextField Delegate

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    if (textField == self.majorTextField){
        self.beaconAdvertiser.beaconMajor = [self.majorTextField.text integerValue];
    } else if (textField == self.minorTextField){
        self.beaconAdvertiser.beaconMinor = [self.minorTextField.text integerValue];
    }
    return YES;
}

@end
