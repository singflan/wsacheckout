//
//  Page1ViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 8/5/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;
@class Visitors;

@interface Page1ViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *monitoringConductedButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *passable4WDButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *observedVisitors;
@property (strong, nonatomic) IBOutlet UILabel *reportUserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *reportDateTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *reportWSALabel;
@property (strong, nonatomic) IBOutlet UILabel *reportFieldOfficeLabel;
@property (strong, nonatomic) IBOutlet UILabel *reportSection1Title;
@property (strong, nonatomic) IBOutlet UITextField *numberOfVisitors;
@property (strong, nonatomic) IBOutlet UISwitch *reportDone;


@property (strong, nonatomic) Report *theCurrentReport;

- (IBAction)handleMonitoringButton:(UISegmentedControl *)sender;
- (IBAction)handle4WDButton:(UISegmentedControl *)sender;
- (IBAction)handleVisitors:(UISegmentedControl *)sender;
- (IBAction)updateNumberOfVisitors:(id)sender;
- (IBAction)reportIsDone:(id)sender;

@end
