//
//  BrotherListViewController.m
//  NYE
//
//  Created by Stephen Silber on 7/7/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "NYEClient.h"
#import "AFNetworking.h"
#import "BrothersViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"

@interface BrothersViewController ()
@property (nonatomic, strong) NSArray *brothers;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation BrothersViewController
@synthesize brothers = _brothers;

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
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.indicator];
    self.navigationItem.rightBarButtonItem = item;
    
    // Default fetch request - Returns Actives
    [self fetchBrothersFromClass:nil withApiUrl:@"brothers/actives"];
    [self.tableView setRowHeight:55];
}

- (void) fetchBrothersFromClass:(NSString *) class withApiUrl:(NSString *)apiPath {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *task = [[NYEClient sharedClient] brothersFromClass:class completion:^(NSArray *results, NSError *error) {
                                                                     if (results) {
                                                                         self.brothers = results;
                                                                         [self.tableView reloadData];
                                                                     } else {
                                                                         NSLog(@"ERROR: %@", error);
                                                                     }
                                                                 }];
    [self.indicator setAnimatingWithStateOfTask:task];

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
    // Return the number of rows in the section.
    return self.brothers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *brother = [self.brothers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [brother objectForKey:@"first_name"], [brother objectForKey:@"last_name"]];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@ | %@", [brother objectForKey:@"current_city"], [brother objectForKey:@"current_state"], [brother objectForKey:@"grad_class"]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [[[[UIAlertView alloc] initWithTitle:@"Coming Soon" message:@"Additional features are on the way! This is a beta release!" delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles: nil]] show];
    //    BrofileViewController *nextView = [[BrofileViewController alloc] initWithUrl:@"http://nyepsilon.com/app/sean.png"];
    //    [self.navigationController pushViewController:nextView animated:YES];
}

@end
