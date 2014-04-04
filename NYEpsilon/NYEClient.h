//
//  NYESessionManager.h
//  NYEpsilon
//
//  Created by Stephen Silber on 11/27/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface NYEClient : AFHTTPSessionManager

+ (NYEClient *)sharedClient;
- (NSURLSessionDataTask *)brothersGivingRides:(BOOL) party completion:(void (^)(NSArray *results, NSError *error) )completion;
- (NSURLSessionDataTask *)brothersFromClass:(NSString *)class completion:( void (^)(NSArray *results, NSError *error) )completion;
- (NSURLSessionDataTask *)eventsFromMonth:(NSString *)startMonth untilMonth:(NSString *)endMonth completion:( void (^)(NSDictionary *results, NSError *error) )completion;

@end
