//
//  MainTabBarViewController.m
//  NYEpsilon
//
//  Created by Stephen Silber on 12/20/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITabBarItem *item1 = self.tabBarController.tabBar.items[0];
    item1.image = [[UIImage imageNamed:@"home_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [UIImage imageNamed:@"home.png"];
    UITabBarItem *item2 = self.tabBarController.tabBar.items[1];
    item2.image = [[UIImage imageNamed:@"group_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [UIImage imageNamed:@"group.png"];
    UITabBarItem *item3 = self.tabBarController.tabBar.items[2];
    item3.image = [[UIImage imageNamed:@"calendar-empty_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [UIImage imageNamed:@"calendar-empty.png"];
    UITabBarItem *item4 = self.tabBarController.tabBar.items[3];
    item4.image = [[UIImage imageNamed:@"placemarker_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [UIImage imageNamed:@"placemarker_sel.png"];
    UITabBarItem *item5 = self.tabBarController.tabBar.items[4];
    item5.image = [[UIImage imageNamed:@"reorder_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.selectedImage = [UIImage imageNamed:@"reorder.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
