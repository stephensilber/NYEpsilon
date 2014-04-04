//
//  EventDetailTableViewCell.h
//  NYEpsilon
//
//  Created by Stephen on 4/2/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *eventTitle;
@property (nonatomic, strong) IBOutlet UILabel *eventDuration;
@property (nonatomic, strong) IBOutlet UIImageView *eventDurationIcon;

@end
