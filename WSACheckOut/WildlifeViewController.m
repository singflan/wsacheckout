//
//  WildernessViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/16/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "WildlifeViewController.h"
#import "WildlifeEditViewController.h"
#import "WildlifeViewCell.h"
#import "Report.h"
#import "WildLife.h"
#import "GPSCoordinates.h"
#import "INTULocationManager.h"
#import "ProgressHUD.h"

@interface WildlifeViewController ()

@end

@implementation WildlifeViewController

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    return [self.theCurrentReport.sawWildLife count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"WildlifeCell";
    
    WildlifeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[WildlifeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.reportWildlifeDateTime.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.reportWildlifeDateTime.textColor = [UIColor silverColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy hh:mm:ss a"];
    cell.reportWildlifeDateTime.text = [dateFormatter stringFromDate:[[self.theCurrentReport.sawWildLife objectAtIndex:indexPath.row] valueForKey:@"animalDateTime"]];
    
    cell.reportWildlifeDescription.font = [UIFont fontWithName:@"Avenir-Black" size:20.0f];
    if ([[[self.theCurrentReport.sawWildLife objectAtIndex:indexPath.row] valueForKey:@"animalObserved"] isEqualToString:@"Other (Please Specify Below)"]) {
        
        cell.reportWildlifeDescription.text = @"Other";
    }
    
    else {
        
       cell.reportWildlifeDescription.text = [[self.theCurrentReport.sawWildLife objectAtIndex:indexPath.row] valueForKey:@"animalObserved"];
    }
    
    NSNumber *lat = [[self.theCurrentReport.sawWildLife objectAtIndex:indexPath.row] valueForKey:@"animalGPSLatitude"];
    NSNumber *lon = [[self.theCurrentReport.sawWildLife objectAtIndex:indexPath.row] valueForKey:@"animalGPSLongitude"];
    cell.reportWildlifeGPS.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.reportWildlifeGPS.textColor = [UIColor silverColor];
    cell.reportWildlifeGPS.text = [GPSCoordinates WithLatitude:[lat doubleValue] WithLongitude:[lon doubleValue]];
    
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
        [[self.theCurrentReport.sawWildLife objectAtIndex:indexPath.row] delete];
        [self.theCurrentReport save];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    [self.tableView reloadData];
}

#pragma mark Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showWildlifeSegue"]) {
        
        WildlifeEditViewController *editWildlifeViewController = [segue destinationViewController];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        [editWildlifeViewController setTitle:[[self.theCurrentReport.sawWildLife objectAtIndex:indexPath.row] valueForKey:@"animalDescription"]];
        [editWildlifeViewController setTheCurrentWildlife:[self.theCurrentReport.sawWildLife objectAtIndex:indexPath.row]];
    }
}

- (IBAction)addWildlife: (id)sender {
    
    [ProgressHUD show:@"Please wait . . ."];
    
        INTULocationManager *locMgr = [INTULocationManager sharedInstance];
[locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                   timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 
                                                 WildLife *newWildlife = [WildLife create];
                                                 [newWildlife setReported:self.theCurrentReport];
                                                 [newWildlife setAnimalDateTime:[NSDate date]];
                                                 
                                                 NSNumber *GPSLatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                                                 NSNumber *GPSLongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                                                 [newWildlife setAnimalGPSLatitude:GPSLatitude];
                                                 [newWildlife setAnimalGPSLongitude:GPSLongitude];
                                                 [newWildlife save];
                                                 
                                                 [ProgressHUD dismiss];
                                                 [self.tableView reloadData];
                                                 
                                                 // the new record is at the end of the rows, so we count them but subtract 1 because index starts at 0
                                                 NSUInteger row = [self.theCurrentReport.sawWildLife count] - 1;
                                                 NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                                                 [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                                 [self performSegueWithIdentifier:@"showWildlifeSegue" sender:self];
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
