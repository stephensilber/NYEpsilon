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
#import "A3ParallaxScrollView.h"

@interface HouseViewController ()
@property (nonatomic, strong) IBOutlet A3ParallaxScrollView *scrollWrapper;
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
    self.photos = [NSMutableArray array];
    [self.photos addObject:[UIImage imageNamed:@"house.jpeg"]];
    [self.photos addObject:[UIImage imageNamed:@"house2.jpeg"]];
    [self.photos addObject:[UIImage imageNamed:@"house3.jpeg"]];

    
    [super viewDidLoad];
    // create ParallaxScrollView
    self.scrollWrapper = [[A3ParallaxScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollWrapper.delegate = self;
    [self.view addSubview:self.scrollWrapper];
    CGSize contentSize = self.scrollWrapper.frame.size;
    contentSize.height *= 1.2f;
    self.scrollWrapper.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollWrapper.contentSize = contentSize;
    
    // add header and content
    CGRect headerFrame = self.imagePager.frame;
    headerFrame.origin.y -= 122.0f;
    self.imagePager.frame = headerFrame;
    [self.scrollWrapper addSubview:self.imagePager withAcceleration:CGPointMake(0.0f, 0.5f)];
    CGRect contentFrame = self.tableView.frame;
    contentFrame.origin.y += 122.0f;
    self.tableView.frame = contentFrame;
    [self.scrollWrapper addSubview:self.tableView];
    
    // force the table to resize the content
    [self.tableView reloadData];
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.tableView.contentSize.height;
    self.tableView.frame = tableFrame;
    
    // add the views to the scroll view instead
    [self.scrollWrapper addSubview:self.imagePager];
    [self.scrollWrapper addSubview:self.tableView];
    
    // set the content size
    self.scrollWrapper.contentSize = CGSizeMake(self.scrollWrapper.frame.size.width,
                                                  self.imagePager.frame.size.height +
                                                  self.tableView.frame.size.height
                                                  );
    
    [self.view addSubview:self.scrollWrapper];

    
    self.imagePager.slideshowTimeInterval = 5.0f;
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollWrapper) {
        CGRect frame = self.scrollWrapper.frame;
        frame.origin.y = scrollView.contentOffset.y;
        self.scrollWrapper.frame = frame;
    }
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