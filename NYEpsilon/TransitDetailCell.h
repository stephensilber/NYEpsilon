//
//  TransitDetailCell.h
//  NYEpsilon
//
//  Created by Stephen on 4/4/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitDetailCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *departureTime;
@property (nonatomic, strong) IBOutlet UILabel *departureStop;

@property (nonatomic, strong) IBOutlet UILabel *arrivalTime;
@property (nonatomic, strong) IBOutlet UILabel *arrivalStop;

@property (nonatomic, strong) IBOutlet UILabel *busNumber;
@property (nonatomic, strong) IBOutlet UILabel *duration;
@property (nonatomic, strong) IBOutlet UILabel *distance;
@property (nonatomic, strong) IBOutlet UILabel *numberOfStop;

@end
