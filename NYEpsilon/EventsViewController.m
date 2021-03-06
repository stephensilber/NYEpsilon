//
//  EventsViewController.m
//  NYEpsilon
//
//  Created by Stephen Silber on 11/28/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//
#import "NYEClient.h"
#import "MBProgressHUD.h"
#import "EventDetailTableViewCell.h"
#import "EventsViewController.h"
#import "AFNetworking.h"

@interface EventsViewController () {
    BOOL emptyFlag;
    NSArray *dayData;
}
@property (nonatomic, weak) IBOutlet CKCalendarView *calendarView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *monthEvents;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *minimumDate;
@end


#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 5.0f
#define k_EVENT_URL @"http://localhost:3000/api/events/"

@implementation EventsViewController

- (id)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
    }
    return self;
}

- (void) goToToday:(id)sender {
    [self calendar:self.calendarView didSelectDate:[NSDate date]];
}

- (void) fetchEventsFromMonth:(NSDate *) startMonth endingOnMonth:(NSDate *)endMonth {
    NSString *startMonthString  = (startMonth)  ? [self.dateFormatter stringFromDate:startMonth] : @"nil";
    NSString *endMonthString    = (endMonth)    ? [self.dateFormatter stringFromDate:endMonth] : @"nil";
    
    NSURLSessionDataTask *task = [[NYEClient sharedClient] eventsFromMonth:startMonthString untilMonth:endMonthString completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"Downloaded %lu events", (unsigned long)results.count);
            self.monthEvents = results;
            [self.calendarView reloadData];
            [self.tableView reloadData];
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    NSLog(@"Task: %@", task);
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchEventsFromMonth:nil endingOnMonth:nil];
    [self.calendarView setDelegate:self];
    self.calendarView.onlyShowCurrentMonth = NO;
    self.minimumDate = [self.dateFormatter dateFromString:@"20/08/2013"];
    
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
    	return NO;
    
    return YES;
}

- (NSArray *) fetchDayDataFromDate:(NSDate *) date {
    NSArray *day = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M"];
    NSString *month_key = [formatter stringFromDate:date];
    [formatter setDateFormat:@"dd"];
    NSString *day_key = [formatter stringFromDate:date];
    
    if([self.monthEvents objectForKey:month_key]) {
        day = [[self.monthEvents objectForKey:month_key] objectForKey:day_key];
    }
    
    return day;
}

#pragma mark -
#pragma mark - CKCalendarDelegate



- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    CGRect calendarFrame = calendar.frame;
    CGRect tableFrame = _tableView.frame;
    
    tableFrame.origin.y = calendar.bounds.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.calendarView.frame = calendarFrame;
    _tableView.frame = tableFrame;
    
    [UIView commitAnimations];
    
}


- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSArray *day = [self fetchDayDataFromDate:date];
    dayData = (day) ? day : [NSArray array];
    [self.tableView reloadData];
}


- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if ([self fetchDayDataFromDate:date]) {
        [dateItem setTextColor:[UIColor purpleColor]];
        [dateItem setBackgroundColor:[UIColor colorWithRed:0.884 green:0.896 blue:0.933 alpha:1.000]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (emptyFlag) ? 44.0f : 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if(dayData.count == 0) {
        emptyFlag = YES;
        return 1;
    } else {
        emptyFlag = NO;
        return dayData.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"eventDetailCell";
    
    EventDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EventDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Show empty cell if there are no events on this day
    if(emptyFlag) {
        cell.eventTitle.text = @"No events on this day!";
        cell.eventDuration.text = nil;
        cell.eventDurationIcon.image = nil;
    } else {
        
        NSDictionary *day = [dayData objectAtIndex:indexPath.row];
        cell.eventTitle.text = [day objectForKey:@"title"];
        cell.eventDurationIcon.image = [UIImage imageNamed:@"event_duration"];
        NSLog(@"AD: %@", [day objectForKey:@"allday"]);
        
        if([[day objectForKey:@"allday"] intValue] == 1) {
            cell.eventDuration.text = @"All-day event";
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZ"];
            NSDate *start = [formatter dateFromString:[day objectForKey:@"start_time"]];
            NSDate *end = [formatter dateFromString:[day objectForKey:@"end_time"]];
            
            [formatter setDateFormat:@"hh:mm a"];
        
            if(start == end) {
                NSString *startString = [formatter stringFromDate:start];
                cell.eventDuration.text = [NSString stringWithFormat:@"%@", startString];
            } else {
                NSString *startString = [formatter stringFromDate:start];
                NSString *endString = [formatter stringFromDate:end];
                cell.eventDuration.text = [NSString stringWithFormat:@"%@ - %@", startString, endString];
            }
        }
        
    }
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
