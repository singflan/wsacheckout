//
//  DisturbViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 9/30/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "DisturbViewController.h"
#import "DisturbViewCell.h"
#import "DisturbEditViewController.h"
#import "Disturbances.h"
#import "Report.h"
#import "GPSCoordinates.h"
#import "INTULocationManager.h"
#import "ProgressHUD.h"

@interface DisturbViewController ()

@end

@implementation DisturbViewController

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
        return [self.theCurrentReport.sawDisturbances count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"DisturbCell";
    
    DisturbViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[DisturbViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.reportDisturbDateTime.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.reportDisturbDateTime.textColor = [UIColor silverColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy hh:mm:ss a"];
    cell.reportDisturbDateTime.text = [dateFormatter stringFromDate:[[self.theCurrentReport.sawDisturbances objectAtIndex:indexPath.row] valueForKey:@"disturbDateTime"]];
    
    cell.reportDisturbDescription.font = [UIFont fontWithName:@"Avenir-Black" size:20.0f];
    cell.reportDisturbDescription.text = [[self.theCurrentReport.sawDisturbances objectAtIndex:indexPath.row] valueForKey:@"disturbDescription"];
    
    NSNumber *lat = [[self.theCurrentReport.sawDisturbances objectAtIndex:indexPath.row] valueForKey:@"disturbGPSLatitude"];
    NSNumber *lon = [[self.theCurrentReport.sawDisturbances objectAtIndex:indexPath.row] valueForKey:@"disturbGPSLongitude"];
    cell.reportDisturbGPS.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.reportDisturbGPS.textColor = [UIColor silverColor];
    cell.reportDisturbGPS.text = [GPSCoordinates WithLatitude:[lat doubleValue] WithLongitude:[lon doubleValue]];
    
    return cell;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return UITableViewCellEditingStyleDelete;
//    
//}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates];
        
        /* First remove this object from the source */
        [[self.theCurrentReport.sawDisturbances objectAtIndex:indexPath.row] delete];
        [self.theCurrentReport save];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    [self.tableView reloadData];
}


#pragma mark Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDisturbSegue"]) {
        
        DisturbEditViewController *editDisturbViewController = [segue destinationViewController];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        [editDisturbViewController setTitle:[[self.theCurrentReport.sawDisturbances objectAtIndex:indexPath.row] valueForKey:@"disturbDescription"]];
        [editDisturbViewController setTheCurrentDisturbance:[self.theCurrentReport.sawDisturbances objectAtIndex:indexPath.row]];

    }
}

- (IBAction)addDisturbance:(id)sender {
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    
    [ProgressHUD show:@"Please wait . . ."];
    
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 
                                                 Disturbances *newDisturbance = [Disturbances create];
                                                 [newDisturbance setReported:self.theCurrentReport];
                                                 [newDisturbance setDisturbDateTime:[NSDate date]];
                                                 
                                                 NSNumber *GPSLatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                                                 NSNumber *GPSLongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                                                 [newDisturbance setDisturbGPSLatitude:GPSLatitude];
                                                 [newDisturbance setDisturbGPSLongitude:GPSLongitude];
                                                 [newDisturbance save];
                                                 
                                                 [ProgressHUD dismiss];
                                                 [self.tableView reloadData];
                                                 
                                                 // the new record is at the end of the rows, so we count them but subtract 1 because index starts at 0
                                                 NSUInteger row = [self.theCurrentReport.sawDisturbances count] - 1;
                                                 NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                                                 [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                                 [self performSegueWithIdentifier:@"showDisturbSegue" sender:self];
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
