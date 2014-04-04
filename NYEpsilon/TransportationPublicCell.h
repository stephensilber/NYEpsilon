//
//  TransportationPublicCell.h
//  NYEpsilon
//
//  Created by Stephen on 4/3/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransportationPublicCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *durationLabel;
@property (nonatomic, strong) IBOutlet UILabel *arrivalLabel;
@property (nonatomic, strong) IBOutlet UILabel *departureLabel;
@property (nonatomic, strong) IBOutlet UILabel *arrivalLabelTitle;
@property (nonatomic, strong) IBOutlet UILabel *departureLabelTitle;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@end
