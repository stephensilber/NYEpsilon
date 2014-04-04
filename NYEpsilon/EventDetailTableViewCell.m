//
//  EventDetailTableViewCell.m
//  NYEpsilon
//
//  Created by Stephen on 4/2/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "EventDetailTableViewCell.h"

@implementation EventDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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
