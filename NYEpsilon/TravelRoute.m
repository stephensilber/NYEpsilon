//
//  TravelRoute.m
//  NYEpsilon
//
//  Created by Stephen on 4/3/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "WalkingStep.h"
#import "TransitStep.h"
#import "TravelRoute.h"

@implementation TravelRoute

- (id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {

        // Assign some TravelRoute details from JSON response
        self.duration       = [[dictionary objectForKey:@"duration"] objectForKey:@"text"];
        self.distance       = [[dictionary objectForKey:@"distance"] objectForKey:@"text"];
        self.arrivalTime    = [[dictionary objectForKey:@"arrival_time"] objectForKey:@"text"];
        self.departureTime  = [[dictionary objectForKey:@"departure_time"] objectForKey:@"text"];
        self.startAddress   = [dictionary objectForKey:@"start_address"];
        self.endAddress     = [dictionary objectForKey:@"end_address"];
        self.walkingOnly    = YES;
        // Make CLLocations for start/end locations (will be used to display on GoogleMap with polyline (later)
        self.startLocation = [[CLLocation alloc] initWithLatitude:[[[dictionary objectForKey:@"start_location"] objectForKey:@"lat"] floatValue]
                                                        longitude:[[[dictionary objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]];
        self.endLocation = [[CLLocation alloc] initWithLatitude:[[[dictionary objectForKey:@"end_location"] objectForKey:@"lat"] floatValue]
                                                        longitude:[[[dictionary objectForKey:@"end_location"] objectForKey:@"lng"] floatValue]];
        
        self.steps = [[NSArray alloc] init];
        NSMutableArray *temporarySteps = [NSMutableArray array];
        
        // Not using waypoints, we can assume we will only have 1 leg
        if([dictionary objectForKey:@"steps"] && [[dictionary objectForKey:@"steps"] count] > 0) {
            NSArray *steps = [dictionary objectForKey:@"steps"];
            
            // Build up TravelRoute steps (either walking or transit objects)
            for(NSDictionary *step in steps) {
                if([[step objectForKey:@"travel_mode"] isEqualToString:@"TRANSIT"]) {
                    self.walkingOnly = NO;
                    TransitStep *transitStep = [[TransitStep alloc] initWithDictionary:step];
                    transitStep.transitDetails = [step objectForKey:@"transit_details"];
                    [temporarySteps addObject:transitStep];
                } else if([[step objectForKey:@"travel_mode"] isEqualToString:@"WALKING"]) {
                    WalkingStep *walkingStep = [[WalkingStep alloc] initWithDictionary:step];
                    walkingStep.walkingSteps = [step objectForKey:@"steps"];
                    [temporarySteps addObject:walkingStep];
                } else {
                    // We have a different type of transit step that we don't know how to handle
                    // We should not return incomplete results to the consumer, cancel the route
                    NSLog(@"ERROR: Could not create TravelRoute, we have an unknown travel_mode: %@", [step objectForKey:@"travel_mode"]);
                    return nil;
                }
            }
            self.steps = temporarySteps;
        }
    }
    
    return self;
}
@end


/* EXAMPLE QUERY
 "arrival_time": {},
 "departure_time": {},
 "distance": {},
 "duration": {},
 "end_address": "2-12 Myrtle Avenue, Troy, NY 12180, USA",
 "end_location": {},
 "start_address": "SAGE AVE AT STUDENT UNION(11949), Rensselaer Polytechnic Institute, Troy, NY 12180, USA",
 "start_location": {},
*/