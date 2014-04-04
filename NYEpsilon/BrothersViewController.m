//
//  BrotherListViewController.m
//  NYE
//
//  Created by Stephen Silber on 7/7/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//
#import "Brother.h"
#import "NYEClient.h"
#import "BrotherCell.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "BrothersViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"

@interface BrothersViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
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

- (void)addBrothersFromArray:(NSArray *) brothersArray {
    for(NSDictionary *bro in brothersArray) {
        [self addBrotherEntryFromDictionary:bro];
    }
}

- (void)addBrotherEntryFromDictionary:(NSDictionary *) brotherDictionary {
    Brother *newEntry = nil;
    
    //Set up to get the thing you want to update
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Brother" inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(first_name = \"%@\") AND (last_name = \"%@\")", [brotherDictionary objectForKey:@"first_name"], [brotherDictionary objectForKey:@"last_name"]]]];

    //Ask for it
    NSError *error;
    newEntry = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    
    if (error) {
        NSLog(@"Whoops, couldn't fetch: %@", [error localizedDescription]);
        return;
    }
    
    if (!newEntry) {
        //Nothing there to update
        newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Brother"
                                                 inManagedObjectContext:self.managedObjectContext];
        newEntry.first_name = [brotherDictionary objectForKey:@"first_name"];
        newEntry.last_name = [brotherDictionary objectForKey:@"last_name"];
        newEntry.hometown = [NSString stringWithFormat:@"%@, %@",[brotherDictionary objectForKey:@"current_city"], [brotherDictionary objectForKey:@"current_state"]];
        newEntry.class_year = [brotherDictionary objectForKey:@"grad_class"];
//        newEntry.major = ([brotherDictionary objectForKey:@"degree"]) ? [brotherDictionary objectForKey:@"degree"] : @"";
    } else {
//        NSLog(@"Updating brother: %@ %@", newEntry.first_name, newEntry.last_name);
        newEntry.hometown = [NSString stringWithFormat:@"%@, %@",[brotherDictionary objectForKey:@"current_city"], [brotherDictionary objectForKey:@"current_state"]];
        newEntry.class_year = [brotherDictionary objectForKey:@"grad_class"];
//        newEntry.major = ([brotherDictionary objectForKey:@"degree"]) ? [brotherDictionary objectForKey:@"degree"] : @"";
    }
    
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}


- (NSArray *)fetchAllBrotherRecords {
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brother"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    fetchedRecords = [fetchedRecords sortedArrayUsingComparator:^NSComparisonResult(Brother *obj1, Brother *obj2) {
        return (obj1.last_name > obj2.last_name);
    }];

    // Returning Fetched Records
    return fetchedRecords;
}

- (void)viewDidLoad
{
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.indicator];
    self.navigationItem.rightBarButtonItem = item;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.brothers = [self fetchAllBrotherRecords];
    [self.tableView setRowHeight:50];
    [super viewDidLoad];
    
    // Default fetch request - Returns Actives
    [self fetchBrothersFromClass:nil];

}

- (void) fetchBrothersFromClass:(NSString *) class {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *task = [[NYEClient sharedClient] brothersFromClass:class completion:^(NSArray *results, NSError *error) {
                                                                     if (results) {
                                                                         [self addBrothersFromArray:results]; // Store new results in CoreData
                                                                         self.brothers = [self fetchAllBrotherRecords];
                                                                         NSLog(@"Successfully downloaded %lu brothers", (unsigned long)self.brothers.count);
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
    
    Brother *brother = [self.brothers objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", brother.first_name, brother.last_name];
    cell.hometownLabel.text = brother.hometown;
    cell.classLabel.text = [NSString stringWithFormat:@"%@", brother.class_year];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
