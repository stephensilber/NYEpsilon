//
//  NYETransportationClient.m
//  NYEpsilon
//
//  Created by Stephen on 4/3/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "NYETransportationClient.h"

@implementation NYETransportationClient

#define k_HOUSE_COORDS @"42.710561,-73.66694999999999"
#define k_RPI_COORDS @"42.729953,-73.6766118"
#define k_API_KEY @"AIzaSyA7KfzdQRS20QS_8yRYxe4YXZ-hketXU6k"
/*
 http://maps.googleapis.com/maps/api/directions/json?origin=42.710561,-73.66694999999999&destination=42.729953,-73.6766118&sensor=false&departure_time=1343641500&mode=transit
 http://maps.google.com/maps/api/directions/json?&sensor=false&mode=transit&alternatives=true&key=AIzaSyA4wDX6snAcyzy2-SZSoTq1dRFtQgV-pKc
 */


+ (NYETransportationClient *)sharedClient {
    static NYETransportationClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/directions/"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"NYE iOS 2.0"}];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        _sharedClient = [[NYETransportationClient alloc] initWithBaseURL:baseURL
                                      sessionConfiguration:config];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)routeFromSAEtoCampusWithcompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    NSURLSessionDataTask *task = [self GET:@"json"
                                parameters:@{ @"origin" : k_HOUSE_COORDS,
                                              @"destination" : k_RPI_COORDS,
                                              @"departure_time" : [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]],
                                              @"sensor" : @"false",
                                              @"mode"  : @"transit",
                                              @"alternatives" : @"true",
                                              @"key" : k_API_KEY }
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                       
                                       if (httpResponse.statusCode == 200) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(responseObject, nil);
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, nil);
                                           });
                                           NSLog(@"Received: %@", responseObject);
                                           NSLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
                                       }
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   }];
    
    NSLog(@"Request: %@", task.originalRequest.URL);
    return task;
}

- (NSURLSessionDataTask *)routeToSAEfromStartingLocation:(CLLocation *)start completion:( void (^)(NSDictionary *results, NSError *error) )completion {
    
    NSURLSessionDataTask *task = [self GET:@"json"
                                parameters:@{ @"origin" : (start) ? [NSString stringWithFormat:@"%f,%f", start.coordinate.latitude, start.coordinate.longitude] : k_RPI_COORDS,
                                              @"destination" : k_HOUSE_COORDS,
                                              @"departure_time" : [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]],
                                              @"sensor" : @"false",
                                              @"mode"  : @"transit",
                                              @"alternatives" : @"true",
                                              @"key" : k_API_KEY }
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                       
                                       if (httpResponse.statusCode == 200) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(responseObject, nil);
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, nil);
                                           });
                                           NSLog(@"Received: %@", responseObject);
                                           NSLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
                                       }
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   }];

    NSLog(@"Request: %@", task.originalRequest.URL);
    return task;
}

@end
