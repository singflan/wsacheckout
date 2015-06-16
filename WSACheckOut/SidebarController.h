//
//  SidebarController.h
//  ADVFlatUI
//
//  Created by Tope on 05/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailReportViewController;
@class Report;

@interface SidebarController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DetailReportViewController *detailReportViewController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *profileEmailLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *syncButton;


@property (strong, nonatomic) UIButton *logoutButton;
@property (strong, nonatomic) NSMutableArray *tableViewItems;

@property (strong, nonatomic) Report *selectedReport;
@property (strong, nonatomic) Report *currentReport;

- (IBAction)syncReports:(id)sender;
- (void)logout:(id)sender;
- (IBAction)fixData:(id)sender;

@end
