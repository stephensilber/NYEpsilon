//
//  BrotherCell.h
//  NYEpsilon
//
//  Created by Stephen Silber on 11/27/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrotherCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *hometownLabel;
@property (nonatomic, weak) IBOutlet UILabel *classLabel;

@property (nonatomic, weak) IBOutlet UIImageView *portraitImageView;

@end
