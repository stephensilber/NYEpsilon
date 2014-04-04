//
//  TransitStep.h
//  NYEpsilon
//
//  Created by Stephen on 4/3/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "RouteStep.h"

@interface TransitStep : RouteStep

@property (nonatomic, strong) NSDictionary *transitDetails;
@end
