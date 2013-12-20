//
//  FirstViewController.h
//  NYEpsilon
//
//  Created by Stephen Silber on 11/27/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"


@interface HouseViewController : UIViewController <KIImagePagerDataSource, KIImagePagerDelegate, UIScrollViewDelegate>

@end
