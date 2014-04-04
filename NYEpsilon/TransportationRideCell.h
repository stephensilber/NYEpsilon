//
//  TransportationRideCell.h
//  NYEpsilon
//
//  Created by Stephen on 4/2/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface TransportationRideCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *rideName;
@property (nonatomic, strong) IBOutlet UILabel *rideNumber;
@property (nonatomic, strong) IBOutlet UIImageView *callIconImageView;
@property (nonatomic, strong) IBOutlet UIImageView *callIconIndicatorView;

@end
