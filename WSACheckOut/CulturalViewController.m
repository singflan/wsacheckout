//
//  CulturalViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/23/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "CulturalViewController.h"
#import "CulturalViewCell.h"
#import "CulturalEditViewController.h"
#import "Cultural.h"
#import "Report.h"
#import "GPSCoordinates.h"
#import "INTULocationManager.h"
#import "ProgressHUD.h"

@interface CulturalViewController ()

@end

@implementation CulturalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.editButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.theCurrentReport = [Report where:@{@"reportTitle":[defaults objectForKey:@"CurrentReportTitle"]} ].lastObject;
    
    [self.tableView reloadData];
}

# pragma mark TableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.theCurrentReport.sawCultural count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CulturalCell";
    
    CulturalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CulturalViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.reportCulturalDateTime.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.reportCulturalDateTime.textColor = [UIColor silverColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy hh:mm:ss a"];
    cell.reportCulturalDateTime.text = [dateFormatter stringFromDate:[[self.theCurrentReport.sawCultural objectAtIndex:indexPath.row] valueForKey:@"culturalDateTime"]];
    
    cell.reportCulturalDescription.font = [UIFont fontWithName:@"Avenir-Black" size:20.0f];
    cell.reportCulturalDescription.text = [[self.theCurrentReport.sawCultural objectAtIndex:indexPath.row] valueForKey:@"culturalDescription"];
    
    NSNumber *lat = [[self.theCurrentReport.sawCultural objectAtIndex:indexPath.row] valueForKey:@"culturalGPSLatitude"];
    NSNumber *lon = [[self.theCurrentReport.sawCultural objectAtIndex:indexPath.row] valueForKey:@"culturalGPSLongitude"];
    cell.reportCulturalGPS.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.reportCulturalGPS.textColor = [UIColor silverColor];
    cell.reportCulturalGPS.text = [GPSCoordinates WithLatitude:[lat doubleValue] WithLongitude:[lon doubleValue]];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates];
        
        /* First remove this object from the source */
        [[self.theCurrentReport.sawCultural objectAtIndex:indexPath.row] delete];
        [self.theCurrentReport save];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.theCurrentCultural = [self.theCurrentReport.sawCultural objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"showCulturalSegue" sender:self];
    
    
}

#pragma mark Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showCulturalSegue"]) {
        
        CulturalEditViewController *editCulturalViewController = [segue destinationViewController];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        [editCulturalViewController setTitle:[[self.theCurrentReport.sawCultural objectAtIndex:indexPath.row] valueForKey:@"CulturalDescription"]];
        [editCulturalViewController setTheCurrentCultural:[self.theCurrentReport.sawCultural objectAtIndex:indexPath.row]];
    }
}

- (IBAction)addCultural:(id)sender {
    
    [ProgressHUD show:@"Please wait . . ."];
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 
                                                 Cultural *newCultural = [Cultural create];
                                                 [newCultural setReported:self.theCurrentReport];
                                                 [newCultural setCulturalDateTime:[NSDate date]];
                                                 
                                                 NSNumber *GPSLatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                                                 NSNumber *GPSLongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                                                 [newCultural setCulturalGPSLatitude:GPSLatitude];
                                                 [newCultural setCulturalGPSLongitude:GPSLongitude];
                                                 [newCultural save];
                                                 
                                                 [ProgressHUD dismiss];
                                                 [self.tableView reloadData];
                                                 
                                                 // the new record is at the end of the rows, so we count them but subtract 1 because index starts at 0
                                                 NSUInteger row = [self.theCurrentReport.sawCultural count] - 1;
                                                 NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                                                 [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                                 [self performSegueWithIdentifier:@"showCulturalSegue" sender:self];
                                                 [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                                             }
                                             else if (status == INTULocationStatusTimedOut) {
                                                 
                                                 [ProgressHUD dismiss];
                                                 
                                                 UIAlertView *locationAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                             message:@"Sorry, there was a problem\ngetting your location.\nPlease try again."
                                                                                                            delegate:nil
                                                                                                   cancelButtonTitle:@"OK"
                                                                                                   otherButtonTitles: nil];
                                                 
                                                 [locationAlertView show];
                                             }
                                             else {
                                                 
                                                 [ProgressHUD dismiss];
                                                 
                                                 UIAlertView *locationAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                             message:@"Sorry, there was a problem\ngetting your location.\nPlease try again."
                                                                                                            delegate:nil
                                                                                                   cancelButtonTitle:@"OK"
                                                                                                   otherButtonTitles: nil];
                                                 
                                                 [locationAlertView show];
                                             }
                                         }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
