//
//  CHLocation.h
//  WhisperMapBox
//
//  Created by Osama Khalid on 28/11/2014.
//  Copyright (c) 2014 Whisper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CHLocation : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSNumber * distance;
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic) BOOL aroundMe;


@end
