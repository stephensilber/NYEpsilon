//
//  WalkingDetailCell.h
//  NYEpsilon
//
//  Created by Stephen on 4/4/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkingDetailCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *duration;
@property (nonatomic, strong) IBOutlet UILabel *distance;
@property (nonatomic, strong) IBOutlet UILabel *description;

@end
