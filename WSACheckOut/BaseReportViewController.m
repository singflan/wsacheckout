//
//  BaseReportViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/7/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "BaseReportViewController.h"
#import "BDBSplitViewController.h"
#import "DetailReportViewController.h"
#import "SidebarController.h"
#import "LoginController.h"

@interface BaseReportViewController ()

@end

@implementation BaseReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIStoryboard *sidebarStoryboard = [UIStoryboard storyboardWithName:@"SidebarStoryboard" bundle:nil];
    UIViewController *sidebarController = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"SidebarController"];
	UIViewController *detailViewController = [[DetailReportViewController alloc] initWithNibName:@"DetailReportViewController" bundle:nil];
	
    BDBSplitViewController *splitViewController = [[BDBSplitViewController alloc] initWithMasterViewController:sidebarController
                                                                                          detailViewController:detailViewController];
    
	
    splitViewController.masterViewDisplayStyle = BDBMasterViewDisplayStyleDrawer;
    
    [self addChildViewController:splitViewController];
    [[self view] addSubview:splitViewController.view];
}

- (void)didReceiveMemoryWarning
{
    
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
