//
//  DetailReportViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/8/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "DetailReportViewController.h"
#import "ReportPagesViewController.h"
#import "Page1ViewController.h"
#import "Page2ViewController.h"
#import "Page3ViewController.h"
#import "Page4ViewController.h"
#import "Page5ViewController.h"
#import "KOPViewController.h"
#import "DisturbViewController.h"
#import "WildlifeViewController.h"
#import "LoginController.h"
#import "User.h"
#import "Report.h"

@interface DetailReportViewController ()

@end

@implementation DetailReportViewController

@synthesize popover = _popover;

- (void)loadView
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	[super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"WSA CheckOut";
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:self.swipeGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSwipe) name:@"StopSwipe" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSwipe) name:@"StartSwipe" object:nil];
    
    UIButton *showButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [showButton setTitle:@"Reports" forState:UIControlStateNormal];
    [showButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    showButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17.0f];
    [showButton addTarget:self action:@selector(showReports:) forControlEvents:UIControlEventTouchUpInside];
    self.showReportButton = [[UIBarButtonItem alloc] initWithCustomView:showButton];
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [addButton setTitle:@"New" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17.0f];
    [addButton addTarget:self action:@selector(listMonitoredAreasPopUp:) forControlEvents:UIControlEventTouchUpInside];
    self.createReportButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17.0f];
    [saveButton addTarget:self action:@selector(saveReport:) forControlEvents:UIControlEventTouchUpInside];
    self.reportSaveButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17.0f];
    [cancelButton addTarget:self action:@selector(cancelReport:) forControlEvents:UIControlEventTouchUpInside];
    self.reportCancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake (0,0,80,20)];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17.0f];
    [closeButton addTarget:self action:@selector(saveReport:) forControlEvents:UIControlEventTouchUpInside];
    self.reportCloseButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    //create the Left Nav Bar Buttons
    
    self.navigationItem.leftBarButtonItem = self.showReportButton;
    
    //create the Right Nav Bar Buttons
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentReportTitle = [defaults valueForKey:@"CurrentReportTitle"];
    
    if (![currentReportTitle isEqualToString: @""] && currentReportTitle != nil) {
        
        if ([self.theCurrentReport.reportStatus isEqualToString:@"new"]) {
            
            self.navigationItem.rightBarButtonItems = @[self.reportSaveButton, self.reportCancelButton];
        }
        
        else {
            
            self.navigationItem.rightBarButtonItem = self.reportCloseButton;
        }
    }
    
    else {
        
        self.navigationItem.rightBarButtonItem = self.createReportButton;
    }
}

#pragma mark - PageViewController Methods

- (ReportPagesViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    ReportPagesViewController *reportViewController = [[ReportPagesViewController alloc] initWithNibName:@"ReportPagesViewController" bundle:nil];
    
    switch (index) {
            
        case 0: {
            
            //Load the Page1 View Controller and setup the fields
            Page1ViewController *page1ViewController = [[Page1ViewController alloc] init];
            [reportViewController addChildViewController:page1ViewController];
            [reportViewController.view addSubview:page1ViewController.view];
            
            NSDateFormatter *reportDateFormatter = [[NSDateFormatter alloc] init];
            [reportDateFormatter setDateStyle:NSDateFormatterLongStyle];
            
            page1ViewController.theCurrentReport = self.theCurrentReport;
            page1ViewController.reportDateTimeLabel.text = [reportDateFormatter stringFromDate:self.theCurrentReport.dateTimeStamp];
            page1ViewController.reportWSALabel.text = self.theCurrentReport.wsaName;
            NSString *firstName = [self.theCurrentReport.createdReport firstName];
            NSString *lastName = [self.theCurrentReport.createdReport lastName];
            page1ViewController.reportUserNameLabel.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
            page1ViewController.reportFieldOfficeLabel.text = self.theCurrentReport.blmDistrict;
            
            CGRect kopvcRect = CGRectMake (80, 340, 600, 550);
            
            //Load the KOP Table
            UIStoryboard *kopStoryboard = [UIStoryboard storyboardWithName:@"KOPStoryboard" bundle:nil];
            KOPViewController *kopViewController = [kopStoryboard instantiateInitialViewController];
            
            [page1ViewController addChildViewController:kopViewController];
            kopViewController.view.frame = kopvcRect;
            [[page1ViewController view] addSubview:kopViewController.view];
            
            break;
        }
            
        case 1: {
            
            Page2ViewController *page2ViewController = [[Page2ViewController alloc] init];
            
            page2ViewController.theCurrentReport = self.theCurrentReport;
            
            [reportViewController addChildViewController:page2ViewController];
            [reportViewController.view addSubview:page2ViewController.view];
            
            break;
        }
            
        case 2: {
            
            Page3ViewController *page3ViewController = [[Page3ViewController alloc] init];
            
            page3ViewController.theCurrentReport = self.theCurrentReport;
            
            [reportViewController addChildViewController:page3ViewController];
            [reportViewController.view addSubview:page3ViewController.view];
            
            break;
        }
            
        case 3: {
            
            Page4ViewController *page4ViewController = [[Page4ViewController alloc] init];
            
            page4ViewController.theCurrentReport = self.theCurrentReport;
            
            [reportViewController addChildViewController:page4ViewController];
            [reportViewController.view addSubview:page4ViewController.view];
            
            break;
        }
            
        case 4: {
            
            Page5ViewController *page5ViewController = [[Page5ViewController alloc] init];
            
            page5ViewController.theCurrentReport = self.theCurrentReport;
            
            [reportViewController addChildViewController:page5ViewController];
            [reportViewController.view addSubview:page5ViewController.view];
            
            break;
        }
            
        default: {
            break;
            
        }
    }
    
    reportViewController.index = index;
    
    return reportViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = [(ReportPagesViewController *)viewController index];
    
    if (index == 0) {
        
        return nil;
    }
    
    else {
        // Decrease the index by 1 to return
        index--;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSUInteger index = [(ReportPagesViewController *)viewController index];
    
    index++;
    
    if (index == 5) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)setViewControllers:(NSArray *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    
}

#pragma mark - Private Methods

- (void)saveReport:(id)sender
{
    
    if ([self.theCurrentReport.reportStatus isEqualToString:@"new"]) {
        
        self.theCurrentReport.reportStatus = @"unfinished";
        
    }
    
    [self.theCurrentReport save];
    
    //flush the current report
    self.theCurrentReport = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"CurrentReportTitle"];
    
    [[self.pageController view] removeFromSuperview];
    [self.pageController removeFromParentViewController];
    
    self.title = nil;
    self.title = @"WSA CheckOut";
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = self.createReportButton;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelReport:(id)sender
{
    
    if ([self.theCurrentReport.reportStatus isEqualToString: @"new"]) {
        
        [self.theCurrentReport delete];
    }
    
    self.title = nil;
    self.title = @"WSA CheckOut";
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = self.createReportButton;
    
    [[self.pageController view] removeFromSuperview];
    [self.pageController removeFromParentViewController];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listMonitoredAreasPopUp:(id)sender
{
    
    if (self.popover) {
        
        [self.popover dismissPopoverAnimated:YES];
    }
    
    MonitoredAreaTableViewController* tableViewController = [[MonitoredAreaTableViewController alloc] init];
    tableViewController.delegate = self;
    
    tableViewController.preferredContentSize = CGSizeMake(300, 350);
    
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:tableViewController];
    popover.delegate = self;
    
    [self.popover presentPopoverFromBarButtonItem:self.createReportButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Delegate Methods

- (void) loadReport:(Report *)report {
    
    //dismiss the popup if it's there
    if (self.popover) {
        
        [self.popover dismissPopoverAnimated:YES];
    }
    
    // populate the variables
    self.theCurrentReport = report;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.theCurrentReport valueForKey:@"reportTitle"] forKey:@"CurrentReportTitle"];
    
    // change the title
    self.title = nil;
    self.title = [self.theCurrentReport valueForKey:@"reportTitle"];
    
    //Load up the pages of the report
    
    [self viewWillDisappear:NO];
    [self viewWillAppear:NO];
    
    if (self.pageController !=nil) {
        
        [[self.pageController view] removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
    }
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    [[self.pageController view] setFrame:(CGRectMake (0,62,768,900))];
    
    ReportPagesViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    
    [self.pageController didMoveToParentViewController:self];
}

- (void) showReports:(id)sender {
    
    [self.splitViewController showMasterViewControllerAnimated:YES completion:nil];
}

- (void) startSwipe {
    
    for (UIScrollView *view in self.pageController.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = YES;
        }
    }
    
}

- (void) stopSwipe {
    
    for (UIScrollView *view in self.pageController.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = NO;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif
    
    [super didReceiveMemoryWarning];
    self.reportCloseButton = nil;
    self.reportCancelButton = nil;
    self.reportSaveButton = nil;
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StopSwipe" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StartSwipe" object:nil];
}

@end
