//
//  TravelRoute.h
//  NYEpsilon
//
//  Created by Stephen on 4/3/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TravelRoute : NSObject

@property (nonatomic, strong) NSString *arrivalTime;
@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) NSString *startAddress;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *endAddress;
@property (nonatomic, strong) CLLocation *endLocation;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, assign) NSInteger numberOfSteps;
@property (nonatomic, assign) BOOL walkingOnly;

@property (nonatomic, strong) NSArray *steps;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
