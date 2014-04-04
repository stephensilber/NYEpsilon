//
//  NYETransportationClient.h
//  NYEpsilon
//
//  Created by Stephen on 4/3/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AFNetworking.h"

@interface NYETransportationClient : AFHTTPSessionManager

+ (NYETransportationClient *)sharedClient;
//- (NSURLSessionDataTask *)routeFromStartingLocation:(CLLocation *)start toEndingLocation:(CLLocation *)end completion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)routeFromSAEtoCampusWithcompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)routeToSAEfromStartingLocation:(CLLocation *)start completion:( void (^)(NSDictionary *results, NSError *error) )completion;
@end
