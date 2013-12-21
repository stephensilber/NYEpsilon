//
//  TransportationRouteViewController.m
//  NYEpsilon
//
//  Created by Stephen Silber on 12/20/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "NSString+stripHTML.h"
#import "TransportationRouteViewController.h"

@interface TransportationRouteViewController ()
@property (nonatomic, strong) NSArray *steps;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.steps = [self.routeInfo objectForKey:@"steps"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.routeInfo objectForKey:@"steps"] objectAtIndex:section] objectForKey:@"travel_mode"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections as number of overall steps
    return [[self.routeInfo objectForKey:@"steps"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[[[self.routeInfo objectForKey:@"steps"] objectAtIndex:section] objectForKey:@"travel_mode"] isEqualToString:@"WALKING"]) {
        return [[[[self.routeInfo objectForKey:@"steps"] objectAtIndex:section] objectForKey:@"steps"] count];
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"transportDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *step = [[self.routeInfo objectForKey:@"steps"] objectAtIndex:indexPath.section];

    cell.detailTextLabel.numberOfLines = 0;
    if([[[[self.routeInfo objectForKey:@"steps"] objectAtIndex:indexPath.section] objectForKey:@"travel_mode"] isEqualToString:@"TRANSIT"]) {
        switch (indexPath.row) {
            case 0:
                // Departure Information
                cell.textLabel.text = [NSString stringWithFormat:@"Depart: %@",
                                       [[[step objectForKey:@"transit_details"] objectForKey:@"departure_stop"] objectForKey:@"name"]];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Time: %@",
                                       [[[step objectForKey:@"transit_details"] objectForKey:@"departure_time"] objectForKey:@"text"]];
                
                break;
            case 1:
                // Number of stops -- duration
                cell.textLabel.text = [NSString stringWithFormat:@"Bus: %@",
                                         [[[step objectForKey:@"transit_details"] objectForKey:@"line"] objectForKey:@"short_name"]];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of stops: %@",
                                       [[step objectForKey:@"transit_details"] objectForKey:@"num_stops"]];

                
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"Arrival: %@",
                                       [[[step objectForKey:@"transit_details"] objectForKey:@"arrival_stop"] objectForKey:@"name"]];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Time: %@",
                                             [[[step objectForKey:@"transit_details"] objectForKey:@"arrival_time"] objectForKey:@"text"]];
                
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"Total Duration: %@",
                                       [[step objectForKey:@"duration"] objectForKey:@"text"]];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Distance: %@",
                                       [[step objectForKey:@"distance"] objectForKey:@"text"]];
                
                break;
            default:
                break;
        }
    } else {
        cell.textLabel.text = [[[[step  objectForKey:@"steps"] objectAtIndex:indexPath.row] objectForKey:@"distance"] objectForKey:@"text"];
        cell.detailTextLabel.text = [[[[step  objectForKey:@"steps"] objectAtIndex:indexPath.row] objectForKey:@"html_instructions"] stripHtml];
    }


    
    return cell;
}

@end
