//
//  RouteStep.h
//  NYEpsilon
//
//  Created by Stephen on 4/3/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RouteStep : NSObject

@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *travelMode;
@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) CLLocation *endLocation;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
