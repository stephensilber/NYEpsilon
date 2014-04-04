//
//  TransitDetailCell.m
//  NYEpsilon
//
//  Created by Stephen on 4/4/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "TransitDetailCell.h"

@implementation TransitDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.busNumber.layer.cornerRadius = (self.busNumber.frame.size.width/2);
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
