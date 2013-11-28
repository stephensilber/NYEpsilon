//
//  NYESessionManager.m
//  NYEpsilon
//
//  Created by Stephen Silber on 11/27/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//


#import "NYEClient.h"

@implementation NYEClient


+ (NYEClient *)sharedClient {
    static NYEClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"http://nyepsilon.herokuapp.com/api/"];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"NYE iOS 2.0"}];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        
        _sharedClient = [[NYEClient alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:config];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)brothersFromClass:(NSString *)class completion:( void (^)(NSArray *results, NSError *error) )completion {
    
    /* Option for searching for individual classes - DEFAULT: Actives */
//    NSMutableDictionary *params = nil;
//    if(class) {
//        [params setObject:class forKey:@"class"];
//    }
    
    NSURLSessionDataTask *task = [self GET:[NSString stringWithFormat:@"brothers/%@", (class) ? class : @"active"]
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                       if (httpResponse.statusCode == 200) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(responseObject[@"results"], nil);
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, nil);
                                           });
                                           NSLog(@"Received: %@", responseObject);
                                           NSLog(@"Received HTTP %d", httpResponse.statusCode);
                                       }
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   }];
    return task;
    
}

@end