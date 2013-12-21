//
//  TransportationViewController.m
//  
//
//  Created by Stephen Silber on 12/20/13.
//
//

#import "AFNetworking.h"
#import "TransportCell.h"
#import "TransportationViewController.h"
#import "TransportationRouteViewController.h"

#define k_TRANSIT_TO_HOUSE @"http://maps.googleapis.com/maps/api/directions/json?mode=transit&alternatives=true&origin=42.729953,-73.6766118&destination=42.710561,-73.66694999999999&sensor=false&departure_time="
#define k_TRANSIT_FROM_HOUSE @"http://maps.googleapis.com/maps/api/directions/json?mode=transit&alternatives=true&destination=42.729953,-73.6766118&origin=42.710561,-73.66694999999999&sensor=false&departure_time="
#define k_HOUSE_COORDS @"42.710561,-73.66694999999999"
#define k_RPI_COORDS @"42.729953,-73.6766118"

@interface TransportationViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *routes;
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

- (void) fetchBusSchedule:(NSString *)route_url {
    NSInteger currentTime = round([[NSDate date] timeIntervalSince1970]);
    NSString *urlString = [NSString stringWithFormat:@"%@%i", route_url, currentTime];
    NSLog(@"Request URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.routes = [NSMutableArray array];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // routes -> legs ->

        for (NSDictionary *route in [responseObject objectForKey:@"routes"]) {
            [self.routes addObject:route];
        }
        NSLog(@"Adding %i routes!", self.routes.count);
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request raised an error and reset activity indicator to refresh button
        NSLog(@"Request to download transit data failed: %@\n\n", error);
    }];
    
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchBusSchedule:k_TRANSIT_TO_HOUSE];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"transportCell";
    
    TransportCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TransportCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *route = [self.routes objectAtIndex:indexPath.row];
    cell.durationLabel.text = [[[[route objectForKey:@"legs"] firstObject] objectForKey:@"duration"] objectForKey:@"text"];
    cell.distanceLabel.text = [[[[route objectForKey:@"legs"] firstObject] objectForKey:@"distance"] objectForKey:@"text"];
    cell.numStepsLabel.text = [NSString stringWithFormat:@"%i steps", [[[[route objectForKey:@"legs"] firstObject] objectForKey:@"steps"] count]];
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"TransportationRouteViewController"])
    {
        // Get reference to the destination view controller
        TransportationRouteViewController *vc = [segue destinationViewController];
        NSDictionary *route = [self.routes objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        vc.routeInfo = [[route objectForKey:@"legs"] firstObject];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
