//
//  DropOffSuggestion.m
//  HaCareem-3
//
//  Created by Hyder@WhisperO on 29/04/2017.
//  Copyright © 2017 Hyder@WhisperO. All rights reserved.
//

#import "DropOffSuggestion.h"

@implementation DropOffSuggestion

- (instancetype)initWithJSONObject:(NSDictionary *)object
{
    self = [super init];
    if (self) {

        if(!(object[@"dropofflong"] == [NSNull null]))
            _longitude = object[@"dropofflong"];
        
        if(!(object[@"dropofflat"] == [NSNull null]))
            _latitude = object[@"dropofflat"];
        
        if(!(object[@"dropoffaddress"] == [NSNull null]))
            _address = object[@"dropoffaddress"];
        
        if(!(object[@"score"] == [NSNull null]))
            _score = [object[@"score"] intValue];
            
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//        
//        if (((NSString*)object[@"CreatedAt"]).length > 19 )
//            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
//        else
//            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//        
//        NSDate *date = [dateFormat dateFromString:object[@"CreatedAt"]];
//        NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
//        [newDateFormatter setDateFormat:@"dd/MM/yyyy"];
//        NSString *newString = [newDateFormatter stringFromDate:date];
//        
//        //NSLog(@"Date: %@, formatted date: %@", date, newString);
//        
//        _date = date;
    }
    
    return self;
}

@end
