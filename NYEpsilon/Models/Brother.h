//
//  Brother.h
//  NYEpsilon
//
//  Created by Stephen on 3/28/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Brother : NSManagedObject

@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * hometown;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSNumber * class_year;
@property (nonatomic, retain) NSString * last_name;

@end
