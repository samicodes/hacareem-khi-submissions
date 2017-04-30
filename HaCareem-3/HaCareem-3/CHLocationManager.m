//
//  CHLocationManager.m
//  WhisperO
//
//  Created by Oun Abbas on 15/06/2015.
//  Copyright (c) 2015 CodingHazard. All rights reserved.
//

#import "CHLocationManager.h"
#import "SVGeocoder.h"


#define ADDRESS_RETRY_MAX 5


@implementation CHLocationManager

@synthesize
LocationManager = _locationManager,
CurrentLocation = _currentLocation,
CurrentAddress = _formattedAddress,
delegate = _delegate;


#pragma mark Singleton Methods
static CHLocationManager *sharedMyManager = nil;
static dispatch_once_t onceToken;


+ (id)sharedObject {
    if (!sharedMyManager) {
        dispatch_once(&onceToken, ^{
            sharedMyManager = [[self alloc] init];
        });
    }

    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        _currentLocation = _locationManager.location;
        [_locationManager startUpdatingLocation];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"CHLocationManager|locationManagerdidFailWithError| ERROR [%@]",error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    if (_currentLocation.coordinate.latitude != newLocation.coordinate.latitude ||
        _currentLocation.coordinate.longitude != newLocation.coordinate.longitude) {
        
        _currentLocation = [locations lastObject];
        _addressFindRetries = 0;
        
        if (_delegate && [_delegate respondsToSelector:@selector(CHLocationManager:LocationChanged:)]) {
            [_delegate CHLocationManager:self LocationChanged:newLocation];
        }
        [self findAddress:_currentLocation];
    }
    
}

- (void)findAddress:(CLLocation *)location {
    [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error == nil) {
            _addressFindRetries = 0;
            SVPlacemark * placemark = [placemarks firstObject];
            _formattedAddress = placemark.formattedAddress;
            if (_delegate && [_delegate respondsToSelector:@selector(CHLocationManager:AddressChanged:)]) {
                [_delegate CHLocationManager:self AddressChanged:_formattedAddress];
            }
        } else {
            _addressFindRetries++;
            NSLog(@"%@",error);
            if (_addressFindRetries < ADDRESS_RETRY_MAX) {
                [self findAddress:location];
            }
        }
    }];
}
@end
