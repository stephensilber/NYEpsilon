//
//  TransportationRouteViewController.h
//  NYEpsilon
//
//  Created by Stephen Silber on 12/20/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface TransportationRouteViewController : UITableViewController <GMSMapViewDelegate>
@property (nonatomic, strong) TravelRoute *route;
@end
