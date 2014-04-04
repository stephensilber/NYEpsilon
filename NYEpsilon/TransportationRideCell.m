//
//  TransportationRideCell.m
//  NYEpsilon
//
//  Created by Stephen on 4/2/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "UIImage+Tint.h"
#import "TransportationRideCell.h"

@interface TransportationRideCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL hasActivatedCall;

@end

@implementation TransportationRideCell

- (void) layoutSubviews {
    [super layoutSubviews];
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        _scrollView.contentSize = self.contentView.frame.size;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;

        [self.contentView insertSubview:_scrollView atIndex:0];
    }
    
    [self.scrollView addSubview:self.rideName];
    [self.scrollView addSubview:self.rideNumber];
    [self.scrollView addSubview:self.callIconImageView];
    [self.scrollView addSubview:self.callIconIndicatorView];
}

#pragma mark - UIScrollView

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Restrict the user from scrolling from left to right. Only right to left [ CELL ]<--
    if(scrollView.contentOffset.x < 0) {
        // Trick that works since we don't need to worry about vertical movement
        scrollView.contentOffset = CGPointZero;
    }
    
    const CGFloat MaxDistance = 40;
    CGFloat progress = MIN(1, scrollView.contentOffset.x / MaxDistance);
    
    self.callIconImageView.image = [self.callIconImageView.image imageTintedWithColor:[UIColor colorWithRed:0 green:progress blue:0 alpha:1]];
//    self.callIconImageView.alpha = (progress > 0.25) ? progress : 0.25;
    // User has reach the action point
    if(progress >= 1.0 && !self.hasActivatedCall) {
        self.hasActivatedCall = YES;
        SystemSoundID soundID;
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/pop.mp3", [[NSBundle mainBundle] resourcePath]]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        AudioServicesPlaySystemSound (soundID);
        NSLog(@"Call!");
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(self.hasActivatedCall) {
        self.hasActivatedCall = NO;
        NSLog(@"Calling!");
    }
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
