//
//  KOPViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 8/29/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "KOPViewController.h"
#import "KOPViewCell.h"
#import "KOPEditViewController.h"
#import "Report.h"
#import "KOP.h"
#import "GPSCoordinates.h"
#import "INTULocationManager.h"
#import "ProgressHUD.h"

@interface KOPViewController ()

@end

@implementation KOPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.editButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.theCurrentReport = [Report where:@{@"reportTitle":[defaults objectForKey:@"CurrentReportTitle"]} ].lastObject;

    [self.tableView reloadData];
}

# pragma mark TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.theCurrentReport.tookKOPs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"KOPCell";
    
    KOPViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[KOPViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy hh:mm:ss a"];
    cell.kopListDateTimeLabel.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.kopListDateTimeLabel.textColor = [UIColor silverColor];
    cell.kopListDateTimeLabel.text = [dateFormatter stringFromDate:[[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row] valueForKey:@"kopDateTime"]];

    NSNumber *lat = [[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row] valueForKey:@"kopGPSLatitude"];
    NSNumber *lon = [[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row] valueForKey:@"kopGPSLongitude"];
    cell.kopListGPSCoordinates.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.kopListGPSCoordinates.textColor = [UIColor silverColor];
    cell.kopListGPSCoordinates.text = [GPSCoordinates WithLatitude:[lat doubleValue] WithLongitude:[lon doubleValue]];
    
    cell.kopListNameLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20.0f];
    cell.kopListNameLabel.text = [[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row] valueForKey:@"kopName"];
    
    if ([[[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row] valueForKey:@"kopStatus"] isEqualToString:@"Complete"]) {
        
        cell.iconImageView.image = [UIImage imageNamed:@"check-green"];
    }

    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"showKOPSegue"]) {

        KOPEditViewController *editKOPViewController = [segue destinationViewController];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        [editKOPViewController setTitle:[[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row] valueForKey:@"kopName"]];
        [editKOPViewController setTheCurrentKOP:[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row]];
        [editKOPViewController setTransferedKOPGPSCoordinates:[NSString stringWithFormat:@"%@,%@",[[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row] valueForKey:@"kopGPSLatitude"], [[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row] valueForKey:@"kopGPSLongitude"]]];
        [editKOPViewController setTheCurrentReport:self.theCurrentReport];
        
        }
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
        [[self.theCurrentReport.tookKOPs objectAtIndex:indexPath.row] delete];
        [self.theCurrentReport save];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Add KOP Method

- (IBAction)addKOP:(id)sender
{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add KOP"
                                                     message:@"Please enter the name of your observation point"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"CREATE",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString* detailString = [alertView textFieldAtIndex:0].text;
    
    if ([[alertView textFieldAtIndex:0].text length] <= 0 || buttonIndex == 0){
        return; //If cancel or 0 length string the string doesn't matter
    }
    if (buttonIndex == 1) {
        
        [ProgressHUD show:@"Please wait . . ."];
        
        //Get the user's location
        INTULocationManager *locationManager = [INTULocationManager sharedInstance];
        
        [locationManager requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                                    timeout:10.0
                                       delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                                      block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                          if (status == INTULocationStatusSuccess) {
                                                              
                                                              // create the new KOP and push the segue to the edit screen
                                                              KOP *newKOP = [KOP create];
                                                              [newKOP setReported:self.theCurrentReport];
                                                              [newKOP setKopDateTime:[NSDate date]];
                                                              [newKOP setKopName:detailString];
                                                              
                                                              NSNumber *kopGPSLatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                                                              NSNumber *kopGPSLongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                                                              [newKOP setKopGPSLatitude:kopGPSLatitude];
                                                              [newKOP setKopGPSLongitude:kopGPSLongitude];
                                                              [newKOP save];
                                                              
                                                              [self.tableView reloadData];
                                                              
                                                              [ProgressHUD dismiss];
                                                              // the new record is at the end of the rows, so we count them but subtract 1 because index starts at 0
                                                              NSUInteger row = [self.theCurrentReport.tookKOPs count] - 1;
                                                              NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                                                              [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                                              [self performSegueWithIdentifier:@"showKOPSegue" sender:self];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
