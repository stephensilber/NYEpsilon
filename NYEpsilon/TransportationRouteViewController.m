//
//  TransportationRouteViewController.m
//  NYEpsilon
//
//  Created by Stephen Silber on 12/20/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "NSString+HTML.h"
#import "NSString+stripHTML.h"
#import "TravelRoute.h"
#import "TransitStep.h"
#import "WalkingStep.h"
#import "TransitDetailCell.h"
#import "WalkingDetailCell.h"
#import "TransportationRouteViewController.h"

@implementation GMSPolyline (GMSPolyline_EncodedString)

+ (NSMutableArray *) decodePolyline:(NSString *)encodedPoints {
    int len = [encodedPoints length];
    NSMutableArray *waypoints = [[NSMutableArray alloc] init];
    int index = 0;
    float lat = 0;
    float lng = 0;

    while (index < len) {
      char b;
      int shift = 0;
      int result = 0;
      do {
          b = [encodedPoints characterAtIndex:index++] - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
      } while (b >= 0x20);
      
      float dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      
      shift = 0;
      result = 0;
      do {
          b = [encodedPoints characterAtIndex:index++] - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
      } while (b >= 0x20);
      
      float dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      
      float finalLat = lat * 1e-5;
      float finalLong = lng * 1e-5;
      
      NSSet *newPoint = [[NSSet alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%f", finalLat], [[NSString alloc] initWithFormat:@"%f", finalLong], nil];
      [waypoints addObject:newPoint];
    }
    return waypoints;
    }

@end


@interface TransportationRouteViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@end

@implementation TransportationRouteViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) doubleTapNavBar:(id) sender {
    // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
    // kGMSTypeTerrain, kGMSTypeNone
    
    if(self.mapView.mapType == kGMSTypeNormal) {
        self.mapView.mapType = kGMSTypeHybrid;
    } else {
        self.mapView.mapType = kGMSTypeNormal;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    const CGFloat mapViewHeight = 175.0f;
    self.mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, mapViewHeight)];
    self.mapView.myLocationEnabled = YES;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.route.startLocation.coordinate zoom:18];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = self.route.startLocation.coordinate;
    marker.title = [self.route.startAddress stripHtml];
    marker.map = self.mapView;

    self.mapView.camera = camera;
    self.tableView.tableHeaderView = self.mapView;
    
    // Double tap navigationBar to toggle map type between normal/satellite
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapNavBar:)];
    taps.numberOfTapsRequired = 2;
    
    [self.navigationController.navigationBar addGestureRecognizer:taps];
    
    self.title = (self.route.walkingOnly) ? @"Walking Route" : @"Bus Route";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView delegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    // Keep tableview from scrolling down
    if(scrollView.contentOffset.y < -64.0f) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -64.0f);
    }
}

- (BOOL) isRouteStepWalking:(NSIndexPath *) indexPath {
    if(self.route.walkingOnly) {
        return YES;
    }
    
    if([[self.route.steps objectAtIndex:indexPath.section] isKindOfClass:[WalkingStep class]]) {
        return YES;
    }
    
    return NO;
}


#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self isRouteStepWalking:indexPath])
        return 70.0f;
    
    return 150.0f;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.route.steps objectAtIndex:section] travelMode];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections as number of overall steps
    return self.route.steps.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[self.route.steps objectAtIndex:section] isKindOfClass:[TransitStep class]]) {
        // We only have one cell to display
        return 1;
    } else {
        // We have multiple steps for the walking directions
        return [[[self.route.steps objectAtIndex:section] walkingSteps] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView transitCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"transitDetailCell";
    TransitDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TransitStep *transitStep = [self.route.steps objectAtIndex:indexPath.section];
    NSDictionary *transit = [[self.route.steps objectAtIndex:indexPath.section] transitDetails];
    
    cell.departureTime.text = [[transit objectForKey:@"departure_time"] objectForKey:@"text"];
    cell.arrivalTime.text = [[transit objectForKey:@"arrival_time"] objectForKey:@"text"];
    
    cell.departureStop.text = [[[transit objectForKey:@"departure_stop"] objectForKey:@"name"] stripHtml];
    cell.arrivalStop.text = [[[transit objectForKey:@"arrival_stop"] objectForKey:@"name"] stripHtml];
    
    cell.duration.text = transitStep.duration;
    cell.distance.text = transitStep.distance;
    cell.numberOfStop.text = [NSString stringWithFormat:@"%@ stops", [[transit objectForKey:@"num_stops"] stringValue]];
    
    cell.busNumber.text = [[transit objectForKey:@"line"] objectForKey:@"short_name"];
    cell.busNumber.layer.cornerRadius = (cell.busNumber.layer.frame.size.width/2);
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Format bus cells differently than walking cells
    if([self isRouteStepWalking:indexPath] == NO) {
        return [self tableView:tableView transitCellForRowAtIndexPath:indexPath];
    }
    
    static NSString *CellIdentifier = @"walkingDetailCell";
    WalkingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *step = [[[self.route.steps objectAtIndex:indexPath.section] walkingSteps] objectAtIndex:indexPath.row];
    
    cell.duration.text      = [[step objectForKey:@"duration"] objectForKey:@"text"];
    cell.description.text   = [[step objectForKey:@"html_instructions"] stripHtml];
    cell.distance.text      = [[step objectForKey:@"distance"] objectForKey:@"text"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Currently not deselecting row to help user keep track of which step they pressed
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.mapView clear];
    
    CLLocation *routeStepLocation;
    if([self isRouteStepWalking:indexPath] == NO) {
        NSDictionary *transit = [[self.route.steps objectAtIndex:indexPath.section] transitDetails];
        float lat = [[[[transit objectForKey:@"departure_stop"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        float lng = [[[[transit objectForKey:@"departure_stop"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        routeStepLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    } else {
        NSDictionary *step = [[[self.route.steps objectAtIndex:indexPath.section] walkingSteps] objectAtIndex:indexPath.row];
        float lat = [[[step objectForKey:@"start_location"] objectForKey:@"lat"] floatValue];
        float lng = [[[step objectForKey:@"start_location"] objectForKey:@"lng"] floatValue];
        routeStepLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    }
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:routeStepLocation.coordinate zoom:17];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = routeStepLocation.coordinate;
    marker.title = @"Start";
    marker.map = self.mapView;
    
    self.mapView.camera = camera;
    [tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

@end
