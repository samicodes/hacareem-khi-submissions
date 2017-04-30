//
//  CHUIImageViewCategory.h
//  WhisperMapBox
//
//  Created by Ali Abdul Jabbar on 16/05/2015.
//  Copyright (c) 2015 Whisper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (additions)

-(UIImage*)makeRoundCornersWithRadius:(const CGFloat)RADIUS;
-(UIImage *)cropImage:(CGRect)dimension;
- (UIImage *)scaleImage:(CGSize)newSize;
- (UIImage *)imageWithImage:(CGSize)size;

- (UIImage *)mergeImages:(UIImage *)image2 withMarkerImageNamed:(NSString*)imageName;
- (UIImage *)mergeImagesForCluster:(UIImage *)image2 withMarkerImageNamed:(NSString*)imageName;

- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;


- (UIImage *)mergeImages:(UIImage *)image2 withMarkerImage:(UIImage*)image1;
- (UIImage *)mergeImagesForCluster:(UIImage *)image2 withMarkerImage:(UIImage*)image1;
@end

