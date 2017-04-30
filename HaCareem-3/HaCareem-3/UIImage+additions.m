//
//  CHUIImageViewCategory.m
//  WhisperMapBox
//
//  Created by Ali Abdul Jabbar on 16/05/2015.
//  Copyright (c) 2015 Whisper. All rights reserved.
//

#import "UIImage+additions.h"

@implementation UIImage (additions)
-(UIImage*)makeRoundCornersWithRadius:(const CGFloat)RADIUS {
    UIImage *image = self;
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    const CGRect RECT = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:RADIUS] addClip];
    // Draw your image
    [image drawInRect:RECT];
    
    // Get the image, here setting the UIImageView image
    //imageView.image
    UIImage* imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
//    UIImage *firstImage = [UIImage imageNamed:@"s_pin"];
//    
//    [firstImage drawAtPoint:CGPointMake(roundf((newImageSize.width-firstImage.size.width)/2),
//                                        roundf((newImageSize.height-firstImage.size.height)/2))];
//    [secondImage drawAtPoint:CGPointMake(roundf((newImageSize.width-secondImage.size.width)/2),
//                                         roundf((newImageSize.height-secondImage.size.height)/2))];
    
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageNew;
}

-(UIImage *)cropImage:(CGRect)dimension {
    UIImage *image = self;
    CGSize actSize = image.size;
    if(actSize.width > actSize.height)
        dimension.size.width = dimension.size.height;
    else
        dimension.size.height = dimension.size.width;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], dimension);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)imageWithImage:(CGSize)size {
    UIImage *image = self;
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaleImage:(CGSize)newSize {
    UIImage *image = self;
    CGSize actSize = image.size;
    float scale = actSize.width/actSize.height;
    
    if (scale < 1)
        newSize.height = newSize.width/scale;
    else
        newSize.width = newSize.height*scale;
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)mergeImages:(UIImage *)image2 withMarkerImageNamed:(NSString*)imageName
{
    
    UIImage *image1 = [UIImage imageNamed:imageName/*@"s_pin"*/];
    
    NSLog(@"%f --- %f",image1.size.width,image1.size.height);
    NSLog(@"%f --- %f",image2.size.width,image2.size.height);
    
    CGSize size = CGSizeMake(73/*image1.size.width*/, 73/*image1.size.height*/);
    
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    
    
    
    [image2 drawInRect:CGRectMake(0.5+4.75, 0.6/*+2.3*/,size.width - 10.5, size.height - 10.5)];
    [image1 drawInRect:CGRectMake(0,0,size.width, size.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
       
    return finalImage;
    
}

- (UIImage *)mergeImagesForCluster:(UIImage *)image2 withMarkerImageNamed:(NSString*)imageName
{
    
    UIImage *image1 = [UIImage imageNamed:imageName/*@"c_pin"*/];
    
    NSLog(@"%f --- %f",image1.size.width,image1.size.height);
    NSLog(@"%f --- %f",image2.size.width,image2.size.height);
    
    CGSize size = CGSizeMake(77/*image1.size.width*/, 71/*image1.size.height*/);
    
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    
    
    
    [image2 drawInRect:CGRectMake(0.5+11.60, 2.6/*+2.0*/,size.width - 12.5, size.height - 12.5)];
    [image1 drawInRect:CGRectMake(0,0,size.width, size.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return finalImage;
    
}

- (UIImage *)mergeImages:(UIImage *)image2 withMarkerImage:(UIImage*)image1
{
    //NSLog(@"%f --- %f",image1.size.width,image1.size.height);
    //NSLog(@"%f --- %f",image2.size.width,image2.size.height);
    
    CGSize size = CGSizeMake(63/*image1.size.width*/, 63/*image1.size.height*/);
    
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    
    
    
    [image2 drawInRect:CGRectMake(0.5+4.75, 0.6+1.8,size.width - 10.5, size.height - 10.5)];
    [image1 drawInRect:CGRectMake(0,0,size.width, size.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return finalImage;
    
}

- (UIImage *)mergeImagesForCluster:(UIImage *)image2 withMarkerImage:(UIImage*)image1
{
    
    //UIImage *image1 = [UIImage imageNamed:imageName/*@"c_pin"*/];
    
    //NSLog(@"%f --- %f",image1.size.width,image1.size.height);
    //NSLog(@"%f --- %f",image2.size.width,image2.size.height);
    
    CGSize size = CGSizeMake(67/*image1.size.width*/, 61/*image1.size.height*/);
    
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    
    
    
    [image2 drawInRect:CGRectMake(0.5+11.00, 1.8/*+2.0*/,size.width - 12.0, size.height - 10.0)];
    [image1 drawInRect:CGRectMake(0,0,size.width, size.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return finalImage;
    
}

@end
