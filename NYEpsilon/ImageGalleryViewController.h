//
//  ImageGalleryViewController.h
//  
//
//  Created by Stephen Silber on 11/27/13.
//
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"

@interface ImageGalleryViewController : UIViewController<KIImagePagerDataSource, KIImagePagerDelegate>

@end
