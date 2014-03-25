//
//  GLBIBeaconBroadcaster.m
//  BroadcastingApp
//
//  Created by Mauricio Santos on 3/21/14.
//

#import "GLBBeaconAdvertiser.h"


@interface GLBBeaconAdvertiser () <CBPeripheralManagerDelegate>
@property (strong, nonatomic, readonly) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (nonatomic, readwrite) BOOL isAdvertising;
@end

@implementation GLBBeaconAdvertiser

#pragma mark - Properties

-(void)setBeaconUUDID:(NSUUID *)beaconUUDID
{
    _beaconUUDID = beaconUUDID;
    [self restartAdvertising];
}

-(void)setBeaconIdentifier:(NSString *)beaconIdentifier
{
    _beaconIdentifier = beaconIdentifier;
    [self restartAdvertising];
}

-(void)setBeaconMajor:(NSUInteger)beaconMajor
{
    _beaconMajor = beaconMajor;
    [self restartAdvertising];
}

-(void)setBeaconMinor:(NSUInteger)beaconMinor
{
    _beaconMinor = beaconMinor;
    [self restartAdvertising];
}

- (CLBeaconRegion *)beaconRegion
{
    return [[CLBeaconRegion alloc] initWithProximityUUID:self.beaconUUDID
                                                   major:self.beaconMajor
                                                   minor:self.beaconMinor
                                              identifier:self.beaconIdentifier];
}

- (CBPeripheralManager *)peripheralManager
{
    if(!_peripheralManager) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
    }
    return _peripheralManager;
}

#pragma mark - Advertiser actions

- (void)restartAdvertising
{
    if (self.isAdvertising) {
        [self stopAdvertising];
        [self startAdvertising];
    }
}

- (void)startAdvertising
{
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        self.isAdvertising = YES;
        [self.peripheralManager startAdvertising:[self.beaconRegion peripheralDataWithMeasuredPower:nil]];
    }
}

- (void)stopAdvertising
{
    if(self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheralManager stopAdvertising];
    }
    
    self.peripheralManager = nil;
    self.isAdvertising = NO;
}

#pragma mark - Errors

- (void)sendErrorMessageWithCode:(NSInteger)code
{
    NSError *error = [NSError errorWithDomain:@"com.globant.BroadcastingApp" code:code userInfo:nil];
    [self.delegate advertiser:self didFailWithError:error];
}

#pragma mark- CBPeripheraDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if(peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self startAdvertising];
    }
    else {
        [self stopAdvertising];
        if(peripheral.state == CBPeripheralManagerStatePoweredOff) {
            [self sendErrorMessageWithCode:GLBBluetoothOff];
        } else if (peripheral.state == CBPeripheralManagerStateUnsupported) {
            [self sendErrorMessageWithCode:GLBBeaconUnsupported];
        } else if (peripheral.state == CBPeripheralManagerStateUnauthorized) {
            [self sendErrorMessageWithCode:GLBBluetoothRestricted];
        } else {
            [self sendErrorMessageWithCode:GLBUnknownError];
        }
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error
{
    if (error) {
        [self stopAdvertising];
        [self sendErrorMessageWithCode:GLBUnknownError];
    }
}

@end
