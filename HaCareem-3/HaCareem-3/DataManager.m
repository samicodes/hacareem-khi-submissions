//
//  DataManager.m
//  HaCareem-3
//
//  Created by Hyder@WhisperO on 29/04/2017.
//  Copyright © 2017 Hyder@WhisperO. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "DropOffSuggestion.h"

NSString * const baseURL = @"http://172.15.59.153:8081";//@"https://radiant-spire-45688.herokuapp.com";

AFHTTPSessionManager *manager;

@implementation DataManager

+ (void)getSuggestionsBy:(NSString*)cloudCodeName andData:(NSDictionary*)params withCallback:(void(^)(NSMutableArray *suggestionsArray, NSString *error))callback
{
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    
    [manager.operationQueue cancelAllOperations];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    
    [manager POST:[NSString stringWithFormat:@"%@/%@", baseURL,cloudCodeName] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        if (responseObject != [NSNull null])
        {
            for (NSDictionary *object in responseObject)
            {
                DropOffSuggestion *suggestion = [[DropOffSuggestion alloc] initWithJSONObject:object];
                
                [array addObject:suggestion];
            }
            
            //NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"score"  ascending:NO];
            //array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
            //array = [array mutableCopy];
            
            callback(array, nil);
        }
        else
            callback(nil, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"The failure is %@", error);
        
        callback(nil, error.localizedDescription);

        
    }];

}

@end
