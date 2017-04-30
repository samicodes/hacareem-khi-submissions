//
//  CHImageCache.m
//  WhisperO
//
//  Created by Oun Abbas on 01/07/2015.
//  Copyright (c) 2015 CodingHazard. All rights reserved.
//
#import "CHCache.h"
#import "NSString+MD5.h"

static NSTimeInterval cacheTime =  (double)604800;

@implementation CHCache

+ (void) resetCache {
    [[NSFileManager defaultManager] removeItemAtPath:[CHCache cacheDirectory] error:nil];
}

+ (NSString*) cacheDirectory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"Caches"];
    return cacheDirectory;
}

+ (NSData*) objectForKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        if ([modificationDate timeIntervalSinceNow] > cacheTime) {
            [fileManager removeItemAtPath:filename error:nil];
        } else {
            NSData *data = [NSData dataWithContentsOfFile:filename];
            return data;
        }
    }
    return nil;
}

+ (NSString*) objectPathForKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        return filename;
    }
    return nil;
}

+ (void) setObject:(NSData*)data forKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSError *error;
    @try {
        [data writeToFile:filename options:NSDataWritingAtomic error:&error];
    }
    @catch (NSException * e) {
        //TODO: error handling maybe
    }
}

+ (void) loadImageFromURL:(NSString*)URL block:(cache_imageloaded_block)block{
    NSURL *imageURL = [NSURL URLWithString:URL];
    NSString *key = [URL MD5Hash];
    NSData *data = [CHCache objectForKey:key];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        block(image);
    } else {
        //imageView.image = [UIImage imageNamed:@"img_def"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [CHCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                //imageView.image = image;
                block(image);
            });
        });
    }
}

@end
