//
//  FirstViewController.m
//  NYEpsilon
//
//  Created by Stephen Silber on 11/27/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "HouseViewController.h"
#import "ImageGalleryViewController.h"
#import "HouseInformationTableViewController.h"

@interface HouseViewController ()
@property (nonatomic, strong) IBOutlet KIImagePager *imagePager;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) IBOutlet UITableViewCell *ourHouseCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *chapterHistoryCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *nationalHistoryCell;
@end

@implementation HouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imagePager = [[KIImagePager alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 175.0f)];
    self.imagePager.delegate = self;
    self.imagePager.dataSource = self;
    
    self.photos = [NSMutableArray array];
    [self.photos addObject:[UIImage imageNamed:@"house.jpeg"]];
    [self.photos addObject:[UIImage imageNamed:@"house2.jpeg"]];
    [self.photos addObject:[UIImage imageNamed:@"house3.jpeg"]];
    [self.tableView setTableHeaderView:self.imagePager];
    [self.tableView reloadData];

    self.imagePager.slideshowTimeInterval = 5.0f;
    
    
}

- (NSArray *) arrayWithImages
{
    return self.photos;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFill;
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Hacky fix but stackoverflow isn't helping with any better solutions currently. Will reinvestigate later
    switch (indexPath.section) {
        case 0:
            return 283.0f;
            break;
        case 1:
            return 280.0f;
            break;
        case 2:
            return 528.0f;
            break;
        default:
            return 44.0f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = self.ourHouseCell;
            break;
        case 1:
            cell = self.chapterHistoryCell;
            break;
        case 2:
            cell = self.nationalHistoryCell;
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Hacky fix but stackoverflow isn't helping with any better solutions currently. Will reinvestigate later
    switch (section) {
        case 0:
            return @"Our House";
            break;
        case 1:
            return @"Chapter History";
            break;
        case 2:
            return @"National History";
            break;
        default:
            return @"";
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end