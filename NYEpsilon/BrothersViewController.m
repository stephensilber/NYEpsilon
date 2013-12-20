//
//  BrotherListViewController.m
//  NYE
//
//  Created by Stephen Silber on 7/7/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "NYEClient.h"
#import "BrotherCell.h"
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
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.indicator];
    self.navigationItem.rightBarButtonItem = item;
    
    [super viewDidLoad];
    
    // Default fetch request - Returns Actives
    [self fetchBrothersFromClass:nil];
    [self.tableView setRowHeight:50];

}

- (void) fetchBrothersFromClass:(NSString *) class {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *task = [[NYEClient sharedClient] brothersFromClass:class completion:^(NSArray *results, NSError *error) {
                                                                     if (results) {
                                                                         self.brothers = results;
                                                                         NSLog(@"Successfully downloaded %i brothers", self.brothers.count);
                                                                         [self.tableView reloadData];
                                                                     } else {
                                                                         NSLog(@"ERROR: %@", error);
                                                                     }
                                                                 }];
    NSLog(@"Task: %@", task);

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
    static NSString *CellIdentifier = @"BrotherCell";
    BrotherCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *brother = [self.brothers objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [brother objectForKey:@"first_name"], [brother objectForKey:@"last_name"]];
    cell.hometownLabel.text = [NSString stringWithFormat:@"%@, %@", [brother objectForKey:@"current_city"], [brother objectForKey:@"current_state"]];
    cell.classLabel.text = [NSString stringWithFormat:@"%@", [brother objectForKey:@"grad_class"]];
    
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
