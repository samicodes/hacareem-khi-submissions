//
//  DataManager.h
//  HaCareem-3
//
//  Created by Hyder@WhisperO on 29/04/2017.
//  Copyright © 2017 Hyder@WhisperO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropOffSuggestion.h"

extern NSString * const baseURL;

@interface DataManager : NSObject

+ (void)getSuggestionsBy:(NSString*)cloudCodeName andData:(NSDictionary*)params withCallback:(void(^)(NSMutableArray *suggestionsArray, NSString *error))callback;

@end
