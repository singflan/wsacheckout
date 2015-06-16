//
//  Page1ViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 8/5/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "Page1ViewController.h"
#import "Report.h"
#import "Visitors.h"

@interface Page1ViewController () {
    UIPopoverController *_popoverController;
}


@end

@implementation Page1ViewController

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
    
    self.reportSection1Title.font = [UIFont fontWithName:@"Avenir-Black" size:22.0f];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    if ([self.theCurrentReport.reportStatus isEqualToString:@"finished"]) {
        
        self.reportDone.on = TRUE;
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    
    else {
        
        self.view.backgroundColor = [UIColor cloudsColor];
        
    }
    
    if ([self.theCurrentReport.monitorConducted isEqualToString:@"All"]) {
        
        self.monitoringConductedButton.selectedSegmentIndex = 0;
    }
    
    else if ([self.theCurrentReport.monitorConducted isEqualToString:@"Part"]) {
        
        self.monitoringConductedButton.selectedSegmentIndex = 1;
    }
    
    else  {
        
        self.monitoringConductedButton.selected = NO;
    }
    
    if ([self.theCurrentReport.handle4WD isEqualToString:@"Yes"]) {
        
        self.passable4WDButton.selectedSegmentIndex = 0;
    }
    
    else if ([self.theCurrentReport.handle4WD isEqualToString:@"No"]) {
        
        self.passable4WDButton.selectedSegmentIndex = 1;
    }
    
    else  {
        
        self.passable4WDButton.selected = NO;
    }
    
    if ([self.theCurrentReport.sawVisitors.encounteredYesNo isEqualToString:@"Yes"]) {
        
        self.observedVisitors.selectedSegmentIndex = 0;
        self.numberOfVisitors.text = self.theCurrentReport.sawVisitors.encounteredNumber;
    }
    
    else if ([self.theCurrentReport.sawVisitors.encounteredYesNo isEqualToString:@"No"]) {
        
        self.observedVisitors.selectedSegmentIndex = 1;
    }
    
    else {
        
        self.observedVisitors.selected = NO;
    }
}

#pragma mark UISegmentedControl Methods

- (IBAction)handleMonitoringButton:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        self.theCurrentReport.monitorConducted = @"All";
    }
    
    else if (sender.selectedSegmentIndex == 1) {
        
        self.theCurrentReport.monitorConducted = @"Part";
    }
}

- (IBAction)handle4WDButton:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        self.theCurrentReport.handle4WD = @"Yes";
    }
    
    else if (sender.selectedSegmentIndex == 1) {
        
        self.theCurrentReport.handle4WD = @"No";
    }
}

- (IBAction)handleVisitors:(UISegmentedControl *)sender {
    
    if (self.theCurrentReport.sawVisitors == nil) {
        
         Visitors *visitors = [Visitors create];
        [visitors setReported:self.theCurrentReport];
    }
    
    if (sender.selectedSegmentIndex == 0) {

        [self.theCurrentReport.sawVisitors setEncounteredYesNo:@"Yes"];
        UIActionSheet *visitorNumberSheet = [[UIActionSheet alloc] initWithTitle:@"Select The Number of Visitors" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:@"Cancel" otherButtonTitles:@"1-2",@"3-5",@"6-10",@"11-19",@"20+", nil];
        
        [visitorNumberSheet showInView:self.view];
    }
    
    else if (sender.selectedSegmentIndex == 1) {
        
        [self.theCurrentReport.sawVisitors setEncounteredYesNo:@"No"];
        [self.theCurrentReport.sawVisitors setEncounteredNumber:@"0"];
        self.numberOfVisitors.text = @"";
    }
    
    [self.theCurrentReport.sawVisitors save];
}

#pragma mark ActionSheet Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"1-2"]) {
        
        [self.theCurrentReport.sawVisitors setEncounteredNumber:@"1-2"];
        self.numberOfVisitors.text = @"1-2";
    }
    
    if ([buttonTitle isEqualToString:@"3-5"]) {
        
        [self.theCurrentReport.sawVisitors setEncounteredNumber:@"3-5"];
        self.numberOfVisitors.text = @"3-5";
    }
    
    if ([buttonTitle isEqualToString:@"6-10"]) {
        
        [self.theCurrentReport.sawVisitors setEncounteredNumber:@"6-10"];
        self.numberOfVisitors.text = @"6-10";
    }
    
    if ([buttonTitle isEqualToString:@"11-19"]) {
        
        [self.theCurrentReport.sawVisitors setEncounteredNumber:@"11-19"];
        self.numberOfVisitors.text = @"11-19";
    }
    
    if ([buttonTitle isEqualToString:@"20+"]) {
        
        [self.theCurrentReport.sawVisitors setEncounteredNumber:@"20+"];
        self.numberOfVisitors.text = @"20+";
    }
    
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        
        self.observedVisitors.selectedSegmentIndex  = 1;
        self.numberOfVisitors.text = @"";
        [self.theCurrentReport.sawVisitors setEncounteredNumber:@"0"];
        [self.theCurrentReport.sawVisitors setEncounteredYesNo:@"No"];
    }
    
    [self.theCurrentReport.sawVisitors save];
}

#pragma mark Private Methods


- (IBAction)updateNumberOfVisitors:(id)sender {
    
    if (self.observedVisitors.selectedSegmentIndex == 0) {
        
        [self.theCurrentReport.sawVisitors setEncounteredYesNo:@"Yes"];
        UIActionSheet *visitorNumberSheet = [[UIActionSheet alloc] initWithTitle:@"Select The Number of Visitors" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:@"Cancel" otherButtonTitles:@"1-2",@"3-5",@"6-10",@"11-19",@"20+", nil];
        
        [visitorNumberSheet showInView:self.view];
    }
}

- (IBAction)reportIsDone:(id)sender {
    
    if (self.reportDone.on == YES) {
        
        self.theCurrentReport.reportStatus = @"finished";
        self.view.backgroundColor = [UIColor lightGrayColor];
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = NO;
        self.reportDone.userInteractionEnabled = YES;
    }
    
    else {
        
        self.theCurrentReport.reportStatus = @"unfinished";
        self.view.backgroundColor = [UIColor cloudsColor];
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = YES;
        self.reportDone.userInteractionEnabled = YES;
    }
    
    [self.theCurrentReport save];
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
