//
//  DropOffSuggestion.h
//  HaCareem-3
//
//  Created by Hyder@WhisperO on 29/04/2017.
//  Copyright © 2017 Hyder@WhisperO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DropOffSuggestion : NSObject

@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) int score;

- (instancetype)initWithJSONObject:(NSDictionary *)object;

@end
