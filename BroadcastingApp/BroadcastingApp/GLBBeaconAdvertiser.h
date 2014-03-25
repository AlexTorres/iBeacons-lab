//
//  GLBIBeaconBroadcaster.h
//  BroadcastingApp
//
//  Created by Mauricio Santos on 3/21/14.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class GLBBeaconAdvertiser;
@protocol GLBBeaconAdvertiserDelegate <NSObject>

- (void)advertiser:(GLBBeaconAdvertiser *)beaconAdvertiser didFailWithError:(NSError *)error;

enum broadcastErrorCodes
{
    GLBBluetoothOff,
    GLBBeaconUnsupported,
    GLBBluetoothRestricted,
    GLBUnknownError,
};

@end

@interface GLBBeaconAdvertiser : NSObject

// Required properties. You can modify them while advertising. Not Nil
@property (nonatomic, copy) NSString *beaconIdentifier;
@property (nonatomic, strong) NSUUID *beaconUUDID;
@property (nonatomic) NSUInteger beaconMajor;
@property (nonatomic) NSUInteger beaconMinor;

@property (nonatomic, weak) id<GLBBeaconAdvertiserDelegate> delegate;
@property (nonatomic, readonly) BOOL isAdvertising;

// Set all required properties before advertising.
- (void)startAdvertising;
- (void)stopAdvertising;

@end


