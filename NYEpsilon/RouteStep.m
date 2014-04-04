//
//  RouteStep.m
//  NYEpsilon
//
//  Created by Stephen on 4/3/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "RouteStep.h"

@implementation RouteStep
- (id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    
    if(self) {
       self.distance = [[dictionary objectForKey:@"distance"] objectForKey:@"text"];
       self.duration = [[dictionary objectForKey:@"duration"] objectForKey:@"text"];
       self.travelMode = [dictionary objectForKey:@"travel_mode"];

       // Make CLLocations for start/end locations (will be used to display on GoogleMap with polyline (later)
       self.startLocation = [[CLLocation alloc] initWithLatitude:[[[dictionary objectForKey:@"start_location"] objectForKey:@"lat"] floatValue]
                                                        longitude:[[[dictionary objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]];
       self.endLocation = [[CLLocation alloc] initWithLatitude:[[[dictionary objectForKey:@"end_location"] objectForKey:@"lat"] floatValue]
                                                      longitude:[[[dictionary objectForKey:@"end_location"] objectForKey:@"lng"] floatValue]];
    }
    
    return self;
}
@end
