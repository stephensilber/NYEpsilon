//
//  ImageGalleryViewController.m
//  
//
//  Created by Stephen Silber on 11/27/13.
//
//

#import "ImageGalleryViewController.h"

@interface ImageGalleryViewController ()
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation ImageGalleryViewController



- (void)viewDidLoad
{
    self.photos = [NSMutableArray array];
    [self.photos addObject:[UIImage imageNamed:@"house.jpeg"]];
    [self.photos addObject:[UIImage imageNamed:@"house2.jpeg"]];
    [self.photos addObject:[UIImage imageNamed:@"house3.jpeg"]];

    [super viewDidLoad];
}

- (NSArray *) arrayWithImages
{
    return self.photos;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFill;
}

@end