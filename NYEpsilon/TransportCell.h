//
//  TransportCell.h
//  NYEpsilon
//
//  Created by Stephen Silber on 12/20/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransportCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UILabel *numStepsLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@end
