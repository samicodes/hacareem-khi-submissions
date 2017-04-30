//
//  CHImageCache.h
//  WhisperO
//
//  Created by Oun Abbas on 01/07/2015.
//  Copyright (c) 2015 CodingHazard. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^cache_imageloaded_block)(UIImage*);


@interface CHCache : NSObject

+ (void) resetCache;

+ (void) setObject:(NSData*)data forKey:(NSString*)key;
+ (id) objectForKey:(NSString*)key;
+ (NSString*) objectPathForKey:(NSString*)key;

+ (void) loadImageFromURL:(NSString*)URL block:(cache_imageloaded_block)block;
@end
