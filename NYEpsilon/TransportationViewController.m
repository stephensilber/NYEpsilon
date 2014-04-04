//
//  TransportationViewController.m
//  
//
//  Created by Stephen Silber on 12/20/13.
//
//

#import "NYEClient.h"
#import "RouteStep.h"
#import "TravelRoute.h"
#import "TransitStep.h"
#import "WalkingStep.h"
#import "AppDelegate.h"
#import "TransportationRideCell.h"
#import "TransportationPublicCell.h"
#import "NYETransportationClient.h"
#import "TransportationViewController.h"
#import "TransportationRouteViewController.h"

@interface TransportationViewController () {
    NSArray *rides;
    NSMutableArray *toHouseBusRoutes;
    NSMutableArray *fromHouseBusRoutes;
    CLLocation *myLocation;
}
@end

@implementation TransportationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) fetchBrothersGivingRides {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *task = [[NYEClient sharedClient] brothersGivingRides:NO completion:^(NSArray *results, NSError *error) {
    if (results) {
            rides = results;
            NSLog(@"Successfully downloaded %lu brothers giving rides", (unsigned long)rides.count);
            [self.tableView reloadData];

        } else {
            NSLog(@"Error fetch rides: %@", error);
        }
    }];
    NSLog(@"Task: %@", task);
}

- (void) fetchBusRoutes {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    // Grab routes to the house from current location (or the union if location services are disabled)
    NSURLSessionDataTask *toHouseTask = [[NYETransportationClient sharedClient] routeToSAEfromStartingLocation:myLocation completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            toHouseBusRoutes = [NSMutableArray array];
            // Success - we have some new routes to display
            for(NSDictionary *route in [results objectForKey:@"routes"]) { // 4 different route options (probably 1 walking)
                TravelRoute *travelRoute = [[TravelRoute alloc] initWithDictionary:[[route objectForKey:@"legs"] firstObject]];
                [toHouseBusRoutes addObject:travelRoute];
            }
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else {
            NSLog(@"Error fetch rides: %@", error);
        }
    }];
    
    // Grab routes from the house to the union
    NSURLSessionDataTask *fromHouseTask = [[NYETransportationClient sharedClient] routeFromSAEtoCampusWithcompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            fromHouseBusRoutes = [NSMutableArray array];
            // Success - we have some new routes to display
            for(NSDictionary *route in [results objectForKey:@"routes"]) { // 4 different route options (probably 1 walking)
                TravelRoute *travelRoute = [[TravelRoute alloc] initWithDictionary:[[route objectForKey:@"legs"] firstObject]];
                [fromHouseBusRoutes addObject:travelRoute];
            }
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else {
            NSLog(@"Error fetch rides: %@", error);
        }
    }];
    
    NSLog(@"To Task: %@", toHouseTask);
    NSLog(@"From Task: %@", fromHouseTask);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Use CLLocationManager in AppDelegate to get current user location
    // Using AppDelegate to get a more accurate positioning of the user on direction request
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myLocation = [appDelegate.locationManager location];
    
    [self setTitle:@"Transportation"];
    [self fetchBrothersGivingRides];
    [self fetchBusRoutes];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 65.0f;
        case 1:
            return 80.0f;
        case 2:
            return 80.0f;
        default:
            return 44.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Brothers Giving Rides";
        case 1:
            return @"TO SAE";
        case 2:
            return @"TO CAMPUS";
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return rides.count;
        case 1:
            return toHouseBusRoutes.count;
        case 2:
            return fromHouseBusRoutes.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView busCellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"publicTranspoCell";
    
    TransportationPublicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TransportationPublicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TravelRoute *route;
    switch (indexPath.section) {
        case 1:
            route = [toHouseBusRoutes objectAtIndex:indexPath.row];
            break;
        case 2:
            route = [fromHouseBusRoutes objectAtIndex:indexPath.row];
        default:
            break;
    }

    // Hide some useless elements if the cell is only for a walking route
    if(route.walkingOnly) {
        cell.arrivalLabel.text = nil;
        cell.arrivalLabelTitle.hidden = YES;
        cell.departureLabel.text = @"Now";
    } else {
        cell.arrivalLabel.text = route.arrivalTime;
        cell.arrivalLabelTitle.hidden = NO;
        cell.departureLabel.text = route.departureTime;
        cell.departureLabelTitle.hidden = NO;
    }
    
    cell.durationLabel.text = route.duration;
    cell.distanceLabel.text = route.distance;
    cell.iconView.image = (route.walkingOnly) ? [UIImage imageNamed:@"walking.png"] : [UIImage imageNamed:@"bus.png"];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView rideCellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"rideCell";
    
    TransportationRideCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TransportationRideCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    NSDictionary *ride = [rides objectAtIndex:indexPath.row];
    
    cell.rideName.text = [ride objectForKey:@"full_name"];
    cell.callIconImageView.image = [UIImage imageNamed:@"phone"];
    
    // Check if we should format the phone number (will expand this into a more sustainable solution later)
    if([[ride objectForKey:@"telephone"] length] == 10) {
        NSMutableString *phoneNumber = [[ride objectForKey:@"telephone"] mutableCopy];
        [phoneNumber insertString:@"(" atIndex:0];
        [phoneNumber insertString:@")" atIndex:4];
        [phoneNumber insertString:@" " atIndex:5];
        [phoneNumber insertString:@"-" atIndex:9];
        cell.rideNumber.text = phoneNumber;
    } else {
        cell.rideNumber.text = [ride objectForKey:@"telephone"];
    }
    
    cell.callIconIndicatorView.image = [UIImage imageNamed:@"arrow_left"];
    
    //Create an animation with pulsating effect
    CABasicAnimation *pulse;
    
    //within the animation we will adjust the "opacity" value of the layer
    pulse=[CABasicAnimation animationWithKeyPath:@"opacity"];
    pulse.duration=0.75;
    pulse.repeatCount= 1e35f;
    pulse.autoreverses=YES;
    pulse.fromValue=[NSNumber numberWithFloat:0.75];
    pulse.toValue=[NSNumber numberWithFloat:0.25];
    
    //Assign the animation to your UIImage layer and the animation will start immediately
    [cell.callIconIndicatorView.layer addAnimation:pulse forKey:@"animateOpacity"];

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return [self tableView:tableView rideCellForRowAtIndexPath:indexPath];
    
    return [self tableView:tableView busCellForRowAtIndexPath:indexPath];
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    NSLog(@"IP: %@", indexPath);
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"routeViewController"]) {
        TravelRoute *route;
        switch (indexPath.section) {
            case 1:
                route = [toHouseBusRoutes objectAtIndex:indexPath.row];
                break;
            case 2:
                route = [fromHouseBusRoutes objectAtIndex:indexPath.row];
                break;
            default:
                break;
        }

        // Get reference to the destination view controller
        TransportationRouteViewController *vc = [segue destinationViewController];
        vc.route = route;
    }
}

@end
