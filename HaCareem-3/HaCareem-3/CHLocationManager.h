//
//  CHLocationManager.h
//  WhisperO
//
//  Created by Oun Abbas on 15/06/2015.
//  Copyright (c) 2015 CodingHazard. All rights reserved.
//


#import <foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class CHLocationManager;

@protocol CHLocationManagerDelegate <NSObject>

@optional
-(void)CHLocationManager:(CHLocationManager *) locationManager LocationChanged:(CLLocation *) location;
-(void)CHLocationManager:(CHLocationManager *) locationManager AddressChanged:(NSString *) Address;
@end


@interface CHLocationManager : NSObject< CLLocationManagerDelegate > {
    NSInteger _addressFindRetries;
}

+ (id)sharedObject;

@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (strong, nonatomic) CLLocation *CurrentLocation;
@property (strong, nonatomic) NSString *CurrentAddress;
@property (weak, nonatomic) id<CHLocationManagerDelegate> delegate;

@end

