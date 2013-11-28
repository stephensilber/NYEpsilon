//
//  HouseInformationTableViewController.m
//  NYEpsilon
//
//  Created by Stephen Silber on 11/27/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "HouseInformationTableViewController.h"

@interface HouseInformationTableViewController ()
@property (nonatomic, strong) IBOutlet UITableViewCell *ourHouseCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *chapterHistoryCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *nationalHistoryCell;

@end

@implementation HouseInformationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            break;
        case 1:
            return 290.0f;
            break;
        case 2:
            return 528.0f;
            break;
        default:
            return 44.0f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = self.ourHouseCell;
            break;
        case 1:
            cell = self.chapterHistoryCell;
            break;
        case 2:
            cell = self.nationalHistoryCell;
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

    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

- (UIScrollView *)scrollViewForParallexController{
    return self.tableView;
}

@end