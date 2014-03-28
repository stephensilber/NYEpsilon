//
//  HouseInformationTableViewController.m
//  NYEpsilon
//
//  Created by Stephen Silber on 11/27/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "HouseInformationTableViewController.h"

@interface HouseInformationTableViewController ()

@end

@implementation HouseInformationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Hacky fix but stackoverflow isn't helping with any better solutions currently. Will reinvestigate later
    switch (indexPath.section) {
        case 0:
            return 283.0f;
        case 1:
            return 290.0f;
        case 2:
            return 528.0f;
        default:
            return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"The chapter house, located on 12 Myrtle Avenue, is a early 19th century mansion bought from a rich farmer in 1961. Although the house is historic, the Brotherhood makes a big effort to constantly enhance the quality of living for the brothers as well as the experience of visiting guests, friends, neighbors and alumni. Each semester the House Manager holds workdays, during which the brothers participate in cleaning, masonry, carpentry, landcaping, electrical and aesthetic projects to improve the house. Pasts projects include refinishing the wood floors, building brick flower boxes for the front of the house, laying new brick walkways, and painting a large Sigma Alpha Epsilon crest in the entrance to the basement.";
            break;
        case 1:
            cell.textLabel.text = @"The New York Epsilon chapter of Sigma Alpha Epsilon began as a local chapter in 1948, known as Lambda Alpha Epsilon (now the name of our housing corporation). On December 8, 1951, Lambda Alpha Epsilon was installed as the New York Epsilon chapter of Sigma Alpha Epsilon, by one of Sigma Alpha Epsilon's finest and most recognized alumni, John O. Moseley. We received the designation 'Epsilon' in recognition of the founder of the chapter, Forrest K. English class of 1951 (a transfer student from Penn Theta). His letter to ΣAE national regarding the founding of a chapter here is displayed to this day in our chapter room.";
            break;
        case 2:
            cell.textLabel.text = @"On March 9, 1856 Sigma Alpha Epsilon was founded by eight students at the University of Alabama at Tuscaloosa. These eight founding fathers, studying in the classics, formed a fraternity governed by age old Greek principles and the highest standards for entrance. Our brothers fought on both sides of the civil war, and many chapters were lost. In fact, only one chapter stayed active throughout the entire civil war, Washington City Rho at Washington Military Academy. Many other chapters were revived after the war, including the famous Kentucky Chi, where before the war; a woman was entrusted with the sacred documents that govern Sigma Alpha Epsilon. Lucie Pattie was given the handshake by a brother of that chapter (who died in the war) and was not to release the documents to any other person until that sacred greeting was given. When a different brother returned and shook Miss Pattie's hand, the documents were received and the chapter was revived! Over the summer of 1925, the national convention spawned the idea of the first and only fraternal leadership school. Through the great depression, amazingly, not a single chapter went under. In this century of prosperity for Sigma Alpha Epsilon, we have grown to over 220 chapters with approximately 11,000 current undergraduates. In total there are over 300,000 initiated brothers of Sigma Alpha Epsilon.";
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Hacky fix but stackoverflow isn't helping with any better solutions currently. Will reinvestigate later
    switch (section) {
        case 0:
            return @"Our House";
            break;
        case 1:
            return @"Chapter History";
            break;
        case 2:
            return @"National History";
            break;
        default:
            return @"";
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIScrollView *)scrollViewForParallexController{
    return self.tableView;
}

@end