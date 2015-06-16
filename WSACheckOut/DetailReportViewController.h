//
//  DetailReportViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 1/8/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBSplitViewController.h"
#import "MonitoredAreaTableViewController.h"

@class Report;
@class SidebarController;
@class MonitoredAreaTableViewController;

@interface DetailReportViewController : BDBDetailViewController <UISplitViewControllerDelegate, UIPageViewControllerDataSource, UIPopoverControllerDelegate, MonitoredAreaSelectViewControllerDelegate> {

    UIPopoverController *popover;
}

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIBarButtonItem *createReportButton;
@property (strong, nonatomic) UIBarButtonItem *reportSaveButton;
@property (strong, nonatomic) UIBarButtonItem *reportCancelButton;
@property (strong, nonatomic) UIBarButtonItem *reportCloseButton;
@property (strong, nonatomic) UIBarButtonItem *showReportButton;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIImageView *blmLogo;
@property (strong, nonatomic) IBOutlet UIImageView *aceLogo;

@property (strong, nonatomic) NSString *reportWSA;
@property (strong, nonatomic) NSString *reportUserFirstName;
@property (strong, nonatomic) NSString *reportUserLastName;
@property (strong, nonatomic) NSDate *reportDateTime;
@property (strong, nonatomic) NSString *reportFieldOffice;
@property (strong, nonatomic) NSMutableArray *reportKOP;
@property (strong, nonatomic) NSMutableArray *reportDisturbances;
@property (strong, nonatomic) NSString *reportStatus;
@property (strong, nonatomic) NSMutableArray *reportPlantLife;
@property (strong, nonatomic) NSMutableArray *reportWildLife;
@property (strong, nonatomic) NSMutableArray *reportVisitors;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) Report *theCurrentReport;
@property (strong, nonatomic) NSString *theCurrentReportTitle;

- (void)loadReport:(Report *)report;
- (void)saveReport:(id)sender;
- (void)cancelReport:(id)sender;
- (void)listMonitoredAreasPopUp:(id)sender;

@end
