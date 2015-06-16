//
//  PlantsViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/23/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "PlantsViewController.h"
#import "PlantsEditViewController.h"
#import "PlantsViewCell.h"
#import "Report.h"
#import "PlantLife.h"
#import "GPSCoordinates.h"
#import "INTULocationManager.h"
#import "ProgressHUD.h"

@interface PlantsViewController ()

@end

@implementation PlantsViewController

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
    return [self.theCurrentReport.sawPlantLife count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"PlantlifeCell";
    
    PlantsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PlantsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.reportPlantlifeDateTime.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.reportPlantlifeDateTime.textColor = [UIColor silverColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy hh:mm:ss a"];
    cell.reportPlantlifeDateTime.text = [dateFormatter stringFromDate:[[self.theCurrentReport.sawPlantLife objectAtIndex:indexPath.row] valueForKey:@"plantDateTime"]];
    
    cell.reportPlantlifeDescription.font = [UIFont fontWithName:@"Avenir-Black" size:20.0f];
    cell.reportPlantlifeDescription.text = [[self.theCurrentReport.sawPlantLife objectAtIndex:indexPath.row] valueForKey:@"plantObserved"];
    
    NSNumber *lat = [[self.theCurrentReport.sawPlantLife objectAtIndex:indexPath.row] valueForKey:@"plantGPSLatitude"];
    NSNumber *lon = [[self.theCurrentReport.sawPlantLife objectAtIndex:indexPath.row] valueForKey:@"plantGPSLongitude"];
    cell.reportPlantlifeGPS.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.reportPlantlifeGPS.textColor = [UIColor silverColor];
    cell.reportPlantlifeGPS.text = [GPSCoordinates WithLatitude:[lat doubleValue] WithLongitude:[lon doubleValue]];
    
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
        [[self.theCurrentReport.sawPlantLife objectAtIndex:indexPath.row] delete];
        [self.theCurrentReport save];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    [self.tableView reloadData];
}

#pragma mark Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showPlantlifeSegue"]) {
        
        PlantsEditViewController *editPlantsViewController = [segue destinationViewController];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        [editPlantsViewController setTitle:[[self.theCurrentReport.sawPlantLife objectAtIndex:indexPath.row] valueForKey:@"plantObserved"]];
        [editPlantsViewController setTheCurrentPlantlife:[self.theCurrentReport.sawPlantLife objectAtIndex:indexPath.row]];
    }
}

- (IBAction)addPlantlife: (id)sender {
    
    [ProgressHUD show:@"Please wait . . ."];
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 
                                                 PlantLife *newPlantlife = [PlantLife create];
                                                 [newPlantlife setReported:self.theCurrentReport];
                                                 [newPlantlife setPlantDateTime:[NSDate date]];
                                                 
                                                 NSNumber *GPSLatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                                                 NSNumber *GPSLongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                                                 [newPlantlife setPlantGPSLatitude:GPSLatitude];
                                                 [newPlantlife setPlantGPSLongitude:GPSLongitude];
                                                 [newPlantlife save];
                                                 
                                                 [ProgressHUD dismiss];
                                                 [self.tableView reloadData];
                                                 
                                                 // the new record is at the end of the rows, so we count them but subtract 1 because index starts at 0
                                                 NSUInteger row = [self.theCurrentReport.sawPlantLife count] - 1;
                                                 NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                                                 [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                                 [self performSegueWithIdentifier:@"showPlantlifeSegue" sender:self];
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
