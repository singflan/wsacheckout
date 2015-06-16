//
//  MapSettingsViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 9/2/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "MapSettingsViewController.h"

@interface MapSettingsViewController ()

@end

@implementation MapSettingsViewController

@synthesize delegate;
@synthesize defaults = _defaults;

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
    self.view.backgroundColor = [UIColor silverColor];
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.mapViewSegmentedControl.selectedSegmentIndex = [self.defaults integerForKey:@"CurrentMapView"];
    self.showReportsSegmentedControl.selectedSegmentIndex = [self.defaults integerForKey:@"CurrentMapReportView"];

}

- (IBAction)mapViewSelection:(id)sender {
    
    if (self.mapViewSegmentedControl.selectedSegmentIndex == 0) {
        
        [self.delegate didSelectMapView:0];
        
    }
    
    else if (self.mapViewSegmentedControl.selectedSegmentIndex == 1) {
        
        [self.delegate didSelectMapView:1];
        
    }
    
    else if (self.mapViewSegmentedControl.selectedSegmentIndex == 2) {
        
        [self.delegate didSelectMapView:2];
        
    }
    
    else if (self.mapViewSegmentedControl.selectedSegmentIndex == 3) {
        
        [self.delegate didSelectMapView:3];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)showReports:(id)sender {
    
    
    if (self.showReportsSegmentedControl.selectedSegmentIndex == 0) {
        
        [self.delegate didSelectReportView:0];
    }
    
    else if (self.showReportsSegmentedControl.selectedSegmentIndex == 1) {
        
        [self.delegate didSelectReportView:1];
        
    }
    
    else if (self.showReportsSegmentedControl.selectedSegmentIndex == 2) {
        
        [self.delegate didSelectReportView:2];
        
    }
    
    else if (self.showReportsSegmentedControl.selectedSegmentIndex == 3) {
        
        [self.delegate didSelectReportView:3];
        
        
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteMapCache:(id)sender {
    
    if (![[self.defaults valueForKey:@"tileCacheDir"] isEqualToString:@""]) {
    //Confirm the choice to delete the cache
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Are you sure you want to delete the map cache?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.delegate = self;
    [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing To Delete" message:@"There isn't a cache file\ncurrently loaded.\nThere is nothing to delete." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)downloadMapCache:(id)sender {
    
    [self.delegate didSelectDownloadCache];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UIAlertView Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //If they selected OK, delete the cache and dismiss
    if(buttonIndex == 1) {
        [self.delegate didSelectDeleteCache];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
